Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591325;
	b=HaQU5AKx2i9kaZ/oydcS7BceVRUAVhCQeJCJsmPOgkeNgP0W46GkhRjObuEW2WEmcZSA
	 +DB9+J92bSTLHDGbwKd2zCuMN/NUThiVu6ctrz0omVfUO84OFzKR1kmElmP842emoBzIV
	 NZSsqG4VwTryNOuwoQ0WcHOKRIw/SGiDwaCW/T3bBHwk0ItU6caDp2cEdjuuIs+VF8dbt
	 A/W//0P0TvxjygYnyaZ0nvedCfXOli4VpArKImUppvQcUsKwBpXMcYna83v1iF12iOqdQ
	 EF4wNWpg6m8ASgRWeGvMHOLaOq7Qo+yjgYI/fw6cy/YuqbWq3/h6n++AozxemULv6bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EnycVw3nlFWhJIRyy7nfrcrqiuj1rsSP2PDHJ1DyIAY=;
	b=dhI5+s9nFY2YRzwxJ0oew5tUcSGSqTLIA7cBumJMaI0GljyzEHjZmyWb6mok1aIHPW0O
	 3mfoXFPLW32BDRjst92wJYWYeZL4gz97uG4RoaMs4TGEfz1mIKx9NM80syUOyMPYc3htD
	 +DGmQGWq4CssWRqA855EutjzEykbRX5Wlyjp7nF2o0rXs8IS0RS4lBdmfpflbPPZCTrtV
	 4j0n2i2wT/JUgrTw+YNMl/7N0jdRJFpM65bkBBp/zjUvEB9vMLOQ34qLC3IV6iff2u2sF
	 NlUPSYutoXvVXTp9nUVmB9d/oKDZ0PK0V5gCCC/x0EeeJIcXdoFnqfqyC9WltrPwhcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCoDu9Qd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A206B606B21D;
	Fri, 13 Nov 2026 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCoDu9Qd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D06F1F000C9;
	Fri, 13 Nov 2026 17:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591325;
	bh=EnycVw3nlFWhJIRyy7nfrcrqiuj1rsSP2PDHJ1DyIAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCoDu9QdM3P4ZRnvt0U6uoVxj/9xPseKuFMmPN3bfhquuEoHFmvvSjZnM3uzAm4f5
	 2yZgowTRspc3LgmYEH/+PlWZLl3RJjWMnD5jmHJZwfz6Ryz5j2UnrEuhLaYRx6e3fD
	 mvfYO2LpAZlavwijfX9t15Vi53OLiZYBBjUghLPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryo Takakura <ryotkkr98@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 438/670] crypto: omap - convert from tasklet to BH workqueue
Date: Fri, 13 Nov 2026 10:50:02 -0500
Message-ID: <20261113153826.743301347@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryo Takakura <ryotkkr98@gmail.com>

[ Upstream commit 381e8ee368234a51b3a4f231f6f24ff0b09d9f9e ]

tasklet has been marked deprecated and it's planned to be
removed. Make omap crypto drivers to use BH workqueue which
is the new interface for executing in BH context in place
of tasklet.

Signed-off-by: Ryo Takakura <ryotkkr98@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: 5d69ed4cd4f9 ("crypto: omap-des - fix crypto engine cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-aes.c  | 15 ++++++++-------
 drivers/crypto/omap-aes.h  |  2 +-
 drivers/crypto/omap-des.c  | 17 +++++++++--------
 drivers/crypto/omap-sham.c | 15 ++++++++-------
 4 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index bad1adacbc84c..df2fc4e1c31d9 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -33,6 +33,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
 
 #include "omap-crypto.h"
 #include "omap-aes.h"
@@ -222,7 +223,7 @@ static void omap_aes_dma_out_callback(void *data)
 	struct omap_aes_dev *dd = data;
 
 	/* dma_lch_out - completed */
-	tasklet_schedule(&dd->done_task);
+	queue_work(system_bh_wq, &dd->done_task);
 }
 
 static int omap_aes_dma_init(struct omap_aes_dev *dd)
@@ -496,9 +497,9 @@ static void omap_aes_copy_ivout(struct omap_aes_dev *dd, u8 *ivbuf)
 		((u32 *)ivbuf)[i] = omap_aes_read(dd, AES_REG_IV(dd, i));
 }
 
-static void omap_aes_done_task(unsigned long data)
+static void omap_aes_done_task(struct work_struct *t)
 {
-	struct omap_aes_dev *dd = (struct omap_aes_dev *)data;
+	struct omap_aes_dev *dd = from_work(dd, t, done_task);
 
 	pr_debug("enter done_task\n");
 
@@ -932,7 +933,7 @@ static irqreturn_t omap_aes_irq(int irq, void *dev_id)
 
 		if (!dd->total)
 			/* All bytes read! */
-			tasklet_schedule(&dd->done_task);
+			queue_work(system_bh_wq, &dd->done_task);
 		else
 			/* Enable DATA_IN interrupt for next block */
 			omap_aes_write(dd, AES_REG_IRQ_ENABLE(dd), 0x2);
@@ -1150,7 +1151,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->major_mask) >> dd->pdata->major_shift,
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
-	tasklet_init(&dd->done_task, omap_aes_done_task, (unsigned long)dd);
+	INIT_WORK(&dd->done_task, omap_aes_done_task);
 
 	err = omap_aes_dma_init(dd);
 	if (err == -EPROBE_DEFER) {
@@ -1245,7 +1246,7 @@ static int omap_aes_probe(struct platform_device *pdev)
 
 	omap_aes_dma_cleanup(dd);
 err_irq:
-	tasklet_kill(&dd->done_task);
+	cancel_work_sync(&dd->done_task);
 err_pm_disable:
 	pm_runtime_disable(dev);
 err_res:
@@ -1280,7 +1281,7 @@ static void omap_aes_remove(struct platform_device *pdev)
 
 	crypto_engine_exit(dd->engine);
 
-	tasklet_kill(&dd->done_task);
+	cancel_work_sync(&dd->done_task);
 	omap_aes_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
 
diff --git a/drivers/crypto/omap-aes.h b/drivers/crypto/omap-aes.h
index 0f35c91647648..d999d94e2314d 100644
--- a/drivers/crypto/omap-aes.h
+++ b/drivers/crypto/omap-aes.h
@@ -161,7 +161,7 @@ struct omap_aes_dev {
 	unsigned long		flags;
 	int			err;
 
-	struct tasklet_struct	done_task;
+	struct work_struct	done_task;
 	struct aead_queue	aead_queue;
 	spinlock_t		lock;
 
diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index d2c016eafd46b..096df577fe127 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -33,6 +33,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
 
 #include "omap-crypto.h"
 
@@ -133,7 +134,7 @@ struct omap_des_dev {
 	unsigned long		flags;
 	int			err;
 
-	struct tasklet_struct	done_task;
+	struct work_struct	done_task;
 
 	struct skcipher_request	*req;
 	struct crypto_engine		*engine;
@@ -328,7 +329,7 @@ static void omap_des_dma_out_callback(void *data)
 	struct omap_des_dev *dd = data;
 
 	/* dma_lch_out - completed */
-	tasklet_schedule(&dd->done_task);
+	queue_work(system_bh_wq, &dd->done_task);
 }
 
 static int omap_des_dma_init(struct omap_des_dev *dd)
@@ -584,9 +585,9 @@ static int omap_des_crypt_req(struct crypto_engine *engine,
 	       omap_des_crypt_dma_start(dd);
 }
 
-static void omap_des_done_task(unsigned long data)
+static void omap_des_done_task(struct work_struct *t)
 {
-	struct omap_des_dev *dd = (struct omap_des_dev *)data;
+	struct omap_des_dev *dd = from_work(dd, t, done_task);
 	int i;
 
 	pr_debug("enter done_task\n");
@@ -899,7 +900,7 @@ static irqreturn_t omap_des_irq(int irq, void *dev_id)
 
 		if (!dd->total)
 			/* All bytes read! */
-			tasklet_schedule(&dd->done_task);
+			queue_work(system_bh_wq, &dd->done_task);
 		else
 			/* Enable DATA_IN interrupt for next block */
 			omap_des_write(dd, DES_REG_IRQ_ENABLE(dd), 0x2);
@@ -1009,7 +1010,7 @@ static int omap_des_probe(struct platform_device *pdev)
 		 (reg & dd->pdata->major_mask) >> dd->pdata->major_shift,
 		 (reg & dd->pdata->minor_mask) >> dd->pdata->minor_shift);
 
-	tasklet_init(&dd->done_task, omap_des_done_task, (unsigned long)dd);
+	INIT_WORK(&dd->done_task, omap_des_done_task);
 
 	err = omap_des_dma_init(dd);
 	if (err == -EPROBE_DEFER) {
@@ -1072,7 +1073,7 @@ static int omap_des_probe(struct platform_device *pdev)
 
 	omap_des_dma_cleanup(dd);
 err_irq:
-	tasklet_kill(&dd->done_task);
+	cancel_work_sync(&dd->done_task);
 err_get:
 	pm_runtime_disable(dev);
 err_res:
@@ -1092,7 +1093,7 @@ static void omap_des_remove(struct platform_device *pdev)
 
 	omap_des_unregister_algs(dd->pdata);
 
-	tasklet_kill(&dd->done_task);
+	cancel_work_sync(&dd->done_task);
 	omap_des_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
 }
diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 5bcd9ab0f72ad..d17654c0410f6 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -37,6 +37,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/workqueue.h>
 
 #define MD5_DIGEST_SIZE			16
 
@@ -217,7 +218,7 @@ struct omap_sham_dev {
 	int			irq;
 	int			err;
 	struct dma_chan		*dma_lch;
-	struct tasklet_struct	done_task;
+	struct work_struct	done_task;
 	u8			polling_mode;
 	u8			xmit_buf[BUFLEN] OMAP_ALIGNED;
 
@@ -561,7 +562,7 @@ static void omap_sham_dma_callback(void *param)
 	struct omap_sham_dev *dd = param;
 
 	set_bit(FLAGS_DMA_READY, &dd->flags);
-	tasklet_schedule(&dd->done_task);
+	queue_work(system_bh_wq, &dd->done_task);
 }
 
 static int omap_sham_xmit_dma(struct omap_sham_dev *dd, size_t length,
@@ -1704,9 +1705,9 @@ static struct ahash_engine_alg algs_sha384_sha512[] = {
 },
 };
 
-static void omap_sham_done_task(unsigned long data)
+static void omap_sham_done_task(struct work_struct *t)
 {
-	struct omap_sham_dev *dd = (struct omap_sham_dev *)data;
+	struct omap_sham_dev *dd = from_work(dd, t, done_task);
 	int err = 0;
 
 	dev_dbg(dd->dev, "%s: flags=%lx\n", __func__, dd->flags);
@@ -1740,7 +1741,7 @@ static void omap_sham_done_task(unsigned long data)
 static irqreturn_t omap_sham_irq_common(struct omap_sham_dev *dd)
 {
 	set_bit(FLAGS_OUTPUT_READY, &dd->flags);
-	tasklet_schedule(&dd->done_task);
+	queue_work(system_bh_wq, &dd->done_task);
 
 	return IRQ_HANDLED;
 }
@@ -2063,7 +2064,7 @@ static int omap_sham_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, dd);
 
 	INIT_LIST_HEAD(&dd->list);
-	tasklet_init(&dd->done_task, omap_sham_done_task, (unsigned long)dd);
+	INIT_WORK(&dd->done_task, omap_sham_done_task);
 	crypto_init_queue(&dd->queue, OMAP_SHAM_QUEUE_LENGTH);
 
 	err = (dev->of_node) ? omap_sham_get_res_of(dd, dev, &res) :
@@ -2204,7 +2205,7 @@ static void omap_sham_remove(struct platform_device *pdev)
 					&dd->pdata->algs_info[i].algs_list[j]);
 			dd->pdata->algs_info[i].registered--;
 		}
-	tasklet_kill(&dd->done_task);
+	cancel_work_sync(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-- 
2.53.0



