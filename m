Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6C339BF
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTWVmma0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C0AC433C9;
	Mon,  9 Oct 2023 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858690;
	bh=DwuVS5GNmPtB1WLKGhg5jPWvK4o8Xp42ra0XBic3lGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTWVmma0th3nTvyRmJeR6R51plGwZyu5DrtLrx/G0Sn1wVegBl7cbLZJ2bh1bpb7F
	 flGcucmKTVko85iFkCgK8rXQ8tm5xX3WNYBK46BzF/rhV0oeIs5UBXh1Wv2OJTcI0k
	 P0rLSgvpCQf3TdSmdup0qGvlaOjJqb3zeZmDqOjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 070/226] media: venus: core: Add io base variables for each block
Date: Mon,  9 Oct 2023 15:00:31 +0200
Message-ID: <20231009130128.613948711@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit b4053a2097ec2f8ea622e817ae5a46a83b23aefe ]

New silicon means that the pre-determined offsets we have been using
in this driver no longer hold. Existing blocks of registers can exist at
different offsets relative to the IO base address.

This commit adds a routine to assign the IO base hooks a subsequent commit
will convert from absolute to relative addressing.

Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: d74e48160980 ("media: venus: hfi_venus: Write to VIDC_CTRL_INIT after unmasking interrupts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 12 ++++++++++++
 drivers/media/platform/qcom/venus/core.h | 10 ++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 62d11c6e41d60..5f7ac2807e5f4 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -21,6 +21,7 @@
 #include "core.h"
 #include "firmware.h"
 #include "pm_helpers.h"
+#include "hfi_venus_io.h"
 
 static void venus_event_notify(struct venus_core *core, u32 event)
 {
@@ -210,6 +211,15 @@ static int venus_enumerate_codecs(struct venus_core *core, u32 type)
 	return ret;
 }
 
+static void venus_assign_register_offsets(struct venus_core *core)
+{
+	core->vbif_base = core->base + VBIF_BASE;
+	core->cpu_base = core->base + CPU_BASE;
+	core->cpu_cs_base = core->base + CPU_CS_BASE;
+	core->cpu_ic_base = core->base + CPU_IC_BASE;
+	core->wrapper_base = core->base + WRAPPER_BASE;
+}
+
 static int venus_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -276,6 +286,8 @@ static int venus_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_core_put;
 
+	venus_assign_register_offsets(core);
+
 	ret = v4l2_device_register(dev, &core->v4l2_dev);
 	if (ret)
 		goto err_core_deinit;
diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
index aebd4c664bfa1..50eb0a9fb1347 100644
--- a/drivers/media/platform/qcom/venus/core.h
+++ b/drivers/media/platform/qcom/venus/core.h
@@ -119,6 +119,11 @@ struct venus_caps {
  * struct venus_core - holds core parameters valid for all instances
  *
  * @base:	IO memory base address
+ * @vbif_base	IO memory vbif base address
+ * @cpu_base	IO memory cpu base address
+ * @cpu_cs_base	IO memory cpu_cs base address
+ * @cpu_ic_base	IO memory cpu_ic base address
+ * @wrapper_base	IO memory wrapper base address
  * @irq:		Venus irq
  * @clks:	an array of struct clk pointers
  * @vcodec0_clks: an array of vcodec0 struct clk pointers
@@ -152,6 +157,11 @@ struct venus_caps {
  */
 struct venus_core {
 	void __iomem *base;
+	void __iomem *vbif_base;
+	void __iomem *cpu_base;
+	void __iomem *cpu_cs_base;
+	void __iomem *cpu_ic_base;
+	void __iomem *wrapper_base;
 	int irq;
 	struct clk *clks[VIDC_CLKS_NUM_MAX];
 	struct clk *vcodec0_clks[VIDC_VCODEC_CLKS_NUM_MAX];
-- 
2.40.1



