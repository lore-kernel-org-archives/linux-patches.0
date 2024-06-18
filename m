Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB3C156972;
	Tue, 18 Jun 2024 12:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715580; cv=none; b=RuO6cSaDTQVeAcyFRk2NP+E/3LCxYY3iB+m2p+eA9b+mlq/Slf9r+TP2tk7fq1LwXI8CBG/Nl+d2vO/8U1yKzkPI2yhHghSORPws+O3cMNcY5+y4shElbJb0YhrTj+JHnWSBcRkY7+gF1jjk8mqyze0FpCSXP/BCFCTWoDNUc2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715580; c=relaxed/simple;
	bh=EUOTRrkXRFtGWRiWSiGX2Rkl8q44Y9IceUO0QUOn52c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0T9wQOTdJKdOku9F3DUPAr30gReKNsMANbMhGB3w5Ze/OKxpthLlsrv9M9OhqZL69u8Z9mn9hemnqe3UWC74qAZcV1o8BMWW4/rIktVxckYhFnHLVR+0D9lGxTnmUUVTk/xtqjxXyodLadAgS2zxpUzLXZybWidxY6ffT4L9Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxDoG2dZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxDoG2dZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA47EC3277B;
	Tue, 18 Jun 2024 12:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715580;
	bh=EUOTRrkXRFtGWRiWSiGX2Rkl8q44Y9IceUO0QUOn52c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxDoG2dZJz6EahhLq6LnQvcXI+PT2L7c9VfVuro+fyxJo0sLOPzIJctUObk2cpAAs
	 tzKPJwChwkinrs6jfWXSRZV8pCy3xGtrnaaxi57GXf4CBlXib+18M+/kMhqJwblgYb
	 LNg8tzvFwqSgJKPZVB5+SPpKwqO/REAyKUa2b7YY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/770] NFS: Remove unused callback void decoder
Date: Tue, 18 Jun 2024 14:33:30 +0200
Message-ID: <20240618123421.047356665@linuxfoundation.org>
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

[ Upstream commit c35a810ce59524971c4a3b45faed4d0121e5a305 ]

Clean up: The callback RPC dispatcher no longer invokes these call
outs, although svc_process_common() relies on seeing a .pc_encode
function.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/callback_xdr.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/callback_xdr.c b/fs/nfs/callback_xdr.c
index e7d1efd45fa46..600e640682401 100644
--- a/fs/nfs/callback_xdr.c
+++ b/fs/nfs/callback_xdr.c
@@ -63,11 +63,10 @@ static __be32 nfs4_callback_null(struct svc_rqst *rqstp)
 	return htonl(NFS4_OK);
 }
 
-static int nfs4_decode_void(struct svc_rqst *rqstp, __be32 *p)
-{
-	return xdr_argsize_check(rqstp, p);
-}
-
+/*
+ * svc_process_common() looks for an XDR encoder to know when
+ * not to drop a Reply.
+ */
 static int nfs4_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
 	return xdr_ressize_check(rqstp, p);
@@ -1063,7 +1062,6 @@ static struct callback_op callback_ops[] = {
 static const struct svc_procedure nfs4_callback_procedures1[] = {
 	[CB_NULL] = {
 		.pc_func = nfs4_callback_null,
-		.pc_decode = nfs4_decode_void,
 		.pc_encode = nfs4_encode_void,
 		.pc_xdrressize = 1,
 		.pc_name = "NULL",
-- 
2.43.0



