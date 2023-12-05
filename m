Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B9A6FB1;
	Tue,  5 Dec 2023 03:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="anB00jrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77380C433C7;
	Tue,  5 Dec 2023 03:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747557;
	bh=ANNWzkHcUrd9P78B/b2qxqW4FIhTUsXOLl2GzwSkkeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anB00jrVi+k7AiFASUZ7YUIAjIvY2K2OmlbgwxWUVtk5Lp/+kCewRrpDjYC3/OY4F
	 XjED4zYIebMYWlDab/YyjNdTUgNVe4JT+L25ZsCYLOjR9eBVYL2x8Wcq6ePlcNX33C
	 9mWjEvudNtJEnIP3IEox0sL+uop8yAKf39Vq+9LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 120/135] smb3: fix caching of ctime on setxattr
Date: Tue,  5 Dec 2023 12:17:21 +0900
Message-ID: <20231205031538.446463318@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve French <stfrench@microsoft.com>

[ Upstream commit 5923d6686a100c2b4cabd4c2ca9d5a12579c7614 ]

Fixes xfstest generic/728 which had been failing due to incorrect
ctime after setxattr and removexattr

Update ctime on successful set of xattr

Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
index b8299173ea7e3..c6931eab3f97e 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -157,10 +157,13 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
 			goto out;
 
-		if (pTcon->ses->server->ops->set_EA)
+		if (pTcon->ses->server->ops->set_EA) {
 			rc = pTcon->ses->server->ops->set_EA(xid, pTcon,
 				full_path, name, value, (__u16)size,
 				cifs_sb->local_nls, cifs_sb);
+			if (rc == 0)
+				inode_set_ctime_current(inode);
+		}
 		break;
 
 	case XATTR_CIFS_ACL:
-- 
2.42.0



