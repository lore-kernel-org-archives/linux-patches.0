Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63F213F431;
	Tue, 18 Jun 2024 12:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714737; cv=none; b=UzPcJctGR/y1AJoQs6pc7bxEyfpDm7AHDITjgFoVYtCeLbbQ/7zbYUkDoydKY3CLa3pMqFE9jau/HWvILh3UJot4so73RF8S01jcdJtxEcsO2WkE7zGLnb62++A/qqe7cp1u8mDYGPEUGfE5hTCrRXK14AsHwp1eStZ8LDurGJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714737; c=relaxed/simple;
	bh=QnkMk+pq4gUYaMTxQghiNsma0lSypEqaj4NHZVWp7RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBZxV852Wy9XJW9bv4JjPv8t0BbgLzs87pyuzAGIk0A+/QGY5GAWSlxxcPPpoRtcoKLjsyX5KBeWcG3g3dyd2w/IZdg8oeH+r1qQYZHtfD0JY3YpxZD4PQ37khuW9lscl2GGDXIoieTlS44L35L7IBKWBsmKqw2dq4iE52inpRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d+p1cEdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d+p1cEdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD1DC3277B;
	Tue, 18 Jun 2024 12:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714737;
	bh=QnkMk+pq4gUYaMTxQghiNsma0lSypEqaj4NHZVWp7RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d+p1cEdG6la/9bwMBKjHPEBeie7ZJI2ArZTtQS0Dyhvc+eVKM6by12d1yy9cLl9n1
	 avNDGwHsX67E/n2VG8hFJdcriKjkWIslbWbKdkcYwFfddG8MHz87AcsAAcmHTRFUFW
	 orhj11hstOR6stJ52nzbdJlRHdNP4f7+fy4poq3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 040/770] NFSD: Add helper to decode OPENs createhow4 argument
Date: Tue, 18 Jun 2024 14:28:13 +0200
Message-ID: <20240618123408.841503777@linuxfoundation.org>
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

[ Upstream commit bf33bab3c4182cdd795983f14de5606e82fab377 ]

Refactor for clarity.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 78 +++++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 33 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1a2dc52c4340b..62096b2a57b35 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -946,6 +946,48 @@ nfsd4_decode_lookup(struct nfsd4_compoundargs *argp, struct nfsd4_lookup *lookup
 	return nfsd4_decode_component4(argp, &lookup->lo_name, &lookup->lo_len);
 }
 
+static __be32
+nfsd4_decode_createhow4(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
+{
+	__be32 status;
+
+	if (xdr_stream_decode_u32(argp->xdr, &open->op_createmode) < 0)
+		return nfserr_bad_xdr;
+	switch (open->op_createmode) {
+	case NFS4_CREATE_UNCHECKED:
+	case NFS4_CREATE_GUARDED:
+		status = nfsd4_decode_fattr4(argp, open->op_bmval,
+					     ARRAY_SIZE(open->op_bmval),
+					     &open->op_iattr, &open->op_acl,
+					     &open->op_label, &open->op_umask);
+		if (status)
+			return status;
+		break;
+	case NFS4_CREATE_EXCLUSIVE:
+		status = nfsd4_decode_verifier4(argp, &open->op_verf);
+		if (status)
+			return status;
+		break;
+	case NFS4_CREATE_EXCLUSIVE4_1:
+		if (argp->minorversion < 1)
+			return nfserr_bad_xdr;
+		status = nfsd4_decode_verifier4(argp, &open->op_verf);
+		if (status)
+			return status;
+		status = nfsd4_decode_fattr4(argp, open->op_bmval,
+					     ARRAY_SIZE(open->op_bmval),
+					     &open->op_iattr, &open->op_acl,
+					     &open->op_label, &open->op_umask);
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
 static __be32 nfsd4_decode_share_access(struct nfsd4_compoundargs *argp, u32 *share_access, u32 *deleg_want, u32 *deleg_when)
 {
 	__be32 *p;
@@ -1046,39 +1088,9 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 	case NFS4_OPEN_NOCREATE:
 		break;
 	case NFS4_OPEN_CREATE:
-		READ_BUF(4);
-		open->op_createmode = be32_to_cpup(p++);
-		switch (open->op_createmode) {
-		case NFS4_CREATE_UNCHECKED:
-		case NFS4_CREATE_GUARDED:
-			status = nfsd4_decode_fattr4(argp, open->op_bmval,
-						     ARRAY_SIZE(open->op_bmval),
-						     &open->op_iattr, &open->op_acl,
-						     &open->op_label, &open->op_umask);
-			if (status)
-				goto out;
-			break;
-		case NFS4_CREATE_EXCLUSIVE:
-			status = nfsd4_decode_verifier4(argp, &open->op_verf);
-			if (status)
-				return status;
-			break;
-		case NFS4_CREATE_EXCLUSIVE4_1:
-			if (argp->minorversion < 1)
-				goto xdr_error;
-			status = nfsd4_decode_verifier4(argp, &open->op_verf);
-			if (status)
-				return status;
-			status = nfsd4_decode_fattr4(argp, open->op_bmval,
-						     ARRAY_SIZE(open->op_bmval),
-						     &open->op_iattr, &open->op_acl,
-						     &open->op_label, &open->op_umask);
-			if (status)
-				goto out;
-			break;
-		default:
-			goto xdr_error;
-		}
+		status = nfsd4_decode_createhow4(argp, open);
+		if (status)
+			return status;
 		break;
 	default:
 		goto xdr_error;
-- 
2.43.0



