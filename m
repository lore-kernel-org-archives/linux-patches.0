Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6B43C1F2B;
	Tue, 21 Jul 2026 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655769; cv=none; b=Ki8tps7kZ2U14duarEwf/r9WWqiVkbKxqLmljMwVNjZVVMtDhkXjCaMXcrH3xzSo+oCz88nBUGAAuXg6WPkK155CXCoNyUv/XyEK/QFlhrXLQPWt3PZQTnNu0ITrMsw+dCoVJTfbYRyarRshowf8qtvHk6MOvyWSLIFSF2BaKoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655769; c=relaxed/simple;
	bh=4gJIbLY08X1SPSnigofk+Nouwomfj+phKDfr8lWzZYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dle0zqZJ24euPkS91b2YTm+QpJ0SEsGjoQUkvvNlNbCEi1rR5y/D6Tn0K9u2iEucit+/NQ1TjUboHemEPEm5nStg35VrPcdfyEL9ycGBxlg/KdaicCIbvo2QuHvhOiY/VBEHoUYL6wGK5qIxyMQv2dRKXweEHcTYs0tnOPM9/6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMU7PUKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMU7PUKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21C31F000E9;
	Tue, 21 Jul 2026 17:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655768;
	bh=CCjiPEXvTi1udVWOauU2EbcJtAABhKjbv2XzEWRlXpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMU7PUKAyEwFIOmFXlzdmx9Y0zlSfnTf4MCr6pFXUOeGQsefeyGc+vfAINahPVJc7
	 llqqcgb3L1DBv4AWExnhGrgyEFBeaz6+9IyA6n1HvoMurPbCQ4a+dfiyrVHVUBgfdu
	 N716FGoiEuHr58AfUCIjLwNu8gHv4rRLM/3iZ9ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0133/1611] bpf: fix crash in bpf_[set|remove]_dentry_xattr for negative dentries
Date: Tue, 21 Jul 2026 17:04:09 +0200
Message-ID: <20260721152517.865157370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit 07410646f6ff1d23222f105ccab778957d401bbe ]

bpf_set_dentry_xattr and bpf_remove_dentry_xattr BPF kfuncs attempt to
lock the inode of the supplied dentry without checking if it is
NULL. If a negative dentry is passed (e.g. from
security_inode_create), d_inode(dentry) returns NULL, and
inode_lock(inode) will cause a NULL pointer dereference.

Trivially fix this by adding a NULL check for inode before attempting
to lock it, returning -EINVAL if it is NULL.

Additionally, drop WARN_ON(!inode) in bpf_xattr_read_permission() and
bpf_xattr_write_permission(). These warnings could be triggered by
passing a negative dentry to bpf_get_dentry_xattr() or the _locked
variants of the xattr kfuncs, potentially causing a Denial of Service
on systems with panic_on_warn enabled. Instead, simply return -EINVAL.

Reported-by: Quan Sun <2022090917019@std.uestc.edu.cn>
Closes: https://lore.kernel.org/bpf/1587cbf4-1293-4e25-ad24-c970836a1686@std.uestc.edu.cn/
Fixes: 56467292794b ("bpf: fs/xattr: Add BPF kfuncs to set and remove xattrs")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Link: https://patch.msgid.link/20260430073836.2894001-1-mattbobrowski@google.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/bpf_fs_kfuncs.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index 5ace2511fec511..b5a0736b120fab 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -103,7 +103,7 @@ static bool match_security_bpf_prefix(const char *name__str)
 
 static int bpf_xattr_read_permission(const char *name, struct inode *inode)
 {
-	if (WARN_ON(!inode))
+	if (!inode)
 		return -EINVAL;
 
 	/* Allow reading xattr with user. and security.bpf. prefix */
@@ -173,7 +173,7 @@ __bpf_kfunc_end_defs();
 
 static int bpf_xattr_write_permission(const char *name, struct inode *inode)
 {
-	if (WARN_ON(!inode))
+	if (!inode)
 		return -EINVAL;
 
 	/* Only allow setting and removing security.bpf. xattrs */
@@ -292,6 +292,9 @@ __bpf_kfunc int bpf_set_dentry_xattr(struct dentry *dentry, const char *name__st
 	struct inode *inode = d_inode(dentry);
 	int ret;
 
+	if (!inode)
+		return -EINVAL;
+
 	inode_lock(inode);
 	ret = bpf_set_dentry_xattr_locked(dentry, name__str, value_p, flags);
 	inode_unlock(inode);
@@ -317,6 +320,9 @@ __bpf_kfunc int bpf_remove_dentry_xattr(struct dentry *dentry, const char *name_
 	struct inode *inode = d_inode(dentry);
 	int ret;
 
+	if (!inode)
+		return -EINVAL;
+
 	inode_lock(inode);
 	ret = bpf_remove_dentry_xattr_locked(dentry, name__str);
 	inode_unlock(inode);
-- 
2.53.0



