Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49F04189B9;
	Sat, 12 Sep 2026 09:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204853; cv=none; b=IkN9i9LRzol3hUEj9DURHZGQ5SOr/omzGZE8UwELjGeVxoGdLZOWZt0bIRSyeZQj6q+bRsuh2fhLSSM107Q7kKz7ox2wdzzuz93eZV6DF9ANmm35ylpeOsz0BIjHIqPgt82UuPD+BhH1d7WuTUqwA09VqCmJsVd2Vc0M+40Vs8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204853; c=relaxed/simple;
	bh=Q1Uv4bbSv4BrpJbK2hYhpxh5EY9tq0pnYOoiCJ7ezBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwHvgu+L/+jQvT5A23W1nlW/jDlG6IX4LgHI9JMa/e4O+Vr0LcIg9LDjSi4hOALm5Sa43L8y78h7H/goZi/aOCW5QWuqydtluYfrF2qRm6Mm0UR3ovmutnCEU/MMmO92drx++bnMYeEYx7Rdu5qebAKjdBaH0RY0JcintNu6OlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQVfcFTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQVfcFTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF46F1F000FF;
	Sat, 12 Sep 2026 09:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204851;
	bh=fuiWBTWfRHioW533ZWcoY5ByT/BvuC0lS2wwexNhVCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQVfcFTqoomNFZSuzu+OqeuI0i6+1zQIJTDmW9FnsVQOdjlE3Vh/KrtbT16xkAcwi
	 XoRc4mCMWKLNg4dkrde1u7QY2faDh+bIxxfvxYe2AfpSS4JBkV+SOlLAds9Dp12sV/
	 itVNnfLytclV+qNp2Z78gONyjLMVs0aKo1z7G7dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Bischoff <sascha.bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1645/1815] irqchip/gic-v5: Synchronize CPU interface disable
Date: Sat, 12 Sep 2026 08:56:35 +0200
Message-ID: <20260912065727.611479983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Bischoff <Sascha.Bischoff@arm.com>

[ Upstream commit ac6db0e0bee18cd4385418c752a007e1aba4ec14 ]

The write disabling the GICv5 CPU interface is only guaranteed to take
effect after a context synchronization event. Without one, execution can
return from gicv5_cpu_disable_interrupts() while an interrupt is still
able to be taken.

Add an ISB after the ICC_CR0_EL1 write to ensure interrupts are
disabled before the function returns. No corresponding ISB is added
when enabling the interface, as interrupt delivery is asynchronous and
there is no obvious benefit to waiting for it.

Fixes: 7ec80fb3f025 ("irqchip/gic-v5: Add GICv5 PPI support")
Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724104819.1296803-1-sascha.bischoff@arm.com?part=6
Link: https://patch.msgid.link/20260811152630.942023-3-sascha.bischoff@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/irqchip/irq-gic-v5.c b/drivers/irqchip/irq-gic-v5.c
index e9d1795235a66..6a99c541b559b 100644
--- a/drivers/irqchip/irq-gic-v5.c
+++ b/drivers/irqchip/irq-gic-v5.c
@@ -983,6 +983,7 @@ static void gicv5_cpu_disable_interrupts(void)
 
 	cr0 = FIELD_PREP(ICC_CR0_EL1_EN, 0);
 	write_sysreg_s(cr0, SYS_ICC_CR0_EL1);
+	isb();
 }
 
 static void gicv5_cpu_enable_interrupts(void)
-- 
2.53.0



