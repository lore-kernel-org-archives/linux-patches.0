Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F45A14D28C;
	Mon,  6 Jan 2025 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177579; cv=none; b=c59Lqg+DqUcP/wb1gY70zG8eCjgMo2swZdFnbm/RGOS1T5eCuaW0iZmNpy5SffqIC/IyDbHDjjBgbHpGuPa0xiup5KsKeuS3p2VJxyCf8VVaU3wSs5UCQ9egtr6AC3UfBNDMJsnE5GXd8SdZw8UI8f/hiJA77Dwm8q85/tuin9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177579; c=relaxed/simple;
	bh=+7UO2/SYzFzGQdQjSqtXZS5NM3+5X4u1+zeD4Pb1IeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMfmzgk0+RFSrzwwxK7zAi7n7NL3aH3jErC06Mc1lQHUSeByBLPNuKVlFXfrF43Ed00dfVI0ZQIeUyTvyEZ1vEs+CIXCxcwRvEyA93ktR++sBKdTg7gdGxQLl/YDco0HqATJtarrR2qMrBlXSIbIwAYR9BObk3kCWa0Lhlw9CHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfxCZhXg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfxCZhXg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09B7C4CED2;
	Mon,  6 Jan 2025 15:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177578;
	bh=+7UO2/SYzFzGQdQjSqtXZS5NM3+5X4u1+zeD4Pb1IeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfxCZhXg4Wdpy9LIObgMsmuFUg1cQa7tqCLWYa5gwCHCNfI5pQOSRvyXPGV9az/ct
	 1/GWhOfmikhtfYiRWa077Z8iseUdGr/91HSTwmaVQX+Vuj5siZCYOMtfPHt+xp+lH6
	 84krInG+NeYNqUXE73FQhT218RB8HdoNIoNoG9MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/222] irqchip/gic: Correct declaration of *percpu_base pointer in union gic_base
Date: Mon,  6 Jan 2025 16:16:36 +0100
Message-ID: <20250106151158.030408407@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit a1855f1b7c33642c9f7a01991fb763342a312e9b ]

percpu_base is used in various percpu functions that expect variable in
__percpu address space. Correct the declaration of percpu_base to

void __iomem * __percpu *percpu_base;

to declare the variable as __percpu pointer.

The patch fixes several sparse warnings:

irq-gic.c:1172:44: warning: incorrect type in assignment (different address spaces)
irq-gic.c:1172:44:    expected void [noderef] __percpu *[noderef] __iomem *percpu_base
irq-gic.c:1172:44:    got void [noderef] __iomem *[noderef] __percpu *
...
irq-gic.c:1231:43: warning: incorrect type in argument 1 (different address spaces)
irq-gic.c:1231:43:    expected void [noderef] __percpu *__pdata
irq-gic.c:1231:43:    got void [noderef] __percpu *[noderef] __iomem *percpu_base

There were no changes in the resulting object files.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/all/20241213145809.2918-2-ubizjak@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 412196a7dad5..2c6c50348afd 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -64,7 +64,7 @@ static void gic_check_cpu_features(void)
 
 union gic_base {
 	void __iomem *common_base;
-	void __percpu * __iomem *percpu_base;
+	void __iomem * __percpu *percpu_base;
 };
 
 struct gic_chip_data {
-- 
2.39.5



