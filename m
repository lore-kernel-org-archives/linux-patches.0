Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984CF3BBFC7;
	Sat, 17 Oct 2026 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259106; cv=none; b=lbLVPFeJgWG/HHOiBE25mAshedd7c5p+Rb4yNRiNLFccULqr6+reSo8AUyN4j5Nm+PYUopNJqVVoAKv0QF4eb52jCJ2hHLtNBeGIU1nP76A6uyfuzJ5qvN9kSClzQCN7ktPF6PQQQLtyMKMzLGRwnmgENpGgLTX0bWivhMZOIFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259106; c=relaxed/simple;
	bh=t/segQQHPe9rOAgJxWbbkfjq8z2JysgZQb4JIfUmOyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocDx6QywLVE3ibQN+mVGtEXB0xk1D/22PEkEqYuT/GczJY/JTBvHe/E1zdDtieJbWURoYMHXM8p2yYQsGE5+kaSqs+/Hb2yZjR78/MI4Gh4JR1F3XK+n/oL40bBTsdGUI+zNsC79oopICj09NWhlnuKFrCxp4sYFSo8Zwqlxf1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0hFWNXy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0hFWNXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25851F000C4;
	Sat, 17 Oct 2026 17:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259105;
	bh=DQNvLCr0Ql2rGRc0gO/GOkfdDuya0+JPcrK0t45cuRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0hFWNXyKLVr6ZoP/esuARYAdvRBmU2AEzGrCno7ktiyrrIIQYnxB51AbaHhc7/4q
	 YhGUUNA3ibEiDNVkLSYX8YarSzdqzaPC1Cg1eYbmypWgpz9CWb3vmWtEEclAPYobfk
	 ZCoq5CeElgYmGNIdJch2vyXIfRQPx6525GJ96EIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1063/1674] smb/client: fix chown/chgrp with SMB3 POSIX Extensions
Date: Sat, 17 Oct 2026 17:55:35 +0200
Message-ID: <20261017160458.411374536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fcf9d0729e03a..fc76614148900 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3242,7 +3242,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
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



