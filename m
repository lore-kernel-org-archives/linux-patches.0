Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159481F37BE;
	Tue, 17 Dec 2024 17:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455388; cv=none; b=otCIeJvTi4QmZFSXrhoJxjTNgZfkstvT0E39GxRxcNv/mNksvY70MeWS/bqk6rmtxWmdya90uWNnieUsJT/nW+cGrJgr0ntgZlw3kXMUiNjOwKTjWg0iY+SyTZ/fLd6cNYaux2z7kVy6dl0TBUhde1e2FuHg6+4I982ji9oMGPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455388; c=relaxed/simple;
	bh=+O4KtCBgwlrJ5eNPsRJ1+rVcubwMggyhddHQ00Fd66Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COgRQjs+qnIZGY+h0nQP5EjA+gMlJ8UXbMdZowy+nJw9Jen27NhrAhfkgQiK/dMXPmu+7iMmjPlRS4xLpoSwIRg/ZqbHY5L9PJsiNCCYkWAIFiQrnYrOdXdL1UAcmpJpbaEHAKBL2yAFv6xfhGdOJKNEAJIjOhqB0bfqIee2KGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JK5dxFKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JK5dxFKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416E1C4CED3;
	Tue, 17 Dec 2024 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455387;
	bh=+O4KtCBgwlrJ5eNPsRJ1+rVcubwMggyhddHQ00Fd66Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JK5dxFKrU6M9j8ACvFVBH0qkCllUUNX1i3C1gzETzgFXro4p9Co0D+KBpnouLMjHh
	 R4jKfKuHrWaTIBb0T9xYPZo19D1M3O9MrONbSih7f4SnGODQTtXhNIkIQcPKdvNw0v
	 0OSmbFfaS+EhwAQVfDoKra3ZiJyV1N1RuX2BxgOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.4 06/24] xfs: dont drop errno values when we fail to ficlone the entire range
Date: Tue, 17 Dec 2024 18:07:04 +0100
Message-ID: <20241217170519.266209623@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 7ce31f20a0771d71779c3b0ec9cdf474cc3c8e9a upstream.

Way back when we first implemented FICLONE for XFS, life was simple --
either the the entire remapping completed, or something happened and we
had to return an errno explaining what happened.  Neither of those
ioctls support returning partial results, so it's all or nothing.

Then things got complicated when copy_file_range came along, because it
actually can return the number of bytes copied, so commit 3f68c1f562f1e4
tried to make it so that we could return a partial result if the
REMAP_FILE_CAN_SHORTEN flag is set.  This is also how FIDEDUPERANGE can
indicate that the kernel performed a partial deduplication.

Unfortunately, the logic is wrong if an error stops the remapping and
CAN_SHORTEN is not set.  Because those callers cannot return partial
results, it is an error for ->remap_file_range to return a positive
quantity that is less than the @len passed in.  Implementations really
should be returning a negative errno in this case, because that's what
btrfs (which introduced FICLONE{,RANGE}) did.

Therefore, ->remap_range implementations cannot silently drop an errno
that they might have when the number of bytes remapped is less than the
number of bytes requested and CAN_SHORTEN is not set.

Found by running generic/562 on a 64k fsblock filesystem and wondering
why it reported corrupt files.

Cc: <stable@vger.kernel.org> # v4.20
Fixes: 3fc9f5e409319e ("xfs: remove xfs_reflink_remap_range")
Really-Fixes: 3f68c1f562f1e4 ("xfs: support returning partial reflink results")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_file.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1068,6 +1068,14 @@ out_unlock:
 	xfs_reflink_remap_unlock(file_in, file_out);
 	if (ret)
 		trace_xfs_reflink_remap_range_error(dest, ret, _RET_IP_);
+	/*
+	 * If the caller did not set CAN_SHORTEN, then it is not prepared to
+	 * handle partial results -- either the whole remap succeeds, or we
+	 * must say why it did not.  In this case, any error should be returned
+	 * to the caller.
+	 */
+	if (ret && remapped < len && !(remap_flags & REMAP_FILE_CAN_SHORTEN))
+		return ret;
 	return remapped > 0 ? remapped : ret;
 }
 


