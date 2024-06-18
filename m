Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD44B15DBA7;
	Tue, 18 Jun 2024 12:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715393; cv=none; b=NL2QdcsSz/UA2f572sAM5lNz1D+Ec5AfOBA/lLNVDg7d6N0nqK/91K/I5r+Sjg1sy+RM8f4EzI5bcj64vCJ0U19njKmQ+u502+ODOTqAHqI2v4ObbDg+vuGKO9ooRupQ6lvfZLWd67TZdtFZGInY6cVp/iKfuMiYmg31k2sdcOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715393; c=relaxed/simple;
	bh=OOyPkfnOpxdFSf4N+3iJrFy6+CN3REG3KjZCt4wXZL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHyzTDZiaZB3I3jX21I0U7zAZQe0F/Ol65SrkPKUvHXejLb38jsc8ZGpXmx/om28tJ8nhOKdNKbNMMJjvQ4Ti//F1QRKa3gqtGyEe9LmNYPDiXiAfHa7GObWy3UGZSkAPaNUZE9W0SLg37uOMi4v9OLWFYLZF3pLmAwZpRt+SvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vf9eAyOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vf9eAyOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C17C4AF48;
	Tue, 18 Jun 2024 12:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715393;
	bh=OOyPkfnOpxdFSf4N+3iJrFy6+CN3REG3KjZCt4wXZL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vf9eAyOf0ZqfY3SStLah2oCOyW/p9RhD+6LZSP8CLyNVMApl0xEB2Pk/aGUcSThL6
	 wL5IG74o+Q+liQYAYG0R8Ynj0pWuyA55Q3Bs/yq+dt/RKy/Nr0gVRu3vFy7U9/Xr4U
	 zSY/BRAYWXGduymGAeJHqhVMrlCB2OABXU6R0A6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 276/770] NFSD: Add tracepoints for SETCLIENTID edge cases
Date: Tue, 18 Jun 2024 14:32:09 +0200
Message-ID: <20240618123417.920905389@linuxfoundation.org>
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

[ Upstream commit 237f91c85acef206a33bc02f3c4e856128fd7994 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 19 ++++++++-----------
 fs/nfsd/trace.h     | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 7e8752f4affda..31310dbe9c1e2 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4008,11 +4008,9 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	new = create_client(clname, rqstp, &clverifier);
 	if (new == NULL)
 		return nfserr_jukebox;
-	/* Cases below refer to rfc 3530 section 14.2.33: */
 	spin_lock(&nn->client_lock);
 	conf = find_confirmed_client_by_name(&clname, nn);
 	if (conf && client_has_state(conf)) {
-		/* case 0: */
 		status = nfserr_clid_inuse;
 		if (clp_used_exchangeid(conf))
 			goto out;
@@ -4024,7 +4022,6 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	unconf = find_unconfirmed_client_by_name(&clname, nn);
 	if (unconf)
 		unhash_client_locked(unconf);
-	/* We need to handle only case 1: probable callback update */
 	if (conf) {
 		if (same_verf(&conf->cl_verifier, &clverifier)) {
 			copy_clid(new, conf);
@@ -4032,7 +4029,8 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		} else
 			trace_nfsd_clid_verf_mismatch(conf, rqstp,
 						      &clverifier);
-	}
+	} else
+		trace_nfsd_clid_fresh(new);
 	new->cl_minorversion = 0;
 	gen_callback(new, setclid, rqstp);
 	add_to_unconfirmed(new);
@@ -4045,12 +4043,13 @@ nfsd4_setclientid(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	spin_unlock(&nn->client_lock);
 	if (new)
 		free_client(new);
-	if (unconf)
+	if (unconf) {
+		trace_nfsd_clid_expire_unconf(&unconf->cl_clientid);
 		expire_client(unconf);
+	}
 	return status;
 }
 
-
 __be32
 nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 			struct nfsd4_compound_state *cstate,
@@ -4087,21 +4086,19 @@ nfsd4_setclientid_confirm(struct svc_rqst *rqstp,
 		trace_nfsd_clid_cred_mismatch(conf, rqstp);
 		goto out;
 	}
-	/* cases below refer to rfc 3530 section 14.2.34: */
 	if (!unconf || !same_verf(&confirm, &unconf->cl_confirm)) {
 		if (conf && same_verf(&confirm, &conf->cl_confirm)) {
-			/* case 2: probable retransmit */
 			status = nfs_ok;
-		} else /* case 4: client hasn't noticed we rebooted yet? */
+		} else
 			status = nfserr_stale_clientid;
 		goto out;
 	}
 	status = nfs_ok;
-	if (conf) { /* case 1: callback update */
+	if (conf) {
 		old = unconf;
 		unhash_client_locked(old);
 		nfsd4_change_callback(conf, &unconf->cl_cb_conn);
-	} else { /* case 3: normal case; new or rebooted client */
+	} else {
 		old = find_confirmed_client_by_name(&unconf->cl_name, nn);
 		if (old) {
 			status = nfserr_clid_inuse;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 3271d925abf2e..aa42d31cdfac1 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -511,6 +511,7 @@ DEFINE_EVENT(nfsd_clientid_class, nfsd_clid_##name, \
 	TP_PROTO(const clientid_t *clid), \
 	TP_ARGS(clid))
 
+DEFINE_CLIENTID_EVENT(expire_unconf);
 DEFINE_CLIENTID_EVENT(reclaim_complete);
 DEFINE_CLIENTID_EVENT(confirmed);
 DEFINE_CLIENTID_EVENT(destroyed);
@@ -600,6 +601,42 @@ TRACE_EVENT(nfsd_clid_verf_mismatch,
 	)
 );
 
+DECLARE_EVENT_CLASS(nfsd_clid_class,
+	TP_PROTO(const struct nfs4_client *clp),
+	TP_ARGS(clp),
+	TP_STRUCT__entry(
+		__field(u32, cl_boot)
+		__field(u32, cl_id)
+		__array(unsigned char, addr, sizeof(struct sockaddr_in6))
+		__field(unsigned long, flavor)
+		__array(unsigned char, verifier, NFS4_VERIFIER_SIZE)
+		__dynamic_array(char, name, clp->cl_name.len + 1)
+	),
+	TP_fast_assign(
+		__entry->cl_boot = clp->cl_clientid.cl_boot;
+		__entry->cl_id = clp->cl_clientid.cl_id;
+		memcpy(__entry->addr, &clp->cl_addr,
+			sizeof(struct sockaddr_in6));
+		__entry->flavor = clp->cl_cred.cr_flavor;
+		memcpy(__entry->verifier, (void *)&clp->cl_verifier,
+		       NFS4_VERIFIER_SIZE);
+		memcpy(__get_str(name), clp->cl_name.data, clp->cl_name.len);
+		__get_str(name)[clp->cl_name.len] = '\0';
+	),
+	TP_printk("addr=%pISpc name='%s' verifier=0x%s flavor=%s client=%08x:%08x",
+		__entry->addr, __get_str(name),
+		__print_hex_str(__entry->verifier, NFS4_VERIFIER_SIZE),
+		show_nfsd_authflavor(__entry->flavor),
+		__entry->cl_boot, __entry->cl_id)
+);
+
+#define DEFINE_CLID_EVENT(name) \
+DEFINE_EVENT(nfsd_clid_class, nfsd_clid_##name, \
+	TP_PROTO(const struct nfs4_client *clp), \
+	TP_ARGS(clp))
+
+DEFINE_CLID_EVENT(fresh);
+
 /*
  * from fs/nfsd/filecache.h
  */
-- 
2.43.0



