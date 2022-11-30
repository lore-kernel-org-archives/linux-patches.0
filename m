Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C58A79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B53C433C1;
	Wed, 30 Nov 2022 18:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834199;
	bh=0OIVG2sGA7qrz1GMQI4kqJI9m5Y/tJdOhVAIxwIbsgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dde9XsiHzyKBXReUNoReY2L/VqOH+JvUhSiRSnX/nT4T3cSF1f8QaUZBivDz3JnDf
	 IGkEeVwifpl+luSZ4FGU8Usoms7H4MVjt6VXoCX/SkZXeqKl7eBSS1rjhE/7iKykJq
	 v8dCPt6AbZ//0bNc8oHkF3GhSxwe4Pe7TwHQUXUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Ekstrand <jason.ekstrand@collabora.com>,
	Sarah Walker <Sarah.Walker@imgtec.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.0 165/289] dma-buf: Use dma_fence_unwrap_for_each when importing fences
Date: Wed, 30 Nov 2022 19:22:30 +0100
Message-Id: <20221130180547.873508828@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Ekstrand <jason@jlekstrand.net>

commit c19083c72ea72a1c12037bb3d708014632df80e4 upstream.

Ever since 68129f431faa ("dma-buf: warn about containers in dma_resv object"),
dma_resv_add_shared_fence will warn if you attempt to add a container fence.
While most drivers were fine, fences can also be added to a dma_resv via the
recently added DMA_BUF_IOCTL_IMPORT_SYNC_FILE.  Use dma_fence_unwrap_for_each
to add each fence one at a time.

Fixes: 594740497e99 ("dma-buf: Add an API for importing sync files (v10)")
Signed-off-by: Jason Ekstrand <jason.ekstrand@collabora.com>
Reported-by: Sarah Walker <Sarah.Walker@imgtec.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
CC: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20220802210158.4162525-1-jason.ekstrand@collabora.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-buf.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index dd0f83ee505b..e6f36c014c4c 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -15,6 +15,7 @@
 #include <linux/slab.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-fence.h>
+#include <linux/dma-fence-unwrap.h>
 #include <linux/anon_inodes.h>
 #include <linux/export.h>
 #include <linux/debugfs.h>
@@ -391,8 +392,10 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
 				     const void __user *user_data)
 {
 	struct dma_buf_import_sync_file arg;
-	struct dma_fence *fence;
+	struct dma_fence *fence, *f;
 	enum dma_resv_usage usage;
+	struct dma_fence_unwrap iter;
+	unsigned int num_fences;
 	int ret = 0;
 
 	if (copy_from_user(&arg, user_data, sizeof(arg)))
@@ -411,13 +414,21 @@ static long dma_buf_import_sync_file(struct dma_buf *dmabuf,
 	usage = (arg.flags & DMA_BUF_SYNC_WRITE) ? DMA_RESV_USAGE_WRITE :
 						   DMA_RESV_USAGE_READ;
 
-	dma_resv_lock(dmabuf->resv, NULL);
+	num_fences = 0;
+	dma_fence_unwrap_for_each(f, &iter, fence)
+		++num_fences;
 
-	ret = dma_resv_reserve_fences(dmabuf->resv, 1);
-	if (!ret)
-		dma_resv_add_fence(dmabuf->resv, fence, usage);
+	if (num_fences > 0) {
+		dma_resv_lock(dmabuf->resv, NULL);
 
-	dma_resv_unlock(dmabuf->resv);
+		ret = dma_resv_reserve_fences(dmabuf->resv, num_fences);
+		if (!ret) {
+			dma_fence_unwrap_for_each(f, &iter, fence)
+				dma_resv_add_fence(dmabuf->resv, f, usage);
+		}
+
+		dma_resv_unlock(dmabuf->resv);
+	}
 
 	dma_fence_put(fence);
 
-- 
2.38.1



