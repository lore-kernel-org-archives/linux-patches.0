Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033158;
	b=rARjaau1tpJn8ajj64NkJjriD9J0Zgr3HOzibrNW5jy6qY9UpJzfG8KxduC8dqhKY7yg
	 Eu3zFN1p9rBUlSZGup8myM0Tw1/eKmnlFUJu2ZSYNB0Zobb2SlNovCIOb6+0oNDIimsoH
	 Sa7avDkC+fqMbH2/zkM5OgFS0ZIYxtOP7C0eALrb6fqUqXFx7WWjeY1ULxptWQIuv0MjQ
	 JGe2slLAT/2Re/ArQtPnrP9JwAgVGn4vPNHbB7pwN5coGXGkmzQ/JxMT2r+pmO7uR50ZY
	 r7n97ZRpJ7iDHnp2Q62R3j/MKgrsboQDgvv4abOHbJi4F/mPPOSXVcDTVETKyFBjFrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6woVAOQQq6l2eVGdtvEVwb/GXyJHigmpl3TiVK7Lixg=;
	b=F/FLdUki7nYk5jwMF0xN82nkIsJg7nxDmzMQbKG5z9wJJT0NUk7gyyiyy4h6q73GRGE+
	 1sPtmOK3XU8cvd0sUXHF3EOHbg2vU4T39vk5v4RmoA1iJMiMNCBRbHR4DwKKOX+7WNRYT
	 YHEpV30aeg73GkTluXhsZbw4FW7AAgXQLo0iaZ4zV9E04rU7SbeF3obdNQgqW5t1WMnRD
	 t1gutxg1H9TCtvk3vy0PvZZXN40lJO46Xa3QX2nX7MYODnOAtjXFwMm7HZK1zRKQK+272
	 nQGoMiDU/XPICSrAlamAGEYPwhJ0Xm8na3ALtkh+repE0p71txiqpMEJ0jCe/79/7hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nifhVqnu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5FE606A334;
	Wed, 18 Nov 2026 20:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nifhVqnu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D211F000C8;
	Wed, 18 Nov 2026 20:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033157;
	bh=6woVAOQQq6l2eVGdtvEVwb/GXyJHigmpl3TiVK7Lixg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nifhVqnuk2bvusBSIPvNuAo6yXp3ec/m+H2BlxOpC2kvKfZRRgyqr9eTqTPvXs3GM
	 7/Ern3JAzDrLbUToAGk2G+wMvX8FTDBx+mgaGaTs9yNHtxn5Qnv/T2oATtmVtha5RD
	 a3dmKNVIw3/DzhJfFAPR8jSr6m3Ponj8fSGMOd94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1668/1756] xattr: always invoke cap_convert_nscap() for security.capability writes
Date: Wed, 18 Nov 2026 16:03:15 +0100
Message-ID: <20261118150116.107692975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 23b9e4b1f3dd8..72a49e0a2ec1e 100644
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



