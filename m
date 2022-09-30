Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731D21376
	for <patches@lists.linux.dev>; Fri, 30 Sep 2022 00:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B77C4347C;
	Fri, 30 Sep 2022 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664499021;
	bh=SlLfoKpwmBknNdU6MSA/2Phbf8VfqnBANRq++WOOwOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XiSHSMKxEbfQIbiuTiB3p19VwghuGzAcIYIb5zA1ZMZkVrv70nY4+9Q74CnarO7mm
	 wNeWEJUw2Shs6W6VSE2NI4HyeCWE/Ce9xCaaGJYf5kfNX97H5WKnPHdiJI/uwXTsbt
	 IzX0LCsgV+WkgtElTaw0rI/8Z3xEpqPGNCPUx3IG8VdWu696P51CiPT5V4S7tiNowo
	 aO0tZBJllbw33hJQHM/qB8NZnGxhzhCxNEtv8OCwi5d/Dg4ClvYM2KEMSK9g9Us/xu
	 CBBdu0oov1WoYgfaJzsfpG2t9opNT+2itNF2CU2Nhukt/EdoIPEbMZ4SdyDOJbAWtP
	 TwDNbi2/pzBdg==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	David Collins <collinsd@codeaurora.org>,
	Fenglin Wu <quic_fenglinw@quicinc.com>
Subject: [PATCH 4/9] spmi: pmic-arb: do not ack and clear peripheral interrupts in cleanup_irq
Date: Thu, 29 Sep 2022 17:50:13 -0700
Message-Id: <20220930005019.2663064-5-sboyd@kernel.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220930005019.2663064-1-sboyd@kernel.org>
References: <20220930005019.2663064-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>

Currently, cleanup_irq() is invoked when a peripheral's interrupt
fires and there is no mapping present in the interrupt domain of
spmi interrupt controller.

The cleanup_irq clears the arbiter bit, clears the pmic interrupt
and disables it at the pmic in that order. The last disable in
cleanup_irq races with request_irq() in that it stomps over the
enable issued by request_irq. Fix this by not writing to the pmic
in cleanup_irq. The latched bit will be left set in the pmic,
which will not send us more interrupts even if the enable bit
stays enabled.

When a client wants to request an interrupt, use the activate
callback on the irq_domain to clear latched bit. This ensures
that the latched, if set due to the above changes in cleanup_irq
or when the bootloader leaves it set, gets cleaned up, paving way
for upcoming interrupts to trigger.

With this, there is a possibility of unwanted triggering of
interrupt right after the latched bit is cleared - the interrupt
may be left enabled too. To avoid that, clear the enable first
followed by clearing the latched bit in the activate callback.

Fixes: 6bc546e71e50 ("spmi: pmic-arb: cleanup unrequested irqs")
Fixes: 02abec3616c1 ("spmi: pmic-arb: rename pa_xx to pmic_arb_xx and other cleanup")
Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
[collinsd@codeaurora.org: fix merge conflict]
Signed-off-by: David Collins <collinsd@codeaurora.org>
Signed-off-by: Fenglin Wu <quic_fenglinw@quicinc.com>
Link: https://lore.kernel.org/r/1655004286-11493-4-git-send-email-quic_fenglinw@quicinc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 719bd73e5153..2bc3b88f35c9 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -593,16 +593,6 @@ static void cleanup_irq(struct spmi_pmic_arb *pmic_arb, u16 apid, int id)
 	dev_err_ratelimited(&pmic_arb->spmic->dev, "%s apid=%d sid=0x%x per=0x%x irq=%d\n",
 			__func__, apid, sid, per, id);
 	writel_relaxed(irq_mask, pmic_arb->ver_ops->irq_clear(pmic_arb, apid));
-
-	if (pmic_arb_write_cmd(pmic_arb->spmic, SPMI_CMD_EXT_WRITEL, sid,
-			(per << 8) + QPNPINT_REG_LATCHED_CLR, &irq_mask, 1))
-		dev_err_ratelimited(&pmic_arb->spmic->dev, "failed to ack irq_mask = 0x%x for ppid = %x\n",
-				irq_mask, ppid);
-
-	if (pmic_arb_write_cmd(pmic_arb->spmic, SPMI_CMD_EXT_WRITEL, sid,
-			       (per << 8) + QPNPINT_REG_EN_CLR, &irq_mask, 1))
-		dev_err_ratelimited(&pmic_arb->spmic->dev, "failed to ack irq_mask = 0x%x for ppid = %x\n",
-				irq_mask, ppid);
 }
 
 static int periph_interrupt(struct spmi_pmic_arb *pmic_arb, u16 apid)
@@ -780,6 +770,7 @@ static int qpnpint_irq_domain_activate(struct irq_domain *domain,
 	u16 apid = hwirq_to_apid(d->hwirq);
 	u16 sid = hwirq_to_sid(d->hwirq);
 	u16 irq = hwirq_to_irq(d->hwirq);
+	u8 buf;
 
 	if (pmic_arb->apid_data[apid].irq_ee != pmic_arb->ee) {
 		dev_err(&pmic_arb->spmic->dev, "failed to xlate sid = %#x, periph = %#x, irq = %u: ee=%u but owner=%u\n",
@@ -788,6 +779,10 @@ static int qpnpint_irq_domain_activate(struct irq_domain *domain,
 		return -ENODEV;
 	}
 
+	buf = BIT(irq);
+	qpnpint_spmi_write(d, QPNPINT_REG_EN_CLR, &buf, 1);
+	qpnpint_spmi_write(d, QPNPINT_REG_LATCHED_CLR, &buf, 1);
+
 	return 0;
 }
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

