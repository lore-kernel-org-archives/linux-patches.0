Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028218;
	b=hOmmycneOzyYvs4nb/BuwPzEL/JNJsVBK3zoZvzAmlWchYBoxerybwxHSkn6XEtRlJjN
	 +xo+uvnjAccbpeCJrAJhCxgsGRcrcQQBzhJl3Zhiq7NtpDouaKiAU0v6DwUiWUhyDKJkO
	 lof84ZXbBhzdwob8QxjOnNdPiqPJXSNu5iyYRxguG9P8AXHXEA69CI9g8PzwJgJfCM/CK
	 7oapXGL1mJRgEZs3kLLHTxzObol7v4zckWOQrGvIr9JWHG1jDwINjpFE+5ossPFZQ8fk7
	 RVp5tb0+TYFS5JQmfnrWye9D0lPDyNMigYANdDT3U5lx3yWsn1+uFsq6uypskvICleg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oVxk8+g+A04ztOS4In2ImR0Gy3IuncZNQGM+rB8lYtc=;
	b=BDgf3DYCU3JPGnt/AQXeHd3T6znxxoDWrkWKUU4I+zXuv9Vh+qNf07Cr+dQjGKdDGBLN
	 MF42RyZ4uZHCBNz7yO/RFwpz0oq77MsfXA3vXEfEaVtyUZaS/sfQqv2h5Z05bkrGAzb9m
	 mjEPPVJREd6A4uhxdLDmWnHKJ8+2QdASzmPqMnCewj76tsjVnXjVkWKg6FRnPfn1kqkQG
	 q0kZ4BnhExJtuthPMR9Lub4eZal0cBsOsJhvlAPHb9bHlsNg74ae2o09PtKKMRMbSKOBT
	 yxsWtcjrGkpFrAUIGP4KwgMcO7AH3NY/GM2xgmDq7rVTgFHngpHAjNZfSGoNBm6Gc4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQjww2I1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC6F606A31C;
	Wed, 18 Nov 2026 18:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qQjww2I1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD711F000C4;
	Wed, 18 Nov 2026 18:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028218;
	bh=oVxk8+g+A04ztOS4In2ImR0Gy3IuncZNQGM+rB8lYtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQjww2I1rfqjLJQoYf9+OklOy88SfuPfxjpIxe56xtWCkYkMVkZKCQuklqrkqeJOP
	 spozJ6a9tQZm7Z+My/u6Zd1aleQ/Wou69/kZBTZCS4o4BLCCohXPPkjxI32H2g+neb
	 rXR45GbP1Vrisj1URBNiDrNAgArNd82IhldLBxNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2067/2151] xattr: always invoke cap_convert_nscap() for security.capability writes
Date: Wed, 18 Nov 2026 16:03:22 +0100
Message-ID: <20261118150237.016594939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominik Maier <dmnk@google.com>

[ Upstream commit 0f4a9e682f7fa5becc3af7204606d9bf4780e425 ]

Commit 8db6c34f1dbc ("Introduce v3 namespaced file capabilities") changed
cap_inode_setxattr() to return 0 unconditionally for XATTR_NAME_CAPS
("security.capability") and moved capability validation into
cap_convert_nscap(), but placed the call inside the "if (size)" block in
setxattr(). Commit 7c03e2cda4a5 ("vfs: move cap_convert_nscap() call into
vfs_setxattr()") preserved that "size &&" condition in vfs_setxattr():

	if (size && strcmp(name, XATTR_NAME_CAPS) == 0) {
		error = cap_convert_nscap(idmap, dentry, &value, size);
		...
	}

For security.* extended attributes, xattr_permission() skips
inode_permission(MAY_WRITE) and leaves permission checks to the security
module, while cap_inode_setxattr() returns 0 for XATTR_NAME_CAPS assuming
cap_convert_nscap() has already validated the write. Because
__vfs_setxattr() treats size == 0 as an empty attribute write (setting
value = "") rather than a removal, calling setxattr(2) on
"security.capability" with size == 0 bypasses cap_convert_nscap() and
allows an unprivileged caller without CAP_SETFCAP or write permission on
the target inode to write a 0-byte security.capability xattr (or
overwrite an existing one).

When that binary is subsequently executed, get_vfs_caps_from_disk() reads
the 0-byte security.capability xattr and fails the
size < sizeof(magic_etc) check with -EINVAL, causing execve(2) to fail
with -EINVAL.

Always invoke cap_convert_nscap() when strcmp(name, XATTR_NAME_CAPS) == 0
regardless of size, so that 0-byte writes hit the existing !*ivalue /
!validheader() checks in cap_convert_nscap() and are rejected with
-EINVAL.

Fixes: 8db6c34f1dbc ("Introduce v3 namespaced file capabilities")
Signed-off-by: Dominik Maier <dmnk@google.com>
Link: https://patch.msgid.link/20261022232119.2537209-1-dmnk@google.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xattr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index 8851a5ef34f5a..733ee0a99b167 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -309,7 +309,7 @@ vfs_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	const void  *orig_value = value;
 	int error;
 
-	if (size && strcmp(name, XATTR_NAME_CAPS) == 0) {
+	if (strcmp(name, XATTR_NAME_CAPS) == 0) {
 		error = cap_convert_nscap(idmap, dentry, &value, size);
 		if (error < 0)
 			return error;
-- 
2.53.0



