Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA3B6AC2;
	Tue,  5 Dec 2023 03:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHyMxhnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B507C433C7;
	Tue,  5 Dec 2023 03:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747764;
	bh=q7MnSV+GtaLlYgz01t3TQakpj66afsMhC/lQeNBngHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHyMxhnCnVwQOnKCaJwlUyhaODqKwgv8IdqQ6BV/u0ce6omJAXbEZNADyOM0ydsWi
	 37xWG8wZrl66LR5gUejhxpsVT7eO+2tYp+Pm8ZJcM1mqUBTlymXlQluH5xWPWR6tuO
	 GLswR5TyBVhid70poRZPgN6ZSYXR3BO2bPIqMi3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 59/67] smb3: fix caching of ctime on setxattr
Date: Tue,  5 Dec 2023 12:17:44 +0900
Message-ID: <20231205031523.296930214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9d486fbbfbbde..6f719b9cf9e9e 100644
--- a/fs/cifs/xattr.c
+++ b/fs/cifs/xattr.c
@@ -150,10 +150,13 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
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



