Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AF6224AFB;
	Thu, 17 Apr 2025 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916273; cv=none; b=WOjmGRm2JuQRtzCP80WBCqoo+Vxip5y2RhNaVZHLK1kBapB60xcYDKiFD0LZem7tSu5X4BqxJ6mb4PhRwgA0gsRFq+BBdbLby0A34/oVu7eZZB379cCNnSppY9GiuS6jI8SuJQI+WO8XkBeIAYMgUBzZIW7fiJ32qa6Wt9rxSgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916273; c=relaxed/simple;
	bh=/viFsuOCZtvOvr6oaIC1ydubx+TWkZNamXtoTeRhTo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWGDYZOjWGEkV0BXxZ9OOgRr28uCX27hqvEwfL/zfV1x+p8MaDWw1K+fHK2zrT5HkzRTX1zqqpFVoSCKBDuv/kGcKi4IB0WtElABYwKV+aYI6XwCIuTYtCQc3lLSdO8Xht8p5tZL0NPDR8MFg3pPsDffvrupf94Ny0cowN2MDlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLHiCMmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLHiCMmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 085AFC4CEE4;
	Thu, 17 Apr 2025 18:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916273;
	bh=/viFsuOCZtvOvr6oaIC1ydubx+TWkZNamXtoTeRhTo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLHiCMmh9vFONVqoEXQCpSbPV4c3yUOYQvbPHYibmT4a3hm9hRBPY2U8ToHarxwOZ
	 IGBlVpzg25pnnXymyloWfzam6Mje0KKRVc5LtVMFBW+YUEsLrZSFoX4Z3dAyymuMSV
	 NIvKgn7oBIPZ3FFq18MhnxfbOecA4Zo/jFvwGVwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e34ad04f27991521104c@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 387/393] nfsd: dont ignore the return code of svc_proc_register()
Date: Thu, 17 Apr 2025 19:53:16 +0200
Message-ID: <20250417175123.172556517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 930b64ca0c511521f0abdd1d57ce52b2a6e3476b upstream.

Currently, nfsd_proc_stat_init() ignores the return value of
svc_proc_register(). If the procfile creation fails, then the kernel
will WARN when it tries to remove the entry later.

Fix nfsd_proc_stat_init() to return the same type of pointer as
svc_proc_register(), and fix up nfsd_net_init() to check that and fail
the nfsd_net construction if it occurs.

svc_proc_register() can fail if the dentry can't be allocated, or if an
identical dentry already exists. The second case is pretty unlikely in
the nfsd_net construction codepath, so if this happens, return -ENOMEM.

Reported-by: syzbot+e34ad04f27991521104c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-nfs/67a47501.050a0220.19061f.05f9.GAE@google.com/
Cc: stable@vger.kernel.org # v6.9
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    9 ++++++++-
 fs/nfsd/stats.c  |    4 ++--
 fs/nfsd/stats.h  |    2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

I did not have any problem cherry-picking 930b64 onto v6.13.11. This
built and ran some simple NFSD tests in my lab.


--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2244,8 +2244,14 @@ static __net_init int nfsd_net_init(stru
 					  NFSD_STATS_COUNTERS_NUM);
 	if (retval)
 		goto out_repcache_error;
+
 	memset(&nn->nfsd_svcstats, 0, sizeof(nn->nfsd_svcstats));
 	nn->nfsd_svcstats.program = &nfsd_programs[0];
+	if (!nfsd_proc_stat_init(net)) {
+		retval = -ENOMEM;
+		goto out_proc_error;
+	}
+
 	for (i = 0; i < sizeof(nn->nfsd_versions); i++)
 		nn->nfsd_versions[i] = nfsd_support_version(i);
 	for (i = 0; i < sizeof(nn->nfsd4_minorversions); i++)
@@ -2255,12 +2261,13 @@ static __net_init int nfsd_net_init(stru
 	nfsd4_init_leases_net(nn);
 	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
 	seqlock_init(&nn->writeverf_lock);
-	nfsd_proc_stat_init(net);
 #if IS_ENABLED(CONFIG_NFS_LOCALIO)
 	INIT_LIST_HEAD(&nn->local_clients);
 #endif
 	return 0;
 
+out_proc_error:
+	percpu_counter_destroy_many(nn->counter, NFSD_STATS_COUNTERS_NUM);
 out_repcache_error:
 	nfsd_idmap_shutdown(net);
 out_idmap_error:
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -73,11 +73,11 @@ static int nfsd_show(struct seq_file *se
 
 DEFINE_PROC_SHOW_ATTRIBUTE(nfsd);
 
-void nfsd_proc_stat_init(struct net *net)
+struct proc_dir_entry *nfsd_proc_stat_init(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	svc_proc_register(net, &nn->nfsd_svcstats, &nfsd_proc_ops);
+	return svc_proc_register(net, &nn->nfsd_svcstats, &nfsd_proc_ops);
 }
 
 void nfsd_proc_stat_shutdown(struct net *net)
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -10,7 +10,7 @@
 #include <uapi/linux/nfsd/stats.h>
 #include <linux/percpu_counter.h>
 
-void nfsd_proc_stat_init(struct net *net);
+struct proc_dir_entry *nfsd_proc_stat_init(struct net *net);
 void nfsd_proc_stat_shutdown(struct net *net);
 
 static inline void nfsd_stats_rc_hits_inc(struct nfsd_net *nn)


