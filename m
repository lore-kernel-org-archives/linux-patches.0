Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215264;
	b=KRsWyQWWSBVXcWC5nieCvOX8XDmL65TVPmKRYlJibibjhGNJ6HmSPM6EqtgBWSE9i2EN
	 33p6RwsIWORJOQG7v89EJx1TmrzG4bgAJgRVBasnlQRwjkjAujFiXrcZIXw0vwwAR3eJd
	 NLz6zXAU0HAUUg/0/cJxV/BVHg+9KWC/BtqbIl71CDlw0zucvUyZoL51t2y0ZeZmCI5F0
	 UMybL5ljCIaFRkTxDGr/5bsBhM/K5m0+YqQCdo4YpTAneofth+X0QRx0WFr6Vpkq13p0b
	 2HJyr6/Qn+9Vhx+SGsyxq7uJRtZF52xXHBlOQxFa5jeOABYihW0Fmny8JZLDE6PmXtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pm4TwNMisJfqog8ykgJeD+nMt9YA3QqZba0LFTZtm80=;
	b=hYS8hVabtWasfnv+vj40D87/7RqGOiV+iPyaUiDOWFeRPpC0FOeL9hx2l//FXbBQQgCn
	 O/FGnss5+eK4aEX+CpC6m+fPdIjfPw4Bf/Qu5WG26tBm0ztotMNAcQ3rk7rywFeLW4E9B
	 2BOfhuveLHfg6XzM2XyCkoc0H5QdoIokLHnl+pGZONbrjvKqtgV9Stp05qrow6PdEl0Qt
	 J5Bu0HZXc+JCA9+9S/5pcltZ7cZS11m69+J42VD210i3K+JvHU18BktzeF+Lvy99cjyoR
	 u7kRyYAAsZIHle2326EnSi8RPCcluVLHQ9MoceY0y4ipjrfNXis0T7lIu9rZhM3UUHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgjGtkEB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F82606A31C;
	Wed, 28 Oct 2026 19:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgjGtkEB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BC21F01825;
	Wed, 28 Oct 2026 19:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215264;
	bh=pm4TwNMisJfqog8ykgJeD+nMt9YA3QqZba0LFTZtm80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgjGtkEBz9MKScR/qyQn0IvUn17I1HStQWXnRDUusSMNPllwCoKNFv8hfkCGjXrXM
	 qIFpderwwCS5ZhHZPkDOoWMox+jfgToVyaNETMQHr4VxZ03lablo5Ax0bVjzijHBcN
	 3ev/JKOQ+FLQOSYmOq+xVbRrgNxNDzb6nAM4YIqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1151/1887] smb/client: fix chown/chgrp with SMB3 POSIX Extensions
Date: Wed, 28 Oct 2026 17:54:07 +0100
Message-ID: <20261028170525.597833264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralph Boehme <slow@samba.org>

[ Upstream commit 760ef2c579c2609cf17fb1cd5392f64d42d43d33 ]

Ownership (chown) and group (chgrp) modifications were being ignored when
mounting with SMB3 POSIX Extensions unless CIFS_MOUNT_CIFS_ACL or
CIFS_MOUNT_MODE_FROM_SID were also explicitly set.

Fix this by checking for posix_extensions in cifs_setattr_nounix() when
updating UID and GID, ensuring that id_mode_to_cifs_acl() is called to map
and set the ownership/group information on the server.

Cc: stable@vger.kernel.org
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 9da26e43ea322..9ea5f5b9dca91 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3004,7 +3004,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 		gid = attrs->ia_gid;
 
 	if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID)) {
+	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) ||
+	    cifs_sb_master_tcon(cifs_sb)->posix_extensions) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
-- 
2.53.0



