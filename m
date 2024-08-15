Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141B044376;
	Thu, 15 Aug 2024 14:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730876; cv=none; b=PGN6Nvxj1BoGXGvFiBMW2Y+GKrX0pA4Q70LcEXuqAbR5Y0IZGawAa197oXOrdBuwDOxMJvOGF39pqlK46iLYNTGzCLevLg5zHKiO3rWmEqqALqRyjQQojm1Ez4f4gPzlFwrhpU1ZXBGlIl1KSABA2bpYFRbxW79LSU0luRaVd6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730876; c=relaxed/simple;
	bh=6lpGLSoZGlgKZBpimTz03TSBAOfu81ZZ7Wzzvisj4LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TmqNHvzm5uVB4bMKCVDZQGCos+jWJiSUgEPX/Ic7YFj/KZsyNVQU86aEWZzY+F4GW6jGd3fHWuS9H8Z8S3g3P6/2byQk3BGUKigBdGKmmatXKEciAqy1/ph4E1JS8E9oMVsmE+hX1/1TiA3gDVsy84iY2+sOOf3A1dONM8PTU4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mADAuw7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mADAuw7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EBAC32786;
	Thu, 15 Aug 2024 14:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730875;
	bh=6lpGLSoZGlgKZBpimTz03TSBAOfu81ZZ7Wzzvisj4LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mADAuw7IcWUj1DZmKLQYptkj4gpQj7V7RIVNH/UX+2uLVPp+KMHKxhlcC974Bj/GF
	 bXFskwIa/cEx4NSMrqXfUaYCpChiz9ap/mgBxvrEmUYYaXSCK+F/sHuVrWJkqkforF
	 zm0aRuX7h12W+MFAdGrQywGD8QtjRdYNJ9OU476c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 06/67] NFSD: Fix frame size warning in svc_export_parse()
Date: Thu, 15 Aug 2024 15:25:20 +0200
Message-ID: <20240815131838.563402108@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -767,13 +772,15 @@ static int svc_export_show(struct seq_fi
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
@@ -819,7 +826,7 @@ static void svc_export_init(struct cache
 	new->ex_layout_types = 0;
 	new->ex_uuid = NULL;
 	new->cd = item->cd;
-	export_stats_reset(&new->ex_stats);
+	export_stats_reset(new->ex_stats);
 }
 
 static void export_update(struct cache_head *cnew, struct cache_head *citem)
@@ -856,7 +863,14 @@ static struct cache_head *svc_export_all
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
@@ -76,8 +76,8 @@ struct svc_export {
 	struct nfsd4_deviceid_map *ex_devid_map;
 	struct cache_detail	*cd;
 	struct rcu_head		ex_rcu;
-	struct export_stats	ex_stats;
 	unsigned long		ex_xprtsec_modes;
+	struct export_stats	*ex_stats;
 };
 
 /* an "export key" (expkey) maps a filehandlefragement to an
--- a/fs/nfsd/stats.h
+++ b/fs/nfsd/stats.h
@@ -61,22 +61,22 @@ static inline void nfsd_stats_rc_nocache
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


