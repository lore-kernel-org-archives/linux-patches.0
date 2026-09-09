Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3CB57268D;
	Wed,  9 Sep 2026 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962978; cv=none; b=gOBFsMeqM+vuEwMN6bV/X5tEV0sPpOG/cnRL3Z3h7yYo45Uu95xq8q1vdzRY/juKFMbQCyg/Md69EjckJz5CQ2bEQ8GHto7Fm/toYPfSiulnSV7Itww0Xhcv6+u1eDEiPvVtnJP4buP2SeohQT7FxG8JAOCMOb0Yy4B7TCys//o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962978; c=relaxed/simple;
	bh=adFzMhdUPeFaN/S9+iehWLmqtGHRAhIHexXAicu/IgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnf5IefHH+hCEXwdBPHO8KNGwqiUavO/BMm0KcsLhow3Yohre6riA3OFyDSrWrwUMiJWFjru0fPH7JiVwq5bcodb6t1yPkX/N5mCbibFN1RsdPjNSfvRlYsXTxFeNf4WHSc1g9t/w+40Q7wsBjo1h3C8ToNHa8jmw0maBf28zT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQs+G+Ia; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQs+G+Ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35FF1F00A3A;
	Wed,  9 Sep 2026 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962977;
	bh=on5GJW9CYEH9wIqxTW+TK4Gb4O1EtHDTvI3SApsiaU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iQs+G+IaPnBnQJW4pE+/r9V4yKCBgQ6d4yRn8XCq4qAyyCYgFl39nkYv8iwLw27Bd
	 /5WXT5HdrWPIOVX684taJrh2NQ0+G0zHjF+CM7pVtj2231o8la/P0syQTOKDY9g/kF
	 NADx6i4E8knjOWL/CqhUIpzKOBZvbFicexHMTMQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 455/556] f2fs: dont drop the top folio order in the f2fs_iostat tracepoint
Date: Wed,  9 Sep 2026 15:42:15 +0200
Message-ID: <20260909134246.577800159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit 575f6f8ef2abe8552af96e42c65d70964db53563 upstream.

The f2fs_iostat tracepoint stores the per-order read folio counts in a
fixed-size array and prints a fixed number of buckets, both hardcoded to
11. The sysfs iostat accounting array is instead sized by NR_PAGE_ORDERS
(= MAX_PAGE_ORDER + 1), which is not always 11:

	arm64 16K pages -> MAX_PAGE_ORDER 11 -> NR_PAGE_ORDERS 12
	arm64 64K pages -> MAX_PAGE_ORDER 13 -> NR_PAGE_ORDERS 14

f2fs enables large folios for immutable, non-compressed files, and the
read folio order is bounded by MAX_PAGECACHE_ORDER, i.e.
min(MAX_XAS_ORDER, PREFERRED_MAX_PAGECACHE_ORDER). With THP enabled this
reaches order 11 on 16K/64K base-page kernels (MAX_XAS_ORDER caps it at
11). So an order-11 read folio is possible there and is accounted into
index 11 of the array.

On those configurations the sysfs file reports the order-11 count
correctly, but the tracepoint silently drops it: the memcpy is capped at
min(NR_PAGE_ORDERS, 11), so index 11 is never copied and the trace
disagrees with sysfs. There is no memory-safety issue, only the order-11
bucket missing from the trace; 4K-page kernels (NR_PAGE_ORDERS == 11,
max order <= 9) are unaffected.

Size the array and the printed buckets by a ceiling that covers the
largest possible NR_PAGE_ORDERS (14) with headroom, and add a
BUILD_BUG_ON() so any future growth of NR_PAGE_ORDERS fails the build
loudly instead of silently truncating again. The human-readable
"order=count" output is preserved.

Fixes: cb8ff3ead9a3 ("f2fs: add page-order information for large folio reads in iostat")
Cc: stable@vger.kernel.org
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/iostat.c            |  6 ++++++
 include/trace/events/f2fs.h | 20 ++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/iostat.c b/fs/f2fs/iostat.c
index ae265e3e9b2c..12d4e18a6a50 100644
--- a/fs/f2fs/iostat.c
+++ b/fs/f2fs/iostat.c
@@ -332,6 +332,12 @@ void f2fs_destroy_iostat_processing(void)
 
 int f2fs_init_iostat(struct f2fs_sb_info *sbi)
 {
+	/*
+	 * The f2fs_iostat tracepoint emits a fixed number of read folio order
+	 * buckets; make sure every order fits so none is silently dropped.
+	 */
+	BUILD_BUG_ON(NR_PAGE_ORDERS > F2FS_IOSTAT_RD_FOLIO_ORDERS);
+
 	/* init iostat info */
 	spin_lock_init(&sbi->iostat_lock);
 	spin_lock_init(&sbi->iostat_lat_lock);
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 270c1a2c24c4..1dd9fc5afc46 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -2114,6 +2114,14 @@ DEFINE_EVENT(f2fs_zip_end, f2fs_decompress_pages_end,
 );
 
 #ifdef CONFIG_F2FS_IOSTAT
+/*
+ * Number of read folio order buckets emitted by the f2fs_iostat tracepoint.
+ * TP_printk() cannot loop, so the field count is fixed here and must be >=
+ * the largest possible NR_PAGE_ORDERS (14 on arm64 with 64K pages). The
+ * BUILD_BUG_ON() in f2fs_update_read_folio_count() enforces this.
+ */
+#define F2FS_IOSTAT_RD_FOLIO_ORDERS	16
+
 TRACE_EVENT(f2fs_iostat,
 
 	TP_PROTO(struct f2fs_sb_info *sbi, unsigned long long *iostat,
@@ -2151,7 +2159,7 @@ TRACE_EVENT(f2fs_iostat,
 		__field(unsigned long long,	fs_mrio)
 		__field(unsigned long long,	fs_discard)
 		__field(unsigned long long,	fs_reset_zone)
-		__array(unsigned long long,	read_folio_count, 11)
+		__array(unsigned long long,	read_folio_count, F2FS_IOSTAT_RD_FOLIO_ORDERS)
 	),
 
 	TP_fast_assign(
@@ -2186,7 +2194,8 @@ TRACE_EVENT(f2fs_iostat,
 		__entry->fs_reset_zone	= iostat[FS_ZONE_RESET_IO];
 		memset(__entry->read_folio_count, 0, sizeof(__entry->read_folio_count));
 		memcpy(__entry->read_folio_count, read_folio_count,
-				sizeof(unsigned long long) * min_t(int, NR_PAGE_ORDERS, 11));
+				sizeof(unsigned long long) *
+				min_t(int, NR_PAGE_ORDERS, F2FS_IOSTAT_RD_FOLIO_ORDERS));
 	),
 
 	TP_printk("dev = (%d,%d), "
@@ -2201,7 +2210,8 @@ TRACE_EVENT(f2fs_iostat,
 		"fs [data=%llu, (gc_data=%llu, cdata=%llu), "
 		"node=%llu, meta=%llu], "
 		"read_folio_count [0=%llu, 1=%llu, 2=%llu, 3=%llu, 4=%llu, "
-		"5=%llu, 6=%llu, 7=%llu, 8=%llu, 9=%llu, 10=%llu]",
+		"5=%llu, 6=%llu, 7=%llu, 8=%llu, 9=%llu, 10=%llu, 11=%llu, "
+		"12=%llu, 13=%llu, 14=%llu, 15=%llu]",
 		show_dev(__entry->dev), __entry->app_wio, __entry->app_dio,
 		__entry->app_bio, __entry->app_mio, __entry->app_bcdio,
 		__entry->app_mcdio, __entry->fs_dio, __entry->fs_cdio,
@@ -2218,7 +2228,9 @@ TRACE_EVENT(f2fs_iostat,
 		__entry->read_folio_count[4], __entry->read_folio_count[5],
 		__entry->read_folio_count[6], __entry->read_folio_count[7],
 		__entry->read_folio_count[8], __entry->read_folio_count[9],
-		__entry->read_folio_count[10])
+		__entry->read_folio_count[10], __entry->read_folio_count[11],
+		__entry->read_folio_count[12], __entry->read_folio_count[13],
+		__entry->read_folio_count[14], __entry->read_folio_count[15])
 );
 
 #ifndef __F2FS_IOSTAT_LATENCY_TYPE
-- 
2.55.0



