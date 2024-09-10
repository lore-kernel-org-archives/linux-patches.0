Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C568E188A1E;
	Tue, 10 Sep 2024 10:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964951; cv=none; b=mLGh0WBSZkOzDFHT5rgnmG+vwnygvMWQ/fa+D46wVldsda/kQYDbi0dAXecURLGoqzy7n76kMNikyroMwxEPKBk7/9QPmh8P0KfdHnCHupF9DL88DE0LwWsYeb4Pliw2beU8V9xhWP9936qOtAjU+7eCBn0cW1vvhzA1a7gWG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964951; c=relaxed/simple;
	bh=7vZGFTGLDzg7MelrNcen2ANVGEXOSJ8S4cxAwfuKhrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRTrjHXPnYcAJAnaoXF22iVRcE0pdSJLBzEGOqLnuHUqPNStVKFdcUsoVxb1ihTNRvFYLbn9k5ji/EERoiH70fQAR5CwgwgvwyIxgw+jRkk8iZm7Guj5lRSV/NmCWS2jkHqVZeMbzV7qraofDMhFC6fyPHUyDacohEtTmcTP0Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/1R4CAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/1R4CAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239C1C4CEC3;
	Tue, 10 Sep 2024 10:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964951;
	bh=7vZGFTGLDzg7MelrNcen2ANVGEXOSJ8S4cxAwfuKhrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/1R4CAuModfLetyQXGfu9TPFqQRBXrFt8I+tGiawAkb3dMTncoLXc26Rm1coynZb
	 Chpdm9GHqIBPa5AIMZ4mrsfsdz2kcNRb2XhMrp+2un9MNSowWpuJqvuGsLSAKlBkCz
	 e9xxnI0ykG6UU1zTw3oNjlU/jEvWg0DITDFfmb1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.10 086/186] NFSD: Fix frame size warning in svc_export_parse()
Date: Tue, 10 Sep 2024 11:33:01 +0200
Message-ID: <20240910092558.052633917@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6939ace1f22681fface7841cdbf34d3204cc94b5 ]

fs/nfsd/export.c: In function 'svc_export_parse':
fs/nfsd/export.c:737:1: warning: the frame size of 1040 bytes is larger than 1024 bytes [-Wframe-larger-than=]
    737 | }

On my systems, svc_export_parse() has a stack frame of over 800
bytes, not 1040, but nonetheless, it could do with some reduction.

When a struct svc_export is on the stack, it's a temporary structure
used as an argument, and not visible as an actual exported FS. No
need to reserve space for export_stats in such cases.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310012359.YEw5IrK6-lkp@intel.com/
Cc: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Stable-dep-of: 4b14885411f7 ("nfsd: make all of the nfsd stats per-network namespace")
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c |   32 +++++++++++++++++++++++---------
 fs/nfsd/export.h |    4 ++--
 fs/nfsd/stats.h  |   12 ++++++------
 3 files changed, 31 insertions(+), 17 deletions(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -339,12 +339,16 @@ static int export_stats_init(struct expo
 
 static void export_stats_reset(struct export_stats *stats)
 {
-	nfsd_percpu_counters_reset(stats->counter, EXP_STATS_COUNTERS_NUM);
+	if (stats)
+		nfsd_percpu_counters_reset(stats->counter,
+					   EXP_STATS_COUNTERS_NUM);
 }
 
 static void export_stats_destroy(struct export_stats *stats)
 {
-	nfsd_percpu_counters_destroy(stats->counter, EXP_STATS_COUNTERS_NUM);
+	if (stats)
+		nfsd_percpu_counters_destroy(stats->counter,
+					     EXP_STATS_COUNTERS_NUM);
 }
 
 static void svc_export_put(struct kref *ref)
@@ -353,7 +357,8 @@ static void svc_export_put(struct kref *
 	path_put(&exp->ex_path);
 	auth_domain_put(exp->ex_client);
 	nfsd4_fslocs_free(&exp->ex_fslocs);
-	export_stats_destroy(&exp->ex_stats);
+	export_stats_destroy(exp->ex_stats);
+	kfree(exp->ex_stats);
 	kfree(exp->ex_uuid);
 	kfree_rcu(exp, ex_rcu);
 }
@@ -738,13 +743,15 @@ static int svc_export_show(struct seq_fi
 	seq_putc(m, '\t');
 	seq_escape(m, exp->ex_client->name, " \t\n\\");
 	if (export_stats) {
-		seq_printf(m, "\t%lld\n", exp->ex_stats.start_time);
+		struct percpu_counter *counter = exp->ex_stats->counter;
+
+		seq_printf(m, "\t%lld\n", exp->ex_stats->start_time);
 		seq_printf(m, "\tfh_stale: %lld\n",
-			   percpu_counter_sum_positive(&exp->ex_stats.counter[EXP_STATS_FH_STALE]));
+			   percpu_counter_sum_positive(&counter[EXP_STATS_FH_STALE]));
 		seq_printf(m, "\tio_read: %lld\n",
-			   percpu_counter_sum_positive(&exp->ex_stats.counter[EXP_STATS_IO_READ]));
+			   percpu_counter_sum_positive(&counter[EXP_STATS_IO_READ]));
 		seq_printf(m, "\tio_write: %lld\n",
-			   percpu_counter_sum_positive(&exp->ex_stats.counter[EXP_STATS_IO_WRITE]));
+			   percpu_counter_sum_positive(&counter[EXP_STATS_IO_WRITE]));
 		seq_putc(m, '\n');
 		return 0;
 	}
@@ -790,7 +797,7 @@ static void svc_export_init(struct cache
 	new->ex_layout_types = 0;
 	new->ex_uuid = NULL;
 	new->cd = item->cd;
-	export_stats_reset(&new->ex_stats);
+	export_stats_reset(new->ex_stats);
 }
 
 static void export_update(struct cache_head *cnew, struct cache_head *citem)
@@ -826,7 +833,14 @@ static struct cache_head *svc_export_all
 	if (!i)
 		return NULL;
 
-	if (export_stats_init(&i->ex_stats)) {
+	i->ex_stats = kmalloc(sizeof(*(i->ex_stats)), GFP_KERNEL);
+	if (!i->ex_stats) {
+		kfree(i);
+		return NULL;
+	}
+
+	if (export_stats_init(i->ex_stats)) {
+		kfree(i->ex_stats);
 		kfree(i);
 		return NULL;
 	}
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -64,10 +64,10 @@ struct svc_export {
 	struct cache_head	h;
 	struct auth_domain *	ex_client;
 	int			ex_flags;
+	int			ex_fsid;
 	struct path		ex_path;
 	kuid_t			ex_anon_uid;
 	kgid_t			ex_anon_gid;
-	int			ex_fsid;
 	unsigned char *		ex_uuid; /* 16 byte fsid */
 	struct nfsd4_fs_locations ex_fslocs;
 	uint32_t		ex_nflavors;
@@ -76,7 +76,7 @@ struct svc_export {
 	struct nfsd4_deviceid_map *ex_devid_map;
 	struct cache_detail	*cd;
 	struct rcu_head		ex_rcu;
-	struct export_stats	ex_stats;
+	struct export_stats	*ex_stats;
 };
 
 /* an "export key" (expkey) maps a filehandlefragement to an
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -60,22 +60,22 @@ static inline void nfsd_stats_rc_nocache
 static inline void nfsd_stats_fh_stale_inc(struct svc_export *exp)
 {
 	percpu_counter_inc(&nfsdstats.counter[NFSD_STATS_FH_STALE]);
-	if (exp)
-		percpu_counter_inc(&exp->ex_stats.counter[EXP_STATS_FH_STALE]);
+	if (exp && exp->ex_stats)
+		percpu_counter_inc(&exp->ex_stats->counter[EXP_STATS_FH_STALE]);
 }
 
 static inline void nfsd_stats_io_read_add(struct svc_export *exp, s64 amount)
 {
 	percpu_counter_add(&nfsdstats.counter[NFSD_STATS_IO_READ], amount);
-	if (exp)
-		percpu_counter_add(&exp->ex_stats.counter[EXP_STATS_IO_READ], amount);
+	if (exp && exp->ex_stats)
+		percpu_counter_add(&exp->ex_stats->counter[EXP_STATS_IO_READ], amount);
 }
 
 static inline void nfsd_stats_io_write_add(struct svc_export *exp, s64 amount)
 {
 	percpu_counter_add(&nfsdstats.counter[NFSD_STATS_IO_WRITE], amount);
-	if (exp)
-		percpu_counter_add(&exp->ex_stats.counter[EXP_STATS_IO_WRITE], amount);
+	if (exp && exp->ex_stats)
+		percpu_counter_add(&exp->ex_stats->counter[EXP_STATS_IO_WRITE], amount);
 }
 
 static inline void nfsd_stats_payload_misses_inc(struct nfsd_net *nn)


