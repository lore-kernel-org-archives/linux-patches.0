Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA0227E05A;
	Tue, 17 Feb 2026 12:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771331645; cv=none; b=d4dbyOsm3D1tqgnofy8faXgL9TLz6LomDhXYrfZVD+xI/TmjjIzhWDLPdLup268m+DPqsaLsL0ZyEsYJ5PEnkEe8CbXc6MkFjqfZzJp3zFNX0p7ugko00ZnkuzJ/m6Vfd3xw2qQtFZKWkh4VN9/I/RAabfSpHSX8Ic3BQBHzrpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771331645; c=relaxed/simple;
	bh=bxU9M9nXqVEmtclr1x8Xb9vfM4SZWn1rd2XzeJD+KHk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=l7I9hRikROjYbNBh/pkiEVyFzDToKi4cK2Uy2ojF3gQh6COPiIOpYTH1lcbieItSJvHD2YL7lwZPUOnOwXGu7brziVYNINtdGxEBd8C8k952dL2W2Lx2gK+wKKceiDRg4mC4jhQeSkvWh0scHXkoLzFB+Pyv8F+BnSdbAI3Tf+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws3S3voG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws3S3voG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508EBC4CEF7;
	Tue, 17 Feb 2026 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771331645;
	bh=bxU9M9nXqVEmtclr1x8Xb9vfM4SZWn1rd2XzeJD+KHk=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=ws3S3voGCgLSc4PzWzlnTx1UfVF7grX0jKVXGQDtOVK9oIppHnX/qoaR7Rn43fVzM
	 YBiTJ7iHXnZKsRtp7RrrzM+t3ah6YqzrmYCuZctjd6A9GxOe5mkOYTolTTXzU5MVcP
	 92uqZFHHTPaXtyJq1gWSnv7nF25SaosbWqMl00XY=
Subject: Patch "nfsd: don't ignore the return code of svc_proc_register()" has been added to the 6.1-stable tree
To: Dai.Ngo@oracle.com,chuck.lever@oracle.com,gregkh@linuxfoundation.org,jianqkang@sina.cn,jlayton@kernel.org,kolga@netapp.com,neilb@suse.de,patches@lists.linux.dev,syzbot+e34ad04f27991521104c@syzkaller.appspotmail.com,tom@talpey.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Feb 2026 13:33:42 +0100
In-Reply-To: <20260211030545.2704021-1-jianqkang@sina.cn>
Message-ID: <2026021741-scrabble-saline-a70e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    nfsd: don't ignore the return code of svc_proc_register()

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     nfsd-don-t-ignore-the-return-code-of-svc_proc_register.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-215737-greg=kroah.com@vger.kernel.org Wed Feb 11 04:06:17 2026
From: Jianqiang kang <jianqkang@sina.cn>
Date: Wed, 11 Feb 2026 11:05:45 +0800
Subject: nfsd: don't ignore the return code of svc_proc_register()
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, jlayton@kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, chuck.lever@oracle.com, neilb@suse.de, kolga@netapp.com, Dai.Ngo@oracle.com, tom@talpey.com, linux-nfs@vger.kernel.org
Message-ID: <20260211030545.2704021-1-jianqkang@sina.cn>

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 930b64ca0c511521f0abdd1d57ce52b2a6e3476b ]

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
[ Update the cleanup path to use nfsd_stat_counters_destroy. This ensures
 the teardown logic is correctly paired with nfsd_stat_counters_init, as
 required by the current NFSD implementation.]
Signed-off-by: Jianqiang kang <jianqkang@sina.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    9 ++++++++-
 fs/nfsd/stats.c  |    4 ++--
 fs/nfsd/stats.h  |    2 +-
 3 files changed, 11 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1460,17 +1460,24 @@ static __net_init int nfsd_init_net(stru
 	retval = nfsd_stat_counters_init(nn);
 	if (retval)
 		goto out_repcache_error;
+
 	memset(&nn->nfsd_svcstats, 0, sizeof(nn->nfsd_svcstats));
 	nn->nfsd_svcstats.program = &nfsd_program;
+	if (!nfsd_proc_stat_init(net)) {
+		retval = -ENOMEM;
+		goto out_proc_error;
+	}
+
 	nn->nfsd_versions = NULL;
 	nn->nfsd4_minorversions = NULL;
 	nfsd4_init_leases_net(nn);
 	get_random_bytes(&nn->siphash_key, sizeof(nn->siphash_key));
 	seqlock_init(&nn->writeverf_lock);
-	nfsd_proc_stat_init(net);
 
 	return 0;
 
+out_proc_error:
+	nfsd_stat_counters_destroy(nn);
 out_repcache_error:
 	nfsd_idmap_shutdown(net);
 out_idmap_error:
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -113,11 +113,11 @@ void nfsd_stat_counters_destroy(struct n
 	nfsd_percpu_counters_destroy(nn->counter, NFSD_STATS_COUNTERS_NUM);
 }
 
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
@@ -15,7 +15,7 @@ void nfsd_percpu_counters_reset(struct p
 void nfsd_percpu_counters_destroy(struct percpu_counter *counters, int num);
 int nfsd_stat_counters_init(struct nfsd_net *nn);
 void nfsd_stat_counters_destroy(struct nfsd_net *nn);
-void nfsd_proc_stat_init(struct net *net);
+struct proc_dir_entry *nfsd_proc_stat_init(struct net *net);
 void nfsd_proc_stat_shutdown(struct net *net);
 
 static inline void nfsd_stats_rc_hits_inc(struct nfsd_net *nn)


Patches currently in stable-queue which might be from jianqkang@sina.cn are

queue-6.1/xsk-fix-race-condition-in-af_xdp-generic-rx-path.patch
queue-6.1/nfsd-don-t-ignore-the-return-code-of-svc_proc_register.patch
