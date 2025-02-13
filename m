Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7EC202F93;
	Thu, 13 Feb 2025 14:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458539; cv=none; b=OuCryW3BjMZojQM/c7p7kUMaYEbaVzGOkor0H1/okjMuFhdFR2Sx7albB/13dt1BX86r8K6oi96Vkk8bo3cdNmu5vuXJ/Iq7xOHccU79bdjERe0Ez4pBy1jE854+NeuL9WW9fmPOlkF72934LkZr3NAtoa9IwFL+hyndzRf0Ua8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458539; c=relaxed/simple;
	bh=raXkr1uNw23gCv/gi/hQVyI+ison6flIaoqYRY7aNkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SO8RERxPvSUyuliP5w0mnVTBgjrSGg8nTYCDlYRuPbD8uuAqtpDoB+ioG0mX+yuc82hPwLfEXevm8d4Pe0hTr5Kgh5mwmdKG1OwYp+55+GZQk9MbFOAv4pH5XpN826+9HvzW/4f25Z8BDtuATZyYRSPo3G+r4iKemK03dxirdQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeT4w9zG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeT4w9zG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C96C4CED1;
	Thu, 13 Feb 2025 14:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458539;
	bh=raXkr1uNw23gCv/gi/hQVyI+ison6flIaoqYRY7aNkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeT4w9zGkRlrk2Y0sendU6RtiJgWSzaqZRm2pCIGFhChPmEe31LDbUC4fzbDjuyHo
	 3p4Bokcb5ZMjlqk6/FMyJXsPmSconPX2unA0O8zm4B/6775fpbp6O6oSt6ldL498zl
	 Mqma4Cb31qS5wUPhRPoUPpZynBFEmMHzh3yPvR60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Koichiro Den <koichiro.den@canonical.com>
Subject: [PATCH 6.12 410/422] btrfs: avoid monopolizing a core when activating a swap file
Date: Thu, 13 Feb 2025 15:29:19 +0100
Message-ID: <20250213142452.382087099@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

commit 2c8507c63f5498d4ee4af404a8e44ceae4345056 upstream.

This commit re-attempts the backport of the change to the linux-6.12.y
branch. Commit 9f372e86b9bd ("btrfs: avoid monopolizing a core when
activating a swap file") on this branch was reverted.

During swap activation we iterate over the extents of a file and we can
have many thousands of them, so we can end up in a busy loop monopolizing
a core. Avoid this by doing a voluntary reschedule after processing each
extent.

CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10142,6 +10142,8 @@ static int btrfs_swap_activate(struct sw
 			ret = -EINTR;
 			goto out;
 		}
+
+		cond_resched();
 	}
 
 	if (bsi.block_len)


