Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDDC4F392C;
	Thu, 17 Sep 2026 15:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659856; cv=none; b=AGpBB2V8Cd9TuqSL71a8EGvCr5An9CPWs5EX+GeT6YkflIOBVViZJVyS01VEmmfuLF9xnObHc+zCvcw8CP2oKteRCOz257cw4wZ8Jgb8z4zqKLeLSsqZcaHj+oOyTrtOTI4+XTfCD0m0h/3ODPQ+O3HL7lHQNiahu6d3px4QwNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659856; c=relaxed/simple;
	bh=wtbFhjsQBlmUmduKfLzYE1nwKp8Pu0ncCn7TnvwUMBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JO5K4dTWi7ytpSciDG0rx4X7JM/XoR5Z1R1i8q8qZCLJiPo2eMXmGkCm1XtW1JNEOB7nyxVCyVs+9J9naA25SA58KTLfdIE0AKNxnsAz+NraZpDESvHubmClZ2CmAYm2k9+bVL8Q/cJmndlAG2DS4jUfkc7Kufnf6LfbrQzx3wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uFvVBCXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uFvVBCXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D191F00893;
	Thu, 17 Sep 2026 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659850;
	bh=BdmBZAE2FsFYcVQjw9Er9Vx909qiyyq3b7yWjdom3s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFvVBCXhADDEoQJssukzlsYVjn5p8gZYvJ1L3j6U2PjVoKMvLoX8/o5fkKdAKGkUb
	 Rwjc+Qh1qseLjdvq9uQXHdu3mwhGNKh1KH2vqQ9qNo9xtonUTOse+R5jMuLqtVdJe6
	 SGtaFfaX8kwgzq2ADF7J886WL6eYDVht5TEKlMeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 395/733] watchdog: msc313e: Fix undefined behavior
Date: Thu, 17 Sep 2026 16:11:43 +0100
Message-ID: <20260917151401.564303597@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit ab390021b2a3bb4cc875f28a6f76d13de90d7457 ]

readw() returns a u16.  Left shifting a u16 by 16 bits yields undefined
behavior.

Cast to u32 explicitly before the shift.

Fixes: ffd264bd152c ("watchdog: msc313e: Check if the WDT was running at boot")
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260828161348.13212-7-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/msc313e_wdt.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/msc313e_wdt.c b/drivers/watchdog/msc313e_wdt.c
index c7d558fefc860..e28261c7a8d4c 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -31,6 +31,16 @@ struct msc313e_wdt_priv {
 	struct clk *clk;
 };
 
+static u32 msc313e_wdt_get_hw_timeout(struct msc313e_wdt_priv *priv)
+{
+	u16 low, high;
+
+	low = readw(priv->base + REG_WDT_MAX_PRD_L);
+	high = readw(priv->base + REG_WDT_MAX_PRD_H);
+
+	return ((u32)high << 16) | low;
+}
+
 static void msc313e_wdt_set_hw_timeout(struct msc313e_wdt_priv *priv,
 				       unsigned int timeout)
 {
@@ -139,7 +149,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 		return ret;
 
 	/* If the period is non-zero the WDT is running */
-	if (readw(priv->base + REG_WDT_MAX_PRD_L) | (readw(priv->base + REG_WDT_MAX_PRD_H) << 16)) {
+	if (msc313e_wdt_get_hw_timeout(priv)) {
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
 		/*
 		 * Keep the clock enabled. The watchdog core will skip the next
-- 
2.53.0



