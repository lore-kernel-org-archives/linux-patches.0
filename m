Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CFD330328;
	Sat, 12 Sep 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232620; cv=none; b=tuLWZuXowSEUGrKNhYw6JBVGHzze4uXOwEXN3lwLq+4cu1L6eHohShd37b4piMJtAkzBAL0eHXy8GBtgAaaTMEat+tyZyjILWRj1nC9j1bp4y3vkbbriWyT4YEnbdbMvM3Q/SHN0rur97QGWuY6EVk0ypXBAySOiEytK2xq9fAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232620; c=relaxed/simple;
	bh=1Lg4D5dEK2LFaaUEU3DsBt46HrR5KtjIdGghyfrflJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B360s2MQpBK+RxjxqEyrHMX9PYjmOrGRB6i8SHchHffXZQgXFKz0CKi49PrOJqKsBcxZSA8GuQRPebyxsLqlwlBDe0iSV5UZhv+zpkXRDBp4jVyE0mkdkleiQNR8l+VmSqHT5tcSTE8GMN+E3ihD7clnycXFIvmxEAbvnseteNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hB8v+mQs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hB8v+mQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A121F000FF;
	Sat, 12 Sep 2026 17:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232619;
	bh=r4fgAzqy1tJuenXpQXrgK/9YZAI3prAbbjCnQBG5rSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hB8v+mQsKF69Q3haSR3TlIcffDgH58XdUT9qG9KALUeoKvtBpV7S9ZhtLIB6rGSV0
	 2f8YdoVABYovUT2YyijJeNKUilDxvy5TofVfP5TWbfwbe5+VnX22j+zOcn0yxUnDGr
	 wYLt9Vnet0mk0GXaO50gYkq7RCRdhYU4JSTostWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 048/935] nfsd: initialize copy-notify stateid before publishing it
Date: Sat, 12 Sep 2026 08:51:18 +0200
Message-ID: <20260912065527.941992826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jeff Layton <jlayton@kernel.org>

commit 129643893b79f8a3c6b72045f933fbab5ee424ca upstream.

nfsd4_copy_notify() finished initializing the cpntf state after
nfs4_alloc_init_cpntf_state() had already linked it into the
s2s_cp_stateids IDR and the parent's sc_cp_list, with cs_count == 1 (the
membership reference) and none held for the caller. A racing
OFFLOAD_CANCEL (crafted cl_id == nn->s2s_cp_cl_id plus the guessable
so_id) could reach manage_cpntf_state() and free the entry, turning the
caller's subsequent cpn_cnr_stateid read and cp_p_stateid/cp_p_clid
writes into use-after-free. The owning clientid was also only recorded
after publication, so it could not gate an ownership check in that window.

Record cp_p_stateid and cp_p_clid inside nfs4_alloc_init_cpntf_state()
before nfs4_init_cp_state() publishes the entry, and return it with an
extra reference. The caller reads the stateid under that reference and
drops it with nfs4_put_cpntf_state(); on a late error the laundromat
reaps the entry.

Fixes: 624322f1adc5 ("NFSD add COPY_NOTIFY operation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260710-nfsd-testing-v3-4-a0ff7db6aa3e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c  |   16 +++++++++-------
 fs/nfsd/nfs4state.c |   10 +++++++++-
 2 files changed, 18 insertions(+), 8 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1885,7 +1885,6 @@ nfsd4_copy_notify(struct svc_rqst *rqstp
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct nfs4_stid *stid;
 	struct nfs4_cpntf_state *cps;
-	struct nfs4_client *clp = cstate->clp;
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					&cn->cpn_src_stateid, RD_STATE, NULL,
@@ -1897,12 +1896,14 @@ nfsd4_copy_notify(struct svc_rqst *rqstp
 	cn->cpn_nsec = 0;
 
 	status = nfserrno(-ENOMEM);
+	/*
+	 * The returned cps is published and fully initialized, and carries an
+	 * extra reference for us; drop it once we are done with it.
+	 */
 	cps = nfs4_alloc_init_cpntf_state(nn, stid);
 	if (!cps)
 		goto out;
 	memcpy(&cn->cpn_cnr_stateid, &cps->cp_stateid.cs_stid, sizeof(stateid_t));
-	memcpy(&cps->cp_p_stateid, &stid->sc_stateid, sizeof(stateid_t));
-	memcpy(&cps->cp_p_clid, &clp->cl_clientid, sizeof(clientid_t));
 
 	/* For now, only return one server address in cpn_src, the
 	 * address used by the client to connect to this server.
@@ -1911,10 +1912,11 @@ nfsd4_copy_notify(struct svc_rqst *rqstp
 	status = nfsd4_set_netaddr((struct sockaddr *)&rqstp->rq_daddr,
 				 &cn->cpn_src->u.nl4_addr);
 	WARN_ON_ONCE(status);
-	if (status) {
-		nfs4_put_cpntf_state(nn, cps);
-		goto out;
-	}
+	/*
+	 * Drop our extra reference. The membership reference keeps the entry
+	 * alive for a later inter-server READ, or until the laundromat reaps it.
+	 */
+	nfs4_put_cpntf_state(nn, cps);
 out:
 	nfs4_put_stid(stid);
 	return status;
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1035,7 +1035,15 @@ struct nfs4_cpntf_state *nfs4_alloc_init
 	/* So a stale list_del_init() before linking is a no-op. */
 	INIT_LIST_HEAD(&cps->cp_list);
 	cps->cpntf_time = ktime_get_boottime_seconds();
-	refcount_set(&cps->cp_stateid.cs_count, 1);
+	/*
+	 * Fully initialize the entry before nfs4_init_cp_state() publishes it,
+	 * since a concurrent OFFLOAD_CANCEL could then free it. Take an extra
+	 * reference for the caller (dropped with nfs4_put_cpntf_state()).
+	 */
+	memcpy(&cps->cp_p_stateid, &p_stid->sc_stateid, sizeof(stateid_t));
+	memcpy(&cps->cp_p_clid, &p_stid->sc_client->cl_clientid,
+	       sizeof(clientid_t));
+	refcount_set(&cps->cp_stateid.cs_count, 2);
 	if (!nfs4_init_cp_state(nn, &cps->cp_stateid, NFS4_COPYNOTIFY_STID,
 				p_stid))
 		goto out_free;


