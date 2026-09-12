Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8173AC0ED;
	Sat, 12 Sep 2026 17:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232600; cv=none; b=B3pzkbVuFHiG7S4Y+XioM5mq48lR9pjX7ESEKJP9YP5I6u+fmDhUnRIlazOU61fncz7FU/pQwXBAs6pAF/PjebcFiHcnBAWD2Nwr5geYR3kc7vE6tkVANygHNMyfnxjYeezud5E9oNtEClayfCRq7wJnUFDWVRMLeY96KwwHl/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232600; c=relaxed/simple;
	bh=Hxv92aAN2jQBkPoj6hI4Gv87+7I1vAJnPp35275mesU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPNAEQ0YMnjY5fDULVIyNaXp914OKKJ7rL3YaSdoQxS78q3ZZa0sNbqTZdK7iuwus2xpQrHL5DJwwJp8amf1gpG3ces88RTsH4zRDb1hKCOnr2zENCHItHKuQG2x0rV5ohVLVU+8O5uG//rfYaXRpwOS4P4BK3zhXtVjgI5t0cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6TEvOIY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6TEvOIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D88C1F000FF;
	Sat, 12 Sep 2026 17:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232599;
	bh=KsCHNNV+H124CT2H+5Tz1VoJEFgurgaD6QdoCpmHSU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S6TEvOIYLuP2+M327jDJGEt/t4CXu15HFf5/7LarUvZY0xmtXKn66PN+NoBwCrCEr
	 zdCqdlXNCT3kt9W41izASRogFjZcvNgwRFwxPeq9S4V5tXQL41oaJhORXGyV22q7Yd
	 fPK7YrjzSFBOPugIJQ93awPMNiK4b8awS3b0pn0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 044/935] nfsd: fix cpntf publish race in nfs4_init_cp_state
Date: Sat, 12 Sep 2026 08:51:14 +0200
Message-ID: <20260912065527.848087607@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit be3a5c1d857b0dcbc11796cea603ef25834f75b2 upstream.

nfs4_alloc_init_cpntf_state() published the new cpntf entry into the
s2s_cp_stateids IDR (with cs_type set) in one s2s_cp_lock section, then
took the lock again to list_add() it onto p_stid->sc_cp_list. In the gap
the entry is reachable by so_id but cp_list is still {NULL,NULL} from
kzalloc. A racing OFFLOAD_CANCEL (so_id is echoed to the client as
cnr_stateid, so any NFSv4.2 client can drive it) reaches
manage_cpntf_state() -> _free_cpntf_state_locked() and does list_del() on
the zeroed list_head, oopsing the server.

Fold the cs_type assignment and the list_add() into the same critical
section as idr_alloc_cyclic(), so a concurrent lookup either misses the
entry or sees a fully linked cp_list. INIT_LIST_HEAD() the entry after
allocation and switch _free_cpntf_state_locked() to list_del_init() so a
stale unlink is a no-op. nfs4_init_copy_state() passes NULL p_stid and
skips the list_add, preserving NFS4_COPY_STID semantics.

Fixes: 624322f1adc5 ("NFSD add COPY_NOTIFY operation")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260710-nfsd-testing-v3-1-a0ff7db6aa3e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -984,7 +984,7 @@ out_free:
  * Create a unique stateid_t to represent each COPY.
  */
 static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
-			      unsigned char cs_type)
+			      unsigned char cs_type, struct nfs4_stid *p_stid)
 {
 	int new_id;
 
@@ -994,19 +994,34 @@ static int nfs4_init_cp_state(struct nfs
 	idr_preload(GFP_KERNEL);
 	spin_lock(&nn->s2s_cp_lock);
 	new_id = idr_alloc_cyclic(&nn->s2s_cp_stateids, stid, 0, 0, GFP_NOWAIT);
-	stid->cs_stid.si_opaque.so_id = new_id;
-	stid->cs_stid.si_generation = 1;
+	if (new_id >= 0) {
+		stid->cs_stid.si_opaque.so_id = new_id;
+		stid->cs_stid.si_generation = 1;
+		/*
+		 * Set cs_type and link onto sc_cp_list under the same lock
+		 * that installed the IDR entry, so a concurrent
+		 * manage_cpntf_state() sees either no entry or a fully
+		 * linked cp_list.
+		 */
+		stid->cs_type = cs_type;
+		if (p_stid) {
+			struct nfs4_cpntf_state *cps =
+				container_of(stid, struct nfs4_cpntf_state,
+					     cp_stateid);
+
+			list_add(&cps->cp_list, &p_stid->sc_cp_list);
+		}
+	}
 	spin_unlock(&nn->s2s_cp_lock);
 	idr_preload_end();
 	if (new_id < 0)
 		return 0;
-	stid->cs_type = cs_type;
 	return 1;
 }
 
 int nfs4_init_copy_state(struct nfsd_net *nn, struct nfsd4_copy *copy)
 {
-	return nfs4_init_cp_state(nn, &copy->cp_stateid, NFS4_COPY_STID);
+	return nfs4_init_cp_state(nn, &copy->cp_stateid, NFS4_COPY_STID, NULL);
 }
 
 struct nfs4_cpntf_state *nfs4_alloc_init_cpntf_state(struct nfsd_net *nn,
@@ -1017,13 +1032,13 @@ struct nfs4_cpntf_state *nfs4_alloc_init
 	cps = kzalloc(sizeof(struct nfs4_cpntf_state), GFP_KERNEL);
 	if (!cps)
 		return NULL;
+	/* So a stale list_del_init() before linking is a no-op. */
+	INIT_LIST_HEAD(&cps->cp_list);
 	cps->cpntf_time = ktime_get_boottime_seconds();
 	refcount_set(&cps->cp_stateid.cs_count, 1);
-	if (!nfs4_init_cp_state(nn, &cps->cp_stateid, NFS4_COPYNOTIFY_STID))
+	if (!nfs4_init_cp_state(nn, &cps->cp_stateid, NFS4_COPYNOTIFY_STID,
+				p_stid))
 		goto out_free;
-	spin_lock(&nn->s2s_cp_lock);
-	list_add(&cps->cp_list, &p_stid->sc_cp_list);
-	spin_unlock(&nn->s2s_cp_lock);
 	return cps;
 out_free:
 	kfree(cps);
@@ -6588,7 +6603,7 @@ _free_cpntf_state_locked(struct nfsd_net
 	WARN_ON_ONCE(cps->cp_stateid.cs_type != NFS4_COPYNOTIFY_STID);
 	if (!refcount_dec_and_test(&cps->cp_stateid.cs_count))
 		return;
-	list_del(&cps->cp_list);
+	list_del_init(&cps->cp_list);
 	idr_remove(&nn->s2s_cp_stateids,
 		   cps->cp_stateid.cs_stid.si_opaque.so_id);
 	kfree(cps);


