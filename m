Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA90215B541;
	Tue, 18 Jun 2024 12:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714723; cv=none; b=it79u4W1hHdIi0ZKD4D7DegTEFXKuthppKPkpGWIcQQsi5oBsaIizNSkeqsPCEYR5AtQQNMVUZfyO9J4pZxCb06POQs43ym+2bmlZ2ExQBOTG16rxzGbQKjFSsqnrLfm49FMNDQ0eVr//fp2SBL9VrxfnEEsvRr8jkG/GC/B9As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714723; c=relaxed/simple;
	bh=/Le/Rj6WbiIUJH8ehUcvoWeh0izH5poyI1zm7y4asBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE09FFeWEqHvWA/iLNq99IiduyNQLqwwuvrp9ecwRVN91VJUEnXE+Wzr1G7OkOZYMQ3xe+kMfyy6GoX2o9L2dmtF2n4MqGGUvJ/N+Y5SURKbr1x8y8pTc/DFdyUvXCLJQ0jq1cDM7aOdlEmafoToQze7MPQUODE/6X/Eg96ar1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ck+1ngDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ck+1ngDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0A1C3277B;
	Tue, 18 Jun 2024 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714722;
	bh=/Le/Rj6WbiIUJH8ehUcvoWeh0izH5poyI1zm7y4asBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ck+1ngDiTkdpK6eo2aJQOk0a1cFoVV2z8dBam+KNHWyzC9t9iaLHx6KKqWQaOP8Ka
	 GyceteUI65d/sMAdKrYm1K54GezNOUnO5tDaHcAfaIvzT61+gPY7ftc9dzdi1g81/l
	 kZNxbmbAtK7Z7i91jGKAzY/XT6m89hF0DUE0Zqgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 065/770] NFSD: Add a separate decoder for ssv_sp_parms
Date: Tue, 18 Jun 2024 14:28:38 +0200
Message-ID: <20240618123409.794581819@linuxfoundation.org>
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

[ Upstream commit 547bfeb4cd8d491aabbd656d5a6f410cb4249b4e ]

Refactor for clarity.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 70 +++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 15535b14328e4..8c5701367e4af 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1488,12 +1488,54 @@ nfsd4_decode_state_protect_ops(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
+/*
+ * This implementation currently does not support SP4_SSV.
+ * This decoder simply skips over these arguments.
+ */
+static noinline __be32
+nfsd4_decode_ssv_sp_parms(struct nfsd4_compoundargs *argp,
+			  struct nfsd4_exchange_id *exid)
+{
+	u32 count, window, num_gss_handles;
+	__be32 status;
+
+	/* ssp_ops */
+	status = nfsd4_decode_state_protect_ops(argp, exid);
+	if (status)
+		return status;
+
+	/* ssp_hash_algs<> */
+	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
+		return nfserr_bad_xdr;
+	while (count--) {
+		status = nfsd4_decode_ignored_string(argp, 0);
+		if (status)
+			return status;
+	}
+
+	/* ssp_encr_algs<> */
+	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
+		return nfserr_bad_xdr;
+	while (count--) {
+		status = nfsd4_decode_ignored_string(argp, 0);
+		if (status)
+			return status;
+	}
+
+	if (xdr_stream_decode_u32(argp->xdr, &window) < 0)
+		return nfserr_bad_xdr;
+	if (xdr_stream_decode_u32(argp->xdr, &num_gss_handles) < 0)
+		return nfserr_bad_xdr;
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 			 struct nfsd4_exchange_id *exid)
 {
-	int dummy, tmp;
 	DECODE_HEAD;
+	int dummy;
 
 	READ_BUF(NFS4_VERIFIER_SIZE);
 	COPYMEM(exid->verifier.data, NFS4_VERIFIER_SIZE);
@@ -1517,33 +1559,9 @@ nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 			return status;
 		break;
 	case SP4_SSV:
-		/* ssp_ops */
-		status = nfsd4_decode_state_protect_ops(argp, exid);
+		status = nfsd4_decode_ssv_sp_parms(argp, exid);
 		if (status)
 			return status;
-
-		/* ssp_hash_algs<> */
-		READ_BUF(4);
-		tmp = be32_to_cpup(p++);
-		while (tmp--) {
-			READ_BUF(4);
-			dummy = be32_to_cpup(p++);
-			READ_BUF(dummy);
-			p += XDR_QUADLEN(dummy);
-		}
-
-		/* ssp_encr_algs<> */
-		READ_BUF(4);
-		tmp = be32_to_cpup(p++);
-		while (tmp--) {
-			READ_BUF(4);
-			dummy = be32_to_cpup(p++);
-			READ_BUF(dummy);
-			p += XDR_QUADLEN(dummy);
-		}
-
-		/* ignore ssp_window and ssp_num_gss_handles: */
-		READ_BUF(8);
 		break;
 	default:
 		goto xdr_error;
-- 
2.43.0



