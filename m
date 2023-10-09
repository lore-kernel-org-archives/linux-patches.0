Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF971803A
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viTWAaOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F94C433C8;
	Mon,  9 Oct 2023 13:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857413;
	bh=RaFp6zF6pRPqdkNFbgdU48FRPl+fLFySEH83KhexbVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viTWAaOAzPN1kMPECfUM3w76Mkmdjf9gYzgc/be2cfXxXxE2iceG31aSZGb+L4sOw
	 KdAdo0Tou2x6kWZS5mA2HxfFuz8TqDawLD4+MWEcSG234yUqbF/vtgED5Nx0KO+5CU
	 tdFvqysnGrpHw9jjZaZXS4fdRP8FmBUmW1vqfui0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Kornievskaia, Olga" <Olga.Kornievskaia@netapp.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>,
	Kornievskaia
Subject: [PATCH 6.1 037/162] Revert "NFSv4: Retry LOCK on OLD_STATEID during delegation return"
Date: Mon,  9 Oct 2023 15:00:18 +0200
Message-ID: <20231009130123.965973301@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit 5b4a82a0724af1dfd1320826e0266117b6a57fbd ]

Olga Kornievskaia reports that this patch breaks NFSv4.0 state recovery.
It also introduces additional complexity in the error paths for cases not
related to the original problem.  Let's revert it for now, and address the
original problem in another manner.

This reverts commit f5ea16137a3fa2858620dc9084466491c128535f.

Fixes: f5ea16137a3f ("NFSv4: Retry LOCK on OLD_STATEID during delegation return")
Reported-by: Kornievskaia, Olga <Olga.Kornievskaia@netapp.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b927a7d1b46d4..e1297c6bcfbe2 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7157,7 +7157,6 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 {
 	struct nfs4_lockdata *data = calldata;
 	struct nfs4_lock_state *lsp = data->lsp;
-	struct nfs_server *server = NFS_SERVER(d_inode(data->ctx->dentry));
 
 	if (!nfs4_sequence_done(task, &data->res.seq_res))
 		return;
@@ -7165,7 +7164,8 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 	data->rpc_status = task->tk_status;
 	switch (task->tk_status) {
 	case 0:
-		renew_lease(server, data->timestamp);
+		renew_lease(NFS_SERVER(d_inode(data->ctx->dentry)),
+				data->timestamp);
 		if (data->arg.new_lock && !data->cancelled) {
 			data->fl.fl_flags &= ~(FL_SLEEP | FL_ACCESS);
 			if (locks_lock_inode_wait(lsp->ls_state->inode, &data->fl) < 0)
@@ -7193,8 +7193,6 @@ static void nfs4_lock_done(struct rpc_task *task, void *calldata)
 			if (!nfs4_stateid_match(&data->arg.open_stateid,
 						&lsp->ls_state->open_stateid))
 				goto out_restart;
-			else if (nfs4_async_handle_error(task, server, lsp->ls_state, NULL) == -EAGAIN)
-				goto out_restart;
 		} else if (!nfs4_stateid_match(&data->arg.lock_stateid,
 						&lsp->ls_stateid))
 				goto out_restart;
-- 
2.40.1



