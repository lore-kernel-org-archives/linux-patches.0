Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5CC1171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B163AC433C9;
	Mon, 21 Aug 2023 20:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648489;
	bh=KDDmVz8V3t9SBYvQP5pPq3AnF5wkAvMsIB2MpFgFYHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0U9151ltKrYuNmLsqzmMpKzt5jgb6/Zo+jj2H8u0Hu9fCN0mSEX6Arrq6CLe9D5yS
	 wlRX+aoXAFLG/6VECWAPXkqpx9hl1GRdSec43q9GjbiFN1pEwJjzNCdR0sI87jDFRk
	 kvd5WvE7ldFZCyxA+0Cfzx3ovUN43PPoMwES0mPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ninad Naik <quic_ninanaik@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH 6.4 194/234] pinctrl: qcom: Add intr_target_width field to support increased number of interrupt targets
Date: Mon, 21 Aug 2023 21:42:37 +0200
Message-ID: <20230821194137.405481551@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ninad Naik <quic_ninanaik@quicinc.com>

[ Upstream commit 9757300d2750ef76f139aa6f5f7eadd61a0de0d3 ]

SA8775 and newer target have added support for an increased number of
interrupt targets. To implement this change, the intr_target field, which
is used to configure the interrupt target in the interrupt configuration
register is increased from 3 bits to 4 bits.

In accordance to these updates, a new intr_target_width member is
introduced in msm_pingroup structure. This member stores the value of
width of intr_target field in the interrupt configuration register. This
value is used to dynamically calculate and generate mask for setting the
intr_target field. By default, this mask is set to 3 bit wide, to ensure
backward compatibility with the older targets.

Fixes: 4b6b18559927 ("pinctrl: qcom: add the tlmm driver sa8775p platforms")
Tested-by: Andrew Halaney <ahalaney@redhat.com> # sa8775p-ride
Signed-off-by: Ninad Naik <quic_ninanaik@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20230809100634.3961-1-quic_ninanaik@quicinc.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c     | 9 ++++++---
 drivers/pinctrl/qcom/pinctrl-msm.h     | 2 ++
 drivers/pinctrl/qcom/pinctrl-sa8775p.c | 1 +
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index c5f52d4f7781b..1fb0a24356bf5 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -1039,6 +1039,7 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	struct gpio_chip *gc = irq_data_get_irq_chip_data(d);
 	struct msm_pinctrl *pctrl = gpiochip_get_data(gc);
 	const struct msm_pingroup *g;
+	u32 intr_target_mask = GENMASK(2, 0);
 	unsigned long flags;
 	bool was_enabled;
 	u32 val;
@@ -1075,13 +1076,15 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 	 * With intr_target_use_scm interrupts are routed to
 	 * application cpu using scm calls.
 	 */
+	if (g->intr_target_width)
+		intr_target_mask = GENMASK(g->intr_target_width - 1, 0);
+
 	if (pctrl->intr_target_use_scm) {
 		u32 addr = pctrl->phys_base[0] + g->intr_target_reg;
 		int ret;
 
 		qcom_scm_io_readl(addr, &val);
-
-		val &= ~(7 << g->intr_target_bit);
+		val &= ~(intr_target_mask << g->intr_target_bit);
 		val |= g->intr_target_kpss_val << g->intr_target_bit;
 
 		ret = qcom_scm_io_writel(addr, val);
@@ -1091,7 +1094,7 @@ static int msm_gpio_irq_set_type(struct irq_data *d, unsigned int type)
 				d->hwirq);
 	} else {
 		val = msm_readl_intr_target(pctrl, g);
-		val &= ~(7 << g->intr_target_bit);
+		val &= ~(intr_target_mask << g->intr_target_bit);
 		val |= g->intr_target_kpss_val << g->intr_target_bit;
 		msm_writel_intr_target(val, pctrl, g);
 	}
diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
index 985eceda25173..7f30416be127b 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.h
+++ b/drivers/pinctrl/qcom/pinctrl-msm.h
@@ -51,6 +51,7 @@ struct msm_function {
  * @intr_status_bit:      Offset in @intr_status_reg for reading and acking the interrupt
  *                        status.
  * @intr_target_bit:      Offset in @intr_target_reg for configuring the interrupt routing.
+ * @intr_target_width:    Number of bits used for specifying interrupt routing target.
  * @intr_target_kpss_val: Value in @intr_target_bit for specifying that the interrupt from
  *                        this gpio should get routed to the KPSS processor.
  * @intr_raw_status_bit:  Offset in @intr_cfg_reg for the raw status bit.
@@ -94,6 +95,7 @@ struct msm_pingroup {
 	unsigned intr_ack_high:1;
 
 	unsigned intr_target_bit:5;
+	unsigned intr_target_width:5;
 	unsigned intr_target_kpss_val:5;
 	unsigned intr_raw_status_bit:5;
 	unsigned intr_polarity_bit:5;
diff --git a/drivers/pinctrl/qcom/pinctrl-sa8775p.c b/drivers/pinctrl/qcom/pinctrl-sa8775p.c
index 2ae7cdca65d3e..62f7a36d290cb 100644
--- a/drivers/pinctrl/qcom/pinctrl-sa8775p.c
+++ b/drivers/pinctrl/qcom/pinctrl-sa8775p.c
@@ -54,6 +54,7 @@
 		.intr_enable_bit = 0,		\
 		.intr_status_bit = 0,		\
 		.intr_target_bit = 5,		\
+		.intr_target_width = 4,		\
 		.intr_target_kpss_val = 3,	\
 		.intr_raw_status_bit = 4,	\
 		.intr_polarity_bit = 1,		\
-- 
2.40.1



