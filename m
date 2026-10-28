Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216061;
	b=pckGmR9tdw41vszKAsKj0YntOhlsLiKmZiEpv65T8rjytqd3aZjKfYOo9mrEKkb3K1X3
	 xpds+JpQ6Gw3TQJYru9x79uVUVtBempr4OlEym/OyhkX4r/TGatjxTtcpbiCuPKn6xs2I
	 Dxct/qsBk1PIq/qQFmpYlOAjffDVc7yCDZuZD7/MKbskquLCHz0ok9FPv1SLyIVkoKtz0
	 LQJMWhghoFTsqSEhCVSE0l/EoZPHj+08xnLLGLHMo6dzOEVQ/tSmmbuDNnSGVclTT/DAR
	 AE7dQzkMDBAhZMW2sQsKy4PXdLxmSivuZRKnmoKZPLQI2FTiEmlMjdtJQ5fuN1LsxYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XVr5r6sNiLulP8/9Cvhomlwt+4dMTt2CJqaiNn05Sac=;
	b=g8kmhJVDs/Akr+rcm/9wAlgY27uFJEo/VUdUOnQekwogLAaemRemLyoEoZv7n1vQ+07k
	 9h1JQ+wfXuT++CqycM4a89qhvk0Kt0fNojhCgowyK6PcVFcRLWdJbo5HDYE5VOFYcciqN
	 kq3FYYN01khcJzh9kQwLZrbyg5pzFzI2wl/EmXyl7lYezOyp/g2K/hl4g+Sl7yG93zkJf
	 TmFCUB3jHkjv4oK9m9r59VA4JrKJYHj9NYkTRXZKMYfYAu3tVMkmp9Ea1g0SJtk4PXsPa
	 gukaAsZgpqThWGUq0p2FK3KRY1MnFP/IzNA50LgRAGgr/hvfReQBh8VHDEPpWoXAlyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktBbxN40;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA5C606A31A;
	Wed, 28 Oct 2026 19:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktBbxN40
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1502F1F01825;
	Wed, 28 Oct 2026 19:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216060;
	bh=XVr5r6sNiLulP8/9Cvhomlwt+4dMTt2CJqaiNn05Sac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktBbxN40JMdomREuaStAH9ducSo3pxU2puot9LHSztZ5Bjg/9LEKcxQTWT5ABDn6i
	 n0/09jOIdDIUE6Utj8t9hiA8we/UffRv0vP5J5hQcC78+lH9/2ZvzX4Eje6yMp+zhS
	 +VMcoo47JiTNfNo2B++Xf1m9QU40EoVOobl92nvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1428/1887] NFSD: Prevent client use-after-free during delegation revoke
Date: Wed, 28 Oct 2026 17:58:44 +0100
Message-ID: <20261028170531.955145112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 4683ca76b3b7e5808338491c6eb3c20e6b4894d5 ]

A delegation stateid holds only a bare pointer to its owning
nfs4_client and does not keep it alive.  The client survives its
stateids only because __destroy_client() drains cl_delegations and
cl_revoked before free_client() runs.

nfs4_laundromat() breaks that invariant: it unhashes an
expired delegation from cl_delegations, drops deleg_lock, then
revoke_delegation() relinks it onto cl_revoked under cl_lock.  In that
window the delegation is on neither list, so client_has_state() can
report no remaining state.

Every teardown path first requires cl_rpc_users to be zero, but
the laundromat holds no such reference.  A client whose recalled
delegation has just timed out can therefore reach free_client()
while revoke_delegation() is still about to dereference cl_lock,
a use-after-free.

Pin the client with cl_rpc_users across the revoke so teardown blocks
until it completes, then reap the delegation from cl_revoked.  A client
already expiring reaps its own, so skip it and leave the delegation on
del_recall_lru.

Fixes: 3bd64a5ba171 ("nfsd4: implement SEQ4_STATUS_RECALLABLE_STATE_REVOKED")
Cc: stable@vger.kernel.org
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-2-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a342f6398e55e..d6f1b9f572bf9 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6270,6 +6270,7 @@ nfs4_laundromat(struct nfsd_net *nn)
 		.new_timeo = nn->nfsd4_lease
 	};
 	struct nfs4_cpntf_state *cps;
+	struct nfs4_client *clp;
 	copy_stateid_t *cps_t;
 	int i;
 
@@ -6295,6 +6296,18 @@ nfs4_laundromat(struct nfsd_net *nn)
 		dp = list_entry (pos, struct nfs4_delegation, dl_recall_lru);
 		if (!state_expired(&lt, dp->dl_time))
 			break;
+		clp = dp->dl_stid.sc_client;
+		spin_lock(&nn->client_lock);
+		if (is_client_expired(clp)) {
+			spin_unlock(&nn->client_lock);
+			continue;
+		}
+		/*
+		 * Pin without reviving: get_client_locked() would
+		 * flip a courtesy client back to NFSD4_ACTIVE.
+		 */
+		atomic_inc(&clp->cl_rpc_users);
+		spin_unlock(&nn->client_lock);
 		WARN_ON(!unhash_delegation_locked(dp));
 		list_add(&dp->dl_recall_lru, &reaplist);
 	}
@@ -6302,8 +6315,18 @@ nfs4_laundromat(struct nfsd_net *nn)
 	while (!list_empty(&reaplist)) {
 		dp = list_first_entry(&reaplist, struct nfs4_delegation,
 					dl_recall_lru);
+		clp = dp->dl_stid.sc_client;
 		list_del_init(&dp->dl_recall_lru);
 		revoke_delegation(dp);
+		/*
+		 * Unpin without renewing: put_client_renew() would
+		 * renew the reaped client's lease.
+		 */
+		if (atomic_dec_and_lock(&clp->cl_rpc_users, &nn->client_lock)) {
+			if (is_client_expired(clp))
+				wake_up_all(&expiry_wq);
+			spin_unlock(&nn->client_lock);
+		}
 	}
 
 	spin_lock(&nn->client_lock);
-- 
2.53.0



