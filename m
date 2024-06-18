Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892691A0714;
	Tue, 18 Jun 2024 13:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716186; cv=none; b=UX07Bo/kfS06LhM6bpt8U7cHr5gUDVK9BhfabWhgNL11KxQgYw0z92ubuoEMMDpCRsCVDMgh8yz5wsaiyQvRmGTU9kRwgZ9AWwBYLDZADd1ey3fzEGDSt/Wx4y3ssDjEDaGQGJPWYbtpoAQVegaOdBVy3rruWdpWQjzkRQ/SH5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716186; c=relaxed/simple;
	bh=dZ2QlbjQMYcAZI0c016HRJEHgHP6BPbPpExYhqXfP2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L3aAV+NqmKBrOYSi9nIlX8rJTGQi3NPzy/701DnhERn2Y7OJj35Z+wiphZLEUyovyMwUsE+RAY5yB3ujQHufJq7DfHYdbN1YWtt28HCKT+BdlV1tFlLSUGv+ugM1ZrAiboTcV5us/UcKTdeMcafkHW/wY+7i0ivMd5J5ZEXACg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MrT12jSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MrT12jSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFBCC3277B;
	Tue, 18 Jun 2024 13:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716186;
	bh=dZ2QlbjQMYcAZI0c016HRJEHgHP6BPbPpExYhqXfP2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MrT12jSltT1chYQeM104MMr1+5a32Lqhzb2GBoJ2D9sftDqNpt+62oyWAk062MZy+
	 gy6KkS0KYNVSXOg4/1Mm5lC9c1ID7v92qoPcC23GzKCDIE/tc7LvzNBmxXWZNv/+EV
	 37047iJAftPK3JJD/eeQ7Sm68D89plR3pRmN5vlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 562/770] NFSD: Report the number of items evicted by the LRU walk
Date: Tue, 18 Jun 2024 14:36:55 +0200
Message-ID: <20240618123428.994094318@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 94660cc19c75083af046b0f8362e3d3bc2eba21d ]

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 13 ++++++++++---
 fs/nfsd/trace.h     | 29 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 1d94491e5ddad..e5bd9f06492c8 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -45,6 +45,7 @@ static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -445,6 +446,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 		goto out_skip;
 
 	list_lru_isolate_move(lru, &nf->nf_lru, head);
+	this_cpu_inc(nfsd_file_evictions);
 	return LRU_REMOVED;
 out_skip:
 	return LRU_SKIP;
@@ -475,9 +477,11 @@ static void
 nfsd_file_gc(void)
 {
 	LIST_HEAD(dispose);
+	unsigned long ret;
 
-	list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
-		      &dispose, LONG_MAX);
+	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
+			    &dispose, LONG_MAX);
+	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 }
 
@@ -502,6 +506,7 @@ nfsd_file_lru_scan(struct shrinker *s, struct shrink_control *sc)
 
 	ret = list_lru_shrink_walk(&nfsd_file_lru, sc,
 				   nfsd_file_lru_cb, &dispose);
+	trace_nfsd_file_shrinker_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 	return ret;
 }
@@ -1064,7 +1069,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long hits = 0, acquisitions = 0, releases = 0;
+	unsigned long hits = 0, acquisitions = 0, releases = 0, evictions = 0;
 	unsigned int i, count = 0, longest = 0;
 	unsigned long lru = 0, total_age = 0;
 
@@ -1088,6 +1093,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
 		releases += per_cpu(nfsd_file_releases, i);
 		total_age += per_cpu(nfsd_file_total_age, i);
+		evictions += per_cpu(nfsd_file_evictions, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1096,6 +1102,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	seq_printf(m, "releases:      %lu\n", releases);
+	seq_printf(m, "evictions:     %lu\n", evictions);
 	if (releases)
 		seq_printf(m, "mean age (ms): %ld\n", total_age / releases);
 	else
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 5c2292a1892cc..b373a161e862b 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -860,6 +860,35 @@ TRACE_EVENT(nfsd_file_fsnotify_handle_event,
 			__entry->nlink, __entry->mode, __entry->mask)
 );
 
+DECLARE_EVENT_CLASS(nfsd_file_lruwalk_class,
+	TP_PROTO(
+		unsigned long removed,
+		unsigned long remaining
+	),
+	TP_ARGS(removed, remaining),
+	TP_STRUCT__entry(
+		__field(unsigned long, removed)
+		__field(unsigned long, remaining)
+	),
+	TP_fast_assign(
+		__entry->removed = removed;
+		__entry->remaining = remaining;
+	),
+	TP_printk("%lu entries removed, %lu remaining",
+		__entry->removed, __entry->remaining)
+);
+
+#define DEFINE_NFSD_FILE_LRUWALK_EVENT(name)				\
+DEFINE_EVENT(nfsd_file_lruwalk_class, name,				\
+	TP_PROTO(							\
+		unsigned long removed,					\
+		unsigned long remaining					\
+	),								\
+	TP_ARGS(removed, remaining))
+
+DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_gc_removed);
+DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_shrinker_removed);
+
 #include "cache.h"
 
 TRACE_DEFINE_ENUM(RC_DROPIT);
-- 
2.43.0



