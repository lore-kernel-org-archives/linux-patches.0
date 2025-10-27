Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798B018A6A5;
	Mon, 27 Oct 2025 19:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593481; cv=none; b=bCUw8n69k/Y092n5AeEbYukm6j0grcSupPK3FYtHHDx+yqQM6rOc4v9uwSI3gXEUK21TkiHQpust2cOoycH4GR1OZw2iSkoZ7IU0zSwN24Qw8XTh2Dhoo3QiCNmIFc/ZsuA2t0U8ujwJpnNTwgH+1FGK6++zjtflpQjIiwh2CgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593481; c=relaxed/simple;
	bh=h7Rsys6sTpyYZpgxtWrdQMams7ANa7ghIw5vaIMbyNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kf7CcsXhDSDqdVDRH/XTQ5EVxpvJSYt5MXUbxEWiIeW2dD/ad6wVUQ8sm+MZzIrz0LWRAG0Z3bLcVCprx1xgUpIvGjlHfKRyW0eJpjUL8AaI9tmmYhGtfg76RPgzOF9fWE7+aYIX5e/v8Mv5Yp9E/F/Nd59HMDw130nCM2Zo9V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SatoigoQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SatoigoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8520DC4CEF1;
	Mon, 27 Oct 2025 19:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593480;
	bh=h7Rsys6sTpyYZpgxtWrdQMams7ANa7ghIw5vaIMbyNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SatoigoQqVV+jPmPr+TiNC9oi9sQYusrfnNlMRBA5bvLB4G9d/BKP27pKG1w9wgmG
	 +eVmeepBjbsDBLnNFgMu5G8A3bNcy0UuRUxfHSlJqY0iS6vCZMC5hlaUhXCZFLbY53
	 ehD0kpWU4UmJ/F8F2XSOcuCTL8SVcIm5rThIs/h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 146/184] gpio: ljca: Fix duplicated IRQ mapping
Date: Mon, 27 Oct 2025 19:37:08 +0100
Message-ID: <20251027183518.871035211@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 3b4f8830c7411..f32d1d237795b 100644
--- a/drivers/gpio/gpio-ljca.c
+++ b/drivers/gpio/gpio-ljca.c
@@ -286,22 +286,14 @@ static void ljca_gpio_event_cb(void *context, u8 cmd, const void *evt_data,
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



