Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2333A16AC;
	Fri,  4 Sep 2026 05:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498819; cv=none; b=PkFeXOmjmc4VOFT+qMaqXnDfgjJhqDLaFIH/YJ/BVo3a7ZVR1MoYuIIAFffwCiOlAhvIfbmA8Cgy2YD5hbP2u6co62QrBlTapMDx3aW57T5X7evbw/PSnwogx/jHq/KFtuClu9uZhK1QRPL0DCXmAgVLYDk+HaNDI0PElkDPOv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498819; c=relaxed/simple;
	bh=dHZ86X04fgXRaW9ghH+SbwGQJRB5sNTnvLAJQh2CvhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKCyVSPluz1GOPmhELSVsBuKRK9qWrvkl3uKmd6R1XBkPu3AnhDRo8us8SLRDKBfyY5nk4+NN8KOz28mUnOBFhfLgS3uQH9m3NmFDwVW/d5iuC976Hs+wk1i4JcSe3wJ8pCH/k5z6QK2Jjctvmi0SQZ3fO6L5xgh4mdwxb1OAoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2fmJXz5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2fmJXz5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2731F00A3D;
	Fri,  4 Sep 2026 05:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498818;
	bh=ggWcbhLs80o3LMDpaJ06rRn3ZwiiC9qGT9gm7eWbDV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2fmJXz5yscpTuw5RnOvGBsAHp+Nqc9S8OicLv2Ih9YyFliiC1k12nygr7JxGX27pF
	 OD8OlCmiNDHuaKE71eIq2yywTDhXnDdjOhiLD33zONuOd6nruLgS6RJGjbvzTQtTci
	 IsbnpwGccibexwox0Cb1aM8mv48/PRNrkXZU+5WU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.2 198/713] nfsd: initialize copy-notify stateid before publishing it
Date: Fri,  4 Sep 2026 06:52:46 +0200
Message-ID: <20260904045808.250483163@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2363,7 +2363,6 @@ nfsd4_copy_notify(struct svc_rqst *rqstp
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct nfs4_stid *stid = NULL;
 	struct nfs4_cpntf_state *cps;
-	struct nfs4_client *clp = cstate->clp;
 
 	status = nfs4_preprocess_stateid_op(rqstp, cstate, &cstate->current_fh,
 					&cn->cpn_src_stateid, RD_STATE, NULL,
@@ -2377,12 +2376,14 @@ nfsd4_copy_notify(struct svc_rqst *rqstp
 	cn->cpn_lease_time.tv_nsec = 0;
 
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
@@ -2391,10 +2392,11 @@ nfsd4_copy_notify(struct svc_rqst *rqstp
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
@@ -990,7 +990,15 @@ struct nfs4_cpntf_state *nfs4_alloc_init
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


