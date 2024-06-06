Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DA51990AA;
	Thu,  6 Jun 2024 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683527; cv=none; b=WZUJf9C0XOgB/4PdwVI9XwySQOgEh+9S2yZfU6swpBh/3GwzYZw5e6jfKxUdHrr8wemzytD+NZIl0vrr6v5b7ZlVdcytfWTSm+z4PEU8a7Q6293BoO7shMyz6TWX6gNq2sjX/SH3oX2JxVcYacirbgd4pLiz3n86Rc7cohYj3yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683527; c=relaxed/simple;
	bh=UDCcFn4GGXebrmNF76+5xSonzhbk5NHHZINsyANTrhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZENvbnhSON0xc05olaUQdn1n0/ZX5opiVmM9tFlAKlNSrmHn3A8vbOulMUIF2yE4KfOKkW25Oj1hQ6G92z6bGvyIrCR31S+lQhD0DmO+VBh1/o8y2P05KkxLQsJthURUI+k/+1hBfuw+EhgqeD3Xcx1+Zi6s/t2g4u2nczhh99Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zVW5IDUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zVW5IDUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E472C2BD10;
	Thu,  6 Jun 2024 14:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683527;
	bh=UDCcFn4GGXebrmNF76+5xSonzhbk5NHHZINsyANTrhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zVW5IDUrA7+5sXdbd+BKmD+yzVUcRlQaxkFoQZcibxCuV17/RRbCfDc5xopChFAMr
	 5yzM7UxrpSL1tlolAFOY/Spp1AbcCpa5uzDg2/iTIUNEOXJ4uXyUrB3xJB4zr3w2vh
	 wIzeubAqrNBHHJnPnu37ILcb/rDIm9PPuMKLopI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 468/744] xfs: match lock mode in xfs_buffered_write_iomap_begin()
Date: Thu,  6 Jun 2024 16:02:20 +0200
Message-ID: <20240606131747.479694063@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit bb712842a85d595525e72f0e378c143e620b3ea2 ]

Commit 1aa91d9c9933 ("xfs: Add async buffered write support") replace
xfs_ilock(XFS_ILOCK_EXCL) with xfs_ilock_for_iomap() when locking the
writing inode, and a new variable lockmode is used to indicate the lock
mode. Although the lockmode should always be XFS_ILOCK_EXCL, it's still
better to use this variable instead of useing XFS_ILOCK_EXCL directly
when unlocking the inode.

Fixes: 1aa91d9c9933 ("xfs: Add async buffered write support")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_iomap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 18c8f168b1532..ccf83e72d8ca8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1149,13 +1149,13 @@ xfs_buffered_write_iomap_begin(
 	 * them out if the write happens to fail.
 	 */
 	seq = xfs_iomap_inode_sequence(ip, IOMAP_F_NEW);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW, seq);
 
 found_imap:
 	seq = xfs_iomap_inode_sequence(ip, 0);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0, seq);
 
 found_cow:
@@ -1165,17 +1165,17 @@ xfs_buffered_write_iomap_begin(
 		if (error)
 			goto out_unlock;
 		seq = xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_iunlock(ip, lockmode);
 		return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
 					 IOMAP_F_SHARED, seq);
 	}
 
 	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0, seq);
 
 out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(ip, lockmode);
 	return error;
 }
 
-- 
2.43.0



