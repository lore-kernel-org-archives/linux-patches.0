Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D668A282F03;
	Sat, 12 Sep 2026 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226970; cv=none; b=beq45ULdGsnFkRWDTdR3m+nE0tVgWf1D3HvoAM8woYd25sHFBTsAWhEaZ5MF4ODC2z4Ajtz2BivfNcD2ZC6FFn81cmNZDzCMBn+DzjN8CkqFo6QWmXFE4XAZmvYEu7J24HGX/htukdiJmy5mjhmybJX/H2LLAS+OudVTf9Jy1Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226970; c=relaxed/simple;
	bh=wGLMqUu45v49lAfMQpycJVW30SIwZOzicE9ZmoD+6FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd/Ei5tRBJLadjWjQwvlfaNfklQlGb00xhsEuuVtEV+i6rKAa/qVjbfh60gt0sDhjPW1wngypkHek4UafVUu/KpYjsY6yVs5gp8G9lTW4onBWD9XX2c83ElvlBgukYnq6tYNgwwE4Y1MwORaG4wQHsH4NCtJ7zHwSnTauR7XmEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqqjH1yP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqqjH1yP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB651F000FF;
	Sat, 12 Sep 2026 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226968;
	bh=rOhbDN0W8AVDQc7xXpa0ofEJRNpauQB03u72nCu+ais=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QqqjH1yPocY/vEzyCQOTfx4JSUE/xh9IodTovoJgcwssVBFGO7gfPBOWnbhthM7J5
	 uhjroiLW4NMRyBinxucUno8IGLXZ9TlvvDlOk/jbq3Q3Gn8/Ob/vwzrOiKhGoLnG/J
	 JqbcFyRcFUlPrvPdKDaR5waPrCDwOnhBYXo0a6wM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.1 0058/1191] nfsd: revoke copy-notify stateids before dropping their reference
Date: Sat, 12 Sep 2026 08:46:26 +0200
Message-ID: <20260912065549.454151658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 3b0c3595db99bb4bebd7c8aa8a36f3c50e411bb7 upstream.

Copy-notify stateids live in the s2s_cp_stateids IDR and on their parent
stid's sc_cp_list, pinned by a single membership reference.
_free_cpntf_state_locked() only unlinks an entry once its refcount reaches
zero, so any revoke path that runs while a concurrent
find_cpntf_state()/manage_cpntf_state() holder has elevated cs_count drops
the reference without unlinking, leaving the entry discoverable with its
membership reference already consumed. A second revoke or a laundromat tick
then frees it while the reader still holds the pointer -- a
KASAN-detectable use-after-free at the reader's nfs4_put_cpntf_state().

This affected all three revoke paths:

  - The parent-stid drain (nfs4_free_cpntf_statelist()) repeatedly called
    _free_cpntf_state_locked() on the first list entry; a holder that had
    bumped cs_count made it return early, so the next iteration
    re-decremented and burned the holder's reference.

  - OFFLOAD_CANCEL (manage_cpntf_state()) and laundromat expiry likewise
    used _free_cpntf_state_locked() and could drop 2->1 without unlinking.

Add revoke_cpntf_state_locked(), which unhashes the entry from the IDR and
sc_cp_list first (deferring the final free to any holder), and use it from
all three revoke paths. The drain now walks with list_for_each_entry_safe()
and revokes each entry unconditionally, so it terminates in one pass per
entry regardless of cs_count. The unhash is gated on
!list_empty(&cps->cp_list); the idr_remove() gate matters because
idr_alloc_cyclic() may have recycled the so_id by then. Keep
_free_cpntf_state_locked() for the reference-holder put path only, where a
concurrent revoke may already have unlinked the entry (its list_del_init()
then a no-op).

Fixes: 624322f1adc5 ("NFSD add COPY_NOTIFY operation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260710-nfsd-testing-v3-6-a0ff7db6aa3e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   78 +++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 62 insertions(+), 16 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1066,18 +1066,66 @@ void nfs4_free_copy_state(struct nfsd4_c
 	spin_unlock(&nn->s2s_cp_lock);
 }
 
+/*
+ * Drop the parent's reference on an already-unlinked cpntf entry. If a
+ * concurrent holder still owns a reference, its nfs4_put_cpntf_state() does
+ * the final free.
+ *
+ * nn->s2s_cp_lock must be held.
+ */
+static void put_cpntf_state_unlinked_locked(struct nfs4_cpntf_state *cps)
+{
+	WARN_ON_ONCE(cps->cp_stateid.cs_type != NFS4_COPYNOTIFY_STID);
+	WARN_ON_ONCE(!list_empty(&cps->cp_list));
+
+	if (refcount_dec_and_test(&cps->cp_stateid.cs_count))
+		kfree(cps);
+}
+
+/*
+ * Unhash from the IDR and sc_cp_list. Gated on list_empty() to avoid
+ * evicting a recycled so_id.
+ */
+static void nfsd4_unhash_cpntf_state(struct nfsd_net *nn, struct nfs4_cpntf_state *cps)
+{
+	lockdep_assert_held(&nn->s2s_cp_lock);
+
+	if (!list_empty(&cps->cp_list)) {
+		list_del_init(&cps->cp_list);
+		idr_remove(&nn->s2s_cp_stateids, cps->cp_stateid.cs_stid.si_opaque.so_id);
+	}
+}
+
+/*
+ * Revoke a copy-notify stateid: unlink it from the IDR and sc_cp_list first
+ * so no new finder can discover it, then drop the membership reference. Every
+ * revoke path (cancel, laundromat, drain) must use this rather than
+ * _free_cpntf_state_locked(), which unlinks only at refcount zero and so could
+ * let a second revoke free the entry under a concurrent reader.
+ *
+ * nn->s2s_cp_lock must be held.
+ */
+static void revoke_cpntf_state_locked(struct nfsd_net *nn,
+				      struct nfs4_cpntf_state *cps)
+{
+	nfsd4_unhash_cpntf_state(nn, cps);
+	put_cpntf_state_unlinked_locked(cps);
+}
+
 static void nfs4_free_cpntf_statelist(struct net *net, struct nfs4_stid *stid)
 {
-	struct nfs4_cpntf_state *cps;
+	struct nfs4_cpntf_state *cps, *tmp;
 	struct nfsd_net *nn;
 
 	nn = net_generic(net, nfsd_net_id);
 	spin_lock(&nn->s2s_cp_lock);
-	while (!list_empty(&stid->sc_cp_list)) {
-		cps = list_first_entry(&stid->sc_cp_list,
-				       struct nfs4_cpntf_state, cp_list);
-		_free_cpntf_state_locked(nn, cps);
-	}
+	/*
+	 * Revoke unlinks each entry before dropping the parent's reference, so
+	 * the drain terminates in one pass per entry regardless of cs_count; a
+	 * concurrent holder does the final kfree via nfs4_put_cpntf_state().
+	 */
+	list_for_each_entry_safe(cps, tmp, &stid->sc_cp_list, cp_list)
+		revoke_cpntf_state_locked(nn, cps);
 	spin_unlock(&nn->s2s_cp_lock);
 }
 
@@ -6226,7 +6274,7 @@ nfs4_laundromat(struct nfsd_net *nn)
 		cps = container_of(cps_t, struct nfs4_cpntf_state, cp_stateid);
 		if (cps->cp_stateid.cs_type == NFS4_COPYNOTIFY_STID &&
 				state_expired(&lt, cps->cpntf_time))
-			_free_cpntf_state_locked(nn, cps);
+			revoke_cpntf_state_locked(nn, cps);
 	}
 	spin_unlock(&nn->s2s_cp_lock);
 	nfs4_get_client_reaplist(nn, &reaplist, &lt);
@@ -6604,16 +6652,14 @@ nfs4_check_file(struct svc_rqst *rqstp,
 out:
 	return status;
 }
-static void
-_free_cpntf_state_locked(struct nfsd_net *nn, struct nfs4_cpntf_state *cps)
+
+static void _free_cpntf_state_locked(struct nfsd_net *nn, struct nfs4_cpntf_state *cps)
 {
 	WARN_ON_ONCE(cps->cp_stateid.cs_type != NFS4_COPYNOTIFY_STID);
-	if (!refcount_dec_and_test(&cps->cp_stateid.cs_count))
-		return;
-	list_del_init(&cps->cp_list);
-	idr_remove(&nn->s2s_cp_stateids,
-		   cps->cp_stateid.cs_stid.si_opaque.so_id);
-	kfree(cps);
+	if (refcount_dec_and_test(&cps->cp_stateid.cs_count)) {
+		nfsd4_unhash_cpntf_state(nn, cps);
+		kfree(cps);
+	}
 }
 /*
  * A READ from an inter server to server COPY will have a
@@ -6650,7 +6696,7 @@ __be32 manage_cpntf_state(struct nfsd_ne
 			state = NULL;
 			goto unlock;
 		} else {
-			_free_cpntf_state_locked(nn, state);
+			revoke_cpntf_state_locked(nn, state);
 		}
 	}
 unlock:


