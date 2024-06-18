Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2BB15B559;
	Tue, 18 Jun 2024 12:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714729; cv=none; b=LpSOE816cZytVyQWieUlCc+rdEUcylWRahM11FsflMjPK4tOCcU7/N3LPSqt/5HSb7RVW9DwlN0LUKT2snJ1VY+Dc9vfgOIhI1bCn23Ga3A8UJdKgZkzv+3XUB89dkV59/IhsAuJ4kRGuWtD7x+2kud2XUdVvGCNGfir1eY5wC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714729; c=relaxed/simple;
	bh=4T7Uf0sG8B9jnMYAseVicUDFaqI5LI8fSL80lXN/hp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uy4MherdLM5iO7de1M/5eDJpl1YALpmqMENJpXXpd0p9TYkG1ghhiHgH7sLf4ln4R3T4dt7yWo6YXP764EdcYwR+AAUtaqqvk2JjFjYxYZOrPWadHsCA0TxE8FDHoZug1qzPhzFQp4e5/6zTfmQCHbA5kPjou77ySv6XjkOXq6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCsz5f3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCsz5f3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF11C32786;
	Tue, 18 Jun 2024 12:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714728;
	bh=4T7Uf0sG8B9jnMYAseVicUDFaqI5LI8fSL80lXN/hp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCsz5f3JIudz2jVTH73CR8xX2K6206FzkGLIrdrNYHPSL6B1fJ5kEkiGSAgzvpvN/
	 QS3gLFHkVWFFBqWVAmYqRFpp9+aeRysGkmguB8hqokFJ5kJMUBk6R7owyN9vLdiZgO
	 w+hiWhEuYV25hbwNevTq5Gg3fToTbBT7vrWoe9jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/770] NFSD: Add a helper to decode nfs_impl_id4
Date: Tue, 18 Jun 2024 14:28:40 +0200
Message-ID: <20240618123409.871007669@linuxfoundation.org>
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

[ Upstream commit 10ff84228197f47401833495ba19a50131323b4a ]

Refactor for clarity.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 63 ++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 6a4ab81e01ffc..e06e657c3d91c 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1558,12 +1558,47 @@ nfsd4_decode_state_protect4_a(struct nfsd4_compoundargs *argp,
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_nfs_impl_id4(struct nfsd4_compoundargs *argp,
+			  struct nfsd4_exchange_id *exid)
+{
+	__be32 status;
+	u32 count;
+
+	if (xdr_stream_decode_u32(argp->xdr, &count) < 0)
+		return nfserr_bad_xdr;
+	switch (count) {
+	case 0:
+		break;
+	case 1:
+		/* Note that RFC 8881 places no length limit on
+		 * nii_domain, but this implementation permits no
+		 * more than NFS4_OPAQUE_LIMIT bytes */
+		status = nfsd4_decode_opaque(argp, &exid->nii_domain);
+		if (status)
+			return status;
+		/* Note that RFC 8881 places no length limit on
+		 * nii_name, but this implementation permits no
+		 * more than NFS4_OPAQUE_LIMIT bytes */
+		status = nfsd4_decode_opaque(argp, &exid->nii_name);
+		if (status)
+			return status;
+		status = nfsd4_decode_nfstime4(argp, &exid->nii_time);
+		if (status)
+			return status;
+		break;
+	default:
+		return nfserr_bad_xdr;
+	}
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 			 struct nfsd4_exchange_id *exid)
 {
-	DECODE_HEAD;
-	int dummy;
+	__be32 status;
 
 	status = nfsd4_decode_verifier4(argp, &exid->verifier);
 	if (status)
@@ -1576,29 +1611,7 @@ nfsd4_decode_exchange_id(struct nfsd4_compoundargs *argp,
 	status = nfsd4_decode_state_protect4_a(argp, exid);
 	if (status)
 		return status;
-
-	READ_BUF(4);    /* nfs_impl_id4 array length */
-	dummy = be32_to_cpup(p++);
-
-	if (dummy > 1)
-		goto xdr_error;
-
-	if (dummy == 1) {
-		status = nfsd4_decode_opaque(argp, &exid->nii_domain);
-		if (status)
-			goto xdr_error;
-
-		/* nii_name */
-		status = nfsd4_decode_opaque(argp, &exid->nii_name);
-		if (status)
-			goto xdr_error;
-
-		/* nii_date */
-		status = nfsd4_decode_time(argp, &exid->nii_time);
-		if (status)
-			goto xdr_error;
-	}
-	DECODE_TAIL;
+	return nfsd4_decode_nfs_impl_id4(argp, exid);
 }
 
 static __be32
-- 
2.43.0



