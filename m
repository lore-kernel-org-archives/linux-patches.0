Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E9715DBCC;
	Tue, 18 Jun 2024 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714849; cv=none; b=Eoml1P9vqJPv3e04gubvbD6qDyXzT8+64op7YXiWfYxF4f9wqLlcjWJXX5maO1wgmGvOUtgp+37qULsjGv6wgtgghkRXkeJV1mqQ6bIZyA4Hnhel0wACoV75S5cVFS/J2vdqsYSuq6ZcMoULM8ngQWzvzt74EsWAtLRegzZI9iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714849; c=relaxed/simple;
	bh=ulWgxqxdO9bxphTGgSRfKz2+Jzq2jkiLWIehQTa4wzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kez0oEUpZYTqYCfCx8IC/+lkHv8HoVCfxyDw5kd0Ocu1Bestyn7z2Ev2SMjWNwdxnp4+trdV26pguaGJ6hvOwv1wvwarTRKzvHv5u6/eHzDJZ/r6G4o1FWZgTRxBJAM8EpRSANhlp/X7qdB2zyzS+oUlFUUPL3wkswnaYeMkVv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qh0MrWYs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qh0MrWYs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D68C3277B;
	Tue, 18 Jun 2024 12:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714849;
	bh=ulWgxqxdO9bxphTGgSRfKz2+Jzq2jkiLWIehQTa4wzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qh0MrWYsCzjhN/+oxg2ydWs8hCrTkaFTq/TtjQbO2exoLHzbvW5mNx8vx9KYcjdTx
	 ce/oX7uqeSrQd4+tAI4K62n5qju2GakIIHxNjal6RX7q2ZZqyHlVwmWjitTo4aMGqe
	 8L4qPBsNpRfxLrpJzh2x6l2tZHeGnxdO0DkhdAS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/770] NFSD: Replace READ* macros in nfsd4_decode_sequence()
Date: Tue, 18 Jun 2024 14:28:50 +0200
Message-ID: <20240618123410.255638214@linuxfoundation.org>
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

[ Upstream commit cf907b11326d9360877d6c6ea8f75e1b29f39f2f ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0561b43855839..3fe0d0228c4ac 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1738,22 +1738,6 @@ nfsd4_decode_free_stateid(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_stateid4(argp, &free_stateid->fr_stateid);
 }
 
-static __be32
-nfsd4_decode_sequence(struct nfsd4_compoundargs *argp,
-		      struct nfsd4_sequence *seq)
-{
-	DECODE_HEAD;
-
-	READ_BUF(NFS4_MAX_SESSIONID_LEN + 16);
-	COPYMEM(seq->sessionid.data, NFS4_MAX_SESSIONID_LEN);
-	seq->seqid = be32_to_cpup(p++);
-	seq->slotid = be32_to_cpup(p++);
-	seq->maxslots = be32_to_cpup(p++);
-	seq->cachethis = be32_to_cpup(p++);
-
-	DECODE_TAIL;
-}
-
 static __be32
 nfsd4_decode_test_stateid(struct nfsd4_compoundargs *argp, struct nfsd4_test_stateid *test_stateid)
 {
@@ -1915,6 +1899,26 @@ static __be32 nfsd4_decode_secinfo_no_name(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_sequence(struct nfsd4_compoundargs *argp,
+		      struct nfsd4_sequence *seq)
+{
+	__be32 *p, status;
+
+	status = nfsd4_decode_sessionid4(argp, &seq->sessionid);
+	if (status)
+		return status;
+	p = xdr_inline_decode(argp->xdr, XDR_UNIT * 4);
+	if (!p)
+		return nfserr_bad_xdr;
+	seq->seqid = be32_to_cpup(p++);
+	seq->slotid = be32_to_cpup(p++);
+	seq->maxslots = be32_to_cpup(p++);
+	seq->cachethis = be32_to_cpup(p);
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_fallocate(struct nfsd4_compoundargs *argp,
 		       struct nfsd4_fallocate *fallocate)
-- 
2.43.0



