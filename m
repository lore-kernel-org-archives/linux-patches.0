Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B840A2D8377;
	Mon, 27 Oct 2025 19:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592686; cv=none; b=RdyX3EBKi6L5zxc0lZiLx8wJ0X9LkbB7L/3CAMUahoxosXxKg0kJWbAZBAb++mWdnJlpVLRajYessgbPCAjLmItjz3BXIoPZLtAuLq4X4IywMAdCvEx571+pKIA0+kQitHkPMRzUdcY5Q+ykkR5BWclj9n+I/vEPqJS8DKzsks8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592686; c=relaxed/simple;
	bh=NsIhEHBJmTIKG0I2qzGFqcm1wkijAspUgebsWeZu1CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJBVHyJL6D/iNGPZU0fOrySd7L6gbdpg0ZwX7PbWTI99suEksvEI3R8AGJvZgjUck+dFYoIA7sllitV2PE0Xoug3GZ0o2i97hNDFdC2JTjWaPTlJfhiMLJI/2mhKofQ+btdTehEKDEmdPcRIsHmU7VnaSC62kRK3QvnE5ydfT1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/ae2QN8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/ae2QN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01DC2C4CEF1;
	Mon, 27 Oct 2025 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592686;
	bh=NsIhEHBJmTIKG0I2qzGFqcm1wkijAspUgebsWeZu1CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/ae2QN8TdaPdlfonW0xagILpsngQGR1W30MnHxscLec1yWyXayvBYibKWwdsWNQb
	 VghZ3fek4M11TJgTZfsXIMuIixxVw0iVmDZC/otKT7c2Cffd4gULvDPpczYVPJk3C9
	 /teqssn44j/5gDUfSq9KL1o2RheI09727K+RRq1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 56/84] gpio: ljca: Fix duplicated IRQ mapping
Date: Mon, 27 Oct 2025 19:36:45 +0100
Message-ID: <20251027183440.312955394@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
References: <20251027183438.817309828@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 4c4e6ea4a120cc5ab58e437c6ba123cbfc357d45 ]

The generic_handle_domain_irq() function resolves the hardware IRQ
internally. The driver performed a duplicative mapping by calling
irq_find_mapping() first, which could lead to an RCU stall.

Delete the redundant irq_find_mapping() call and pass the hardware IRQ
directly to generic_handle_domain_irq().

Fixes: c5a4b6fd31e8 ("gpio: Add support for Intel LJCA USB GPIO driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://lore.kernel.org/r/20251023070231.1305-1-vulab@iscas.ac.cn
[Bartosz: remove unused variable]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-ljca.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/gpio/gpio-ljca.c b/drivers/gpio/gpio-ljca.c
index dfec9fbfc7a9b..ddd73b8b790e7 100644
--- a/drivers/gpio/gpio-ljca.c
+++ b/drivers/gpio/gpio-ljca.c
@@ -281,22 +281,14 @@ static void ljca_gpio_event_cb(void *context, u8 cmd, const void *evt_data,
 {
 	const struct ljca_gpio_packet *packet = evt_data;
 	struct ljca_gpio_dev *ljca_gpio = context;
-	int i, irq;
+	int i;
 
 	if (cmd != LJCA_GPIO_INT_EVENT)
 		return;
 
 	for (i = 0; i < packet->num; i++) {
-		irq = irq_find_mapping(ljca_gpio->gc.irq.domain,
-				       packet->item[i].index);
-		if (!irq) {
-			dev_err(ljca_gpio->gc.parent,
-				"gpio_id %u does not mapped to IRQ yet\n",
-				packet->item[i].index);
-			return;
-		}
-
-		generic_handle_domain_irq(ljca_gpio->gc.irq.domain, irq);
+		generic_handle_domain_irq(ljca_gpio->gc.irq.domain,
+					packet->item[i].index);
 		set_bit(packet->item[i].index, ljca_gpio->reenable_irqs);
 	}
 
-- 
2.51.0



