Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB4339B5
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFY0aEV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E874EC433CB;
	Mon,  9 Oct 2023 13:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858703;
	bh=kA6TNG83qMNL4dWYkzUcmJujlbOZOx+VAkoDK4kRzZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFY0aEV3yXQj5E9jjEXA/3KGVuzXp6Pz2HdmbjFIVYR7CSNQybazlcQz2wkpVt+2L
	 b2QLDcEP5nggmakilgyqGVscatS8Nxw0LEnazaDuGpsdSS0uTgsKdnA89I31lZgdII
	 W5YvBswuLItxypQ2KttXggHSh34dzlLVwLMW6t+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dikshita Agarwal <dikshita@codeaurora.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/226] media: venus: hfi: Add a 6xx boot logic
Date: Mon,  9 Oct 2023 15:00:35 +0200
Message-ID: <20231009130128.718445837@linuxfoundation.org>
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

From: Dikshita Agarwal <dikshita@codeaurora.org>

[ Upstream commit 255385ca433ce5ff621732f26a759211a27c8f85 ]

This patch adds a 6xx specific boot logic. The goal is to share as much
code as possible between 3xx, 4xx and 6xx silicon.

We need to do a different write to WRAPPER_INTR_MASK with an additional
write to CPU_CS_H2XSOFTINTEN_V6 and CPU_CS_X2RPMh_V6.

The other writes are the same for 6xx and non-6xx silicon albeit at
different absolute relative locations to the base of the venus address
space.

Signed-off-by: Dikshita Agarwal <dikshita@codeaurora.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: d74e48160980 ("media: venus: hfi_venus: Write to VIDC_CTRL_INIT after unmasking interrupts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_venus.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
index 3d705fc5e1093..97d36cafd8cb2 100644
--- a/drivers/media/platform/qcom/venus/hfi_venus.c
+++ b/drivers/media/platform/qcom/venus/hfi_venus.c
@@ -431,14 +431,21 @@ static int venus_boot_core(struct venus_hfi_device *hdev)
 {
 	struct device *dev = hdev->core->dev;
 	static const unsigned int max_tries = 100;
-	u32 ctrl_status = 0;
+	u32 ctrl_status = 0, mask_val;
 	unsigned int count = 0;
 	void __iomem *cpu_cs_base = hdev->core->cpu_cs_base;
 	void __iomem *wrapper_base = hdev->core->wrapper_base;
 	int ret = 0;
 
 	writel(BIT(VIDC_CTRL_INIT_CTRL_SHIFT), cpu_cs_base + VIDC_CTRL_INIT);
-	writel(WRAPPER_INTR_MASK_A2HVCODEC_MASK, wrapper_base + WRAPPER_INTR_MASK);
+	if (IS_V6(hdev->core)) {
+		mask_val = readl(wrapper_base + WRAPPER_INTR_MASK);
+		mask_val &= ~(WRAPPER_INTR_MASK_A2HWD_BASK_V6 |
+			      WRAPPER_INTR_MASK_A2HCPU_MASK);
+	} else {
+		mask_val = WRAPPER_INTR_MASK_A2HVCODEC_MASK;
+	}
+	writel(mask_val, wrapper_base + WRAPPER_INTR_MASK);
 	writel(1, cpu_cs_base + CPU_CS_SCIACMDARG3);
 
 	while (!ctrl_status && count < max_tries) {
@@ -456,6 +463,9 @@ static int venus_boot_core(struct venus_hfi_device *hdev)
 	if (count >= max_tries)
 		ret = -ETIMEDOUT;
 
+	if (IS_V6(hdev->core))
+		writel(0x0, cpu_cs_base + CPU_CS_X2RPMH_V6);
+
 	return ret;
 }
 
-- 
2.40.1



