Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DBC3D522F;
	Thu, 16 Jul 2026 13:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209557; cv=none; b=sfvmIlcP/7hzw03vpM2vN4vGT5YCN+4t0tUCL7BuSWKrpgEVMJT4M4dPJLOvxTsCHG8yPRzulFw650LKl/CpE1ajdKhIhQQA1O4zvUfYkkGy2wuoCy1XdUc7tU0UMl6/zOz8YtEHEzOS6WUnwEYCpAcEWi6NCszVZp9pQrtgCx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209557; c=relaxed/simple;
	bh=YanmnAdWiy5qDtBisOI8o3qIuExPsk9mArLbprY2bE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKXYJOox9I96eNuTgFksYtxLkICOkJviWJYi6rmho3D9VluD5h0xrWsKSfkf4OmiybaAybMvsVnxCev349u2uOvV9zOX1bh7urNkiKlz94Kfxy+bTrrkGaT1VuShbRYQUCAVPQpBxY2pK5MXJiwIqzmC8mJ8+E0ZK6UUTUbPvKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0+8pZr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0+8pZr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DA31F000E9;
	Thu, 16 Jul 2026 13:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209552;
	bh=/5QKkv/FRe1QHRsAe+rPdaxhQfeoqi98kZMFsrtsAvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0+8pZr8SQm5xXf/gwzx4TwZKhJMy0TrsGhW80psUALEjxl33omiVYwWD1MRb/5jO
	 7qbji37J/PTcYkeQRAQPAB/GSNy9zlQ9MOD7AeoHJsP+g7RBK+DOO2Ba6BcVnjnOKn
	 FAroE8D/0WNLd6LOlCD3cZ0fF7bATmftSHtIXSNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.1 230/518] smb/client: fix chown/chgrp with SMB3 POSIX Extensions
Date: Thu, 16 Jul 2026 15:28:18 +0200
Message-ID: <20260716133052.855258485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Ralph Boehme <slow@samba.org>

commit 760ef2c579c2609cf17fb1cd5392f64d42d43d33 upstream.

Ownership (chown) and group (chgrp) modifications were being ignored when
mounting with SMB3 POSIX Extensions unless CIFS_MOUNT_CIFS_ACL or
CIFS_MOUNT_MODE_FROM_SID were also explicitly set.

Fix this by checking for posix_extensions in cifs_setattr_nounix() when
updating UID and GID, ensuring that id_mode_to_cifs_acl() is called to map
and set the ownership/group information on the server.

Cc: stable@vger.kernel.org
Signed-off-by: Ralph Boehme <slow@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3348,7 +3348,8 @@ cifs_setattr_nounix(struct dentry *diren
 	if (attrs->ia_valid & ATTR_GID)
 		gid = attrs->ia_gid;
 
-	if (sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)) {
+	if ((sbflags & (CIFS_MOUNT_CIFS_ACL | CIFS_MOUNT_MODE_FROM_SID)) ||
+	    cifs_sb_master_tcon(cifs_sb)->posix_extensions) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,


