Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE581EA8F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99583C433C8;
	Tue,  1 Aug 2023 09:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883444;
	bh=sJsafFDedZLtkkRHhZ4Zb3t48A2S29HP/j+E2LTYALM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQrQB6FODlhbaY5DJjvipcY17rn2WgHtLjhEzoaWqqpFy2H2XP1BWVTKbOSq6pdN3
	 +IIcy3SHb3bKlO9loOeGK4c1cT2k5wiBJ/0AYXZXlIewIERIGmSfrrd9JbKmgGhaNv
	 BjRovD5VnvNAtUse6p4/JN36yS9e+R+G4CSdGfJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Jindong Yue <jindong.yue@nxp.com>
Subject: [PATCH 6.4 238/239] dma-buf: keep the signaling time of merged fences v3
Date: Tue,  1 Aug 2023 11:21:42 +0200
Message-ID: <20230801091934.639356142@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

commit f781f661e8c99b0cb34129f2e374234d61864e77 upstream.

Some Android CTS is testing if the signaling time keeps consistent
during merges.

v2: use the current time if the fence is still in the signaling path and
the timestamp not yet available.
v3: improve comment, fix one more case to use the correct timestamp

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230630120041.109216-1-christian.koenig@amd.com
Cc: Jindong Yue <jindong.yue@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-fence-unwrap.c |   26 ++++++++++++++++++++++----
 drivers/dma-buf/dma-fence.c        |    5 +++--
 drivers/gpu/drm/drm_syncobj.c      |    2 +-
 include/linux/dma-fence.h          |    2 +-
 4 files changed, 27 insertions(+), 8 deletions(-)

--- a/drivers/dma-buf/dma-fence-unwrap.c
+++ b/drivers/dma-buf/dma-fence-unwrap.c
@@ -66,18 +66,36 @@ struct dma_fence *__dma_fence_unwrap_mer
 {
 	struct dma_fence_array *result;
 	struct dma_fence *tmp, **array;
+	ktime_t timestamp;
 	unsigned int i;
 	size_t count;
 
 	count = 0;
+	timestamp = ns_to_ktime(0);
 	for (i = 0; i < num_fences; ++i) {
-		dma_fence_unwrap_for_each(tmp, &iter[i], fences[i])
-			if (!dma_fence_is_signaled(tmp))
+		dma_fence_unwrap_for_each(tmp, &iter[i], fences[i]) {
+			if (!dma_fence_is_signaled(tmp)) {
 				++count;
+			} else if (test_bit(DMA_FENCE_FLAG_TIMESTAMP_BIT,
+					    &tmp->flags)) {
+				if (ktime_after(tmp->timestamp, timestamp))
+					timestamp = tmp->timestamp;
+			} else {
+				/*
+				 * Use the current time if the fence is
+				 * currently signaling.
+				 */
+				timestamp = ktime_get();
+			}
+		}
 	}
 
+	/*
+	 * If we couldn't find a pending fence just return a private signaled
+	 * fence with the timestamp of the last signaled one.
+	 */
 	if (count == 0)
-		return dma_fence_get_stub();
+		return dma_fence_allocate_private_stub(timestamp);
 
 	array = kmalloc_array(count, sizeof(*array), GFP_KERNEL);
 	if (!array)
@@ -138,7 +156,7 @@ restart:
 	} while (tmp);
 
 	if (count == 0) {
-		tmp = dma_fence_get_stub();
+		tmp = dma_fence_allocate_private_stub(ktime_get());
 		goto return_tmp;
 	}
 
--- a/drivers/dma-buf/dma-fence.c
+++ b/drivers/dma-buf/dma-fence.c
@@ -150,10 +150,11 @@ EXPORT_SYMBOL(dma_fence_get_stub);
 
 /**
  * dma_fence_allocate_private_stub - return a private, signaled fence
+ * @timestamp: timestamp when the fence was signaled
  *
  * Return a newly allocated and signaled stub fence.
  */
-struct dma_fence *dma_fence_allocate_private_stub(void)
+struct dma_fence *dma_fence_allocate_private_stub(ktime_t timestamp)
 {
 	struct dma_fence *fence;
 
@@ -169,7 +170,7 @@ struct dma_fence *dma_fence_allocate_pri
 	set_bit(DMA_FENCE_FLAG_ENABLE_SIGNAL_BIT,
 		&fence->flags);
 
-	dma_fence_signal(fence);
+	dma_fence_signal_timestamp(fence, timestamp);
 
 	return fence;
 }
--- a/drivers/gpu/drm/drm_syncobj.c
+++ b/drivers/gpu/drm/drm_syncobj.c
@@ -353,7 +353,7 @@ EXPORT_SYMBOL(drm_syncobj_replace_fence)
  */
 static int drm_syncobj_assign_null_handle(struct drm_syncobj *syncobj)
 {
-	struct dma_fence *fence = dma_fence_allocate_private_stub();
+	struct dma_fence *fence = dma_fence_allocate_private_stub(ktime_get());
 
 	if (IS_ERR(fence))
 		return PTR_ERR(fence);
--- a/include/linux/dma-fence.h
+++ b/include/linux/dma-fence.h
@@ -606,7 +606,7 @@ static inline signed long dma_fence_wait
 void dma_fence_set_deadline(struct dma_fence *fence, ktime_t deadline);
 
 struct dma_fence *dma_fence_get_stub(void);
-struct dma_fence *dma_fence_allocate_private_stub(void);
+struct dma_fence *dma_fence_allocate_private_stub(ktime_t timestamp);
 u64 dma_fence_context_alloc(unsigned num);
 
 extern const struct dma_fence_ops dma_fence_array_ops;


