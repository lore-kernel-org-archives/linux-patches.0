Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71931875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B2DC433D2;
	Wed, 28 Dec 2022 15:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242867;
	bh=+3N8A5ehwRNw1+D/NJfYjY1m1IDAkBhYXXBjXr/Pbu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gabd3jQ3RWuajJZbdZZ7OAI37lVcYbPXIcwE1vJn1rZwHixbeUBstQkaBDVmFLajc
	 nKs6Mz5bMlTX2NFJztuYdkkgghKb6IWuhZSqOxOGvAq6ZT8uPLr2YP7f8fSNUruS7k
	 sxFnjjQR2lHYTpObe3yAySqFcaK65psCHsJRPaAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0425/1146] NFSv4.2: Fix initialisation of struct nfs4_label
Date: Wed, 28 Dec 2022 15:32:44 +0100
Message-Id: <20221228144341.719847079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit c528f70f504434eaff993a5ddd52203a2010d51f ]

The call to nfs4_label_init_security() should return a fully initialised
label.

Fixes: aa9c2669626c ("NFS: Client implementation of Labeled-NFS")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 86ed5c0142c3..98a867092039 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -122,6 +122,11 @@ nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
 	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL) == 0)
 		return NULL;
 
+	label->lfs = 0;
+	label->pi = 0;
+	label->len = 0;
+	label->label = NULL;
+
 	err = security_dentry_init_security(dentry, sattr->ia_mode,
 				&dentry->d_name, NULL,
 				(void **)&label->label, &label->len);
@@ -3796,7 +3801,7 @@ nfs4_atomic_open(struct inode *dir, struct nfs_open_context *ctx,
 		int open_flags, struct iattr *attr, int *opened)
 {
 	struct nfs4_state *state;
-	struct nfs4_label l = {0, 0, 0, NULL}, *label = NULL;
+	struct nfs4_label l, *label;
 
 	label = nfs4_label_init_security(dir, ctx->dentry, attr, &l);
 
@@ -4682,7 +4687,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		 int flags)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
-	struct nfs4_label l, *ilabel = NULL;
+	struct nfs4_label l, *ilabel;
 	struct nfs_open_context *ctx;
 	struct nfs4_state *state;
 	int status = 0;
@@ -5033,7 +5038,7 @@ static int nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
@@ -5074,7 +5079,7 @@ static int nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
@@ -5193,7 +5198,7 @@ static int nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
-- 
2.35.1



