Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA2724888A;
	Tue, 20 May 2025 14:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750442; cv=none; b=XE/iBY7iN7LPr+KYpayE8OiXtWx3K9HkCPIe+eGtLt4q6O9GFxrr+L8sI/1CY3ljLbDKTHGRezT50sZt9JQ5iRserYYMxAPevmd3on6ABlJfZDUJsLlB+kGx7urm6AVjKqhRzS/QMlH4ccgH0h3+z0cckNubZgTyJl3NfXF5a/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750442; c=relaxed/simple;
	bh=F3KjT2ap9H/i4oSyPzyCRmHtEFiCNs+kw5LCTIoHcmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST4Zg9J4GQXWd0EZC7Xz7xcazGCsBth0qC0m6T4kTN2Vad8KzGpZXHp7yTgCfAYecqzhMjAuoG2wF2GtZNb898QPkSMHoFq7FmWnUyPDs0VADiWqxVw1E4kKFmo+j5SE/sWAYjlUBmpQ9JmrEAAligcmabJPRUdHbfyDTpKMwxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nCeAR3xx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nCeAR3xx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC625C4CEE9;
	Tue, 20 May 2025 14:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750442;
	bh=F3KjT2ap9H/i4oSyPzyCRmHtEFiCNs+kw5LCTIoHcmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nCeAR3xx8UCsiMCsxB9xbZ8P+7bixCvYaBzQDlI4T3zAjZCgrQ+oQJbs2RLEuy160
	 MOE5vOT2B2qhtDBFq2RivrVKnTcuaYXcBkfG80sm8/1yK7zv59kxu3n03dH7h1HjrF
	 JR2si1fHlnA129GVhRqNNggvfXTFqVtKAyVhJLCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 002/145] fs/xattr.c: fix simple_xattr_list to always include security.* xattrs
Date: Tue, 20 May 2025 15:49:32 +0200
Message-ID: <20250520125810.639018428@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

[ Upstream commit 8b0ba61df5a1c44e2b3cf683831a4fc5e24ea99d ]

The vfs has long had a fallback to obtain the security.* xattrs from the
LSM when the filesystem does not implement its own listxattr, but
shmem/tmpfs and kernfs later gained their own xattr handlers to support
other xattrs. Unfortunately, as a side effect, tmpfs and kernfs-based
filesystems like sysfs no longer return the synthetic security.* xattr
names via listxattr unless they are explicitly set by userspace or
initially set upon inode creation after policy load. coreutils has
recently switched from unconditionally invoking getxattr for security.*
for ls -Z via libselinux to only doing so if listxattr returns the xattr
name, breaking ls -Z of such inodes.

Before:
$ getfattr -m.* /run/initramfs
<no output>
$ getfattr -m.* /sys/kernel/fscaps
<no output>
$ setfattr -n user.foo /run/initramfs
$ getfattr -m.* /run/initramfs
user.foo

After:
$ getfattr -m.* /run/initramfs
security.selinux
$ getfattr -m.* /sys/kernel/fscaps
security.selinux
$ setfattr -n user.foo /run/initramfs
$ getfattr -m.* /run/initramfs
security.selinux
user.foo

Link: https://lore.kernel.org/selinux/CAFqZXNtF8wDyQajPCdGn=iOawX4y77ph0EcfcqcUUj+T87FKyA@mail.gmail.com/
Link: https://lore.kernel.org/selinux/20250423175728.3185-2-stephen.smalley.work@gmail.com/
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Link: https://lore.kernel.org/20250424152822.2719-1-stephen.smalley.work@gmail.com
Fixes: b09e0fa4b4ea66266058ee ("tmpfs: implement generic xattr support")
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xattr.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/xattr.c b/fs/xattr.c
index fabb2a04501ee..8ec5b0204bfdc 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -1428,6 +1428,15 @@ static bool xattr_is_trusted(const char *name)
 	return !strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN);
 }
 
+static bool xattr_is_maclabel(const char *name)
+{
+	const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
+
+	return !strncmp(name, XATTR_SECURITY_PREFIX,
+			XATTR_SECURITY_PREFIX_LEN) &&
+		security_ismaclabel(suffix);
+}
+
 /**
  * simple_xattr_list - list all xattr objects
  * @inode: inode from which to get the xattrs
@@ -1460,6 +1469,17 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 	if (err)
 		return err;
 
+	err = security_inode_listsecurity(inode, buffer, remaining_size);
+	if (err < 0)
+		return err;
+
+	if (buffer) {
+		if (remaining_size < err)
+			return -ERANGE;
+		buffer += err;
+	}
+	remaining_size -= err;
+
 	read_lock(&xattrs->lock);
 	for (rbp = rb_first(&xattrs->rb_root); rbp; rbp = rb_next(rbp)) {
 		xattr = rb_entry(rbp, struct simple_xattr, rb_node);
@@ -1468,6 +1488,10 @@ ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 		if (!trusted && xattr_is_trusted(xattr->name))
 			continue;
 
+		/* skip MAC labels; these are provided by LSM above */
+		if (xattr_is_maclabel(xattr->name))
+			continue;
+
 		err = xattr_list_one(&buffer, &remaining_size, xattr->name);
 		if (err)
 			break;
-- 
2.39.5



