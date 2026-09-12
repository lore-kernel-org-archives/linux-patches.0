Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A4D119D8BC;
	Sat, 12 Sep 2026 10:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208690; cv=none; b=W1QS24XlqriyAM0QVtOg7tzUst4CFIp/Q3OZHt6tCo8x62gg9j1QHQ49kMAYFfcrvyFm4DifxdBJwkAbLT/KcrFcIn3C5fqe9iIrP4je6Ci30fpun2G687wVD/9DOdNo2fx8RPdUW9GiWUWRuSPDOHGhTDxSp2zEV83ee7ZER9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208690; c=relaxed/simple;
	bh=ckJ6IdrnZIdaMLgDux+WX+W1LOBppWtR8+l1fZGQRDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8Xob7D/ntTZIihBZc9B1dchUTRE8p8JA+s4UvTyeGBT6Rytjy4PS95NRr8x8y2lS6qteVSDgOrezQYp0lw/yUasFw3n59HQNB81iI+Hk/NIuT8n290YkLE6WigNXqCeOm0IS3sTmCsKnvR0LrhLPjd9MdqV4mV5c08vs4JW5Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJqjRgW5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJqjRgW5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861A71F000FF;
	Sat, 12 Sep 2026 10:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208688;
	bh=znYX57zW6Xb5cfNuOl+91MF3UF0Gx0uU7tfiFyPg3sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GJqjRgW5MMSYYGuaVv/MVMMoohHSjdXKZh76/y0deno4iaGaqiZkQNTelfn9Osrej
	 UtSTBpMRbPmAky6aI82lIKmDmXM5mSyPOq+R5Bv3bWHWs38v16kv1OQHSF4LAPmtba
	 H8Bz4oSku6rZad8rDorxJfJ3x5Pvw/rcRmUGjWfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <brgl@kernel.org>,
	Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>,
	Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0668/1518] firmware: qcom_scm: Add API to get waitqueue IRQ info
Date: Sat, 12 Sep 2026 08:47:17 +0200
Message-ID: <20260912065638.546974356@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>

[ Upstream commit da9e6b1a96b1eef47542ec46b67e3f4f883fed3b ]

Bootloader and firmware for SM8650 and older chipsets expect node
name as "qcom_scm", in order to patch the wait queue IRQ information.
However, DeviceTree uses node name "scm" and this mismatch prevents
firmware from correctly identifying waitqueue IRQ information. Waitqueue
IRQ is used for signaling between secure and non-secure worlds.

To resolve this, introduce qcom_scm_get_waitq_irq() that'll get the
hardware IRQ number to be used from firmware instead of relying on data
provided by devicetree, thereby bypassing the DeviceTree node name
mismatch.

This hardware IRQ number is converted to a Linux IRQ number using newly
qcom_scm_fill_irq_fwspec_params(). This Linux IRQ number is then
supplied to the threaded_irq call.

Reviewed-by: Bartosz Golaszewski <brgl@kernel.org>
Signed-off-by: Unnathi Chalicheemala <unnathi.chalicheemala@oss.qualcomm.com>
Signed-off-by: Shivendra Pratap <shivendra.pratap@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251217-multi_waitq_scm-v11-1-f21e50e792b8@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 966d23c7e68e ("firmware: qcom: scm: Fix NULL dereference in IRQ handler before __scm is published")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 62 +++++++++++++++++++++++++++++++-
 drivers/firmware/qcom/qcom_scm.h |  1 +
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 2e51c4d80fdce..10edb6579f052 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -30,11 +30,18 @@
 #include <linux/sizes.h>
 #include <linux/types.h>
 
+#include <dt-bindings/interrupt-controller/arm-gic.h>
+
 #include "qcom_scm.h"
 #include "qcom_tzmem.h"
 
 static u32 download_mode;
 
+#define GIC_SPI_BASE        32
+#define GIC_MAX_SPI       1019  // SPIs in GICv3 spec range from 32..1019
+#define GIC_ESPI_BASE     4096
+#define GIC_MAX_ESPI      5119 // ESPIs in GICv3 spec range from 4096..5119
+
 struct qcom_scm {
 	struct device *dev;
 	struct clk *core_clk;
@@ -2257,6 +2264,56 @@ bool qcom_scm_is_available(void)
 }
 EXPORT_SYMBOL_GPL(qcom_scm_is_available);
 
+static int qcom_scm_fill_irq_fwspec_params(struct irq_fwspec *fwspec, u32 hwirq)
+{
+	if (hwirq >= GIC_SPI_BASE && hwirq <= GIC_MAX_SPI) {
+		fwspec->param[0] = GIC_SPI;
+		fwspec->param[1] = hwirq - GIC_SPI_BASE;
+	} else if (hwirq >= GIC_ESPI_BASE && hwirq <= GIC_MAX_ESPI) {
+		fwspec->param[0] = GIC_ESPI;
+		fwspec->param[1] = hwirq - GIC_ESPI_BASE;
+	} else {
+		WARN(1, "Unexpected hwirq: %d\n", hwirq);
+		return -ENXIO;
+	}
+
+	fwspec->param[2] = IRQ_TYPE_EDGE_RISING;
+	fwspec->param_count = 3;
+
+	return 0;
+}
+
+static int qcom_scm_get_waitq_irq(struct qcom_scm *scm)
+{
+	struct qcom_scm_desc desc = {
+		.svc = QCOM_SCM_SVC_WAITQ,
+		.cmd = QCOM_SCM_WAITQ_GET_INFO,
+		.owner = ARM_SMCCC_OWNER_SIP
+	};
+	struct device_node *parent_irq_node;
+	struct irq_fwspec fwspec;
+	struct qcom_scm_res res;
+	u32 hwirq;
+	int ret;
+
+	ret = qcom_scm_call_atomic(scm->dev, &desc, &res);
+	if (ret)
+		return ret;
+
+	hwirq = res.result[1] & GENMASK(15, 0);
+	ret = qcom_scm_fill_irq_fwspec_params(&fwspec, hwirq);
+	if (ret)
+		return ret;
+
+	parent_irq_node = of_irq_find_parent(scm->dev->of_node);
+	if (!parent_irq_node)
+		return -ENODEV;
+
+	fwspec.fwnode = of_fwnode_handle(parent_irq_node);
+
+	return irq_create_fwspec_mapping(&fwspec);
+}
+
 static int qcom_scm_assert_valid_wq_ctx(u32 wq_ctx)
 {
 	/* FW currently only supports a single wq_ctx (zero).
@@ -2430,7 +2487,10 @@ static int qcom_scm_probe(struct platform_device *pdev)
 		return dev_err_probe(scm->dev, PTR_ERR(scm->mempool),
 				     "Failed to create the SCM memory pool\n");
 
-	irq = platform_get_irq_optional(pdev, 0);
+	irq = qcom_scm_get_waitq_irq(scm);
+	if (irq < 0)
+		irq = platform_get_irq_optional(pdev, 0);
+
 	if (irq < 0) {
 		if (irq != -ENXIO)
 			return irq;
diff --git a/drivers/firmware/qcom/qcom_scm.h b/drivers/firmware/qcom/qcom_scm.h
index a56c8212cc0c4..8b1e2ea18a59a 100644
--- a/drivers/firmware/qcom/qcom_scm.h
+++ b/drivers/firmware/qcom/qcom_scm.h
@@ -152,6 +152,7 @@ int qcom_scm_shm_bridge_enable(struct device *scm_dev);
 #define QCOM_SCM_SVC_WAITQ			0x24
 #define QCOM_SCM_WAITQ_RESUME			0x02
 #define QCOM_SCM_WAITQ_GET_WQ_CTX		0x03
+#define QCOM_SCM_WAITQ_GET_INFO		0x04
 
 #define QCOM_SCM_SVC_GPU			0x28
 #define QCOM_SCM_SVC_GPU_INIT_REGS		0x01
-- 
2.53.0



