Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3622839FC6;
	Fri, 24 Nov 2023 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4C7J02E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504FDC433C8;
	Fri, 24 Nov 2023 17:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700848676;
	bh=QAuWEI3ISTTvmzxDQotNPAd7uJb71cAqo1NEjZFcJQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4C7J02Ekkdmhnb4L5LUJoYEBWha1N1cedu2PXYkee697ok1o7N8VI5nMKqUqwBPI
	 fnWOBZ+IkVNrUepHEh7bL6dBydZoVeR164dGse2wWt/NbjjMnwBIFLtlj8ssucJGLW
	 Pbbecb31iCVgvLv5gYwjELRVQX2O/nh80p9FvMDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/97] NFSv4.1: fix SP4_MACH_CRED protection for pnfs IO
Date: Fri, 24 Nov 2023 17:50:09 +0000
Message-ID: <20231124171935.507323041@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124171934.122298957@linuxfoundation.org>
References: <20231124171934.122298957@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit 5cc7688bae7f0757c39c1d3dfdd827b724061067 ]

If the client is doing pnfs IO and Kerberos is configured and EXCHANGEID
successfully negotiated SP4_MACH_CRED and WRITE/COMMIT are on the
list of state protected operations, then we need to make sure to
choose the DS's rpc_client structure instead of the MDS's one.

Fixes: fb91fb0ee7b2 ("NFS: Move call to nfs4_state_protect_write() to nfs4_write_setup()")
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 3651619468d74..c44efead1a329 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -5143,7 +5143,7 @@ static void nfs4_proc_write_setup(struct nfs_pgio_header *hdr,
 
 	msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_WRITE];
 	nfs4_init_sequence(&hdr->args.seq_args, &hdr->res.seq_res, 0, 0);
-	nfs4_state_protect_write(server->nfs_client, clnt, msg, hdr);
+	nfs4_state_protect_write(hdr->ds_clp ? hdr->ds_clp : server->nfs_client, clnt, msg, hdr);
 }
 
 static void nfs4_proc_commit_rpc_prepare(struct rpc_task *task, struct nfs_commit_data *data)
@@ -5184,7 +5184,8 @@ static void nfs4_proc_commit_setup(struct nfs_commit_data *data, struct rpc_mess
 	data->res.server = server;
 	msg->rpc_proc = &nfs4_procedures[NFSPROC4_CLNT_COMMIT];
 	nfs4_init_sequence(&data->args.seq_args, &data->res.seq_res, 1, 0);
-	nfs4_state_protect(server->nfs_client, NFS_SP4_MACH_CRED_COMMIT, clnt, msg);
+	nfs4_state_protect(data->ds_clp ? data->ds_clp : server->nfs_client,
+			NFS_SP4_MACH_CRED_COMMIT, clnt, msg);
 }
 
 static int _nfs4_proc_commit(struct file *dst, struct nfs_commitargs *args,
-- 
2.42.0



