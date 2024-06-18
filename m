Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B797613C675;
	Tue, 18 Jun 2024 12:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714657; cv=none; b=SwaslovMKWY9XaqCeYcCqQAMTcU+e9xI0YLS9q2/htlpyRY4YboBSGBOmCTc0vg8lwzHSF3b0wO0yTpfQMiQ/jwi1nwR4DZwoYRV2vxmjBovhFG4XI7kU6oX+sjoDlzZPcwTgl8OUn3hmuvkIeb64ieBcfAX7pvgdOGJZ9+AZW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714657; c=relaxed/simple;
	bh=P9TDbalEPazZaLrN7IqFCnN08WEwyQXNeHslCy2FQ+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT42OP3U9lOQqMRj8DEnJQ4r2O/oT9EODdtJmVcM3LeCBsQvin0bIpUXK5UP154cV4zDBt2qWN24A9zKcJ31GoSXZ9nEmJvr0wRT7+IW+Ef6ZR34lNwz1ObYS20YHC0aAGyCuMBSBWON0KtqA/BPfF+ALb06YC7Os/M/AHevjLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbCmaYIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbCmaYIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDF6C3277B;
	Tue, 18 Jun 2024 12:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714657;
	bh=P9TDbalEPazZaLrN7IqFCnN08WEwyQXNeHslCy2FQ+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JbCmaYIt+memAJPOTpoHdwaMNbyR0SVfd7W6OXxn4CL6y2PQ6wNyUDlXM3jAHH5Sg
	 4S4IxBVE71XBHit1tBqmXU/sWeIGsRE2Px/NWxRKF5v7mIXg/5DIz/5aGzWGfG6OPG
	 +o2pcV0gUxjxYwnELCnfMB3GwvV61ASGFlInkAQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 045/770] NFSD: Replace READ* macros in nfsd4_decode_open()
Date: Tue, 18 Jun 2024 14:28:18 +0200
Message-ID: <20240618123409.033127675@linuxfoundation.org>
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

[ Upstream commit 61e5e0b3ec713d1365008c8af3fe5fdd262e2a60 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 3e0fca521c39b..2de54e84a3ab0 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1124,7 +1124,7 @@ nfsd4_decode_open_claim4(struct nfsd4_compoundargs *argp,
 static __be32
 nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 {
-	DECODE_HEAD;
+	__be32 status;
 	u32 dummy;
 
 	memset(open->op_bmval, 0, sizeof(open->op_bmval));
@@ -1132,28 +1132,24 @@ nfsd4_decode_open(struct nfsd4_compoundargs *argp, struct nfsd4_open *open)
 	open->op_openowner = NULL;
 
 	open->op_xdr_error = 0;
-	/* seqid, share_access, share_deny, clientid, ownerlen */
-	READ_BUF(4);
-	open->op_seqid = be32_to_cpup(p++);
-	/* decode, yet ignore deleg_when until supported */
+	if (xdr_stream_decode_u32(argp->xdr, &open->op_seqid) < 0)
+		return nfserr_bad_xdr;
+	/* deleg_want is ignored */
 	status = nfsd4_decode_share_access(argp, &open->op_share_access,
 					   &open->op_deleg_want, &dummy);
 	if (status)
-		goto xdr_error;
+		return status;
 	status = nfsd4_decode_share_deny(argp, &open->op_share_deny);
 	if (status)
-		goto xdr_error;
-	READ_BUF(sizeof(clientid_t));
-	COPYMEM(&open->op_clientid, sizeof(clientid_t));
-	status = nfsd4_decode_opaque(argp, &open->op_owner);
+		return status;
+	status = nfsd4_decode_state_owner4(argp, &open->op_clientid,
+					   &open->op_owner);
 	if (status)
-		goto xdr_error;
+		return status;
 	status = nfsd4_decode_openflag4(argp, open);
 	if (status)
 		return status;
-	status = nfsd4_decode_open_claim4(argp, open);
-
-	DECODE_TAIL;
+	return nfsd4_decode_open_claim4(argp, open);
 }
 
 static __be32
-- 
2.43.0



