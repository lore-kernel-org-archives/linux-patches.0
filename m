Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0177E224AEF;
	Tue,  8 Apr 2025 11:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112259; cv=none; b=QdP4CWs6mvXWZZy8IiPfHdu7TtimS1igxd4x8f5TvEx8ILSMLL4YCXOvoU/Tpo1DpV8vEO+Va0+vbICOEKGulYHGC5HuaObmGF8eBTCkYxjKEwrEYF4tmolRcdVt8MP92OXa11oH8DZNm0v8U/M5aBLvYYyImFxJELySAsjhgAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112259; c=relaxed/simple;
	bh=rK+dW1mEQ8+3c8kgSDGwcvL4rRqWp+ydwt9MDLqXCEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE9Z7JnxD9ZLl0RnFTDSEMTgOLGloh3IIstKm6qnglCR1gzGryMG/Et3Itp+P6qSMCUvbw3lze1P/lK9ZGI40XYIfrfj4aV6y76u61HCyRlx9+H6DOF2njBdNsHZ0CTN2Smt39jvgwO5Bdszm6exTvmEMkPYs9Lw1bLwLT+733s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ba75M3Md; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ba75M3Md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85314C4CEE5;
	Tue,  8 Apr 2025 11:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112258;
	bh=rK+dW1mEQ8+3c8kgSDGwcvL4rRqWp+ydwt9MDLqXCEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba75M3MdzIIgXWc8KF3I988EHrhaexV5LI+dWW0P/I5eJH5JkGPTc/E4LkYgjXsWT
	 3dhvP3SjhnlXIcX6xrvoiSfLbqV4RgKv6TnkPT319jEHLuXK/xoytt0a5KrpMr3XtA
	 wwVYbUGK/QGzOQRh3l2BIqr31eR+u5D9IthTk2/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e34ad04f27991521104c@syzkaller.appspotmail.com,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.14 724/731] nfsd: dont ignore the return code of svc_proc_register()
Date: Tue,  8 Apr 2025 12:50:21 +0200
Message-ID: <20250408104931.114928956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2204,8 +2204,14 @@ static __net_init int nfsd_net_init(stru
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
@@ -2215,13 +2221,14 @@ static __net_init int nfsd_net_init(stru
 	nfsd4_init_leases_net(nn);
 	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
 	seqlock_init(&nn->writeverf_lock);
-	nfsd_proc_stat_init(net);
 #if IS_ENABLED(CONFIG_NFS_LOCALIO)
 	spin_lock_init(&nn->local_clients_lock);
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


