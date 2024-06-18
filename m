Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFB613F431;
	Tue, 18 Jun 2024 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714735; cv=none; b=gwBENzi3Tn6L/BJKtxCxDFRiuZQNDbvP2Ao8S0ZY+pPW3YzBtEjpJQT169YTv2F7KQPluQWUif109iJjEr6851FanYXq/xET03DXDWq2SmWX3r0x9MJUhbFWFSVU0snsHeNAq3Jx2IY1F9JnChk5T02u8OT/PXAbGyukebhnK94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714735; c=relaxed/simple;
	bh=EN47V9tbVjCQlDHM7mY1LpVIvVGWFJE4+sLitX4uI/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sEW/7V8knMU2dmJta+yTXkV+2SzWnUcxgiCkOkrCPEifxw/OxmI7ts0iSI8An+e5NYhBn1f2MRPAG/0vL+TRqLpBHkKk4m4tvJbg67R4rWCiJAL8SKdO25hEv5LPSyGDUBG0XW3haJ/bqLygjKCUrp0Db0h+L+PAmhKu0uEh8wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ia9KEEaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ia9KEEaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4C5C3277B;
	Tue, 18 Jun 2024 12:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714734;
	bh=EN47V9tbVjCQlDHM7mY1LpVIvVGWFJE4+sLitX4uI/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ia9KEEaPpc1KdM2jTKlY7vlm2bgf0F2uRmfsMR5sG2azdlvZ+rWgSoXpIE6OlT8zd
	 rwuWxQlv1AUXCHyswjpWjgwS01wMU4rH6aCgtuv82/J7pQUgmbq2dBxlOiVLOHIZOg
	 m4GQR3RcuK8S/geitzTzcHz2qIb5mu7fs0a9cTHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 039/770] NFSD: Add helper to decode NFSv4 verifiers
Date: Tue, 18 Jun 2024 14:28:12 +0200
Message-ID: <20240618123408.802857246@linuxfoundation.org>
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

[ Upstream commit 796dd1c6b680959ac968b52aa507911b288b1749 ]

This helper will be used to simplify decoders in subsequent
patches.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 431ab9d604be7..1a2dc52c4340b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -284,6 +284,18 @@ nfsd4_decode_nfstime4(struct nfsd4_compoundargs *argp, struct timespec64 *tv)
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_verifier4(struct nfsd4_compoundargs *argp, nfs4_verifier *verf)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(argp->xdr, NFS4_VERIFIER_SIZE);
+	if (!p)
+		return nfserr_bad_xdr;
+	memcpy(verf->data, p, sizeof(verf->data));
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 {
@@ -1047,14 +1059,16 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 				goto out;
 			break;
 		case NFS4_CREATE_EXCLUSIVE:
-			READ_BUF(NFS4_VERIFIER_SIZE);
-			COPYMEM(open->op_verf.data, NFS4_VERIFIER_SIZE);
+			status = nfsd4_decode_verifier4(argp, &open->op_verf);
+			if (status)
+				return status;
 			break;
 		case NFS4_CREATE_EXCLUSIVE4_1:
 			if (argp->minorversion < 1)
 				goto xdr_error;
-			READ_BUF(NFS4_VERIFIER_SIZE);
-			COPYMEM(open->op_verf.data, NFS4_VERIFIER_SIZE);
+			status = nfsd4_decode_verifier4(argp, &open->op_verf);
+			if (status)
+				return status;
 			status = nfsd4_decode_fattr4(argp, open->op_bmval,
 						     ARRAY_SIZE(open->op_bmval),
 						     &open->op_iattr, &open->op_acl,
-- 
2.43.0



