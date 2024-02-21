Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9976069D29;
	Wed, 21 Feb 2024 13:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523652; cv=none; b=reCxdFeAcdYVkDfHYx+AtGxpD/Bi14fu/EShF9J1J3NJWlb5ZenlcfdV2O2V9vXJUBmb1J/42rAUR6uEAxltoZjqMyTfLjCvAhAxP8KfISvakyshvyKQRWux0mVM8XIIzU5mVVPp/tQ4CSExFUa8oag/QD9mv2vP98p6QN95c80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523652; c=relaxed/simple;
	bh=Y/no8nYqPSZaBor0qr0yQ18/nusRjlElX5lgpYeAWvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmEPc9hrYIL6NO4G8eXk3wKH4dD/mPk11bSkvkYmnWQIxW5L/QLpNjUmYSSPBmDlm4mKhEgv1f8VSjHq/eqP4nTfeaY4N/lbANIeYiqQCKDR4Zv1aunw+TQKnFnxLXdjfPZlvnWO2ksgV8Mm21swZJYbaST7esXC5ZFoRZVUYd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBYAl79w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBYAl79w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08604C433F1;
	Wed, 21 Feb 2024 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523652;
	bh=Y/no8nYqPSZaBor0qr0yQ18/nusRjlElX5lgpYeAWvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBYAl79whoDdOjISeSLSgH/BhNUoEnW0vjxoWkOPcPnswZnBXWGLD3gCDQqyc5i0c
	 n4a2h7oA3E/uUUsSS4o+tSjQYnszXyJWt/TeWHyMMmKt2VApdUvrm+VuWTkkutVVhW
	 oSGq0YzN5gUdKapjHF3NDsIVT6m/PKF7c/g7BmZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongchen Zhang <zhanghongchen@loongson.cn>,
	Weihao Li <liweihao@loongson.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 019/379] PM: hibernate: Enforce ordering during image compression/decompression
Date: Wed, 21 Feb 2024 14:03:18 +0100
Message-ID: <20240221125955.488779244@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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
@@ -603,11 +603,11 @@ static int crc32_threadfn(void *data)
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
@@ -616,7 +616,7 @@ static int crc32_threadfn(void *data)
 		for (i = 0; i < d->run_threads; i++)
 			*d->crc32 = crc32_le(*d->crc32,
 			                     d->unc[i], *d->unc_len[i]);
-		atomic_set(&d->stop, 1);
+		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
 	return 0;
@@ -646,12 +646,12 @@ static int lzo_compress_threadfn(void *d
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
@@ -660,7 +660,7 @@ static int lzo_compress_threadfn(void *d
 		d->ret = lzo1x_1_compress(d->unc, d->unc_len,
 		                          d->cmp + LZO_HEADER, &d->cmp_len,
 		                          d->wrk);
-		atomic_set(&d->stop, 1);
+		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
 	return 0;
@@ -798,7 +798,7 @@ static int save_image_lzo(struct swap_ma
 
 			data[thr].unc_len = off;
 
-			atomic_set(&data[thr].ready, 1);
+			atomic_set_release(&data[thr].ready, 1);
 			wake_up(&data[thr].go);
 		}
 
@@ -806,12 +806,12 @@ static int save_image_lzo(struct swap_ma
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
@@ -850,7 +850,7 @@ static int save_image_lzo(struct swap_ma
 			}
 		}
 
-		wait_event(crc->done, atomic_read(&crc->stop));
+		wait_event(crc->done, atomic_read_acquire(&crc->stop));
 		atomic_set(&crc->stop, 0);
 	}
 
@@ -1132,12 +1132,12 @@ static int lzo_decompress_threadfn(void
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
@@ -1150,7 +1150,7 @@ static int lzo_decompress_threadfn(void
 			flush_icache_range((unsigned long)d->unc,
 					   (unsigned long)d->unc + d->unc_len);
 
-		atomic_set(&d->stop, 1);
+		atomic_set_release(&d->stop, 1);
 		wake_up(&d->done);
 	}
 	return 0;
@@ -1338,7 +1338,7 @@ static int load_image_lzo(struct swap_ma
 		}
 
 		if (crc->run_threads) {
-			wait_event(crc->done, atomic_read(&crc->stop));
+			wait_event(crc->done, atomic_read_acquire(&crc->stop));
 			atomic_set(&crc->stop, 0);
 			crc->run_threads = 0;
 		}
@@ -1374,7 +1374,7 @@ static int load_image_lzo(struct swap_ma
 					pg = 0;
 			}
 
-			atomic_set(&data[thr].ready, 1);
+			atomic_set_release(&data[thr].ready, 1);
 			wake_up(&data[thr].go);
 		}
 
@@ -1393,7 +1393,7 @@ static int load_image_lzo(struct swap_ma
 
 		for (run_threads = thr, thr = 0; thr < run_threads; thr++) {
 			wait_event(data[thr].done,
-			           atomic_read(&data[thr].stop));
+				atomic_read_acquire(&data[thr].stop));
 			atomic_set(&data[thr].stop, 0);
 
 			ret = data[thr].ret;
@@ -1424,7 +1424,7 @@ static int load_image_lzo(struct swap_ma
 				ret = snapshot_write_next(snapshot);
 				if (ret <= 0) {
 					crc->run_threads = thr + 1;
-					atomic_set(&crc->ready, 1);
+					atomic_set_release(&crc->ready, 1);
 					wake_up(&crc->go);
 					goto out_finish;
 				}
@@ -1432,13 +1432,13 @@ static int load_image_lzo(struct swap_ma
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


