Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152561772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:02:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843AFC433D2;
	Mon, 15 May 2023 18:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173776;
	bh=QKnPYoNfJHpYUOJ2pC81Ucz8grnRi8FPBRVHApVh53U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TysM9jDUzv2xwn23D+bjwszVzMgj1CWoWBLxaT3nQMjLO8INJzslAw33oT6eUsXLO
	 J202iIRXvN3QJIM9xlZM/1dyDNQoILLrDDKsN+oVE30rxoGEsQZS1gl9bnYoh0pHQ8
	 sbhCASn18iaJoLahUi3Cy9KLoPbieUNSJeUCYR3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bgolaszewski@baylibre.com>,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 172/282] firmware: raspberrypi: Introduce devm_rpi_firmware_get()
Date: Mon, 15 May 2023 18:29:10 +0200
Message-Id: <20230515161727.363115080@linuxfoundation.org>
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

[ Upstream commit f663204c9a1f8d6fcc590667d9d7a9f44e064644 ]

It'll simplify the firmware handling for most consumers.

Suggested-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Stable-dep-of: 5bca3688bdbc ("Input: raspberrypi-ts - fix refcount leak in rpi_ts_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/raspberrypi.c             | 29 ++++++++++++++++++++++
 include/soc/bcm2835/raspberrypi-firmware.h |  8 ++++++
 2 files changed, 37 insertions(+)

diff --git a/drivers/firmware/raspberrypi.c b/drivers/firmware/raspberrypi.c
index eb3b052a407ec..6a60b5bde0c98 100644
--- a/drivers/firmware/raspberrypi.c
+++ b/drivers/firmware/raspberrypi.c
@@ -232,6 +232,13 @@ void rpi_firmware_put(struct rpi_firmware *fw)
 }
 EXPORT_SYMBOL_GPL(rpi_firmware_put);
 
+static void devm_rpi_firmware_put(void *data)
+{
+	struct rpi_firmware *fw = data;
+
+	rpi_firmware_put(fw);
+}
+
 static int rpi_firmware_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -320,6 +327,28 @@ struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node)
 }
 EXPORT_SYMBOL_GPL(rpi_firmware_get);
 
+/**
+ * devm_rpi_firmware_get - Get pointer to rpi_firmware structure.
+ * @firmware_node:    Pointer to the firmware Device Tree node.
+ *
+ * Returns NULL is the firmware device is not ready.
+ */
+struct rpi_firmware *devm_rpi_firmware_get(struct device *dev,
+					   struct device_node *firmware_node)
+{
+	struct rpi_firmware *fw;
+
+	fw = rpi_firmware_get(firmware_node);
+	if (!fw)
+		return NULL;
+
+	if (devm_add_action_or_reset(dev, devm_rpi_firmware_put, fw))
+		return NULL;
+
+	return fw;
+}
+EXPORT_SYMBOL_GPL(devm_rpi_firmware_get);
+
 static const struct of_device_id rpi_firmware_of_match[] = {
 	{ .compatible = "raspberrypi,bcm2835-firmware", },
 	{},
diff --git a/include/soc/bcm2835/raspberrypi-firmware.h b/include/soc/bcm2835/raspberrypi-firmware.h
index f11e9d3f6fd30..cf6e58fa5266b 100644
--- a/include/soc/bcm2835/raspberrypi-firmware.h
+++ b/include/soc/bcm2835/raspberrypi-firmware.h
@@ -142,6 +142,8 @@ int rpi_firmware_property_list(struct rpi_firmware *fw,
 			       void *data, size_t tag_size);
 void rpi_firmware_put(struct rpi_firmware *fw);
 struct rpi_firmware *rpi_firmware_get(struct device_node *firmware_node);
+struct rpi_firmware *devm_rpi_firmware_get(struct device *dev,
+					   struct device_node *firmware_node);
 #else
 static inline int rpi_firmware_property(struct rpi_firmware *fw, u32 tag,
 					void *data, size_t len)
@@ -160,6 +162,12 @@ static inline struct rpi_firmware *rpi_firmware_get(struct device_node *firmware
 {
 	return NULL;
 }
+
+static inline struct rpi_firmware *devm_rpi_firmware_get(struct device *dev,
+					struct device_node *firmware_node)
+{
+	return NULL;
+}
 #endif
 
 #endif /* __SOC_RASPBERRY_FIRMWARE_H__ */
-- 
2.39.2



