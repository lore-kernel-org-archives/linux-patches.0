Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D6A46A5F6;
	Tue, 21 Jul 2026 15:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648509; cv=none; b=F05Z5/ButEiRfCQW71rIjebgqkashFlLBqQT8iYC6agJGsbMUtKFjEb8WXX1+BCxwZuDi/GXE59wG/g7yLXlha0bcQVQpBuq1Cw6IvlG760BZuErtmILy0YOT/YC2wfVdHMgOxQzwxPdVwsnaNmGOTxZQdBUSH3qaxJSmqrC5XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648509; c=relaxed/simple;
	bh=h26DOkTJq/lCdwDqYw15QBtFmJfk6QcWFcQiJTK7Luc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMMGrQgRB31hA1Ed/9Ymh6CAmnJxugYVYbHPbDFRys7aqQbwRIptlLIHiPy86Ok6Cl7STbnP87NAO0o4azEfTrV0ghiKbbG7o74RaS5WSrwrZIGY1ACePwOkSOOHhoirNQD5B1KGhafl8j+8j4xbWcBYc8NETuip1hUMH6akJYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/o/uYgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/o/uYgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BE41F00A3A;
	Tue, 21 Jul 2026 15:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648508;
	bh=+CUDyXkPc4LKwfGIHiZ1GgAviGSLJSd/6aN1Xs7BMcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/o/uYgk9Le1stgIGvFdvfFHPosHR9MQfLHGaMQxJnrUr2zFMeTmzBxmU3fJ3pD4z
	 Ig5r+gax3Tiwsfb9fdRGbXUyIWHlmwSx4IhCXMpjRuJ8hEFV5VMygXZs7aqnYayUkC
	 Lb21rx2G609zq85FzhdwFLj445qMsakgthefBn9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0183/2077] bpf: fix crash in bpf_[set|remove]_dentry_xattr for negative dentries
Date: Tue, 21 Jul 2026 16:57:36 +0200
Message-ID: <20260721152556.999542849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e4e51a1d0de281..606319dd69e803 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -100,7 +100,7 @@ static bool match_security_bpf_prefix(const char *name__str)
 
 static int bpf_xattr_read_permission(const char *name, struct inode *inode)
 {
-	if (WARN_ON(!inode))
+	if (!inode)
 		return -EINVAL;
 
 	/* Allow reading xattr with user. and security.bpf. prefix */
@@ -170,7 +170,7 @@ __bpf_kfunc_end_defs();
 
 static int bpf_xattr_write_permission(const char *name, struct inode *inode)
 {
-	if (WARN_ON(!inode))
+	if (!inode)
 		return -EINVAL;
 
 	/* Only allow setting and removing security.bpf. xattrs */
@@ -289,6 +289,9 @@ __bpf_kfunc int bpf_set_dentry_xattr(struct dentry *dentry, const char *name__st
 	struct inode *inode = d_inode(dentry);
 	int ret;
 
+	if (!inode)
+		return -EINVAL;
+
 	inode_lock(inode);
 	ret = bpf_set_dentry_xattr_locked(dentry, name__str, value_p, flags);
 	inode_unlock(inode);
@@ -314,6 +317,9 @@ __bpf_kfunc int bpf_remove_dentry_xattr(struct dentry *dentry, const char *name_
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



