Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182CE1772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:02:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B99C433EF;
	Mon, 15 May 2023 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173773;
	bh=EeP1rovB/FHbrkyhQjZUIZuP6PqJrMDrJtCmI0TSPs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqdfDplRQR5Ni94n1BT39+vwPc7DIjl0Y360EQ44kfZ30p1YQKZwocpAbUNAiszxL
	 rj19WvhXmOCqT52gOyUSzdDJGVnfBCVFjAGfoAlyw7nq1GZirD8SsLRGxCBwyL7+Xz
	 hOvSsWLdVXjSmdcpXZuDTUqeNkJRkLRg+o3Tocqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 171/282] firmware: raspberrypi: Keep count of all consumers
Date: Mon, 15 May 2023 18:29:09 +0200
Message-Id: <20230515161727.334479962@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>

[ Upstream commit 1e7c57355a3bc617fc220234889e49fe722a6305 ]

When unbinding the firmware device we need to make sure it has no
consumers left. Otherwise we'd leave them with a firmware handle
pointing at freed memory.

Keep a reference count of all consumers and introduce rpi_firmware_put()
which will permit automatically decrease the reference count upon
unbinding consumer drivers.

Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Stable-dep-of: 5bca3688bdbc ("Input: raspberrypi-ts - fix refcount leak in rpi_ts_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/raspberrypi.c             | 40 ++++++++++++++++++++--
 include/soc/bcm2835/raspberrypi-firmware.h |  2 ++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index da26a584dca06..eb3b052a407ec 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/dma-mapping.h>
+#include <linux/kref.h>
 #include <linux/mailbox_client.h>
 #include <linux/module.h>
 #include <linux/of_platform.h>
@@ -27,6 +28,8 @@ struct rpi_firmware {
 	struct mbox_chan *chan; /* The property channel. */
 	struct completion c;
 	u32 enabled;
+
+	struct kref consumers;
 };
 
 static DEFINE_MUTEX(transaction_lock);
@@ -214,12 +217,31 @@ static void rpi_register_clk_driver(struct device *dev)
 						-1, NULL, 0);
 }
 
+static void rpi_firmware_delete(struct kref *kref)
+{
+	struct rpi_firmware *fw = container_of(kref, struct rpi_firmware,
+					       consumers);
+
+	mbox_free_channel(fw->chan);
+	kfree(fw);
+}
+
+void rpi_firmware_put(struct rpi_firmware *fw)
+{
+	kref_put(&fw->consumers, rpi_firmware_delete);
+}
+EXPORT_SYMBOL_GPL(rpi_firmware_put);
+
 static int rpi_firmware_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rpi_firmware *fw;
 
-	fw = devm_kzalloc(dev, sizeof(*fw), GFP_KERNEL);
+	/*
+	 * Memory will be freed by rpi_firmware_delete() once all users have
+	 * released their firmware handles. Don't use devm_kzalloc() here.
+	 */
+	fw = kzalloc(sizeof(*fw), GFP_KERNEL);
 	if (!fw)
 		return -ENOMEM;
 
@@ -236,6 +258,7 @@ static int rpi_firmware_probe(struct platform_device *pdev)
 	}
 
 	init_completion(&fw->c);
+	kref_init(&fw->consumers);
 
 	platform_set_drvdata(pdev, fw);
 
@@ -264,7 +287,8 @@ static int rpi_firmware_remove(struct platform_device *pdev)
 	rpi_hwmon = NULL;
 	platform_device_unregister(rpi_clk);
 	rpi_clk = NULL;
-	mbox_free_channel(fw->chan);
+
+	rpi_firmware_put(fw);
 
 	return 0;
 }
@@ -273,16 +297,26 @@ static int rpi_firmware_remove(struct platform_device *pdev)
  * rpi_firmware_get - Get pointer to rpi_firmware structure.
  * @firmware_node:    Pointer to the firmware Device Tree node.
  *
+ * The reference to rpi_firmware has to be released with rpi_firmware_put().
+ *
  * Returns NULL is the firmware device is not ready.
  */
 struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node)
 {
 	struct platform_device *pdev = of_find_device_by_node(firmware_node);
+	struct rpi_firmware *fw;
 
 	if (!pdev)
 		return NULL;
 
-	return platform_get_drvdata(pdev);
+	fw = platform_get_drvdata(pdev);
+	if (!fw)
+		return NULL;
+
+	if (!kref_get_unless_zero(&fw->consumers))
+		return NULL;
+
+	return fw;
 }
 EXPORT_SYMBOL_GPL(rpi_firmware_get);
 
diff --git a/include/soc/bcm2835/raspberrypi-firmware.h b/include/soc/bcm2835/raspberrypi-firmware.h
index 7800e12ee042c..f11e9d3f6fd30 100644
--- a/include/soc/bcm2835/raspberrypi-firmware.h
+++ b/include/soc/bcm2835/raspberrypi-firmware.h
@@ -140,6 +140,7 @@ int rpi_firmware_property(struct rpi_firmware *fw,
 			  u32 tag, void *data, size_t len);
 int rpi_firmware_property_list(struct rpi_firmware *fw,
 			       void *data, size_t tag_size);
+void rpi_firmware_put(struct rpi_firmware *fw);
 struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node);
 #else
 static inline int rpi_firmware_property(struct rpi_firmware *fw, u32 tag,
@@ -154,6 +155,7 @@ static inline int rpi_firmware_property_list(struct rpi_firmware *fw,
 	return -ENOSYS;
 }
 
+static inline void rpi_firmware_put(struct rpi_firmware *fw) { }
 static inline struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node)
 {
 	return NULL;
-- 
2.39.2



