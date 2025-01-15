Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47147248BD1;
	Wed, 15 Jan 2025 10:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938752; cv=none; b=IetswzIGURd8eN7KNjfsomhWHSN0asBgbyvDMD0MoTsRHMO6TfjAw6mPtXjYtIaXyfq7VR/urrf3xjvegBN7lstjVtdz+W6WWZ2+8+ZrtFl1jzCf3TqFu2lEYkGCyVPCxLL43tSAFdMTdbj1BNWxg4bmaCJAhC3SJVBpdY7f53Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938752; c=relaxed/simple;
	bh=+lo+rhdeUGBNK7TJxjjf66XrZcM6yp0w8wETyTSD+NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4c6ieH00/FYb5Lzgu1QvjbA3H2th7CA8XvZYT70TaaMZvb0+rTxLJG8XUUTZo2+KqIuEnDj5dVK2MqEFOupNn/SWotlr5ZTRqeySXG2ghD3eptL/rGa9rue4wXP8AytCIvXOaHPV7dilbZgb3qnELNwVs+9tPcHLYaUYa+Vai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cvm3mJBw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cvm3mJBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1838C4CEDF;
	Wed, 15 Jan 2025 10:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938752;
	bh=+lo+rhdeUGBNK7TJxjjf66XrZcM6yp0w8wETyTSD+NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cvm3mJBwFPS2bq8Nl9js1ueur7iT6Bqz/5kaUNwWbHywKdPKq9S+ISDTzWqGh1tjq
	 6VRlHJBzIJskVg/h6dnEM04r/G7B3J+8r3p2jz2rxvX1n77GKWQRnCrbTlR1HIxH1a
	 1wXaiPxhF9o5FunCpZe9/dYQS0CunhWACC2LbQwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.6 087/129] misc: microchip: pci1xxxx: Resolve kernel panic during GPIO IRQ handling
Date: Wed, 15 Jan 2025 11:37:42 +0100
Message-ID: <20250115103557.837156185@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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
@@ -277,7 +277,7 @@ static irqreturn_t pci1xxxx_gpio_irq_han
 			writel(BIT(bit), priv->reg_base + INTR_STATUS_OFFSET(gpiobank));
 			spin_unlock_irqrestore(&priv->lock, flags);
 			irq = irq_find_mapping(gc->irq.domain, (bit + (gpiobank * 32)));
-			generic_handle_irq(irq);
+			handle_nested_irq(irq);
 		}
 	}
 	spin_lock_irqsave(&priv->lock, flags);


