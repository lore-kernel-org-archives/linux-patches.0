Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BEF1A256C;
	Tue, 18 Jun 2024 13:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716349; cv=none; b=RmJe4gsvXX8KlvtXP/XqbSc9sSTWWrRMDpCvMi281SZKGHUdBajAhgeEXnoymsShYA42tdyKT38voG4aXTIec7MP96/3ROtaXEIX+meybnKhPLxAdT22NDqQH+NirI4UVDfokRUxFEiFl7nx63z54STiLeOFZ2Rvtho8vBmxTx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716349; c=relaxed/simple;
	bh=5ujYsQTHVDYOihAiyEmTDZpl+j04hPKiGuhtuDrjYtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buuVY9jWENuTkv9/4T6QNeEwU3tJlORK6nP1zLv64NxIoQRztJCbWgXoJs5WCG5k50Sd5AOamsIx57GsQb0QsPJ1+vU0tmtfoRPLOdLDOVn5Skd9pP4X2i29MOhnVlycOXgTkI6pysAZMykb7ai97mRABKXmxC+GMYUcVpqSlB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nW4PnU//; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nW4PnU//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367EDC3277B;
	Tue, 18 Jun 2024 13:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716349;
	bh=5ujYsQTHVDYOihAiyEmTDZpl+j04hPKiGuhtuDrjYtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nW4PnU//fFEWLx6kTlM6KAtI4Bzp/IBEIXD0szazfd4pKrPeXvpKq9QwVs4oCEUJX
	 RGJ6C7cS5pHW9BjpIRgP8qISfGUo+IwwylszYJzuAy9zJ/ELbLTJDGtGFRLhDy2+sq
	 SHSx6K6866TKroRH4LxelteG2nQeWau5ow4fD678=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 585/770] NFSD: refactoring v4 specific code to a helper in nfs4state.c
Date: Tue, 18 Jun 2024 14:37:18 +0200
Message-ID: <20240618123429.875720333@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 6867137ebcf4155fe25f2ecf7c29b9fb90a76d1d ]

This patch moves the v4 specific code from nfsd_init_net() to
nfsd4_init_leases_net() helper in nfs4state.c

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 12 ++++++++++++
 fs/nfsd/nfsctl.c    |  9 +--------
 fs/nfsd/nfsd.h      |  4 ++++
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 16e5bd54d92c2..76a77329cf368 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4347,6 +4347,18 @@ nfsd4_init_slabs(void)
 	return -ENOMEM;
 }
 
+void nfsd4_init_leases_net(struct nfsd_net *nn)
+{
+	nn->nfsd4_lease = 90;	/* default lease time */
+	nn->nfsd4_grace = 90;
+	nn->somebody_reclaimed = false;
+	nn->track_reclaim_completes = false;
+	nn->clverifier_counter = prandom_u32();
+	nn->clientid_base = prandom_u32();
+	nn->clientid_counter = nn->clientid_base + 1;
+	nn->s2s_cp_cl_id = nn->clientid_counter++;
+}
+
 static void init_nfs4_replay(struct nfs4_replay *rp)
 {
 	rp->rp_status = nfserr_serverfault;
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 7002edbf26870..164c822ae3ae9 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1484,14 +1484,7 @@ static __net_init int nfsd_init_net(struct net *net)
 	retval = nfsd_reply_cache_init(nn);
 	if (retval)
 		goto out_drc_error;
-	nn->nfsd4_lease = 90;	/* default lease time */
-	nn->nfsd4_grace = 90;
-	nn->somebody_reclaimed = false;
-	nn->track_reclaim_completes = false;
-	nn->clverifier_counter = prandom_u32();
-	nn->clientid_base = prandom_u32();
-	nn->clientid_counter = nn->clientid_base + 1;
-	nn->s2s_cp_cl_id = nn->clientid_counter++;
+	nfsd4_init_leases_net(nn);
 
 	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
 	seqlock_init(&nn->writeverf_lock);
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 9a8b09afc1733..ef8087691138a 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -496,12 +496,16 @@ extern void unregister_cld_notifier(void);
 extern void nfsd4_ssc_init_umount_work(struct nfsd_net *nn);
 #endif
 
+extern void nfsd4_init_leases_net(struct nfsd_net *nn);
+
 #else /* CONFIG_NFSD_V4 */
 static inline int nfsd4_is_junction(struct dentry *dentry)
 {
 	return 0;
 }
 
+static inline void nfsd4_init_leases_net(struct nfsd_net *nn) {};
+
 #define register_cld_notifier() 0
 #define unregister_cld_notifier() do { } while(0)
 
-- 
2.43.0



