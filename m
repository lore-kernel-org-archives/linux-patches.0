Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623436;
	b=rSMBPncdAYxp4szOqHYRWnc7NJPSel+c3ZxjnVUFnBQYQwwq1IolRetLU1T4ICLryUkZ
	 WcgYSaW9pImWgP2Kp3l2IHuY2f6fcgEKwluHaQD81m8ocJjADWHmF8UqaQTORWK8saMKu
	 Y1lJkgkzOxd9rdiW9P1ouei4srAiQxjXAGIwuWE/yvraCr9F7JFonl3splfICyfHkWH8/
	 gZD416L7w4h7SFFk7Zx085tHDxgZokFw//1M8lqKh65neM05SMh8cwqpS8ceqL9k5bxTW
	 znc/vt/bFgdxFDG2t5l9xi0HFRE9RZ3l73dXisWwbHiFV8vnb/Axa/IIGasqT2zvCSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8M9OEL3SX4j1XX/faNoawIjoQGENEWBViCWIgFS2Jt4=;
	b=eI3eMHgbqfT18QAuy5aACabqHEQcHJ77HiueuJVnrVaaXDAylarTHoy61wPn6lybtQ5K
	 fESSn5VwtBXRFfideNpSJXNbmP+4JXSa0LvkwI8vUaxhkKOidgh1P7BUKy57fDfx9CY03
	 XWwEXki3hTU2TQ4jo16TiG/sRO+sDdsB9/1D9gsFz0sURgKhqDWQQjfaQvlkF4wlZWmnC
	 OZLxOAlpI7mFdSmh5JLg4l+dlFD/TrH1QXSnmd9iIpPIAMDrnoEaukHxyA/kzBG6d5ECM
	 61GrFmT6Op78i2xMsgEQtYRCARYbzuo4GVdO/JDGCHaUpxJJ6VBodvK7/n6SfM+Ir5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qh440RuH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B935606A323;
	Wed, 25 Nov 2026 16:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qh440RuH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A7A1F000CA;
	Wed, 25 Nov 2026 16:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623435;
	bh=8M9OEL3SX4j1XX/faNoawIjoQGENEWBViCWIgFS2Jt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qh440RuHSrv4NdJURKLHoCG6+zgwyneBwb4vBkQVA611yh4MPbXlgDN818TSN9xyS
	 qmiET5z+4QBfIR8MfHGwTlXJTl2SvK+pjx6H39TGyrWjv/3txrzrunqmkhNENehVij
	 XpYIRdl43pddJ40nGlaOkc0LDO5kZT+SNirWlMEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 6.18 859/990] dm-pcache: do not advance dirty_tail after backing flush failure
Date: Wed, 25 Nov 2026 15:37:06 +0100
Message-ID: <20261125143842.148222750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: guolingxing <guolingxing@tju.edu.cn>

commit b1310cb291935c788f34ed6eb1e7e9b42cfac045 upstream.

After all writeback bios for a kset complete, writeback_ctx_end()
flushes the backing device and then advances the persistent dirty_tail.
However, backing_dev_flush() discards the error returned by
blkdev_issue_flush(), so dirty_tail is advanced even when the written
data is not known to be durable.

dirty_tail points to the first kset that still requires writeback.
Advancing it causes recovery to treat the preceding kset as clean and
allows its cache copy to eventually be reclaimed by garbage collection.
If the backing device flush failed, a subsequent power failure may
therefore result in data loss.

Make backing_dev_flush() return the flush status and handle a flush
failure like a writeback I/O failure. Leave dirty_tail unchanged so
that the same kset will be retried.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/backing_dev.c     |  4 ++--
 drivers/md/dm-pcache/backing_dev.h     |  2 +-
 drivers/md/dm-pcache/cache_writeback.c | 28 +++++++++++++++++++-------
 3 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-pcache/backing_dev.c b/drivers/md/dm-pcache/backing_dev.c
index 23002beb192a..84b4e76367fa 100644
--- a/drivers/md/dm-pcache/backing_dev.c
+++ b/drivers/md/dm-pcache/backing_dev.c
@@ -336,9 +336,9 @@ struct pcache_backing_dev_req *backing_dev_req_create(struct pcache_backing_dev
 	return backing_req;
 }
 
-void backing_dev_flush(struct pcache_backing_dev *backing_dev)
+int backing_dev_flush(struct pcache_backing_dev *backing_dev)
 {
-	blkdev_issue_flush(backing_dev->dm_dev->bdev);
+	return blkdev_issue_flush(backing_dev->dm_dev->bdev);
 }
 
 int pcache_backing_init(void)
diff --git a/drivers/md/dm-pcache/backing_dev.h b/drivers/md/dm-pcache/backing_dev.h
index b371cba483b9..8422e5e76e29 100644
--- a/drivers/md/dm-pcache/backing_dev.h
+++ b/drivers/md/dm-pcache/backing_dev.h
@@ -120,7 +120,7 @@ struct pcache_backing_dev_req *backing_dev_req_alloc(struct pcache_backing_dev *
 						struct pcache_backing_dev_req_opts *opts);
 void backing_dev_req_init(struct pcache_backing_dev_req *backing_req,
 			struct pcache_backing_dev_req_opts *opts);
-void backing_dev_flush(struct pcache_backing_dev *backing_dev);
+int backing_dev_flush(struct pcache_backing_dev *backing_dev);
 
 int pcache_backing_init(void);
 void pcache_backing_exit(void);
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index c8a4c8110a58..e09560f172dd 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -18,12 +18,18 @@ static void writeback_ctx_end(struct pcache_cache *cache, int ret)
 		return;
 
 	if (!cache->writeback_ctx.ret) {
-		backing_dev_flush(cache->backing_dev);
-
-		mutex_lock(&cache->dirty_tail_lock);
-		cache_pos_advance(&cache->dirty_tail, cache->writeback_ctx.advance);
-		cache_encode_dirty_tail(cache);
-		mutex_unlock(&cache->dirty_tail_lock);
+		ret = backing_dev_flush(cache->backing_dev);
+		if (ret) {
+			pcache_dev_err(CACHE_TO_PCACHE(cache),
+				       "failed to flush backing device: %d", ret);
+			cache->writeback_ctx.ret = ret;
+		} else {
+			mutex_lock(&cache->dirty_tail_lock);
+			cache_pos_advance(&cache->dirty_tail,
+					  cache->writeback_ctx.advance);
+			cache_encode_dirty_tail(cache);
+			mutex_unlock(&cache->dirty_tail_lock);
+		}
 	}
 	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
 }
@@ -76,8 +82,16 @@ static inline bool is_cache_clean(struct pcache_cache *cache, struct pcache_cach
 
 void cache_writeback_exit(struct pcache_cache *cache)
 {
+	int ret;
+
 	cancel_delayed_work_sync(&cache->writeback_work);
-	backing_dev_flush(cache->backing_dev);
+
+	ret = backing_dev_flush(cache->backing_dev);
+	if (ret)
+		pcache_dev_err(CACHE_TO_PCACHE(cache),
+			       "failed to flush backing device during exit: %d",
+			       ret);
+
 	cache_tree_exit(&cache->writeback_key_tree);
 }
 
-- 
2.56.1



