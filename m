Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13FCE3314B4;
	Tue, 16 Dec 2025 11:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884943; cv=none; b=HaHajFM1d4JNgIck12L+n+cefUHH9vb5R/REWmFOTbhAihv1moC7r6covjieNCnXb7h7Gcaqm2+MrkPD29ErpIzWGFZvn8TQ+7kyzn00Rfp7gAt1J0Eb4zYxtAmBjzfN/BkSkFF3IglD2XegCb/bdcpcrEfRYE1dv/da3ltyK2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884943; c=relaxed/simple;
	bh=ZKY+Pu22L6Nyxuad2oCnAeqQZDPQkKtJQlCspKdWdfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB5adYgE2YJB2Lm6J0x20j3GPMThVNewNfywuYVhuMz4DDUTZkAeAL/6To73A72RsAbI+whZ94wW7sQZyOkr0vDteoEt6eBSdsNOyIGnkvtoKDMjRDrKUcVDSdxFHsXZmuTcBgYxScmM/L8+ZUIBSRF6nud1MxVDt9SqRNpDkzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zW7TFWjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zW7TFWjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 294E7C4CEF1;
	Tue, 16 Dec 2025 11:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884942;
	bh=ZKY+Pu22L6Nyxuad2oCnAeqQZDPQkKtJQlCspKdWdfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zW7TFWjUYmfoC9hdQDVmLyNFzPduABqu+oQ2+pyJSuRAJmMzvJZz49Knf4HuOUrqD
	 8Lc7fga+XSzOw3VzrwJ77QZlpXOgvkhlnSgByqQJnjAOFm8NzBS7VtS3j/xrvLWMgL
	 PuLGpjp4+qQRpYPS9+bUwkSuc+/FfjmfHP/6P9mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/354] irqchip/mchp-eic: Fix error code in mchp_eic_domain_alloc()
Date: Tue, 16 Dec 2025 12:15:11 +0100
Message-ID: <20251216111333.368185810@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7dbc0d40d8347bd9de55c904f59ea44bcc8dedb7 ]

If irq_domain_translate_twocell() sets "hwirq" to >= MCHP_EIC_NIRQ (2) then
it results in an out of bounds access.

The code checks for invalid values, but doesn't set the error code.  Return
-EINVAL in that case, instead of returning success.

Fixes: 00fa3461c86d ("irqchip/mchp-eic: Add support for the Microchip EIC")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://patch.msgid.link/aTfHmOz6IBpTIPU5@stanley.mountain
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-mchp-eic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-mchp-eic.c b/drivers/irqchip/irq-mchp-eic.c
index 5dcd94c000a26..8a5baa0987a4b 100644
--- a/drivers/irqchip/irq-mchp-eic.c
+++ b/drivers/irqchip/irq-mchp-eic.c
@@ -166,7 +166,7 @@ static int mchp_eic_domain_alloc(struct irq_domain *domain, unsigned int virq,
 
 	ret = irq_domain_translate_twocell(domain, fwspec, &hwirq, &type);
 	if (ret || hwirq >= MCHP_EIC_NIRQ)
-		return ret;
+		return ret ?: -EINVAL;
 
 	switch (type) {
 	case IRQ_TYPE_EDGE_RISING:
-- 
2.51.0



