Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B478F75
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25692C433C9;
	Sun, 16 Jul 2023 20:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538688;
	bh=FKwkdh2mokyMTOLw2JfdnLXiIOww9tEyAmodkPwuKrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trsOu/cdJTLFsUKp/Lnow/r6d9CSApxNcFEbWC64XzHL35Ld+ekHndhy1xNOmM4rN
	 upJBuA0G9+N/JYfDy7PeHhJ+ND/pVuUWmWo1h9dN6KFvLV/UByY3J8ULuJ16Z3hcIx
	 /H7N17nTF9btbG+RpP2Df3Tpm39wu5HQYao2+mLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 541/800] cifs: prevent use-after-free by freeing the cfile later
Date: Sun, 16 Jul 2023 21:46:34 +0200
Message-ID: <20230716195001.658058775@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 33f736187d08f6bc822117629f263b97d3df4165 ]

In smb2_compound_op we have a possible use-after-free
which can cause hard to debug problems later on.

This was revealed during stress testing with KASAN enabled
kernel. Fixing it by moving the cfile free call to
a few lines below, after the usage.

Fixes: 76894f3e2f71 ("cifs: improve symlink handling for smb2+")
Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 163a03298430d..7e3ac4cb4efa6 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -398,9 +398,6 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 					rsp_iov);
 
  finished:
-	if (cfile)
-		cifsFileInfo_put(cfile);
-
 	SMB2_open_free(&rqst[0]);
 	if (rc == -EREMCHG) {
 		pr_warn_once("server share %s deleted\n", tcon->tree_name);
@@ -529,6 +526,9 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		break;
 	}
 
+	if (cfile)
+		cifsFileInfo_put(cfile);
+
 	if (rc && err_iov && err_buftype) {
 		memcpy(err_iov, rsp_iov, 3 * sizeof(*err_iov));
 		memcpy(err_buftype, resp_buftype, 3 * sizeof(*err_buftype));
-- 
2.39.2



