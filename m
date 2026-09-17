Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4051349D59C;
	Thu, 17 Sep 2026 19:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671610; cv=none; b=ZhEHjnDqVeJ/Lp1qUcPkiDVU7QJHA+peNxrZ1NIsNiPBcvSOEXQuWS61l+7yblzVQ+4yMnU731JP1FNygkutepzreu1H3O9LR1nxIPvC66cSpwq98UYXe76hO4qgdtyfxJBDUVnOllESZ/a1KDDn7f5ewgpk5ax+oVN1PL8jOIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671610; c=relaxed/simple;
	bh=Hku+FF+AXwpUEtBDCt/LaZ+w5VyMRN/uuDpaaQEAeDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gp6mdy1yamnEQynsKOjpcq7TDBJ9F8wsdB1F+ovFVDSAeUY2Fh/uf6lrPHyTOHltLUlr6dOyVqOkKKmxqv0vnTsfBvzgv034a0LBNbMz1AbGtX3uZ4MeSv6gLdFQrX7WX5Op9xxrEIv2fC1BbTqOJMMPZ5tTsaEnwPfvcOa3xtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpoQF+Xf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpoQF+Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D301F000FF;
	Thu, 17 Sep 2026 19:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671608;
	bh=zNNnD4/P5mYcC/rwyKoCpgUx+r1tG+iCKwvtokqQR40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpoQF+XfyT3LETv4RZYHkEbW4+xTPr2gFNkPJravF5PTwTvGZh84PJ0tjuHPMcqRM
	 AJ+3vg3YiktI6U3GpXkh4fDiBDVASHrDV55oq32UrB4kDG1NaHlSxsffhLmjY1ArTi
	 N2vfYuHnCnxrWVzDt1yODgOH+aiMMIpoMHCbWCZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neil@brown.name>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1032/1102] NFSD: Prevent client use-after-free during admin state revocation
Date: Thu, 17 Sep 2026 16:16:15 +0100
Message-ID: <20260917151606.683010300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit e270e5a0778e5bff852c8862ce9576ce70359393 ]

A stateid holds only a bare pointer to its nfs4_client; a stateid
reference does not pin it.  The client survives only because
__destroy_client() drains its stateids before free_client() runs.

nfsd4_revoke_states() drops nn->client_lock across revoke_one_stid(),
which dereferences the client to revoke a stateid and read
clp->cl_minorversion.  A teardown racing the dropped lock can free
the client first.

Pinning cl_rpc_users under client_lock blocks the DESTROY_CLIENTID and
EXCHANGE_ID teardown, which refuses while cl_rpc_users is non-zero.
force_expire_client() ignores it: once its wait for cl_rpc_users to
reach zero has passed, a later pin goes unnoticed.

Under client_lock, skip a client whose cl_time is already zero --
force_expire_client() clears it there before waiting -- otherwise pin
cl_rpc_users before dropping the lock.  The walk then either sees the
expiry and skips, or pins in time for that wait to cover the revoke.

Fixes: 1c13bf9f2e3c ("nfsd: allow lock state ids to be revoked and then freed")
Cc: stable@vger.kernel.org
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-3-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ adapted revoke_one_stid() calls to the branch’s inline revocation logic ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -1840,13 +1840,23 @@ void nfsd4_revoke_states(struct nfsd_net
 		struct nfs4_client *clp;
 	retry:
 		list_for_each_entry(clp, head, cl_idhash) {
-			struct nfs4_stid *stid = find_one_sb_stid(clp, sb,
-								  sc_types);
+			struct nfs4_stid *stid;
+
+			/*
+			 * force_expire_client() ignores cl_rpc_users once
+			 * its wait_event() has passed, so pinning cannot
+			 * keep an already-expiring client alive; the
+			 * expiry path revokes its states instead.
+			 */
+			if (is_client_expired(clp))
+				continue;
+			stid = find_one_sb_stid(clp, sb, sc_types);
 			if (stid) {
 				struct nfs4_ol_stateid *stp;
 				struct nfs4_delegation *dp;
 				struct nfs4_layout_stateid *ls;
 
+				atomic_inc(&clp->cl_rpc_users);
 				spin_unlock(&nn->client_lock);
 				switch (stid->sc_type) {
 				case SC_TYPE_OPEN:
@@ -1930,6 +1940,9 @@ void nfsd4_revoke_states(struct nfsd_net
 					 */
 					nn->nfs40_last_revoke =
 						ktime_get_boottime_seconds();
+				if (atomic_dec_and_test(&clp->cl_rpc_users) &&
+				    is_client_expired(clp))
+					wake_up_all(&expiry_wq);
 				goto retry;
 			}
 		}
@@ -3129,6 +3142,11 @@ static void force_expire_client(struct n
 
 	trace_nfsd_clid_admin_expired(&clp->cl_clientid);
 
+	/*
+	 * cl_time is cleared under client_lock before the wait so a
+	 * revocation walk pinning cl_rpc_users under it either skips
+	 * this client or is seen by this wait_event().
+	 */
 	spin_lock(&nn->client_lock);
 	clp->cl_time = 0;
 	spin_unlock(&nn->client_lock);


