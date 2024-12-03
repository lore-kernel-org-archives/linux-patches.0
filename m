Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBD923CE;
	Tue,  3 Dec 2024 16:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241820; cv=none; b=pwbbUQ80vr59Sxc1VMY/hRLaxzVTepqBeUolUv40eH5eOaIEZpEOiEDhabzEvggINUh0HdxkU6fCnN9QD8dt3mN/wcaGf58GbZMV3L3GQ6tquPVeWCmSNjm/NHPj7EOr+GKpy8sLbVykesuqfozH0sukPESP4ByLLDfSs8i6wnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241820; c=relaxed/simple;
	bh=c3tvnrDPH8iosFbMaHeM1OG+v+b33w/6anl8u0EVODE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srU0n4AjMspOXYgKeXseGaPEKMyqQnYLrZRhJY40xUlB7mOorODY0CnlMYFKoQOxhVGrAKuRrcJi5cN3Z4taAFSS+lH7qpqy6XXH+FoZ41yqIgvf3ByiQIJxKp9He6ECrCjDE3dcTNUs/XL1RARxGOMtY2L/5XHgNi2ZS87Dc74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPDoppEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPDoppEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCE3C4CECF;
	Tue,  3 Dec 2024 16:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241820;
	bh=c3tvnrDPH8iosFbMaHeM1OG+v+b33w/6anl8u0EVODE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wPDoppErmOJq4/rRgoF2jvlTc1rTbTQ2cGxtKrbQSfRg8/hp9hnpMVAOtnDWXtywl
	 1XZX8lVrw/yrzsSz+BaQvc13gDaE0ZaL0KCytlSQ/dMolXq367TlBl7pyHwoPxK49d
	 VxZIDre0P99/Uh32XCBebGNEzVyHY09l6/Q1xX0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 527/826] nfsd: release svc_expkey/svc_export with rcu_work
Date: Tue,  3 Dec 2024 15:44:14 +0100
Message-ID: <20241203144804.315543721@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit f8c989a0c89a75d30f899a7cabdc14d72522bb8d ]

The last reference for `cache_head` can be reduced to zero in `c_show`
and `e_show`(using `rcu_read_lock` and `rcu_read_unlock`). Consequently,
`svc_export_put` and `expkey_put` will be invoked, leading to two
issues:

1. The `svc_export_put` will directly free ex_uuid. However,
   `e_show`/`c_show` will access `ex_uuid` after `cache_put`, which can
   trigger a use-after-free issue, shown below.

   ==================================================================
   BUG: KASAN: slab-use-after-free in svc_export_show+0x362/0x430 [nfsd]
   Read of size 1 at addr ff11000010fdc120 by task cat/870

   CPU: 1 UID: 0 PID: 870 Comm: cat Not tainted 6.12.0-rc3+ #1
   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
   1.16.1-2.fc37 04/01/2014
   Call Trace:
    <TASK>
    dump_stack_lvl+0x53/0x70
    print_address_description.constprop.0+0x2c/0x3a0
    print_report+0xb9/0x280
    kasan_report+0xae/0xe0
    svc_export_show+0x362/0x430 [nfsd]
    c_show+0x161/0x390 [sunrpc]
    seq_read_iter+0x589/0x770
    seq_read+0x1e5/0x270
    proc_reg_read+0xe1/0x140
    vfs_read+0x125/0x530
    ksys_read+0xc1/0x160
    do_syscall_64+0x5f/0x170
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

   Allocated by task 830:
    kasan_save_stack+0x20/0x40
    kasan_save_track+0x14/0x30
    __kasan_kmalloc+0x8f/0xa0
    __kmalloc_node_track_caller_noprof+0x1bc/0x400
    kmemdup_noprof+0x22/0x50
    svc_export_parse+0x8a9/0xb80 [nfsd]
    cache_do_downcall+0x71/0xa0 [sunrpc]
    cache_write_procfs+0x8e/0xd0 [sunrpc]
    proc_reg_write+0xe1/0x140
    vfs_write+0x1a5/0x6d0
    ksys_write+0xc1/0x160
    do_syscall_64+0x5f/0x170
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

   Freed by task 868:
    kasan_save_stack+0x20/0x40
    kasan_save_track+0x14/0x30
    kasan_save_free_info+0x3b/0x60
    __kasan_slab_free+0x37/0x50
    kfree+0xf3/0x3e0
    svc_export_put+0x87/0xb0 [nfsd]
    cache_purge+0x17f/0x1f0 [sunrpc]
    nfsd_destroy_serv+0x226/0x2d0 [nfsd]
    nfsd_svc+0x125/0x1e0 [nfsd]
    write_threads+0x16a/0x2a0 [nfsd]
    nfsctl_transaction_write+0x74/0xa0 [nfsd]
    vfs_write+0x1a5/0x6d0
    ksys_write+0xc1/0x160
    do_syscall_64+0x5f/0x170
    entry_SYSCALL_64_after_hwframe+0x76/0x7e

2. We cannot sleep while using `rcu_read_lock`/`rcu_read_unlock`.
   However, `svc_export_put`/`expkey_put` will call path_put, which
   subsequently triggers a sleeping operation due to the following
   `dput`.

   =============================
   WARNING: suspicious RCU usage
   5.10.0-dirty #141 Not tainted
   -----------------------------
   ...
   Call Trace:
   dump_stack+0x9a/0xd0
   ___might_sleep+0x231/0x240
   dput+0x39/0x600
   path_put+0x1b/0x30
   svc_export_put+0x17/0x80
   e_show+0x1c9/0x200
   seq_read_iter+0x63f/0x7c0
   seq_read+0x226/0x2d0
   vfs_read+0x113/0x2c0
   ksys_read+0xc9/0x170
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x67/0xd1

Fix these issues by using `rcu_work` to help release
`svc_expkey`/`svc_export`. This approach allows for an asynchronous
context to invoke `path_put` and also facilitates the freeing of
`uuid/exp/key` after an RCU grace period.

Fixes: 9ceddd9da134 ("knfsd: Allow lockless lookups of the exports")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/export.c | 31 +++++++++++++++++++++++++------
 fs/nfsd/export.h |  4 ++--
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index c82d8e3e0d4f2..984f8e6379dd4 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -40,15 +40,24 @@
 #define	EXPKEY_HASHMAX		(1 << EXPKEY_HASHBITS)
 #define	EXPKEY_HASHMASK		(EXPKEY_HASHMAX -1)
 
-static void expkey_put(struct kref *ref)
+static void expkey_put_work(struct work_struct *work)
 {
-	struct svc_expkey *key = container_of(ref, struct svc_expkey, h.ref);
+	struct svc_expkey *key =
+		container_of(to_rcu_work(work), struct svc_expkey, ek_rcu_work);
 
 	if (test_bit(CACHE_VALID, &key->h.flags) &&
 	    !test_bit(CACHE_NEGATIVE, &key->h.flags))
 		path_put(&key->ek_path);
 	auth_domain_put(key->ek_client);
-	kfree_rcu(key, ek_rcu);
+	kfree(key);
+}
+
+static void expkey_put(struct kref *ref)
+{
+	struct svc_expkey *key = container_of(ref, struct svc_expkey, h.ref);
+
+	INIT_RCU_WORK(&key->ek_rcu_work, expkey_put_work);
+	queue_rcu_work(system_wq, &key->ek_rcu_work);
 }
 
 static int expkey_upcall(struct cache_detail *cd, struct cache_head *h)
@@ -355,16 +364,26 @@ static void export_stats_destroy(struct export_stats *stats)
 					    EXP_STATS_COUNTERS_NUM);
 }
 
-static void svc_export_put(struct kref *ref)
+static void svc_export_put_work(struct work_struct *work)
 {
-	struct svc_export *exp = container_of(ref, struct svc_export, h.ref);
+	struct svc_export *exp =
+		container_of(to_rcu_work(work), struct svc_export, ex_rcu_work);
+
 	path_put(&exp->ex_path);
 	auth_domain_put(exp->ex_client);
 	nfsd4_fslocs_free(&exp->ex_fslocs);
 	export_stats_destroy(exp->ex_stats);
 	kfree(exp->ex_stats);
 	kfree(exp->ex_uuid);
-	kfree_rcu(exp, ex_rcu);
+	kfree(exp);
+}
+
+static void svc_export_put(struct kref *ref)
+{
+	struct svc_export *exp = container_of(ref, struct svc_export, h.ref);
+
+	INIT_RCU_WORK(&exp->ex_rcu_work, svc_export_put_work);
+	queue_rcu_work(system_wq, &exp->ex_rcu_work);
 }
 
 static int svc_export_upcall(struct cache_detail *cd, struct cache_head *h)
diff --git a/fs/nfsd/export.h b/fs/nfsd/export.h
index 3794ae253a701..081afb68681e1 100644
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -75,7 +75,7 @@ struct svc_export {
 	u32			ex_layout_types;
 	struct nfsd4_deviceid_map *ex_devid_map;
 	struct cache_detail	*cd;
-	struct rcu_head		ex_rcu;
+	struct rcu_work		ex_rcu_work;
 	unsigned long		ex_xprtsec_modes;
 	struct export_stats	*ex_stats;
 };
@@ -92,7 +92,7 @@ struct svc_expkey {
 	u32			ek_fsid[6];
 
 	struct path		ek_path;
-	struct rcu_head		ek_rcu;
+	struct rcu_work		ek_rcu_work;
 };
 
 #define EX_ISSYNC(exp)		(!((exp)->ex_flags & NFSEXP_ASYNC))
-- 
2.43.0



