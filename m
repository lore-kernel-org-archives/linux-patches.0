Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7574C44AB68;
	Tue, 21 Jul 2026 21:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668964; cv=none; b=dxEcbMHvTWnbnJ/XPMhpVI3l5nI1drT6aEsUixCxBUleQuhyZFSeP9HLvY7MoREuJxlW2XqGiaj9JLL9gKu+GyHAoquPKjCnC1MYMuubdMhVlquXrNhExc4GA356Th47EV6vphrnCQcNadp3OJ9euc9LBg9lWEfyzzQllElUpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668964; c=relaxed/simple;
	bh=tvucemKKqc5/Fd+MBQnCwr1RAU1hYf4YjgSl2SHx2jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIItcPIznbJKp4P2Z8PcfCVAQSrLTULQjAxrzCLlg3DQ8XRrZZte48rIvmZSQYi+8mZOLpue6FZCp7pFaqmpdgc5i+p4InDGP01d5Vt8FjQy0mLdivX+TktUymkTO1yLT6SrWHdXUMqaNPKLGmgPMnWZWrASrEB/biPGGYh7Gwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnuQIDk8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnuQIDk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E171F000E9;
	Tue, 21 Jul 2026 21:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668963;
	bh=oGCmGNlcoy52qjsPU/v2qevjXVPauu+6FpiTjkW8xRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnuQIDk8A6HjZQP0GrHyrkD+4jRFSFxHYvmXZBjOSYEOsHPcmfCcw5FrcBbe6X95n
	 7zzBy3AHJjiCcxF4xw0jPMqQLV6hPcWYzb7yHiq/MlXRI9gmJTPiMrFjfrbw8QnQM8
	 LdpZgfWNr0TwvVT0gJSuNyXY2fgFCTxNrs2nZW5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Breno Leitao <leitao@debian.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0373/1067] configfs_lookup(): dont leave ->s_dentry dangling on failure
Date: Tue, 21 Jul 2026 17:16:14 +0200
Message-ID: <20260721152432.968322693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 10da12d352b7b2bb330a8609fdda9a58bf0e9856 ]

Normally ->s_dentry is cleared when dentry it's pointing to becomes
negative (on eviction, realistically).  However, that only happens
if dentry gets to be positive in the first place; in case of inode
allocation failure dentry never becomes positive, so ->d_iput()
is not called at all.

We do part of what normally would've been done by configfs_d_iput()
(dropping the reference to configfs_dirent) manually, but we do
not clear ->s_dentry there.  Sloppy as it is, it does not matter in
case of configfs_create_{dir,link}() - there configfs_dirent does
not survive dropping the sole reference to it.

However, for configfs_lookup() it *does* survive, with a dangling
pointer to soon to be freed dentry sitting it its ->s_dentry.

Subsequent getdents(2) in that directory will end up dereferencing
that pointer in order to pick the inode number.  Use after free...

This is the minimal fix; the right approach is to set the linkage
between dentry and configfs_dirent only after we know that we have
an inode, but that takes more surgery and the bug had been there
since 2006, so...

Fixes: 3d0f89bb1694 ("configfs: Add permission and ownership to configfs objects") # 2.6.16-rc3
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/configfs/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index e017ba188f7b5c..afe2b802eb3193 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -462,6 +462,9 @@ static struct dentry * configfs_lookup(struct inode *dir,
 
 			inode = configfs_create(dentry, mode);
 			if (IS_ERR(inode)) {
+				spin_lock(&configfs_dirent_lock);
+				sd->s_dentry = NULL;
+				spin_unlock(&configfs_dirent_lock);
 				configfs_put(sd);
 				return ERR_CAST(inode);
 			}
-- 
2.53.0



