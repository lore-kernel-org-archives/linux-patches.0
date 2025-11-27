Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E42334397;
	Thu, 27 Nov 2025 14:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255503; cv=none; b=b7BQs7HZaioZ0kjDgQMCHwl/dFQqH5Fc47S32+Dv9Y/Dsut5QeJS4oz2PJmmWhQ+4GRxRW3k937H3Vig/nTdzpL6ozw46sm4p9tDGOxpoUNPLjbi3Jz6/Rtdv2Ms1+O2TchplMIXq0JXFd1J6k89N4VGnIb7rKe5BFcToCsZe9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255503; c=relaxed/simple;
	bh=tNPwQgyg47bQpsgJ2JQ2lzpZZndMc0PuBxVawSzNAmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdsyoVWHjIIAKMpxQP3p0O4pjxlplo/mXLHGrTUSzMTAJUw/vSJ0jkjRot6FsG3Fo4BNYRHn2/t/InZQbpH7z5uCe0VgZTIqS2l6PQ3P7jVzkNvbmSxER2YvsQDS2jQOKpq/IjBgzAYVylL0NbfvyKZEvRlrLhJJ+SZWxKNVMms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM8oqC3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM8oqC3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FCCC113D0;
	Thu, 27 Nov 2025 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255502;
	bh=tNPwQgyg47bQpsgJ2JQ2lzpZZndMc0PuBxVawSzNAmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EM8oqC3X7Qd44HMB7o4gSWEv6VtLiiRigLX/2WtEvrTH7hHR9z/gFZLVHKAmtyJXD
	 f3kIb5q7Yvp2/5QSh3jK+pgxJvuPUxIViaaJv0IJtKW7c0M67ALK5t+ppjpxbJlLNb
	 ZBBwymIOa8SjiLp/niuZAs6Jx5zcKrjrDXkXFsNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.17 016/175] xfs: check the return value of sb_min_blocksize() in xfs_fs_fill_super
Date: Thu, 27 Nov 2025 15:44:29 +0100
Message-ID: <20251127144043.550229047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

commit 124af0868ec6929ba838fb76d25f00c06ba8fc0d upstream.

sb_min_blocksize() may return 0. Check its return value to avoid the
filesystem super block when sb->s_blocksize is 0.

Cc: stable@vger.kernel.org # v6.15
Fixes: a64e5a596067bd ("bdev: add back PAGE_SIZE block size validation for sb_set_blocksize()")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Link: https://patch.msgid.link/20251104125009.2111925-5-yangyongpeng.storage@gmail.com
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1710,7 +1710,10 @@ xfs_fs_fill_super(
 	if (error)
 		return error;
 
-	sb_min_blocksize(sb, BBSIZE);
+	if (!sb_min_blocksize(sb, BBSIZE)) {
+		xfs_err(mp, "unable to set blocksize");
+		return -EINVAL;
+	}
 	sb->s_xattr = xfs_xattr_handlers;
 	sb->s_export_op = &xfs_export_operations;
 #ifdef CONFIG_XFS_QUOTA


