Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCEF78B60;
	Wed, 21 Feb 2024 14:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524998; cv=none; b=caEBQu7rIAoyddtvPnbNzbxT07MSC8h/RgLtAGbJThw+eQGk/+ZSSTGjngkxFCi8Hk4pUXj0hfQgwK3FdKnzSWkvRN/ovpGlWEymWP4lWxljmAjwQ2VS8jiFqUqeiKPxR1iYzaii6O1Z094VuZTAl8eYomG4QFXi7gL5yXT7iIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524998; c=relaxed/simple;
	bh=Ibbp1vXvSh/90E17kPjUAZ7KegSVp+rQqemNMuRmQjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3yHkC8rdUDCxq0+2fjrJEvbd3iGrh4lPn9sJcUolgIjpO06aDVCuOvyp7IrszT1d+AS44Cf5uFJH+ffSgWEk+PLNlLj6FBTflHe2jhCNInO8Cj+2IAiE1okBAN1Qviqd6c0Gd8wOwdc7nYoUb9fbNifrhUb66QdAHKPJAej2uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhczRHDC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhczRHDC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3E9C433C7;
	Wed, 21 Feb 2024 14:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524997;
	bh=Ibbp1vXvSh/90E17kPjUAZ7KegSVp+rQqemNMuRmQjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhczRHDCEsyP+CnM9QXr7X6o34z54TuXkvX9ScIDHUP6YHl5ODZSkmkdbNisys9q/
	 /leGm/WGI/aNvlju//igy80O4YPRbFo5V4yM44/o4ei6+m9HBJTHSd8x9vE3cZu5bn
	 x2ru/Ismdl1v1H9uoY6pKeYvQJbK+iMV7lebVNDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Weihao Li <liweihao@loongson.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 011/267] PM: hibernate: Enforce ordering during image compression/decompression
Date: Wed, 21 Feb 2024 14:05:52 +0100
Message-ID: <20240221125940.415150759@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongchen Zhang <zhanghongchen@loongson.cn>

commit 71cd7e80cfde548959952eac7063aeaea1f2e1c6 upstream.

An S4 (suspend to disk) test on the LoongArch 3A6000 platform sometimes
fails with the following error messaged in the dmesg log:

	Invalid LZO compressed length

That happens because when compressing/decompressing the image, the
synchronization between the control thread and the compress/decompress/crc
thread is based on a relaxed ordering interface, which is unreliable, and the
following situation may occur:

CPU 0					CPU 1
save_image_lzo				lzo_compress_threadfn
					  atomic_set(&d->stop, 1);
  atomic_read(&data[thr].stop)
  data[thr].cmp = data[thr].cmp_len;
	  				  WRITE data[thr].cmp_len

Then CPU0 gets a stale cmp_len and writes it to disk. During resume from S4,
wrong cmp_len is loaded.

To maintain data consistency between the two threads, use the acquire/release
variants of atomic set and read operations.

Fixes: 081a9d043c98 ("PM / Hibernate: Improve performance of LZO/plain hibernation, checksum image")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hongchen Zhang <zhanghongchen@loongson.cn>
Co-developed-by: Weihao Li <liweihao@loongson.cn>
Signed-off-by: Weihao Li <liweihao@loongson.cn>
[ rjw: Subject rewrite and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/swap.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -594,11 +594,11 @@ static int crc32_threadfn(void *data)
 	unsigned i;
 
 	while (1) {
-		wait_event(d->go, atomic_read(&d->ready) ||
+		wait_event(d->go, atomic_read_acquire(&d->ready) ||
 		                  kthread_should_stop());
 		if (kthread_should_stop()) {
 			d->thr = NULL;
-			atomic_set(&d->stop, 1);
+			atomic_set_release(&d->stop, 1);
 			wake_up(&d->done);
 			break;
 		}
@@ -607,7 +607,7 @@ static int crc32_threadfn(void *data)
 		for (i = 0; i < d->run_threads; i++)
 			*d->crc32 = crc32_le(*d->crc32,
 			                     d->unc[i], *d->unc_len[i]);
-		atomic_set(&d->stop, 1);
+		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
 	return 0;
@@ -637,12 +637,12 @@ static int lzo_compress_threadfn(void *d
 	struct cmp_data *d = data;
 
 	while (1) {
-		wait_event(d->go, atomic_read(&d->ready) ||
+		wait_event(d->go, atomic_read_acquire(&d->ready) ||
 		                  kthread_should_stop());
 		if (kthread_should_stop()) {
 			d->thr = NULL;
 			d->ret = -1;
-			atomic_set(&d->stop, 1);
+			atomic_set_release(&d->stop, 1);
 			wake_up(&d->done);
 			break;
 		}
@@ -651,7 +651,7 @@ static int lzo_compress_threadfn(void *d
 		d->ret = lzo1x_1_compress(d->unc, d->unc_len,
 		                          d->cmp + LZO_HEADER, &d->cmp_len,
 		                          d->wrk);
-		atomic_set(&d->stop, 1);
+		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
 	return 0;
@@ -789,7 +789,7 @@ static int save_image_lzo(struct swap_ma
 
 			data[thr].unc_len = off;
 
-			atomic_set(&data[thr].ready, 1);
+			atomic_set_release(&data[thr].ready, 1);
 			wake_up(&data[thr].go);
 		}
 
@@ -797,12 +797,12 @@ static int save_image_lzo(struct swap_ma
 			break;
 
 		crc->run_threads = thr;
-		atomic_set(&crc->ready, 1);
+		atomic_set_release(&crc->ready, 1);
 		wake_up(&crc->go);
 
 		for (run_threads = thr, thr = 0; thr < run_threads; thr++) {
 			wait_event(data[thr].done,
-			           atomic_read(&data[thr].stop));
+				atomic_read_acquire(&data[thr].stop));
 			atomic_set(&data[thr].stop, 0);
 
 			ret = data[thr].ret;
@@ -841,7 +841,7 @@ static int save_image_lzo(struct swap_ma
 			}
 		}
 
-		wait_event(crc->done, atomic_read(&crc->stop));
+		wait_event(crc->done, atomic_read_acquire(&crc->stop));
 		atomic_set(&crc->stop, 0);
 	}
 
@@ -1121,12 +1121,12 @@ static int lzo_decompress_threadfn(void
 	struct dec_data *d = data;
 
 	while (1) {
-		wait_event(d->go, atomic_read(&d->ready) ||
+		wait_event(d->go, atomic_read_acquire(&d->ready) ||
 		                  kthread_should_stop());
 		if (kthread_should_stop()) {
 			d->thr = NULL;
 			d->ret = -1;
-			atomic_set(&d->stop, 1);
+			atomic_set_release(&d->stop, 1);
 			wake_up(&d->done);
 			break;
 		}
@@ -1139,7 +1139,7 @@ static int lzo_decompress_threadfn(void
 			flush_icache_range((unsigned long)d->unc,
 					   (unsigned long)d->unc + d->unc_len);
 
-		atomic_set(&d->stop, 1);
+		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
 	return 0;
@@ -1327,7 +1327,7 @@ static int load_image_lzo(struct swap_ma
 		}
 
 		if (crc->run_threads) {
-			wait_event(crc->done, atomic_read(&crc->stop));
+			wait_event(crc->done, atomic_read_acquire(&crc->stop));
 			atomic_set(&crc->stop, 0);
 			crc->run_threads = 0;
 		}
@@ -1363,7 +1363,7 @@ static int load_image_lzo(struct swap_ma
 					pg = 0;
 			}
 
-			atomic_set(&data[thr].ready, 1);
+			atomic_set_release(&data[thr].ready, 1);
 			wake_up(&data[thr].go);
 		}
 
@@ -1382,7 +1382,7 @@ static int load_image_lzo(struct swap_ma
 
 		for (run_threads = thr, thr = 0; thr < run_threads; thr++) {
 			wait_event(data[thr].done,
-			           atomic_read(&data[thr].stop));
+				atomic_read_acquire(&data[thr].stop));
 			atomic_set(&data[thr].stop, 0);
 
 			ret = data[thr].ret;
@@ -1413,7 +1413,7 @@ static int load_image_lzo(struct swap_ma
 				ret = snapshot_write_next(snapshot);
 				if (ret <= 0) {
 					crc->run_threads = thr + 1;
-					atomic_set(&crc->ready, 1);
+					atomic_set_release(&crc->ready, 1);
 					wake_up(&crc->go);
 					goto out_finish;
 				}
@@ -1421,13 +1421,13 @@ static int load_image_lzo(struct swap_ma
 		}
 
 		crc->run_threads = thr;
-		atomic_set(&crc->ready, 1);
+		atomic_set_release(&crc->ready, 1);
 		wake_up(&crc->go);
 	}
 
 out_finish:
 	if (crc->run_threads) {
-		wait_event(crc->done, atomic_read(&crc->stop));
+		wait_event(crc->done, atomic_read_acquire(&crc->stop));
 		atomic_set(&crc->stop, 0);
 	}
 	stop = ktime_get();


