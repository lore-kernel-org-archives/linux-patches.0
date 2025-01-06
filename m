Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A761DE889;
	Mon,  6 Jan 2025 16:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179309; cv=none; b=kap9ecNpWkOHfvZX6wi2uTz6RZ7/vLmqjNJSITHJQ+fbHg4wP4k0uoOK79hj32vJnMk/SpWRqWjqUm6GECKQFyUdSBRTiuB9BkO2zZ6fIo4zuTKaRqG4+ac3aJC8aPiW3aHJxJ/Ol/62jUNg3r7IvEB5DVYnEQjuxix8KKfJIBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179309; c=relaxed/simple;
	bh=boUP0RDcFxRfmlVAAlhAh22xNH/7j1pe/YoeEOgTSAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n8rCE0RGi0/64DwZH1BB2uz5hirVm5MehMO4MVf7ZKpfBeZbhLTMNyXOqUCier2QAriJWhqphPeGO+fqqjEGXInKBX3Pq5ODw2VSK/jBg3lPshVSxx1JUYLMo55uSktS3BrhRWgB3OtUUFduybEN0MhIadoIPEc2VLwpnhFw72A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvMzKigy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvMzKigy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B231C4CED2;
	Mon,  6 Jan 2025 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179309;
	bh=boUP0RDcFxRfmlVAAlhAh22xNH/7j1pe/YoeEOgTSAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvMzKigy1oZT0xrFz/OhUS2wnhX4YAex/taCgHc6BYmXFojIHKI0ZQ0avJjmDevjm
	 pfIrTeijAGgR3ShB7K5O57eKc44ryseb+fWtiZLEE3g02sjwTnclh2ZHWEXPNJ+K7j
	 0UcQBV4YqFeN4HlzSaRE2EYmIQ1US1ZT4fGqDQ4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 84/93] irqchip/gic: Correct declaration of *percpu_base pointer in union gic_base
Date: Mon,  6 Jan 2025 16:18:00 +0100
Message-ID: <20250106151131.875651247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 882204d1ef4f..5937f3cd288b 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -62,7 +62,7 @@ static void gic_check_cpu_features(void)
 
 union gic_base {
 	void __iomem *common_base;
-	void __percpu * __iomem *percpu_base;
+	void __iomem * __percpu *percpu_base;
 };
 
 struct gic_chip_data {
-- 
2.39.5



