Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6471B25179A;
	Tue, 29 Apr 2025 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946137; cv=none; b=EwDkGqdPlyrG8hrJ+QaEzv4dsldV6ZZ23xuNIS8usMq3UesDcHNR0O8/IHzBNONghGAHnnWi7NUpTGDW4XZ52lJmEJBowThXhVy040VTiyqH9JX6sXrDuF68DvCPIs3gHGfcrkTK7h4+Ua1pViiVWv3TfThTWN4GAzPPsDXNl6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946137; c=relaxed/simple;
	bh=oMOwetYhsyWRHBU04Glel5p3FwbvxIvC632VYoXmi2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxnvaIPHo7u18ltboqzAgUjXlSbyqhcm5SE1Ex0w40Nc6YCuAg/TnOojB0J0E4vm0EoL/UlORflCmK3YV1xvB6o7quILldlZ9Va9dFobrCkLXG7EHDlTeD+Gh/yu+xF01WtXAd9UnBDMoTPpTR92dW5lrm6hHOwoXBWb6e+LbY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQW/YCNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQW/YCNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F227C4CEF1;
	Tue, 29 Apr 2025 17:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946136;
	bh=oMOwetYhsyWRHBU04Glel5p3FwbvxIvC632VYoXmi2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQW/YCNGyPhp72Opw87zLbraVJibf2DeyZlMckLN7hNWv6o5vUS22eUBe2wqr2+wa
	 hWHmIc1q0LNZbZ6C3Nsh2/9n5QsZXk3W7ruPk2VYv2vTcZohY5NkXiOvLj9YCmzT+b
	 6fPNyY0F5q7nJon/KMOyAiYmxG72GNjl0OlHiexU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.14 150/311] misc: microchip: pci1xxxx: Fix incorrect IRQ status handling during ack
Date: Tue, 29 Apr 2025 18:39:47 +0200
Message-ID: <20250429161127.185720462@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -168,7 +168,7 @@ static void pci1xxxx_gpio_irq_ack(struct
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	pci1xxx_assign_bit(priv->reg_base, INTR_STAT_OFFSET(gpio), (gpio % 32), true);
+	writel(BIT(gpio % 32), priv->reg_base + INTR_STAT_OFFSET(gpio));
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 


