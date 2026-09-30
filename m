Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86363BAD84;
	Wed, 30 Sep 2026 19:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795446; cv=none; b=ZPps7Z68P5NJ6F+7SKMUlbLo14pzpOGJCAXSlt/85ZxCdfUVu41m9aN/GZNTeS/AtiEFWqECTausLvfmrMqI2kY8PyV6+iY3aetwGZO+QoTxY5dJvvGuSaVn3f+RnKgNN45HOpDAZdJgIuOQvDfMWQu+P1kMH4qSqk+s4TTuzcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795446; c=relaxed/simple;
	bh=7o6MOGvwOBsoEc3/QGuJ3OguYeD8R1Tp3ALkDEN2Nv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF95HJTQtjPTJ0B1qASZd2/NsCC1bkR8APu2V2JltBAF3AYNyRTkUjDF6iwx1KBPRI4T/aF+BimoC1xZcvbQhdIaAtaG/Tocwk/uU7pD2DX/whb46yxH5H0gXiv5kEPeeR5k/Vq1Lmsak3AscsyHOWPc55Xl+G+Q55A4kYRxcl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTwFgwYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTwFgwYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4D71F000FF;
	Wed, 30 Sep 2026 19:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795444;
	bh=/c32oMJ+PvMPhyewwqtuJQ164XrywqKSlhhnXAOqhaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTwFgwYV0zY7EqUIG2CXVhO9Q6VCr0LR3rudYHZJelUrDPINJjltdiEsFYuCxCot6
	 BRiycXpslx+7aJpRQqNBElt7OwhbsAl5vr6PvTIkxhN1at6lxlw5/9ZvUcHd16F0rK
	 wvc28kIorPZl4KJ1UmYqz/bzGMZ6sA924yBInHG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0562/1193] watchdog: msc313e: Fix undefined behavior
Date: Wed, 30 Sep 2026 17:20:46 +0200
Message-ID: <20260930152446.725296388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 9cfe059fd31a7..72620adec641a 100644
--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -32,6 +32,16 @@ struct msc313e_wdt_priv {
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
@@ -140,7 +150,7 @@ static int msc313e_wdt_probe(struct platform_device *pdev)
 		return ret;
 
 	/* If the period is non-zero the WDT is running */
-	if (readw(priv->base + REG_WDT_MAX_PRD_L) | (readw(priv->base + REG_WDT_MAX_PRD_H) << 16)) {
+	if (msc313e_wdt_get_hw_timeout(priv)) {
 		set_bit(WDOG_HW_RUNNING, &priv->wdev.status);
 		/*
 		 * Keep the clock enabled. The watchdog core will skip the next
-- 
2.53.0



