Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AAE15B10C;
	Tue, 18 Jun 2024 12:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714625; cv=none; b=lQZpMoH8QyKYzmBWzEMNiyzOVFREw+OMeMMa8Fz1af5OezSqyoR00TOD2BcGckADWi4o9NJBXKtlxV+r2sOIZgpW3RWWws++fAEzLyxglVMK8OancDNPZcPAHWMMbQFs2wWk7vaiKhbt8UvIi+pc2TdcMWZAOhdP8fYgb+JMg0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714625; c=relaxed/simple;
	bh=PoL7LqZEiyaR9E8YbUcqljL8wn46cndW5EqnGku0duU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F94aI6KIQRWAXVeBNJd4C7YNWFUyYpLzF1i2zLWHgMFhhDR8wQI9pxC3El2zV1IXfdnG/nAfcPktMRFDS4MEYjH01tS2zJfUMeHZGG4jzB5wR43OrVJ3I6o8gvKDCqaD2P3hwgcK9B1mh9PF+dJwvzUBfL7ualG6u3Tn05EIMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDwfVyZf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDwfVyZf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E3E2C3277B;
	Tue, 18 Jun 2024 12:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714625;
	bh=PoL7LqZEiyaR9E8YbUcqljL8wn46cndW5EqnGku0duU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDwfVyZfp5As7ADHz+USWbzstc9atCuCG4v4mDJu3sJqNkQP8liOA1ydvoQtdqzps
	 NOuw477RWR2T0NEzJF0M0Ck1aap2Z7ERBa/jN2hQujAqxL2pWGt6vnrr/cfyZPY7Im
	 r/titg31W0eHyYZPYs59I55Pon4zgcCEVabKNamA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/770] NFSD: Relocate nfsd4_decode_opaque()
Date: Tue, 18 Jun 2024 14:28:05 +0200
Message-ID: <20240618123408.533324230@linuxfoundation.org>
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

[ Upstream commit 5dcbfabb676b2b6d97767209cf707eb463ca232a ]

Enable nfsd4_decode_opaque() to be used in more decoders, and
replace the READ* macros in nfsd4_decode_opaque().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 43 +++++++++++++++++++++++++++----------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 4596b8cef222c..b3459059cec1b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -207,6 +207,33 @@ static char *savemem(struct nfsd4_compoundargs *argp, __be32 *p, int nbytes)
 	return ret;
 }
 
+
+/*
+ * NFSv4 basic data type decoders
+ */
+
+static __be32
+nfsd4_decode_opaque(struct nfsd4_compoundargs *argp, struct xdr_netobj *o)
+{
+	__be32 *p;
+	u32 len;
+
+	if (xdr_stream_decode_u32(argp->xdr, &len) < 0)
+		return nfserr_bad_xdr;
+	if (len == 0 || len > NFS4_OPAQUE_LIMIT)
+		return nfserr_bad_xdr;
+	p = xdr_inline_decode(argp->xdr, len);
+	if (!p)
+		return nfserr_bad_xdr;
+	o->data = svcxdr_tmpalloc(argp, len);
+	if (!o->data)
+		return nfserr_jukebox;
+	o->len = len;
+	memcpy(o->data, p, len);
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_component4(struct nfsd4_compoundargs *argp, char **namp, u32 *lenp)
 {
@@ -943,22 +970,6 @@ static __be32 nfsd4_decode_share_deny(struct nfsd4_compoundargs *argp, u32 *x)
 	return nfserr_bad_xdr;
 }
 
-static __be32 nfsd4_decode_opaque(struct nfsd4_compoundargs *argp, struct xdr_netobj *o)
-{
-	DECODE_HEAD;
-
-	READ_BUF(4);
-	o->len = be32_to_cpup(p++);
-
-	if (o->len == 0 || o->len > NFS4_OPAQUE_LIMIT)
-		return nfserr_bad_xdr;
-
-	READ_BUF(o->len);
-	SAVEMEM(o->data, o->len);
-
-	DECODE_TAIL;
-}
-
 static __be32
 nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 {
-- 
2.43.0



