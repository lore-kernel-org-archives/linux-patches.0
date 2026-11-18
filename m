Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022201;
	b=ESB6rShDiEom4RbZiZ4hayNfIipZi6sKV8G2QRTlaWWapy3yiPo8og9cd894wJbNVuVM
	 963kwFClLEyhhw2QsjKOeZ+GgiCprbo3Gx8c5j2gAB73diVlPeWME4cOGjHUhG3NCzlGd
	 CBCna4R3jmKxW0h58nPOEq50hr+lq8kuwp+3Uk2wN6V+x0XllQaheZbYvVERo6p0VwZ06
	 4kZTZEHz0tPT1/h1HTAbwLYXOhytvKoZEGWHfh7YaewDdoUUXR543NG/+0Q1Mbj2YKaso
	 b5E5Qr235R54odIC5Y+hqACtXw8THIMsc34CwLpNKxxYm/2M3dvMThAzmzKE0M4NsMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FamDkIm1W7H//ywItiVZXU4Urd3sODNzyBhG+y6S0U8=;
	b=w+OMS11zXasfXWttQCDYlYNFcPzu+F9VTBw/qRx+SYio1rmpojjCOVGxYHpRAQLG5SZR
	 6fR2tUNiUa+VmPjBkzR2j53z/7o4cGySL8egTqurqFbNjUh1c+6FTETXfdC2cgmboOg5K
	 pF2mTr34MFxQ3v5aBjHDSI1VjHcZJneGaFMGL3st61mh0g9LWqnEk3UiFvoAnBcfSSuW9
	 I21ClJOxawY4jgD195PwakzrN1lODOPsD6ze/lY3ZyrMRqXmt3ltn/xghMWW70MRSeR75
	 6XbWRT3AGPW1c62sjtjnah2+vgieSnJ0Em6sN8JR8wld5g2upZpEzulWFsvhwAFknlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gXzh/2W0";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A9D606A334;
	Wed, 18 Nov 2026 17:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXzh/2W0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE641F000C7;
	Wed, 18 Nov 2026 17:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022201;
	bh=FamDkIm1W7H//ywItiVZXU4Urd3sODNzyBhG+y6S0U8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXzh/2W0nxOrTyKOkIvQQZybNrOrCAFCzTzZdBQLGqfkl3bxbaBclWpZoKzE0BAHP
	 wFQuxmivtk0rPtSu/S3kYMI35agnsjv7Q85BrdKsWbffABqOQOQWEDfz1fiN8NK9jR
	 ym4OBYLmmqZwaARg/Q2IJbU45iXZ/S4+log+UUv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2576/2651] xattr: always invoke cap_convert_nscap() for security.capability writes
Date: Wed, 18 Nov 2026 16:03:36 +0100
Message-ID: <20261118150417.088247384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index d589791152007..44710ef2dfe50 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -332,7 +332,7 @@ vfs_setxattr(struct mnt_idmap *idmap, struct dentry *dentry,
 	const void  *orig_value = value;
 	int error;
 
-	if (size && strcmp(name, XATTR_NAME_CAPS) == 0) {
+	if (strcmp(name, XATTR_NAME_CAPS) == 0) {
 		error = cap_convert_nscap(idmap, dentry, &value, size);
 		if (error < 0)
 			return error;
-- 
2.53.0



