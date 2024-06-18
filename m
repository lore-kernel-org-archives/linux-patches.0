Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6820150297;
	Tue, 18 Jun 2024 12:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714755; cv=none; b=Hn3BQM6o0ZiEqd3QiC3ewfzSTQjYaEZotQiE2jpV437nBDMNoR+IB92ihCFxfNUJyD9oWU738eyyzaE2J6DXv6j9qRlO8mvyZVI69umWTv8u9uV8pwwtiszfrMH7Y15R46ym8pvZC/S5IhIOUhqA51/BWKqp7Nh8ukCUkab9tm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714755; c=relaxed/simple;
	bh=CwPeKAGLJzApY9CHW+DnTQrI+Jr2tslk3boXxEDUnSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQriMCmUENdlFP2m9ZGnorVu0JofGJxj9tKDrAYsHF/SopH2lCHrjQ3Byx9AnYsy7kShkc5x3QL0Flo18X3ige0l1vxj2wg2hbYOl+7rR0hr+d+6qClemrLgFcYN/zYWWqDaSPO4NBYws+PnhPI2LaKG4IgrzUD2l2IN3c0dJ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zbPzygUx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zbPzygUx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CD5C3277B;
	Tue, 18 Jun 2024 12:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714755;
	bh=CwPeKAGLJzApY9CHW+DnTQrI+Jr2tslk3boXxEDUnSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zbPzygUx6+sO5dhSQ9rYcG9XKg2NkmqYRhIg89l19HTOFxtRxTIW6lYQeBgWj3i7l
	 I+JIJpNZzhXrClkqorpdko/qdUv8HXd9KK/m/hkEFxCfOeSNjaQSXxvY/OLwzkRXhI
	 f+QoSJClW2kWcCL33lR7qiHnIvl+xrbhhxhYXEGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/770] NFSD: Replace READ* macros in nfsd4_decode_test_stateid()
Date: Tue, 18 Jun 2024 14:28:51 +0200
Message-ID: <20240618123410.293785048@linuxfoundation.org>
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

[ Upstream commit b7a0c8f6e741bf9dee0d24e69d3ce51fa4ccce78 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 61 +++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 36 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 3fe0d0228c4ac..9642de1550431 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1738,42 +1738,6 @@ nfsd4_decode_free_stateid(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_stateid4(argp, &free_stateid->fr_stateid);
 }
 
-static __be32
-nfsd4_decode_test_stateid(struct nfsd4_compoundargs *argp, struct nfsd4_test_stateid *test_stateid)
-{
-	int i;
-	__be32 *p, status;
-	struct nfsd4_test_stateid_id *stateid;
-
-	READ_BUF(4);
-	test_stateid->ts_num_ids = ntohl(*p++);
-
-	INIT_LIST_HEAD(&test_stateid->ts_stateid_list);
-
-	for (i = 0; i < test_stateid->ts_num_ids; i++) {
-		stateid = svcxdr_tmpalloc(argp, sizeof(*stateid));
-		if (!stateid) {
-			status = nfserrno(-ENOMEM);
-			goto out;
-		}
-
-		INIT_LIST_HEAD(&stateid->ts_id_list);
-		list_add_tail(&stateid->ts_id_list, &test_stateid->ts_stateid_list);
-
-		status = nfsd4_decode_stateid(argp, &stateid->ts_id_stateid);
-		if (status)
-			goto out;
-	}
-
-	status = 0;
-out:
-	return status;
-xdr_error:
-	dprintk("NFSD: xdr error (%s:%d)\n", __FILE__, __LINE__);
-	status = nfserr_bad_xdr;
-	goto out;
-}
-
 static __be32 nfsd4_decode_destroy_clientid(struct nfsd4_compoundargs *argp, struct nfsd4_destroy_clientid *dc)
 {
 	DECODE_HEAD;
@@ -1919,6 +1883,31 @@ nfsd4_decode_sequence(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_test_stateid(struct nfsd4_compoundargs *argp, struct nfsd4_test_stateid *test_stateid)
+{
+	struct nfsd4_test_stateid_id *stateid;
+	__be32 status;
+	u32 i;
+
+	if (xdr_stream_decode_u32(argp->xdr, &test_stateid->ts_num_ids) < 0)
+		return nfserr_bad_xdr;
+
+	INIT_LIST_HEAD(&test_stateid->ts_stateid_list);
+	for (i = 0; i < test_stateid->ts_num_ids; i++) {
+		stateid = svcxdr_tmpalloc(argp, sizeof(*stateid));
+		if (!stateid)
+			return nfserrno(-ENOMEM);	/* XXX: not jukebox? */
+		INIT_LIST_HEAD(&stateid->ts_id_list);
+		list_add_tail(&stateid->ts_id_list, &test_stateid->ts_stateid_list);
+		status = nfsd4_decode_stateid4(argp, &stateid->ts_id_stateid);
+		if (status)
+			return status;
+	}
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_fallocate(struct nfsd4_compoundargs *argp,
 		       struct nfsd4_fallocate *fallocate)
-- 
2.43.0



