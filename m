Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7969F1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A985C433D7;
	Wed, 23 Nov 2022 09:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196458;
	bh=epqlPfwW5mmXbY8koToNXaDlKsypaqIZpDyMNUSVwyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fB+ZcmVhOs8SKlVC2eYj5usbta1j8K+/3iukymjzH6nmdGr5wt6AAWvIntyaoMo6r
	 PtNZNiQv5fh2THYYfVvh49pvsssLs0Td9LnyBSMdCu4bLFQWVwAQ1Ko+lFBfGhHNVU
	 vY8aPjtMWic6G8tnI1eKMItzn5RqrRZ4WXrVybDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gonzalo Siero Humet <gsierohu@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 035/314] NFSv4: Retry LOCK on OLD_STATEID during delegation return
Date: Wed, 23 Nov 2022 09:48:00 +0100
Message-Id: <20221123084627.115425342@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit f5ea16137a3fa2858620dc9084466491c128535f ]

There's a small window where a LOCK sent during a delegation return can
race with another OPEN on client, but the open stateid has not yet been
updated.  In this case, the client doesn't handle the OLD_STATEID error
from the server and will lose this lock, emitting:
"NFS: nfs4_handle_delegation_recall_error: unhandled error -10024".

Fix this by sending the task through the nfs4 error handling in
nfs4_lock_done() when we may have to reconcile our stateid with what the
server believes it to be.  For this case, the result is a retry of the
LOCK operation with the updated stateid.

Reported-by: Gonzalo Siero Humet <gsierohu@redhat.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 3ed14a2a84a4..313e9145b6c9 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7137,6 +7137,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_lockdata *data = calldata;
 	struct nfs4_lock_state *lsp = data->lsp;
+	struct nfs_server *server = NFS_SERVER(d_inode(data->ctx->dentry));
 
 	if (!nfs4_sequence_done(task, &data->res.seq_res))
 		return;
@@ -7144,8 +7145,7 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	data->rpc_status = task->tk_status;
 	switch (task->tk_status) {
 	case 0:
-		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
-				data->timestamp);
+		renew_lease(server, data->timestamp);
 		if (data->arg.new_lock && !data->cancelled) {
 			data->fl.fl_flags &= ~(FL_SLEEP | FL_ACCESS);
 			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
@@ -7166,6 +7166,8 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 			if (!nfs4_stateid_match(&data->arg.open_stateid,
 						&lsp->ls_state->open_stateid))
 				goto out_restart;
+			else if (nfs4_async_handle_error(task, server, lsp->ls_state, NULL) == -EAGAIN)
+				goto out_restart;
 		} else if (!nfs4_stateid_match(&data->arg.lock_stateid,
 						&lsp->ls_stateid))
 				goto out_restart;
-- 
2.35.1



