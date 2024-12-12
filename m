Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4AB223C48;
	Thu, 12 Dec 2024 17:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025164; cv=none; b=WaFB8Lj4El2q89N8TNSGsNB9QChc2pxlT0zufZdDLVsiVL0eY1TNoEoy9vt6Z2NmGREIPd1VQ+LI1S9HT4oXrp+wyz9tsETMm//slBxUdVcMe5wJlgEaI23LDsBPf0XCwg6B1SD/krDVY9ZKnQZ2Owkv/DHPOD73o2knfNPwKaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025164; c=relaxed/simple;
	bh=Uj7NLUqSm5bG+CkvQ8HGFmACHXWcSy52OLefetMg4Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmCAwZgyHSbpz/86SXo1KTDbWBTBxss9HkUB9jn8LHYqK6JkTGmaV0GE5FB0xjtR/IaMKDRKYNMYTgaDzz3WxEAp07pu2pQyOO1OnOOyw53WpnkRdYIcQh0pRlZ9ruhgfO034cRvrCoyX3VU4z5bNQDUyU0rIunb9F7QA/27sJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/INBLqW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/INBLqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B8DEC4CECE;
	Thu, 12 Dec 2024 17:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025163;
	bh=Uj7NLUqSm5bG+CkvQ8HGFmACHXWcSy52OLefetMg4Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/INBLqW1XGG6GBfmflQ+Wb9rL+lZIk7o2TX1JFAeJ6GOj18cEJ6vvs+YKS5fHgQY
	 M2V2ekQVjqJGfabTahil3Py9ufuuVE7QCdFF71ZLyRBT59L8xS0DKjSbijiks7N9pq
	 aqWuypckvgNtHsfjpCA3i7humlWaNnskDHwl1xFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 047/321] soc: ti: smartreflex: Use IRQF_NO_AUTOEN flag in request_irq()
Date: Thu, 12 Dec 2024 15:59:25 +0100
Message-ID: <20241212144231.850969525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 16a0a69244240cfa32c525c021c40f85e090557a ]

If request_irq() fails in sr_late_init(), there is no need to enable
the irq, and if it succeeds, disable_irq() after request_irq() still has
a time gap in which interrupts can come.

request_irq() with IRQF_NO_AUTOEN flag will disable IRQ auto-enable when
request IRQ.

Fixes: 1279ba5916f6 ("OMAP3+: SR: disable interrupt by default")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240912034147.3014213-1-ruanjinjie@huawei.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/avs/smartreflex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index 2365efe2dae15..2fe4dbbab46d2 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -213,10 +213,10 @@ static int sr_late_init(struct omap_sr *sr_info)
 
 	if (sr_class->notify && sr_class->notify_flags && sr_info->irq) {
 		ret = devm_request_irq(&sr_info->pdev->dev, sr_info->irq,
-				       sr_interrupt, 0, sr_info->name, sr_info);
+				       sr_interrupt, IRQF_NO_AUTOEN,
+				       sr_info->name, sr_info);
 		if (ret)
 			goto error;
-		disable_irq(sr_info->irq);
 	}
 
 	if (pdata && pdata->enable_on_init)
-- 
2.43.0



