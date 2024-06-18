Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBC8176FBB;
	Tue, 18 Jun 2024 12:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715470; cv=none; b=gwSLPxLWxt2pCMTSm345zMyB0a9rzUpYyMsAGPs+dBiBHfvoiMNXJJpSS+8mITFjakxcJcwvuzr2PZdsjy008OwDaiInrvBzb2KDUyyTeZ3mRQS+Hj5lcoo00ixfTnQB+zEhQH0apC1Gp7qt9wuPY7BTPi34Moj4240XBBa1I/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715470; c=relaxed/simple;
	bh=PRfpInrka8oSkzNqaK1Jy5vbgIVxZkwpCuLsPV0Lsh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmYgInnT/Hst7gXqqSPejRiNYTF50UOkVQEtR+MplL+Kl1rlR8T6ZqS6XmwuaZrQbxZ8EqBoO2vCNi9xrmkub11QBeMGiq4gC+H8XC95vg7/p9oTfiTCWl7cQOYW4+jtWncEqTolHSpBLLTUWgo+Ho9/S2iJsQ0q9275a73LPJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ce+7R1ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ce+7R1ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF6BC3277B;
	Tue, 18 Jun 2024 12:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715470;
	bh=PRfpInrka8oSkzNqaK1Jy5vbgIVxZkwpCuLsPV0Lsh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ce+7R1ewxpdIhQJyLGdtdKZM+/gffl/MxstiYDEORvWf/k0krhy/Vy3+8fUXHDMGZ
	 U2BzKWxX7hL+v007S7BEIrSWyqW3qia7tLC3g5lovbQK67mPaLSrC5bN5CBgABcXhf
	 WbfMR4cRTfzIVTQgrEbC+8kypqoU3QfF4gHE82ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/770] lockd: Update the NLMv4 nlm_res arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:53 +0200
Message-ID: <20240618123419.608279671@linuxfoundation.org>
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

[ Upstream commit b4c24b5a41da63e5f3a9b6ea56cbe2a1efe49579 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 47a87ea4a99b1..6bd3bfb69ed7f 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -295,6 +295,20 @@ nlm4svc_decode_unlockargs(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+int
+nlm4svc_decode_res(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_res *resp = rqstp->rq_argp;
+
+	if (!svcxdr_decode_cookie(xdr, &resp->cookie))
+		return 0;
+	if (!svcxdr_decode_stats(xdr, &resp->status))
+		return 0;
+
+	return 1;
+}
+
 int
 nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -375,17 +389,6 @@ nlm4svc_decode_reboot(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nlm4svc_decode_res(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_res *resp = rqstp->rq_argp;
-
-	if (!(p = nlm4_decode_cookie(p, &resp->cookie)))
-		return 0;
-	resp->status = *p++;
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nlm4svc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



