Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1503A388860;
	Thu, 17 Sep 2026 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670735; cv=none; b=EBjNAzHW7eBe+qaMlhOBlPqKTpUxmWwat5HA+CL1ItbMmd5D7gdcwyJY1Z70OHpuYgVNOm+PRfwnF8HfTHPxPds/U31Cq1b5lklOX6NNz3Lprm+tm2tNPMc8nRU61iLwi+bq5DV8jJI6XItyU9ucb7Kh6sdIp7+duWFC/mYbXRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670735; c=relaxed/simple;
	bh=WBQiUg9m2pMzUYt5xD9AmYKs+7GgI3ORgQxZxdtM7LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7Vla+IfbMhePseuk08oZ98bDQcYmpXqfdyDbvdb4Pv1XVwfKtyiH7O2MwtLewxnHLAueU0AOIBFCB7YGuJ0mofzxORcDFYJ5LfDBvlMJBspxWI32KWtAhXODzJjRW2C7JP2FHxgiePaPdaZjVTLAnnenT5zfmFOwC8FxBK8n9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ppKqfWo1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ppKqfWo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240F31F000FF;
	Thu, 17 Sep 2026 18:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670733;
	bh=xU6As8dol1XBpu5YD7jS6Pxd2UwIn7GEmRCJtu+66Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppKqfWo1y+Ss+NXxSlc/Gr4Naa8l1UK4qm8FouG007sYsYkOVlmh7TQY894uWx1hb
	 SMWpS9KiueWkZFn8688nzX85s/DuN8gYUd6W3rIuBoccGKXtaI5KCnzG43JRH38RAH
	 g2TAC0tp586ZOdFDnTtEaXAQW2q04qUkmroJDHuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0752/1102] watchdog: msc313e: Fix undefined behavior
Date: Thu, 17 Sep 2026 16:11:35 +0100
Message-ID: <20260917151559.301300575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



