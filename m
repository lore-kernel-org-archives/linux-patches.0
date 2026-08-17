Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADDA3E4C94;
	Mon, 17 Aug 2026 13:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973890; cv=none; b=LYltK0aG1wHWZUQz/m6EHtgcUMmNLhVIuCVGLGqGikSKXRrXUYmNua2xRV3aYPv+Ffnw9XjCvaIQ9sgIV9FJJXJcG125dleuy3tyQvKLMZ3ytiY1djqF4PFuDZhsgL3+65W/jfzUtCX/eGtBCP2SZL/0d6qd1jaM10CHUzIPGFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973890; c=relaxed/simple;
	bh=BpDg+hc/cFnwUoHS6tmgKTScC/NOYsjjgWmTUIKAovU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZRPGgImLuiIl510JlmH/Q2R7WXFnXoJ1TSobaCFNJiBDSC6QXU+f+WdHugtVVloQt80lFndtBSJiEM3ncGzBrZmWYN2N3faErAN4Ekv16iJqKd4rhh/XGdKiydyr+ewUIcaGRQSXasWXHe0okNZSSSLUWZyGcnM/74znqcO/Oxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYD3Rnj7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYD3Rnj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B24B1F000E9;
	Mon, 17 Aug 2026 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973889;
	bh=P7j4vjoz/AGp59p7uFV+djnsRxtn/Pko9XD03tgSPS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYD3Rnj7Ij86XU6g4eDpfueMsN8bsWCisgNnJ5WThhZIbTekHQUFy0cdrLs6jnowB
	 s4M+OcHY7SqmzgLD6g+C7L2gHhsZpQSMG/96DsuhA0t/xB2ezBe1lNqDHd4ZbhPnUl
	 iMdpN1XIfsmAqUVqALbui3wjQpTosxkcaWbM0C9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 017/271] NFS: Decrement refcounts if allocating nfs_free_stateid_data fails
Date: Mon, 17 Aug 2026 15:29:02 +0200
Message-ID: <20260817132537.483163842@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

From: Anna Schumaker <anna.schumaker@hammerspace.com>

[ Upstream commit 4aeb63d5ac2dba2a474e7b64d60776d9dd1c6cd2 ]

I noticed that we were immediately exiting this function if the
allocation fails, leaving the client and server object refcounts bumped.
Fix this by creating a common exit point to clean up dangling
references.

Fixes: 576acc259146 ("nfs4: take a reference on the nfs_client when running FREE_STATEID")
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index bea00343f09b1..6142a7daf983d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10369,21 +10369,22 @@ static int nfs41_free_stateid(struct nfs_server *server,
 	struct nfs_free_stateid_data *data;
 	struct rpc_task *task;
 	struct nfs_client *clp = server->nfs_client;
+	int ret = -EIO;
 
 	if (!refcount_inc_not_zero(&clp->cl_count))
-		return -EIO;
-	if (!nfs_sb_active(server->super)) {
-		nfs_put_client(clp);
-		return -EIO;
-	}
+		return ret;
+	if (!nfs_sb_active(server->super))
+		goto out_put_clp;
 
 	nfs4_state_protect(clp, NFS_SP4_MACH_CRED_STATEID,
 		&task_setup.rpc_client, &msg);
 
 	dprintk("NFS call  free_stateid %p\n", stateid);
 	data = kmalloc_obj(*data);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		ret = -ENOMEM;
+		goto out_put_server;
+	}
 	data->server = server;
 	nfs4_stateid_copy(&data->args.stateid, stateid);
 
@@ -10399,6 +10400,11 @@ static int nfs41_free_stateid(struct nfs_server *server,
 	rpc_put_task(task);
 	stateid->type = NFS4_FREED_STATEID_TYPE;
 	return 0;
+out_put_server:
+	nfs_sb_deactive(server->super);
+out_put_clp:
+	nfs_put_client(clp);
+	return ret;
 }
 
 static void
-- 
2.53.0



