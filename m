Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A1C155333;
	Tue, 29 Apr 2025 18:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950463; cv=none; b=kmn00xImApmW6nijMdWi2pMaGRb9FAHau0EDzEb4qK/8cE3J+kVva1Hv3d3ZsK11aCu0suZVWSixui1NwFmkEvgbUYbXOH3rq89myxF22X5vmxZu5abrSIn4JhzeY7R96daAX1Qi6sVx/Eg/W0mGKPoct68b6fChLUW59/3jYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950463; c=relaxed/simple;
	bh=+J0dwCvyZbPW8kLTUKC6jBRPM2z9HvqJkd/GdPDq+Q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JM/reZFgLqgQU2UT0tzpssRq40I6qe4/cvDArrVd/B9dKM1iz3seymM75tjig0MUO8YeIAqvAxRJpdWkKmRH98BRvYnHnNt8OyFGDwk1WcffU2j5pHha6UwfsBuKcOOudXFhmvcMWnI3EWhZgRXpih08E5P3zGtwbeDlhx6m35U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+jEnb/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+jEnb/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07F8C4CEE3;
	Tue, 29 Apr 2025 18:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950463;
	bh=+J0dwCvyZbPW8kLTUKC6jBRPM2z9HvqJkd/GdPDq+Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J+jEnb/7jKKtK4lpJ7WEPtixovB4krlndfcQ+M4qjqmB9hRV2in0SeymETdcMxqC0
	 f/+W58aQ7GRGfNlO4C8LS75XU2xAg5j7/NSQHF/+GgLIcVT/GKEESwMTO2ekp6ubkK
	 wx9+fffaVeNXlGXO2/kcld0KbuDCGGhBAxTNon4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.6 096/204] misc: microchip: pci1xxxx: Fix incorrect IRQ status handling during ack
Date: Tue, 29 Apr 2025 18:43:04 +0200
Message-ID: <20250429161103.363449265@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

From: Rengarajan S <rengarajan.s@microchip.com>

commit e9d7748a7468581859d2b85b378135f9688a0aff upstream.

Under irq_ack, pci1xxxx_assign_bit reads the current interrupt status,
modifies and writes the entire value back. Since, the IRQ status bit
gets cleared on writing back, the better approach is to directly write
the bitmask to the register in order to preserve the value.

Fixes: 1f4d8ae231f4 ("misc: microchip: pci1xxxx: Add gpio irq handler and irq helper functions irq_ack, irq_mask, irq_unmask and irq_set_type of irq_chip.")
Cc: stable <stable@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20250313170856.20868-3-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
@@ -165,7 +165,7 @@ static void pci1xxxx_gpio_irq_ack(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	pci1xxx_assign_bit(priv->reg_base, INTR_STAT_OFFSET(gpio), (gpio % 32), true);
+	writel(BIT(gpio % 32), priv->reg_base + INTR_STAT_OFFSET(gpio));
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 


