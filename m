Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4C51DE2AC;
	Tue, 17 Dec 2024 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455572; cv=none; b=UmrplKAy1YTSZeFyjUgt7psVPlCpSVCyBmYknaiOwTLjcjDdFOKF8TnSj99K2M23KoOQp3EAhQukAznBXYPTP64x+PBN+N3bfXQn7JSXNia9+ERI3HVLcwAEhaPAdGiKDOvCRDTcr7Zi1yhEJUdCOSiSzZKeU4vO8rUuoSfhpjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455572; c=relaxed/simple;
	bh=Fs62zVzO3UgiTJvayH2l+SxQ/9hN3zbNfmLbbFBkrn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZY9t3UGXVgMUUuha60l5AF6hEI/csKKvwBi4qJxu/bFUOAa01R1YTA0HjJgWaX359nWlBT409CsQyRlhwdRuBujUWnYVdUqVPTOUkPxeFkz/Rf8QEiJPJu9vdweLhmb0nLxA/B0Mimd04h46YLINxBI/U5GQfKVjZvhZ7KCNTJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FWuEFR4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FWuEFR4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403C2C4CED3;
	Tue, 17 Dec 2024 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455572;
	bh=Fs62zVzO3UgiTJvayH2l+SxQ/9hN3zbNfmLbbFBkrn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FWuEFR4y+S+W2EulLm7JgFDea0n3c6H7cQ6qD6Pre5viyQp3MeFNhM4xIbFpZ15Ne
	 NsajFmqwOwJE0DLCtTXjxxLOdF/6z8ef8qV14Ub075Ka6rs9E6ivsmOET9T0TGXRJQ
	 TmwyylUoIF+f3+YuEFaT32CWTY+0N3mvs+JLf9Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.15 12/51] xfs: dont drop errno values when we fail to ficlone the entire range
Date: Tue, 17 Dec 2024 18:07:05 +0100
Message-ID: <20241217170520.809238224@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1193,6 +1193,14 @@ out_unlock:
 	xfs_iunlock2_io_mmap(src, dest);
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
 


