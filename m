Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8655A1EF085;
	Tue, 17 Dec 2024 17:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456489; cv=none; b=htXjVz2deavHNBUJpzldhCPQjq6yHYiXAT7qplc9QiWr0z4jTr0Xzak7IPQOtiy40U7peY8VUzN45I+pE8lHyF54ayahxPMPpgBXQnt+HmubPyZvpUK/iQl4+1nABadL4uYGeIaqzyp7Rqu5e4wRFN+c5RMd2idOXjf+Z+pPts0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456489; c=relaxed/simple;
	bh=ZhvhM+57g5lAfUG46HRebv2jBC7SFWJrDsX154Wy504=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7SLi/HiHEpLgfPVpNZeH0HlAiAui/IB/7RYqwd38bfbSqajhKGtXtteMEg10EgTZ/AgqcKgu4QlQmHS0fPcGSTEF8/mZknRibOEBjjM5B5n2+VWcIoipWRSciZvT8XhT+R3T9yktvVE9bNasf6l091YXLj5WT9b/Te74gq8q6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=py1X/pO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="py1X/pO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091DDC4CED7;
	Tue, 17 Dec 2024 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456489;
	bh=ZhvhM+57g5lAfUG46HRebv2jBC7SFWJrDsX154Wy504=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=py1X/pO8i3GKkwC+1FkQAbiuSZd53JX126d85b3a3e1WWX7L8RXStdlIJzzF2ZxzQ
	 /HOO5nMQ529YgZYn6XUf8vuDcwLzKi4u/oDq1KKhsOaiwYnBym1EM7RnNoSEXj49eT
	 32PhujsZADzY6noK9g1/wIv5F+o3Hr8LCJcuBRvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6.12 075/172] xfs: unlock inodes when erroring out of xfs_trans_alloc_dir
Date: Tue, 17 Dec 2024 18:07:11 +0100
Message-ID: <20241217170549.397904854@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 53b001a21c9dff73b64e8c909c41991f01d5d00f upstream.

Debugging a filesystem patch with generic/475 caused the system to hang
after observing the following sequences in dmesg:

 XFS (dm-0): metadata I/O error in "xfs_imap_to_bp+0x61/0xe0 [xfs]" at daddr 0x491520 len 32 error 5
 XFS (dm-0): metadata I/O error in "xfs_btree_read_buf_block+0xba/0x160 [xfs]" at daddr 0x3445608 len 8 error 5
 XFS (dm-0): metadata I/O error in "xfs_imap_to_bp+0x61/0xe0 [xfs]" at daddr 0x138e1c0 len 32 error 5
 XFS (dm-0): log I/O error -5
 XFS (dm-0): Metadata I/O Error (0x1) detected at xfs_trans_read_buf_map+0x1ea/0x4b0 [xfs] (fs/xfs/xfs_trans_buf.c:311).  Shutting down filesystem.
 XFS (dm-0): Please unmount the filesystem and rectify the problem(s)
 XFS (dm-0): Internal error dqp->q_ino.reserved < dqp->q_ino.count at line 869 of file fs/xfs/xfs_trans_dquot.c.  Caller xfs_trans_dqresv+0x236/0x440 [xfs]
 XFS (dm-0): Corruption detected. Unmount and run xfs_repair
 XFS (dm-0): Unmounting Filesystem be6bcbcc-9921-4deb-8d16-7cc94e335fa7

The system is stuck in unmount trying to lock a couple of inodes so that
they can be purged.  The dquot corruption notice above is a clue to what
happened -- a link() call tried to set up a transaction to link a child
into a directory.  Quota reservation for the transaction failed after IO
errors shut down the filesystem, but then we forgot to unlock the inodes
on our way out.  Fix that.

Cc: <stable@vger.kernel.org> # v6.10
Fixes: bd5562111d5839 ("xfs: Hold inode locks in xfs_trans_alloc_dir")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_trans.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1374,5 +1374,8 @@ done:
 
 out_cancel:
 	xfs_trans_cancel(tp);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (dp != ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }


