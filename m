Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87708248BA8;
	Wed, 15 Jan 2025 10:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937813; cv=none; b=OwISEI8Wij15kip9083Pavq1x4dxfTrzF/NIrPVGXflpBs75lo+4WHI8LaJi/3JeKxHxNTnyZs742Hu6i3B2UnePkLhTE3MhzB+I4X+14DEgRmysNZURS95A5R8PxW6eW1rWTsyoa0r5LOsJ1/UdkZ5gjodOK8b+zxD1f8lWRhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937813; c=relaxed/simple;
	bh=rbb4jy0AWJDGpg8/cu14tudUro75Q8bPmz2yEc5u9Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o57lPXXzAwdC6Jhy9YL3m6Gjjhyt4NQzt5UdXlvZPP7JnbBngCbgegL5cNVcxkOxmFOPvHJF8QrjrQ2AGGQtIoPcFBjXZ1v0EGUSTOpNoaW+4nWJWfVZ93iASYZ7E7DPHGdmvsrawxqLPywg9PGZpNExTOO/KihXcKdloabZ1qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w05HvCKs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w05HvCKs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB61C4CEE2;
	Wed, 15 Jan 2025 10:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937813;
	bh=rbb4jy0AWJDGpg8/cu14tudUro75Q8bPmz2yEc5u9Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w05HvCKsITMUG6wz4dQJ9vUjuzaSE0sOhyk/exSlBXzs/vXCbd/NJlwtTD7Tqc192
	 ezs0o/SUL8RnfkzamtJrAhgdhHeL+CP3Oaeh6L6fWb99EdG15uhQZihWcgYJEaUQUK
	 Xlhgt+2ix+jbDFv5LhdC0jjZXtzEIJucnfUR3xpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.1 60/92] misc: microchip: pci1xxxx: Resolve kernel panic during GPIO IRQ handling
Date: Wed, 15 Jan 2025 11:37:18 +0100
Message-ID: <20250115103549.956723224@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit 194f9f94a5169547d682e9bbcc5ae6d18a564735 upstream.

Resolve kernel panic caused by improper handling of IRQs while
accessing GPIO values. This is done by replacing generic_handle_irq with
handle_nested_irq.

Fixes: 1f4d8ae231f4 ("misc: microchip: pci1xxxx: Add gpio irq handler and irq helper functions irq_ack, irq_mask, irq_unmask and irq_set_type of irq_chip.")
Cc: stable <stable@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20241205133626.1483499-2-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
@@ -273,7 +273,7 @@ static irqreturn_t pci1xxxx_gpio_irq_han
 			writel(BIT(bit), priv->reg_base + INTR_STATUS_OFFSET(gpiobank));
 			spin_unlock_irqrestore(&priv->lock, flags);
 			irq = irq_find_mapping(gc->irq.domain, (bit + (gpiobank * 32)));
-			generic_handle_irq(irq);
+			handle_nested_irq(irq);
 		}
 	}
 	spin_lock_irqsave(&priv->lock, flags);


