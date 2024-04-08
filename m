Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A9B7D3FE;
	Mon,  8 Apr 2024 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584776; cv=none; b=dPaDQgKwgyADCAcz/k54gJxBc1f3HD+dzTAAMAmmPgfhRAoc1AKOeIOQqFqudDBUfeZL7hvmgC8QjEWr7dgiAdZ0S5WO2ITJUD7V0uL41eqwgs/mKx21dZ0xG6dM22uCpk3VQ4AUX8gJ+7ZXlBDlqaWcjDJ5EAW1tTAf8bTsJdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584776; c=relaxed/simple;
	bh=LD4nDZuA1rXeHoOPV3JVW7gkkUZfjiFmTCLNE47KmN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ld3djuSmNnMNc+09P3T6x5Ug+lEw/TxHL0rMi+zCdjcO0M3isLvaOkh/3Lyvik+jk/UmTjIMxZGPqpWeRbqfGkMxVcL+W94nhYtNkmCl7lT4aGYd7I3SShWEy2wxPgfCzW9OF7EV8r5kuxZlP1s5mq7xX/4K+5w4hg/y3sQb+uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMxB1bKo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMxB1bKo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCA7C433C7;
	Mon,  8 Apr 2024 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584776;
	bh=LD4nDZuA1rXeHoOPV3JVW7gkkUZfjiFmTCLNE47KmN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMxB1bKoV74njRfZgaFTW2BJT6SZ6y4cGpIRaG4/4HEgpskLDpa7sDKci3mk0rZ3W
	 n2UPhJ9tLAhmbuWsdMzuAShzoLM/4Oq/8CMy+Z3faPfxkKi8MrlzL8ByzE9PgWdg3n
	 NXmOsoseCDMHZPxaAiT2GrBNlyXmkJfZyrFzA1WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Galbraith <efault@gmx.de>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 513/690] NFSD: register/unregister of nfsd-client shrinker at nfsd startup/shutdown time
Date: Mon,  8 Apr 2024 14:56:19 +0200
Message-ID: <20240408125418.226406283@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit f385f7d244134246f984975ed34cd75f77de479f ]

Currently the nfsd-client shrinker is registered and unregistered at
the time the nfsd module is loaded and unloaded. The problem with this
is the shrinker is being registered before all of the relevant fields
in nfsd_net are initialized when nfsd is started. This can lead to an
oops when memory is low and the shrinker is called while nfsd is not
running.

This patch moves the  register/unregister of nfsd-client shrinker from
module load/unload time to nfsd startup/shutdown time.

Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 19 +++++++++++--------
 fs/nfsd/nfsctl.c    |  7 +------
 fs/nfsd/nfsd.h      |  6 ++----
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 485e7055e52ec..ca0a1816500c3 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4421,7 +4421,7 @@ nfsd4_state_shrinker_scan(struct shrinker *shrink, struct shrink_control *sc)
 	return SHRINK_STOP;
 }
 
-int
+void
 nfsd4_init_leases_net(struct nfsd_net *nn)
 {
 	struct sysinfo si;
@@ -4446,13 +4446,6 @@ nfsd4_init_leases_net(struct nfsd_net *nn)
 	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
 	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
 	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
-	return register_shrinker(&nn->nfsd_client_shrinker);
-}
-
-void
-nfsd4_leases_net_shutdown(struct nfsd_net *nn)
-{
-	unregister_shrinker(&nn->nfsd_client_shrinker);
 }
 
 static void init_nfs4_replay(struct nfs4_replay *rp)
@@ -8067,8 +8060,17 @@ static int nfs4_state_create_net(struct net *net)
 	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
+	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
+	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
+	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
+
+	if (register_shrinker(&nn->nfsd_client_shrinker))
+		goto err_shrinker;
 	return 0;
 
+err_shrinker:
+	put_net(net);
+	kfree(nn->sessionid_hashtbl);
 err_sessionid:
 	kfree(nn->unconf_id_hashtbl);
 err_unconf_id:
@@ -8161,6 +8163,7 @@ nfs4_state_shutdown_net(struct net *net)
 	struct list_head *pos, *next, reaplist;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
+	unregister_shrinker(&nn->nfsd_client_shrinker);
 	cancel_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
 
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index d1e581a60480c..c2577ee7ffb22 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1457,9 +1457,7 @@ static __net_init int nfsd_init_net(struct net *net)
 		goto out_idmap_error;
 	nn->nfsd_versions = NULL;
 	nn->nfsd4_minorversions = NULL;
-	retval = nfsd4_init_leases_net(nn);
-	if (retval)
-		goto out_drc_error;
+	nfsd4_init_leases_net(nn);
 	retval = nfsd_reply_cache_init(nn);
 	if (retval)
 		goto out_cache_error;
@@ -1469,8 +1467,6 @@ static __net_init int nfsd_init_net(struct net *net)
 	return 0;
 
 out_cache_error:
-	nfsd4_leases_net_shutdown(nn);
-out_drc_error:
 	nfsd_idmap_shutdown(net);
 out_idmap_error:
 	nfsd_export_shutdown(net);
@@ -1486,7 +1482,6 @@ static __net_exit void nfsd_exit_net(struct net *net)
 	nfsd_idmap_shutdown(net);
 	nfsd_export_shutdown(net);
 	nfsd_netns_free_versions(net_generic(net, nfsd_net_id));
-	nfsd4_leases_net_shutdown(nn);
 }
 
 static struct pernet_operations nfsd_net_ops = {
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 93b42ef9ed91b..fa0144a742678 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -504,8 +504,7 @@ extern void unregister_cld_notifier(void);
 extern void nfsd4_ssc_init_umount_work(struct nfsd_net *nn);
 #endif
 
-extern int nfsd4_init_leases_net(struct nfsd_net *nn);
-extern void nfsd4_leases_net_shutdown(struct nfsd_net *nn);
+extern void nfsd4_init_leases_net(struct nfsd_net *nn);
 
 #else /* CONFIG_NFSD_V4 */
 static inline int nfsd4_is_junction(struct dentry *dentry)
@@ -513,8 +512,7 @@ static inline int nfsd4_is_junction(struct dentry *dentry)
 	return 0;
 }
 
-static inline int nfsd4_init_leases_net(struct nfsd_net *nn) { return 0; };
-static inline void nfsd4_leases_net_shutdown(struct nfsd_net *nn) {};
+static inline void nfsd4_init_leases_net(struct nfsd_net *nn) { };
 
 #define register_cld_notifier() 0
 #define unregister_cld_notifier() do { } while(0)
-- 
2.43.0



