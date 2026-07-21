Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8AA403EA5;
	Tue, 21 Jul 2026 21:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669604; cv=none; b=MKi0nskqvkR0J9/GKObYHiXq0Xc6+AGMz69BpMCKrIdvXQfDvzMzFuwaNOa6V3x6POZaNdn0jwQIO42A0yKnSIVIba+2LNJho9Nr2Qj78pM8uq0xnxzi0grka/qsbyczuZEwFXlf6I/EidUYUVJHTRRUI3A8I2ncot1+rWlmE2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669604; c=relaxed/simple;
	bh=Bc/sZHI4/BxiLF7szYLxqDAsX/4tqF4HCKQZf8sjTmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvEJQaTuPvCjED7OPgWGdeof8KIeNBM8Za+3KlvOZv5aWBRoRMhIvnVtMNoQQ9Jc5YlYZrZHxXKK2x0JyU3rZE7B5mejDlCkOO7hOpgEtn+kOSqtY4VieYyWTiflAUEN0qzuwV7X5wGyUgQHE9mpff2HCQ0uXyEk87zAGYwN6/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFHNfTW3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFHNfTW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A701F000E9;
	Tue, 21 Jul 2026 21:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669603;
	bh=Cr7wec2h2Y0UtonUIqVs7eyQG3dZt5nY0hitBv4hSks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFHNfTW3sCcRwhiHI2uyVSHSy5EtfnWIOlB8VvSYhyEGMjZc54Sa32GhT5VLTORUk
	 pIWoQnq0tQBKxZZzEntqD4uUvE7tlLPKg8CU19/q3SaXmfxcw5CYztWJ6vwG5OWp4e
	 MXHHgxtLOtVq/RNCsAduZxf8wquvoTeP8HTgSeQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0618/1067] rtc: msc313: fix NULL deref in shared IRQ handler at probe
Date: Tue, 21 Jul 2026 17:20:19 +0200
Message-ID: <20260721152438.426401903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

[ Upstream commit a369f48be8de426a7d2bca18dbd46c2ad1138803 ]

msc313_rtc_probe() calls devm_request_irq() with IRQF_SHARED and
&pdev->dev as the cookie, but platform_set_drvdata() is only called
later after the clock setup. With a shared IRQ line, another device
on the same line can trigger the handler in that window. The
handler does dev_get_drvdata() on the cookie, gets NULL, and
dereferences priv->rtc_base in interrupt context.

Pass priv as the cookie directly so the handler reads it from
dev_id without the lookup, removing the dependency on probe order.

Fixes: be7d9c9161b9 ("rtc: Add support for the MSTAR MSC313 RTC")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Link: https://patch.msgid.link/20260511032703.48262-1-sozdayvek@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-msc313.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-msc313.c b/drivers/rtc/rtc-msc313.c
index 8d7737e0e2e02c..6ef9c4efd7c92e 100644
--- a/drivers/rtc/rtc-msc313.c
+++ b/drivers/rtc/rtc-msc313.c
@@ -160,7 +160,7 @@ static const struct rtc_class_ops msc313_rtc_ops = {
 
 static irqreturn_t msc313_rtc_interrupt(s32 irq, void *dev_id)
 {
-	struct msc313_rtc *priv = dev_get_drvdata(dev_id);
+	struct msc313_rtc *priv = dev_id;
 	u16 reg;
 
 	reg = readw(priv->rtc_base + REG_RTC_STATUS_INT);
@@ -206,7 +206,7 @@ static int msc313_rtc_probe(struct platform_device *pdev)
 	priv->rtc_dev->range_max = U32_MAX;
 
 	ret = devm_request_irq(dev, irq, msc313_rtc_interrupt, IRQF_SHARED,
-			       dev_name(&pdev->dev), &pdev->dev);
+			       dev_name(&pdev->dev), priv);
 	if (ret) {
 		dev_err(dev, "Could not request IRQ\n");
 		return ret;
-- 
2.53.0



