Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE37C1365
	for <patches@lists.linux.dev>; Fri, 30 Sep 2022 00:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F24C433C1;
	Fri, 30 Sep 2022 00:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664499020;
	bh=1iKgq57jI+UOl7K/jTlEvdXh17z6ctGT+qZUxoeVpCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKf3xd2w/P/LVo7L9VmrzjR/2bRsBRK7UnDSKPe0DFKelXF48aoVFfbtakbChcB2F
	 iOyxwhUd38n+DYMBUucONFy3PO0tGLEzcdyaCjIhtcPBPy4MvL+3QiEWUdKR+4CCQA
	 nZMftVHc5+QXyEBY0ctX7sggU9qzkvyqdYQ6cezjS/E0KUFqbJ7c+PZs6XbnZIgucR
	 89lcLJ42cTplQFCwldpxhWMXBdZwAIGs83PspsiPgIktEHVC+Ek9L08czn+LlkHE+P
	 +BBmbviUJtyWw9yJ18YMJBJ77GeEFjUZUrTOSvKuTPnW+b8DCh8hm8TzgDGJBZrS3Y
	 8m7TUwmveqNeQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	David Collins <collinsd@codeaurora.org>,
	Fenglin Wu <quic_fenglinw@quicinc.com>
Subject: [PATCH 2/9] spmi: pmic-arb: add a print in cleanup_irq
Date: Thu, 29 Sep 2022 17:50:11 -0700
Message-Id: <20220930005019.2663064-3-sboyd@kernel.org>
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

From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>

The cleanup_irq() was meant to clear and mask interrupts that were
left enabled in the hardware but there was no interrupt handler
registered for it. Add an error print when it gets invoked.

Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Signed-off-by: David Collins <collinsd@codeaurora.org>
Signed-off-by: Fenglin Wu <quic_fenglinw@quicinc.com>
Link: https://lore.kernel.org/r/1655004286-11493-2-git-send-email-quic_fenglinw@quicinc.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index 2113be40b5a9..5a99723b3f32 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -590,6 +590,8 @@ static void cleanup_irq(struct spmi_pmic_arb *pmic_arb, u16 apid, int id)
 	u8 per = ppid & 0xFF;
 	u8 irq_mask = BIT(id);
 
+	dev_err_ratelimited(&pmic_arb->spmic->dev, "%s apid=%d sid=0x%x per=0x%x irq=%d\n",
+			__func__, apid, sid, per, id);
 	writel_relaxed(irq_mask, pmic_arb->ver_ops->irq_clear(pmic_arb, apid));
 
 	if (pmic_arb_write_cmd(pmic_arb->spmic, SPMI_CMD_EXT_WRITEL, sid,
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

