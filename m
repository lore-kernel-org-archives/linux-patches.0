Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6EAA4C62;
	Wed, 21 Feb 2024 14:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525083; cv=none; b=ehDSJxCncG4OxFTJCMtlUarbiZF5tXjL6s2p3gybaRqwulRZsV3smpXsW1gBroLs4A9W3e9eOVLepEjvjhAoOcnff5/2CNNI9xSqNkpB6F64X+oZ9YOw9WcV0HvhcTFw40j3EhlZhb+xLusOifz7LgJC+6sW1f8PFDekuAZJa8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525083; c=relaxed/simple;
	bh=nWX2GnNhFO4hygytI0a1fYvwKxVuCOZXoHkPPncSFVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKvZw3ZaQtQA3DXzDvBdYU3h6o9Cyeij4oCXhv1Owy4W3zNKElliixBuSLKWBG3pLJHoq7cwo5qonLyVdWoklfYfiW2BEOgnTghwPipr6YbhH3nrxFvbT/1zVAwPDiPImhHkgfaXMZs10CY8MAjqwia7t8rBaP0Qnl8/R4fte9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ea8ccYCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ea8ccYCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F0AC433F1;
	Wed, 21 Feb 2024 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525083;
	bh=nWX2GnNhFO4hygytI0a1fYvwKxVuCOZXoHkPPncSFVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ea8ccYCEoBfhqJf9NKSqPXaHnKkMYv1vM4PZasRwbXkkcI4YmCPI4uZKgNkRxjJ1s
	 XqQJFvq3zT6LSOeevQpS+Wv1V/o9d62grIsuerfHWdO0PGa+vyt6gBaebVN2tNVbgh
	 G41pRF1mDTMafjXfrvKeqVTLF/iqx+K5CRiCm/sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/267] gpio: eic-sprd: Clear interrupt after set the interrupt type
Date: Wed, 21 Feb 2024 14:06:37 +0100
Message-ID: <20240221125941.771420132@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenhua Lin <Wenhua.Lin@unisoc.com>

[ Upstream commit 84aef4ed59705585d629e81d633a83b7d416f5fb ]

The raw interrupt status of eic maybe set before the interrupt is enabled,
since the eic interrupt has a latch function, which would trigger the
interrupt event once enabled it from user side. To solve this problem,
interrupts generated before setting the interrupt trigger type are ignored.

Fixes: 25518e024e3a ("gpio: Add Spreadtrum EIC driver support")
Acked-by: Chunyan Zhang <zhang.lyra@gmail.com>
Signed-off-by: Wenhua Lin <Wenhua.Lin@unisoc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-eic-sprd.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-eic-sprd.c b/drivers/gpio/gpio-eic-sprd.c
index a69b3faf51ef..e50e27304c38 100644
--- a/drivers/gpio/gpio-eic-sprd.c
+++ b/drivers/gpio/gpio-eic-sprd.c
@@ -318,20 +318,27 @@ static int sprd_eic_irq_set_type(struct irq_data *data, unsigned int flow_type)
 		switch (flow_type) {
 		case IRQ_TYPE_LEVEL_HIGH:
 			sprd_eic_update(chip, offset, SPRD_EIC_DBNC_IEV, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_DBNC_IC, 1);
 			break;
 		case IRQ_TYPE_LEVEL_LOW:
 			sprd_eic_update(chip, offset, SPRD_EIC_DBNC_IEV, 0);
+			sprd_eic_update(chip, offset, SPRD_EIC_DBNC_IC, 1);
 			break;
 		case IRQ_TYPE_EDGE_RISING:
 		case IRQ_TYPE_EDGE_FALLING:
 		case IRQ_TYPE_EDGE_BOTH:
 			state = sprd_eic_get(chip, offset);
-			if (state)
+			if (state) {
 				sprd_eic_update(chip, offset,
 						SPRD_EIC_DBNC_IEV, 0);
-			else
+				sprd_eic_update(chip, offset,
+						SPRD_EIC_DBNC_IC, 1);
+			} else {
 				sprd_eic_update(chip, offset,
 						SPRD_EIC_DBNC_IEV, 1);
+				sprd_eic_update(chip, offset,
+						SPRD_EIC_DBNC_IC, 1);
+			}
 			break;
 		default:
 			return -ENOTSUPP;
@@ -343,20 +350,27 @@ static int sprd_eic_irq_set_type(struct irq_data *data, unsigned int flow_type)
 		switch (flow_type) {
 		case IRQ_TYPE_LEVEL_HIGH:
 			sprd_eic_update(chip, offset, SPRD_EIC_LATCH_INTPOL, 0);
+			sprd_eic_update(chip, offset, SPRD_EIC_LATCH_INTCLR, 1);
 			break;
 		case IRQ_TYPE_LEVEL_LOW:
 			sprd_eic_update(chip, offset, SPRD_EIC_LATCH_INTPOL, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_LATCH_INTCLR, 1);
 			break;
 		case IRQ_TYPE_EDGE_RISING:
 		case IRQ_TYPE_EDGE_FALLING:
 		case IRQ_TYPE_EDGE_BOTH:
 			state = sprd_eic_get(chip, offset);
-			if (state)
+			if (state) {
 				sprd_eic_update(chip, offset,
 						SPRD_EIC_LATCH_INTPOL, 0);
-			else
+				sprd_eic_update(chip, offset,
+						SPRD_EIC_LATCH_INTCLR, 1);
+			} else {
 				sprd_eic_update(chip, offset,
 						SPRD_EIC_LATCH_INTPOL, 1);
+				sprd_eic_update(chip, offset,
+						SPRD_EIC_LATCH_INTCLR, 1);
+			}
 			break;
 		default:
 			return -ENOTSUPP;
@@ -370,29 +384,34 @@ static int sprd_eic_irq_set_type(struct irq_data *data, unsigned int flow_type)
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTMODE, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTPOL, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;
 		case IRQ_TYPE_EDGE_FALLING:
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTMODE, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTPOL, 0);
+			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;
 		case IRQ_TYPE_EDGE_BOTH:
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTMODE, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTBOTH, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;
 		case IRQ_TYPE_LEVEL_HIGH:
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTMODE, 1);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTPOL, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_level_irq);
 			break;
 		case IRQ_TYPE_LEVEL_LOW:
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTMODE, 1);
 			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTPOL, 0);
+			sprd_eic_update(chip, offset, SPRD_EIC_ASYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_level_irq);
 			break;
 		default:
@@ -405,29 +424,34 @@ static int sprd_eic_irq_set_type(struct irq_data *data, unsigned int flow_type)
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTMODE, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTPOL, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;
 		case IRQ_TYPE_EDGE_FALLING:
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTMODE, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTPOL, 0);
+			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;
 		case IRQ_TYPE_EDGE_BOTH:
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTMODE, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTBOTH, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_edge_irq);
 			break;
 		case IRQ_TYPE_LEVEL_HIGH:
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTMODE, 1);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTPOL, 1);
+			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_level_irq);
 			break;
 		case IRQ_TYPE_LEVEL_LOW:
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTBOTH, 0);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTMODE, 1);
 			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTPOL, 0);
+			sprd_eic_update(chip, offset, SPRD_EIC_SYNC_INTCLR, 1);
 			irq_set_handler_locked(data, handle_level_irq);
 			break;
 		default:
-- 
2.43.0



