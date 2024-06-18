Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F350181CE9;
	Tue, 18 Jun 2024 12:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715577; cv=none; b=AwRsVmNmTx0FRvsp7x7C7DFZlxwg9O3XHzVK/eMh/bXYd4fq0Y51TBfW5ihbR/HJTN2h0nok/HaRcDQSd/6DqB2qIsmI4Z3MdeOUosyndWyhI0fasBnnntUEUqVm+5xlig1j5sYjvL1hOv8S3nxeV3JdgOd/b3kVxaDIzjHIXWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715577; c=relaxed/simple;
	bh=Wi9EDac6rHEMJSk4gokA3FlcLGsiV+qKHSByVFm7zx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBiurQkMCdNIYoIM7pP/yDGKOtvUjCjuFz8H6o4yeGPkWEjNEBrVxmBUqpPLgomldUpl056+lMyTicqwJRMURJf4B+2LgS7pgqVnaywJrn1oih6dkC3R2KVmrGAclKBMXjw+a88vMm3p9yMNJ/J70pZcyOO0ynV2IHToKWjL5ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wcU2QiY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wcU2QiY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C864BC3277B;
	Tue, 18 Jun 2024 12:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715577;
	bh=Wi9EDac6rHEMJSk4gokA3FlcLGsiV+qKHSByVFm7zx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wcU2QiY5woVUNk1sf1wW/CdH8c5BPglVvCEbirXOOdZidgviWaJJcgZnfVzsprSQA
	 57RZ/AtXwQdHYcOLSJR5mXKlrnjZDnlSUFnHNApPWm6ulnUHMe4zShv5+QP8KJl42h
	 GhzyK0DMarsTYRFlDN+6AkZrmDCnQAx0VKjMnlZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/770] NFS: Add a private local dispatcher for NFSv4 callback operations
Date: Tue, 18 Jun 2024 14:33:29 +0200
Message-ID: <20240618123421.010131024@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 7d34c96217cf3c2d37ca0a56ca0bc3c3bef1e189 ]

The client's NFSv4 callback service is the only remaining user of
svc_generic_dispatch().

Note that the NFSv4 callback service doesn't use the .pc_encode and
.pc_decode callouts in any substantial way, so they are removed.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index 0559e8b6a8ec4..e7d1efd45fa46 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -988,6 +988,15 @@ static __be32 nfs4_callback_compound(struct svc_rqst *rqstp)
 	return rpc_success;
 }
 
+static int
+nfs_callback_dispatch(struct svc_rqst *rqstp, __be32 *statp)
+{
+	const struct svc_procedure *procp = rqstp->rq_procinfo;
+
+	*statp = procp->pc_func(rqstp);
+	return 1;
+}
+
 /*
  * Define NFS4 callback COMPOUND ops.
  */
@@ -1076,7 +1085,7 @@ const struct svc_version nfs4_callback_version1 = {
 	.vs_proc = nfs4_callback_procedures1,
 	.vs_count = nfs4_callback_count1,
 	.vs_xdrsize = NFS4_CALLBACK_XDRSIZE,
-	.vs_dispatch = NULL,
+	.vs_dispatch = nfs_callback_dispatch,
 	.vs_hidden = true,
 	.vs_need_cong_ctrl = true,
 };
@@ -1088,7 +1097,7 @@ const struct svc_version nfs4_callback_version4 = {
 	.vs_proc = nfs4_callback_procedures1,
 	.vs_count = nfs4_callback_count4,
 	.vs_xdrsize = NFS4_CALLBACK_XDRSIZE,
-	.vs_dispatch = NULL,
+	.vs_dispatch = nfs_callback_dispatch,
 	.vs_hidden = true,
 	.vs_need_cong_ctrl = true,
 };
-- 
2.43.0



