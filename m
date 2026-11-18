Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042777;
	b=fsabddSvQVmVwjbs5qBrPOnI3e193PNIZWt1JM2YE3BFR3WzztOn5fwil0tPV5B8bU4L
	 g0yOw3/PP3hddv/PtpertHBtgvUViD8KstiO+GODKSl4/kVlsT+NCNC9dE25v+Y4fU1ju
	 tAnVkdClApaPds6+6ViQpfocIrbdXvykDnclPa5iWtjTasBax+Oy988P+gwpjBN7Ut9Ba
	 IqCrGF9TXooEGu9XBH0m2GpFIcH5liRtqdL95hf85XaNH6EddrlSwi8cWT1wjauIcV9SE
	 LgllbRbagNl5V9Cz1NZW2puxtxC1mHRXQRTW15tLOEDO6tznZAtS+86w86cmeHdvPQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UcPFuXfcKDogEy2CT7tUmk/Uzxtw23WK89p4aT1L/qs=;
	b=EOnsKxxlVT9lbr3JwXh306usSKzAXUm9fJl9aFciZ0ZY/6driHuTzb5lgs01p1VFmhqn
	 NMQkwJ/Le7A3J0E1YBxG2cswcQyw2tEGZXDZAMoYumEhz23sNK8xrpxdBzdNdXSv5W3AG
	 Gm9ThtpVH6ZLL90nU/0c3KrYdGm6JCzOz8T4365sdSTqwPq2qu8ZGrz5legpvKQiL0F67
	 z3x6duSCxROicthrlPog4ULLbUuZd8rl5ISXj/YUaLrtJnPz3ZbTWhClOlkOEjkQWPcpX
	 TWdliS8eb14h/N8yRb+1ILWahWMnJCD9YUMKxtLKs0jIzs72gfRBRQH86gzPyVG3PWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWZRiJvR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F28606A31C;
	Wed, 18 Nov 2026 22:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IWZRiJvR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363251F000C4;
	Wed, 18 Nov 2026 22:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042776;
	bh=UcPFuXfcKDogEy2CT7tUmk/Uzxtw23WK89p4aT1L/qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IWZRiJvR/as+oNvleRrYqzWf3TELU7EYskH/v0fJyHwR+KIa3/8G9KLa2lVULgJHV
	 CH9XGLK2C1P3zybWtar/htoKuVbCYoA2yu1t1RDUyKqdfW7zTKw1j2WZuMCERKB6ui
	 63vPKVasNJfJhIIp9eygToS/rQIpRHlEbE5VyWd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3251/3318] xattr: always invoke cap_convert_nscap() for security.capability writes
Date: Wed, 18 Nov 2026 16:04:33 +0100
Message-ID: <20261118150457.174127256@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20a038b06d127..7ba337bb640f2 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -310,7 +310,7 @@ vfs_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	const void  *orig_value = value;
 	int error;
 
-	if (size && strcmp(name, XATTR_NAME_CAPS) == 0) {
+	if (strcmp(name, XATTR_NAME_CAPS) == 0) {
 		error = cap_convert_nscap(idmap, dentry, &value, size);
 		if (error < 0)
 			return error;
-- 
2.53.0



