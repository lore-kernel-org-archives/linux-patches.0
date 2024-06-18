Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F80213DBA8;
	Tue, 18 Jun 2024 12:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714628; cv=none; b=AY47X7T6r7qnGXwNEZSp8k+0/EEiR+yD34TK1EYh/m7q3V2iPms55R+q6VBN+sBcMoXFs/GSqrVEn0gcsju+2whLByA7UTrIP5Jn2dsRqDmtmtBnyGouxihwykQBGuclDjicv9HbSrSs8vSoSHvjLv/Am3xHxcpRCb/2dEOU/tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714628; c=relaxed/simple;
	bh=y6lLNtrNmwHBrdCq4FwwWmzAcIW/b/bYZ03E7kIIcKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQK4Yv0nMe+ql17E/9cCEF8OiDL4UIdy8TMdbTcN6PjPSoGtOzT7z3XbR2VwyQet3fGUM1CuoiwkpuLvS98TjIZwVk+Jfy8WsyLNCuZwPQQqkwe/L/lapD+65sZ/JuZ40EcOQ/mFRiOpunB4VhV7s/CrPgXxm5WyRrOdORNDrlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoYKYJfv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoYKYJfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87948C32786;
	Tue, 18 Jun 2024 12:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714627;
	bh=y6lLNtrNmwHBrdCq4FwwWmzAcIW/b/bYZ03E7kIIcKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoYKYJfv85paH0r1IWiXJDtY/rvTwU1uFMoWIenPICTqRDrIgx7ldBSN3hn31b70c
	 Vyk1bK/LXT+rt7HztuRaDbiO2Er+pcWfLBI3XnEKkDcEyFa4v+durvPU3gOXc7hyzb
	 eyaKEBnygRBWwCwRBf3N2kDrKN3GDVOq5rrH/Q5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/770] NFSD: Add helpers to decode a clientid4 and an NFSv4 state owner
Date: Tue, 18 Jun 2024 14:28:06 +0200
Message-ID: <20240618123408.572607327@linuxfoundation.org>
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

[ Upstream commit 144e82694092ff80b5e64749d6822cd8947587f2 ]

These helpers will also be used to simplify decoders in subsequent
patches.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 34 +++++++++++++++++++++++++++++-----
 1 file changed, 29 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b3459059cec1b..63140cd4c50e4 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -609,6 +609,30 @@ nfsd4_decode_stateid4(struct nfsd4_compoundargs *argp, stateid_t *sid)
 	return nfs_ok;
 }
 
+static __be32
+nfsd4_decode_clientid4(struct nfsd4_compoundargs *argp, clientid_t *clientid)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(argp->xdr, sizeof(__be64));
+	if (!p)
+		return nfserr_bad_xdr;
+	memcpy(clientid, p, sizeof(*clientid));
+	return nfs_ok;
+}
+
+static __be32
+nfsd4_decode_state_owner4(struct nfsd4_compoundargs *argp,
+			  clientid_t *clientid, struct xdr_netobj *owner)
+{
+	__be32 status;
+
+	status = nfsd4_decode_clientid4(argp, clientid);
+	if (status)
+		return status;
+	return nfsd4_decode_opaque(argp, owner);
+}
+
 static __be32 nfsd4_decode_cb_sec(struct nfsd4_compoundargs *argp, struct nfsd4_cb_sec *cbs)
 {
 	DECODE_HEAD;
@@ -832,12 +856,12 @@ nfsd4_decode_lock(struct nfsd4_compoundargs *argp, struct nfsd4_lock *lock)
 		status = nfsd4_decode_stateid(argp, &lock->lk_new_open_stateid);
 		if (status)
 			return status;
-		READ_BUF(8 + sizeof(clientid_t));
+		READ_BUF(4);
 		lock->lk_new_lock_seqid = be32_to_cpup(p++);
-		COPYMEM(&lock->lk_new_clientid, sizeof(clientid_t));
-		lock->lk_new_owner.len = be32_to_cpup(p++);
-		READ_BUF(lock->lk_new_owner.len);
-		READMEM(lock->lk_new_owner.data, lock->lk_new_owner.len);
+		status = nfsd4_decode_state_owner4(argp, &lock->lk_new_clientid,
+						   &lock->lk_new_owner);
+		if (status)
+			return status;
 	} else {
 		status = nfsd4_decode_stateid(argp, &lock->lk_old_lock_stateid);
 		if (status)
-- 
2.43.0



