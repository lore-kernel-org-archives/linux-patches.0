Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043845;
	b=AisF9yeWsdytohjyqoPC5c//rFkoSFMaH7Pj/cKDsi2ewiezYCEp3yonR5+3hQCR2cNh
	 HQRS3s/tSyFOMhBbCGnAzqs/dQH1HS3bymmgim+aJ9imV4H5Ko5xPe5mpB0rqB7vOhC4p
	 DP2CcPRsTMKrBRqIFbzCzxajhjYTwkO7OXvKn3XTOgWAGfrdG6p/0astBMRKJ3bCW2cqZ
	 obzFEV7VKoKTNYDem3ROajOWiXq3VSkLpnm7ahLgtPBxlETffeC1q+aJ3PD83KeDDXMfX
	 ygxdrV4MXs6AsuL/xGPAKSBUO90Q+HH5TbSVyI1GglY0gGzAWClwDrhYTx+iT3BvEoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XuAFa+aMkK61V4I2h+D2PE2VhUHKJrOsqC5D/ukukdo=;
	b=y6rHb8w58cH3gTCjgxQ4RoRGxp0CmozEvIFjGM0/PdZK4K/1oWUKwv6SvNzj1cbjEISP
	 cLg2hyeG21gCwcETWl5DWukmmCW/kdvPiLCvaOB7tuTHyMTJPmE2Cj7ylWrAcwiozmRr+
	 r+TILIYOPY0sfSzVPoNZgSDzU5g9zgvULctl2gStkJ9S3UxhvvFpO+y5AzxjXPN7P8pQ5
	 BXg+FtiDhYnW8dlTynLVIsloRl1FpfMEUVyZSR/lspsrW0yyo4p7QQCb9pIv2yXP31rIL
	 Zn9ofsd8mkf5avXsioyOdqoYWb87UCpVVjbmq0txqQphIy2RbYaapH1WDjcCmX4+kcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tjRdNn0/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC0760A2607;
	Wed, 18 Nov 2026 23:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tjRdNn0/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52C91F000CC;
	Wed, 18 Nov 2026 23:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043845;
	bh=XuAFa+aMkK61V4I2h+D2PE2VhUHKJrOsqC5D/ukukdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tjRdNn0/43ZLvUJGkY+jHsHYi0FtE/HqxWmXpc+0AeKqdZhPqd8feQ2BAWAAaM29P
	 4Z6Rv2BsrmdCgiZAGMpDGZ775FcOmBRVPgx+aQjRAN4cBac6oWDsUBrn+vEFHXKWTV
	 5ViqtGs7L+T7AXUBh4es+lnhhtnJpMYw9D7WaC/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0355/2857] NFSD: Prevent client use-after-free during blocked-lock reaping
Date: Wed, 18 Nov 2026 15:23:09 +0100
Message-ID: <20261118150214.222085272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

[ Upstream commit 9026932ac8be4d0ae01db47f23619a98cc57b671 ]

A bare lock owner -- its only remaining reference a blocked lock on
nn->blocked_locks_lru -- holds a raw pointer to its nfs4_client but
no reference keeping the client alive. When the per-net laundromat
reaps such a lock, freeing the nbl drops the owner reference
held through flc_owner, and the final nfs4_put_stateowner()
takes the client's cl_lock. Because the laundromat detaches the
nbl first, __destroy_client() no longer finds it, so a concurrent
force_expire_client() can free the client before nfs4_put_stateowner()
runs, dereferencing cl_lock in freed memory.

Pin the client with cl_rpc_users before dropping
nn->blocked_locks_lock, and skip clients already expiring, whose
blocked locks __destroy_client() frees while holding an owner
reference. Take nn->client_lock outside nn->blocked_locks_lock.
Every other site holds nn->blocked_locks_lock as a leaf, acquiring
no further lock, so placing nn->client_lock outside it cannot form
a lock-order cycle.

Fixes: 7919d0a27f1e ("nfsd: add a LRU list for blocked locks")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260709-cel-v4-7-1d519d9be0cb@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
[ sashal: Replaced nbl->nbl_lock.c.flc_owner with fl_owner, and open-coded the put_client_no_renew() unpin because that helper is missing here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 158a8ab9c83a0..c6d9e3c873010 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -329,6 +329,16 @@ free_blocked_lock(struct nfsd4_blocked_lock *nbl)
 	kref_put(&nbl->nbl_kref, free_nbl);
 }
 
+/* A blocked lock's fl_owner is its nfs4_lockowner. */
+static struct nfs4_client *
+nbl_client(struct nfsd4_blocked_lock *nbl)
+{
+	struct nfs4_lockowner *lo;
+
+	lo = (struct nfs4_lockowner *)nbl->nbl_lock.fl_owner;
+	return lo->lo_owner.so_client;
+}
+
 static void
 remove_blocked_locks(struct nfs4_lockowner *lo)
 {
@@ -6382,22 +6392,33 @@ nfs4_laundromat(struct nfsd_net *nn)
 	 * indefinitely once the lock does become free.
 	 */
 	BUG_ON(!list_empty(&reaplist));
+	spin_lock(&nn->client_lock);
 	spin_lock(&nn->blocked_locks_lock);
-	while (!list_empty(&nn->blocked_locks_lru)) {
-		nbl = list_first_entry(&nn->blocked_locks_lru,
-					struct nfsd4_blocked_lock, nbl_lru);
+	list_for_each_safe(pos, next, &nn->blocked_locks_lru) {
+		nbl = list_entry(pos, struct nfsd4_blocked_lock, nbl_lru);
 		if (!state_expired(&lt, nbl->nbl_time))
 			break;
+		clp = nbl_client(nbl);
+		if (is_client_expired(clp))
+			continue;
+		atomic_inc(&clp->cl_rpc_users);
 		list_move(&nbl->nbl_lru, &reaplist);
 		list_del_init(&nbl->nbl_list);
 	}
 	spin_unlock(&nn->blocked_locks_lock);
+	spin_unlock(&nn->client_lock);
 
 	while (!list_empty(&reaplist)) {
 		nbl = list_first_entry(&reaplist,
 					struct nfsd4_blocked_lock, nbl_lru);
+		clp = nbl_client(nbl);
 		list_del_init(&nbl->nbl_lru);
 		free_blocked_lock(nbl);
+		if (atomic_dec_and_lock(&clp->cl_rpc_users, &nn->client_lock)) {
+			if (is_client_expired(clp))
+				wake_up_all(&expiry_wq);
+			spin_unlock(&nn->client_lock);
+		}
 	}
 #ifdef CONFIG_NFSD_V4_2_INTER_SSC
 	/* service the server-to-server copy delayed unmount list */
-- 
2.53.0



