Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D2A4EC673;
	Tue, 13 Oct 2026 12:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893655; cv=none; b=oeUzHHiAtyjJFunmWOuvT+sWMQ9x1lP4ZjNf9wSsC8Cir5pE6f0nxCvYAYn2oPOedBuiotJKTnWnaPbleA7DSh9L9UJ3GTMAEReUsNXFh6nduPWF6FKhtDcsKDX8sTBsr2HSNIUMw7isETicRssAvkTkKdz46sXzV1jrhpmn06I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893655; c=relaxed/simple;
	bh=hRQEcT3AQ6zBrq/CdSdeHGO9XPSr7Lu0Fa+aRp91flU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K06+2Q/At/0J14eaTr+yUxB+3BjVBK1SkCY/Dz/iRfqM0hO/XhRhgtBz4SPnLCarLVThzohxmilePtq4n+6wDraK8bubNnZ1e5wBY0TrFIz+p68XnfQZgJjbXNlzFmFr+GrH9IQ9BcVDrRMKPK9P++19K4QwjdCrbIqdjaTArLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GfmniqaX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GfmniqaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DA51F000FF;
	Tue, 13 Oct 2026 12:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893654;
	bh=wak8S9ODFJ6M4DZjP5KBP0u14Mw56a+KhNKmqbLk9Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GfmniqaXyzmDdj/xy3q5498OIHlqkz/M+eB+VHu4YWZBxQYRgOvSS/WuYFjOPAo0k
	 vu+unVjnfC9Mfl0VmAkdKd7xiKHXlVJLLfc0/WySLXsF+WNcAzg1R/acHXRGgPO2Vu
	 lFxlaMhV6zBlp3i8B2GyvuApqVmi0GkPEM2Lvd58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ralph Boehme <slow@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 254/621] smb/client: fix chown/chgrp with SMB3 POSIX Extensions
Date: Tue, 13 Oct 2026 13:34:09 +0200
Message-ID: <20261013112926.889117302@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7f8d2edb828ee..aa3b275f33c9a 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3382,7 +3382,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 		gid = attrs->ia_gid;
 
 	if ((cifs_sb_flags(cifs_sb) & CIFS_MOUNT_CIFS_ACL) ||
-	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID)) {
+	    (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_MODE_FROM_SID) ||
+	    posix) {
 		if (uid_valid(uid) || gid_valid(gid)) {
 			mode = NO_CHANGE_64;
 			rc = id_mode_to_cifs_acl(inode, full_path, &mode,
-- 
2.53.0



