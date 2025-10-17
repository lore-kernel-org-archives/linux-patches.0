Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B862F231C9F;
	Fri, 17 Oct 2025 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714782; cv=none; b=ZGXmOCQokbfLxeXFoKgs1IKRltXH4boUEfDV1VAuQHk+LX2ln1TszspVvcVeKDPkAmGQJzbAm8OsjwysHnMRK3KsFjzemIeinKe01Bi5G/ib1vBnNKfF82uPZyZUHg3556Qwjt1fRjlkctOFO7tiYPspZqS2BSia3rhU0htkcP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714782; c=relaxed/simple;
	bh=X2JLOnXs/xG6zFKj51jawaReg7XrqZhPBumDsesmTBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOiCKYgNHsJFsLYYz+wp/nmEGl7wpBuJqoUQ3cjq6SVJw0Qdyg3rM7KJq/cmtEMd88Qfpc1BxVsTbXNh3mqo/XPX2jqcARg4Vc+7wHhUQ9iaVIu2is3YCHH+Kqa94Nb85gf0kP3PxqryXjMy2qsaQ/cBnrxddSDfm9SGerqGMhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=huPOKEIB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="huPOKEIB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41681C4CEE7;
	Fri, 17 Oct 2025 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714782;
	bh=X2JLOnXs/xG6zFKj51jawaReg7XrqZhPBumDsesmTBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=huPOKEIBYzHe13NBKRhFWCBLFuekzClklU+NxFGTqlyfutqIRYtxcXASwJKdK94mW
	 NoOc5F5/IwYavkdaEgOzTx8aw5nxGnsxEM6F637R9w6XawItONwHeRHaF6jxfyAUvn
	 OAJl9J+w6wp5yZQWnM//yQWsiXgPH9X7aTR/5g+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Wang <wangjia@ultrarisc.com>,
	Charles Mirabile <cmirabil@redhat.com>,
	Lucas Zampieri <lzampier@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 264/277] irqchip/sifive-plic: Avoid interrupt ID 0 handling during suspend/resume
Date: Fri, 17 Oct 2025 16:54:31 +0200
Message-ID: <20251017145156.801310033@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Lucas Zampieri <lzampier@redhat.com>

[ Upstream commit f75e07bf5226da640fa99a0594687c780d9bace4 ]

According to the PLIC specification[1], global interrupt sources are
assigned small unsigned integer identifiers beginning at the value 1.
An interrupt ID of 0 is reserved to mean "no interrupt".

The current plic_irq_resume() and plic_irq_suspend() functions incorrectly
start the loop from index 0, which accesses the register space for the
reserved interrupt ID 0.

Change the loop to start from index 1, skipping the reserved
interrupt ID 0 as per the PLIC specification.

This prevents potential undefined behavior when accessing the reserved
register space during suspend/resume cycles.

Fixes: e80f0b6a2cf3 ("irqchip/irq-sifive-plic: Add syscore callbacks for hibernation")
Co-developed-by: Jia Wang <wangjia@ultrarisc.com>
Signed-off-by: Jia Wang <wangjia@ultrarisc.com>
Co-developed-by: Charles Mirabile <cmirabil@redhat.com>
Signed-off-by: Charles Mirabile <cmirabil@redhat.com>
Signed-off-by: Lucas Zampieri <lzampier@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://github.com/riscv/riscv-plic-spec/releases/tag/1.0.0
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-sifive-plic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-sifive-plic.c b/drivers/irqchip/irq-sifive-plic.c
index bf69a4802b71e..9c4af7d588463 100644
--- a/drivers/irqchip/irq-sifive-plic.c
+++ b/drivers/irqchip/irq-sifive-plic.c
@@ -252,7 +252,8 @@ static int plic_irq_suspend(void)
 
 	priv = per_cpu_ptr(&plic_handlers, smp_processor_id())->priv;
 
-	for (i = 0; i < priv->nr_irqs; i++) {
+	/* irq ID 0 is reserved */
+	for (i = 1; i < priv->nr_irqs; i++) {
 		__assign_bit(i, priv->prio_save,
 			     readl(priv->regs + PRIORITY_BASE + i * PRIORITY_PER_ID));
 	}
@@ -283,7 +284,8 @@ static void plic_irq_resume(void)
 
 	priv = per_cpu_ptr(&plic_handlers, smp_processor_id())->priv;
 
-	for (i = 0; i < priv->nr_irqs; i++) {
+	/* irq ID 0 is reserved */
+	for (i = 1; i < priv->nr_irqs; i++) {
 		index = BIT_WORD(i);
 		writel((priv->prio_save[index] & BIT_MASK(i)) ? 1 : 0,
 		       priv->regs + PRIORITY_BASE + i * PRIORITY_PER_ID);
-- 
2.51.0



