Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BBCC61FDF;
	Mon, 27 May 2024 19:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838692; cv=none; b=BuOP3F5fOt+rmJaS6nIZYDQtyr6L8TjLasszuEGlVAhjH+pCa5N5DHbinfcJwkKRiYPBzNaFIxC5KAR9Aqbdhr0jYIANxUesW4Uq4DJf2EZNkMhiP+af2pnt/Gr/nlo1QdIirizwipa4gZYbM+2nl5gfmeOjNXtg3kZ/lAy9RO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838692; c=relaxed/simple;
	bh=Uw4zdM1/LAbJit8JA5mvR9iD+k223t183McOzb++JEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nogj6/Dpew/18TzV+1hOST+2JLW1uzl/Qty8rMTUbxRKzkQWrKPl8ELX1m+u+1aUDzrkidG5fiCd3u8Susk6RsLaBwTcPvSPxZfcBgt3GdtgO5NPskDMzJoOF3sv0aTWNJiZR4loU9POzU74sf403hfTTvkkOmbJ6MXi16KuBBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bfpbsoYt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bfpbsoYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E51C2BBFC;
	Mon, 27 May 2024 19:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838692;
	bh=Uw4zdM1/LAbJit8JA5mvR9iD+k223t183McOzb++JEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfpbsoYts5ciZZh3f3ECxzNFmAKTn8PgXYFAZq68zehLfJYHRdmcMoCSX9V9WBikb
	 WzWwIrNHIXNEsLyMniXDyLN/Cpfsr8SbJIvAFSVBnHm0uaoHGmkwst46/G12qjfe5y
	 O7sqXQaO33Pno1UUN3ghWxN1RgZTMFZYsENIoKD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 492/493] net: txgbe: fix to clear interrupt status after handling IRQ
Date: Mon, 27 May 2024 20:58:14 +0200
Message-ID: <20240527185646.225175364@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 0e71862a20d58b6e8d4c39de1d72c8919c4dccd1 ]

GPIO EOI is not set to clear interrupt status after handling the
interrupt. It should be done in irq_chip->irq_ack, but this function
is not called in handle_nested_irq(). So executing function
txgbe_gpio_irq_ack() manually in txgbe_gpio_irq_handler().

Fixes: aefd013624a1 ("net: txgbe: use irq_domain for interrupt controller")
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://lore.kernel.org/r/20240301092956.18544-2-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index bae0a8ee70142..3c9bb4ab98681 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -475,8 +475,10 @@ irqreturn_t txgbe_gpio_irq_handler(int irq, void *data)
 	gc = txgbe->gpio;
 	for_each_set_bit(hwirq, &gpioirq, gc->ngpio) {
 		int gpio = irq_find_mapping(gc->irq.domain, hwirq);
+		struct irq_data *d = irq_get_irq_data(gpio);
 		u32 irq_type = irq_get_trigger_type(gpio);
 
+		txgbe_gpio_irq_ack(d);
 		handle_nested_irq(gpio);
 
 		if ((irq_type & IRQ_TYPE_SENSE_MASK) == IRQ_TYPE_EDGE_BOTH) {
-- 
2.43.0



