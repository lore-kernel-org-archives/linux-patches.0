Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8902119CD12;
	Thu,  6 Jun 2024 14:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683439; cv=none; b=Fa+p90G6uUHWShoVTEJLEqzeEyLDUxNmVQrtiKauxhQHQtAMaxq/6NMn5rIwYUBKH1O2Tu0Y2/djqrLtNrGSdatGLdSLP9GyGSdBqa873tVV20Bm6j5N1QRgVG3n6c3URjmfH9b48A4jNdsWPlwjV/RVIqkNeRDt4G0ENmELfX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683439; c=relaxed/simple;
	bh=iljrgyoQBfLOT8UFLk0YJgllzbyTDiVH+3WZYW5NZHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNzWBeij+IO9WTXw9neXnnsW9uIciEhIFXQLEjb4nsFie6cVy7pNLpCcZUtZpSqyXFeyOQB9yjBcKKLILO7hbOXKBlBbWKf3riX5B+hGNgXjxXAIIzFgUJwrmOa42z5/MTLPii2VSkdoqdcMiOfR2VkyrWJh2hPJS7ls6zOD1no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LDYby8sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LDYby8sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6944FC2BD10;
	Thu,  6 Jun 2024 14:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683439;
	bh=iljrgyoQBfLOT8UFLk0YJgllzbyTDiVH+3WZYW5NZHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LDYby8syzlusJEZferUCwYoyMn51OXEe3q7ZESqOBeY0CNW6pgLNM8U6YbBFShL80
	 qRdK6aQSeFBzJBY8PE/+itzTscmhKN1GeAxfumymQKf9n9OZp4SRA5kBLfqiWK9mA7
	 Sv+t0xXyoj8bKWsGFdkzQij+016MhvmLePmdHVkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 324/473] ovl: remove upper umask handling from ovl_create_upper()
Date: Thu,  6 Jun 2024 16:04:13 +0200
Message-ID: <20240606131710.640553834@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 096802748ea1dea8b476938e0a8dc16f4bd2f1ad ]

This is already done by vfs_prepare_mode() when creating the upper object
by vfs_create(), vfs_mkdir() and vfs_mknod().

No regressions have been observed in xfstests run with posix acls turned
off for the upper filesystem.

Fixes: 1639a49ccdce ("fs: move S_ISGID stripping into the vfs_*() helpers")
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/dir.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5339ff08bd0f4..582d4bd50a1fb 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -327,9 +327,6 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	struct dentry *newdentry;
 	int err;
 
-	if (!attr->hardlink && !IS_POSIXACL(udir))
-		attr->mode &= ~current_umask();
-
 	inode_lock_nested(udir, I_MUTEX_PARENT);
 	newdentry = ovl_create_real(ofs, udir,
 				    ovl_lookup_upper(ofs, dentry->d_name.name,
-- 
2.43.0



