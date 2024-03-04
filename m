Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28931EB5A;
	Mon,  4 Mar 2024 21:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589101; cv=none; b=SNWQbY8skoSIfGdl7Sfsal9xV87mSyPvKSXUHGUWFBl7FvZW17fdahiMlA7W1/kyLPSFZee3YIMhE0OONcc01IC8N/ATwMm9b+haI1dX4BXi6dVhO3yq0ymwxc/ISR3lfrPwXu6/PJqFo32GV2QnOvHUi86FnBa9xE46XJcdNXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589101; c=relaxed/simple;
	bh=Xyq2BaZYuyPZ63iGBiPlwPmjZRP7fTn0l5lRCqs6+58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A03et2gBcxF/O3WOo9tQlaAdkbMo5ZZRMTGtR3lweOnObgMdi7ldtAJlWAQa2N+8Hvwsc7ee65Rw8zgMiAEr0+wd2ntw/Mp2ArMdushQDsmtt94EAAaly6X0wNmuwbin1mAX/aNDuJJBV+eFpaSIELdR0Q0pVwxZ0gdl2liZxy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gioU+J2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gioU+J2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A67C433F1;
	Mon,  4 Mar 2024 21:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589100;
	bh=Xyq2BaZYuyPZ63iGBiPlwPmjZRP7fTn0l5lRCqs6+58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gioU+J2FNHEmVrpqkXIyKigWqxuvZI331/QClPqXkDuaegUaVQhMswneMhp/lJtWo
	 Dg+ZlYYLkgzOz1lBaUCC0v0VZ25IigijiQ+w54yr4dBBmIxAmoKhx6YhC5kZJSvuFD
	 UArMEOtptwbqnp1ZHo9ejdMKKp6Wvoe3nlIYmM9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Galbraith <efault@gmx.de>,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 177/215] NFSD: register/unregister of nfsd-client shrinker at nfsd startup/shutdown time
Date: Mon,  4 Mar 2024 21:24:00 +0000
Message-ID: <20240304211602.558700036@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   22 +++++++++++-----------
 fs/nfsd/nfsctl.c    |    7 +------
 fs/nfsd/nfsd.h      |    6 ++----
 3 files changed, 14 insertions(+), 21 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4422,7 +4422,7 @@ nfsd4_state_shrinker_scan(struct shrinke
 	return SHRINK_STOP;
 }
 
-int
+void
 nfsd4_init_leases_net(struct nfsd_net *nn)
 {
 	struct sysinfo si;
@@ -4444,16 +4444,6 @@ nfsd4_init_leases_net(struct nfsd_net *n
 	nn->nfs4_max_clients = max_t(int, max_clients, NFS4_CLIENTS_PER_GB);
 
 	atomic_set(&nn->nfsd_courtesy_clients, 0);
-	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
-	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
-	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
-	return register_shrinker(&nn->nfsd_client_shrinker, "nfsd-client");
-}
-
-void
-nfsd4_leases_net_shutdown(struct nfsd_net *nn)
-{
-	unregister_shrinker(&nn->nfsd_client_shrinker);
 }
 
 static void init_nfs4_replay(struct nfs4_replay *rp)
@@ -8099,8 +8089,17 @@ static int nfs4_state_create_net(struct
 	INIT_DELAYED_WORK(&nn->nfsd_shrinker_work, nfsd4_state_shrinker_worker);
 	get_net(net);
 
+	nn->nfsd_client_shrinker.scan_objects = nfsd4_state_shrinker_scan;
+	nn->nfsd_client_shrinker.count_objects = nfsd4_state_shrinker_count;
+	nn->nfsd_client_shrinker.seeks = DEFAULT_SEEKS;
+
+	if (register_shrinker(&nn->nfsd_client_shrinker, "nfsd-client"))
+		goto err_shrinker;
 	return 0;
 
+err_shrinker:
+	put_net(net);
+	kfree(nn->sessionid_hashtbl);
 err_sessionid:
 	kfree(nn->unconf_id_hashtbl);
 err_unconf_id:
@@ -8193,6 +8192,7 @@ nfs4_state_shutdown_net(struct net *net)
 	struct list_head *pos, *next, reaplist;
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
+	unregister_shrinker(&nn->nfsd_client_shrinker);
 	cancel_delayed_work_sync(&nn->laundromat_work);
 	locks_end_grace(&nn->nfsd4_manager);
 
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1452,9 +1452,7 @@ static __net_init int nfsd_init_net(stru
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
@@ -1464,8 +1462,6 @@ static __net_init int nfsd_init_net(stru
 	return 0;
 
 out_cache_error:
-	nfsd4_leases_net_shutdown(nn);
-out_drc_error:
 	nfsd_idmap_shutdown(net);
 out_idmap_error:
 	nfsd_export_shutdown(net);
@@ -1481,7 +1477,6 @@ static __net_exit void nfsd_exit_net(str
 	nfsd_idmap_shutdown(net);
 	nfsd_export_shutdown(net);
 	nfsd_netns_free_versions(net_generic(net, nfsd_net_id));
-	nfsd4_leases_net_shutdown(nn);
 }
 
 static struct pernet_operations nfsd_net_ops = {
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -504,8 +504,7 @@ extern void unregister_cld_notifier(void
 extern void nfsd4_ssc_init_umount_work(struct nfsd_net *nn);
 #endif
 
-extern int nfsd4_init_leases_net(struct nfsd_net *nn);
-extern void nfsd4_leases_net_shutdown(struct nfsd_net *nn);
+extern void nfsd4_init_leases_net(struct nfsd_net *nn);
 
 #else /* CONFIG_NFSD_V4 */
 static inline int nfsd4_is_junction(struct dentry *dentry)
@@ -513,8 +512,7 @@ static inline int nfsd4_is_junction(stru
 	return 0;
 }
 
-static inline int nfsd4_init_leases_net(struct nfsd_net *nn) { return 0; };
-static inline void nfsd4_leases_net_shutdown(struct nfsd_net *nn) {};
+static inline void nfsd4_init_leases_net(struct nfsd_net *nn) { };
 
 #define register_cld_notifier() 0
 #define unregister_cld_notifier() do { } while(0)


