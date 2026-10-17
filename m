Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6882C026C;
	Sat, 17 Oct 2026 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254203; cv=none; b=AmC/IrctmIuaCrb+UaKewF4m2dtIfvtdLVE+oE8gpyimnfv0KBbhgGtaUxKOXHCozbNyn+vtM7n7IzMvo4CZIw64/U/Qtzw9pi3okl3nuLPxXGZB9nGw0C5F6EI2hiKucAw51b9YbjhacLvOGlkhPXH6O8Jiq8De3T5KCxd5uKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254203; c=relaxed/simple;
	bh=UU0OEv0Jf4RA4wJO39mWYVrZ/Ae4WI/Mwd59MTt5e+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RptK1ciRRGZONwJd4zbc5RSB+ocdSKJl9f62wvBVouXojlV3NzkrkCiMsJc5H1zWTTKdtYhqHg2iEw41MMz7MrwnC/UzFAWVWillCorT2fLhETpeqehKBOi6BzFQsU2nO8ZYfYQaHWDn+WjzFBxAwYkOHB6hvqyvNhuzvOoTOFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNxFTep8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNxFTep8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD011F000C4;
	Sat, 17 Oct 2026 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254201;
	bh=ZOUJthvUYk3CQCiFvi3aI/eg3rdaw1CfT8f5P2Y9F8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNxFTep8H93cYjmkKVXpupwIy2LONPY2TUtnEgLxL7eAYCrlc54i2xA0gj6Kpxmvy
	 UkS8EQ4LCF2rE5rh7IdLa06KAUnJpKgryByLFQPw/qV+pDGP7+DI36aa2iSxpv5sSH
	 JIvYeDCeKRYa7qcfuaMoA+N9s9XWMgOQbLy6uUzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 368/869] smb/client: fix chown/chgrp with SMB3 POSIX Extensions
Date: Sat, 17 Oct 2026 17:53:29 +0200
Message-ID: <20261017160046.543937032@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7c4828580076c..acb3220e5b703 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3296,7 +3296,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
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



