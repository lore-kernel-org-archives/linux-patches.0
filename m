Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1222E7E0E8;
	Mon,  8 Apr 2024 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584069; cv=none; b=apOUS/r/iZLMrtcxJDMRy5GI/fYmqjERNvabynVURcK74tuEBUCbuNiK7317DISIJzdNiWO1043jhSPbAcgMW3DW8PYmJHf8kPxtlG/b0WIFs4Rugf4VaxqMfbxa+uKWvCJCIOOOb8Ah4yzs1U8EknZtkNP5kDxnFsJEYKfrf6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584069; c=relaxed/simple;
	bh=UpT75ChKz0WXCJMINmy2siLSeHDT7mSTIJ8vbNPSX+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2rf1iHIeGxOq1XkAfdW94wYyB84gxUnW62H4+JLVON0d2RkVB6H8ksAVajSNFq5s25DnxT2ZIyQxErBIOpFf2HG8/krTdC1kmQsTTOE63wQgwfSXmNQsUuCvGKWIPiBojMLRDnrLgvSihDkkTe9fyU6jEuJmQd0t/2HWQXjDrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjOhbYSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjOhbYSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F273C43390;
	Mon,  8 Apr 2024 13:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584068;
	bh=UpT75ChKz0WXCJMINmy2siLSeHDT7mSTIJ8vbNPSX+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjOhbYSEvQhp9BGm2NGWk/D2Ngehv0n09FfGLHo8cFOqY//Zr7dPbw49LOK6yRmzu
	 1Sdl7GXPlA+6CGKZefJ1g5JOEmN6+gK1G1tFWZh7v98AFR/2i+NZ7NnLUIQO54xH7X
	 5gS+75LGVQg2AR1YXTKZy4DllFXEyq6JszdmyajU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 329/690] NFSD: Modernize nfsd4_release_lockowner()
Date: Mon,  8 Apr 2024 14:53:15 +0200
Message-ID: <20240408125411.526477648@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit bd8fdb6e545f950f4654a9a10d7e819ad48146e5 ]

Refactor: Use existing helpers that other lock operations use. This
change removes several automatic variables, so re-organize the
variable declarations for readability.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d79b736019d49..2d52656095340 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7548,16 +7548,13 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 			union nfsd4_op_u *u)
 {
 	struct nfsd4_release_lockowner *rlockowner = &u->release_lockowner;
+	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	clientid_t *clid = &rlockowner->rl_clientid;
-	struct nfs4_stateowner *sop;
-	struct nfs4_lockowner *lo = NULL;
 	struct nfs4_ol_stateid *stp;
-	struct xdr_netobj *owner = &rlockowner->rl_owner;
-	unsigned int hashval = ownerstr_hashval(owner);
-	__be32 status;
-	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
+	struct nfs4_lockowner *lo;
 	struct nfs4_client *clp;
-	LIST_HEAD (reaplist);
+	LIST_HEAD(reaplist);
+	__be32 status;
 
 	dprintk("nfsd4_release_lockowner clientid: (%08x/%08x):\n",
 		clid->cl_boot, clid->cl_id);
@@ -7565,30 +7562,19 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 	status = set_client(clid, cstate, nn);
 	if (status)
 		return status;
-
 	clp = cstate->clp;
-	/* Find the matching lock stateowner */
-	spin_lock(&clp->cl_lock);
-	list_for_each_entry(sop, &clp->cl_ownerstr_hashtbl[hashval],
-			    so_strhash) {
 
-		if (sop->so_is_open_owner || !same_owner_str(sop, owner))
-			continue;
-
-		if (atomic_read(&sop->so_count) != 1) {
-			spin_unlock(&clp->cl_lock);
-			return nfserr_locks_held;
-		}
-
-		lo = lockowner(sop);
-		nfs4_get_stateowner(sop);
-		break;
-	}
+	spin_lock(&clp->cl_lock);
+	lo = find_lockowner_str_locked(clp, &rlockowner->rl_owner);
 	if (!lo) {
 		spin_unlock(&clp->cl_lock);
 		return status;
 	}
-
+	if (atomic_read(&lo->lo_owner.so_count) != 2) {
+		spin_unlock(&clp->cl_lock);
+		nfs4_put_stateowner(&lo->lo_owner);
+		return nfserr_locks_held;
+	}
 	unhash_lockowner_locked(lo);
 	while (!list_empty(&lo->lo_owner.so_stateids)) {
 		stp = list_first_entry(&lo->lo_owner.so_stateids,
-- 
2.43.0



