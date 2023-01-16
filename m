Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9D46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499EEC433EF;
	Mon, 16 Jan 2023 16:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885808;
	bh=7MU6reeRN23qenEgOAQ6GOmM/thQ4/aZ/GMi6+ynRQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTmA4OcsR1XeONgQKbH4cIQMwHNsN/8qSwlaJ0LEYwcAVIxD8dLQEaJ6/1MaOuFie
	 LwVvqHWr1tacD/jl7TvjSD9kG6YOqR9vCymivxHU6in81yhxmxz0oxuEyDaf3f25i9
	 LmexzYByElxbRwBJbTy/v4bu5Knk28yX1p7LLhFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 162/658] NFSv4.2: Fix initialisation of struct nfs4_label
Date: Mon, 16 Jan 2023 16:44:10 +0100
Message-Id: <20230116154916.873533762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index 77c2c88621be..3da48dd67b83 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -121,6 +121,11 @@ nfs4_label_init_security(struct inode *dir, struct dentry *dentry,
 	if (nfs_server_capable(dir, NFS_CAP_SECURITY_LABEL) == 0)
 		return NULL;
 
+	label->lfs = 0;
+	label->pi = 0;
+	label->len = 0;
+	label->label = NULL;
+
 	err = security_dentry_init_security(dentry, sattr->ia_mode,
 				&dentry->d_name, (void **)&label->label, &label->len);
 	if (err == 0)
@@ -3742,7 +3747,7 @@ nfs4_atomic_open(struct inode *dir, struct nfs_open_context *ctx,
 		int open_flags, struct iattr *attr, int *opened)
 {
 	struct nfs4_state *state;
-	struct nfs4_label l = {0, 0, 0, NULL}, *label = NULL;
+	struct nfs4_label l, *label;
 
 	label = nfs4_label_init_security(dir, ctx->dentry, attr, &l);
 
@@ -4497,7 +4502,7 @@ nfs4_proc_create(struct inode *dir, struct dentry *dentry, struct iattr *sattr,
 		 int flags)
 {
 	struct nfs_server *server = NFS_SERVER(dir);
-	struct nfs4_label l, *ilabel = NULL;
+	struct nfs4_label l, *ilabel;
 	struct nfs_open_context *ctx;
 	struct nfs4_state *state;
 	int status = 0;
@@ -4850,7 +4855,7 @@ static int nfs4_proc_symlink(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
@@ -4891,7 +4896,7 @@ static int nfs4_proc_mkdir(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
@@ -5012,7 +5017,7 @@ static int nfs4_proc_mknod(struct inode *dir, struct dentry *dentry,
 	struct nfs4_exception exception = {
 		.interruptible = true,
 	};
-	struct nfs4_label l, *label = NULL;
+	struct nfs4_label l, *label;
 	int err;
 
 	label = nfs4_label_init_security(dir, dentry, sattr, &l);
-- 
2.35.1



