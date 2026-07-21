Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3952D8376;
	Tue, 21 Jul 2026 20:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666666; cv=none; b=NcsPENx5m7SDwXI4OI3FMUBeOOFUYYc6HLbHZOOj40+P83HnnRyPWR9XogvNcNLt5AMY8RrXsqnu9mOFLrubAOIpWNE1OM2IRWJSMekCpkNcW41LBAS05JFD5ekFny2K7ZvGr2OeE1xCHTVuqxfP7ppXUs3di6AcBYxFDfIk8dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666666; c=relaxed/simple;
	bh=C1eCPTvAhHgntfx/2Wse4mwk8Dh4wNQNuKM9r/xEMcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh297AFEPOg9ogS2kP+iFCuE+L8eh0Gd/UFju80f1IKf6Ppl1anY6Kb5dBy8E+WBicuJRfW8ou/r/mAox8ayabnelFtbffFDQIh1wsFw/Rv+/ZssnGN08CBL14mwZiemkTveGabRWT2WvymFId/IQBiulrkCaJ8zy2tc6YXSxwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+S+R09z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+S+R09z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABE741F000E9;
	Tue, 21 Jul 2026 20:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666665;
	bh=VjZDjd3kvBEcm7kkIizbHHYxNvOmq2g8EUx91Dda4NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+S+R09zw5p2WxG+jRE0t8tMiD7i+Tp0GhvuG3TJsU+7vjAlUVDguvNh/5PKtw9fF
	 w2k+9gH+Aa7M9sP3isPtczA/H4IMqyjbS8NcURyz8S9/1DqcZWDekfvKrXKG94HSof
	 Aeb0v3+8VF9vknLORtuBILxrvrbkkgX9qWUo4sI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0768/1266] rtc: msc313: fix NULL deref in shared IRQ handler at probe
Date: Tue, 21 Jul 2026 17:20:05 +0200
Message-ID: <20260721152459.047116398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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



