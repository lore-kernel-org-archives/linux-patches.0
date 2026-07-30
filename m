Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6DF441612;
	Thu, 30 Jul 2026 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423940; cv=none; b=fPjquv1s1FLChQhb82Hu9cDF+wVBAOC6Qh48wnKEfUkrfXeWW9L9JhIAUNZs7RtG2TNRdX91Hm8MWj65CcKXPzdBOYKQ/bVPu4dW16iaN2sPRrdHt+sbIM3O9SyBzvwSoa0HqR7PzLob7k0WsyneAfFQ7cyqeS4xUbckbAmCn6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423940; c=relaxed/simple;
	bh=kigszDCmFKLATbcJd4IzJlGGWdKc8OugzW68gJ4td+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u7yUBko4x9WmZM3QFsOIBUlYQGjUmTvWmExViA5X5vn7KJ4Lr5nj/STYK+UiCgUBc3lx8j5iNV3mwdmZ8EQ635iRIhHHhJ9YILapAuZD+ntYlPVvwDOE6pEorkE6b2Fr5fCj6c5a3pnM9y44mA3B2GsU1ac7PJ47WK/pVAp83Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJan6YhC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJan6YhC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D611F00ACA;
	Thu, 30 Jul 2026 15:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423938;
	bh=g32uA3k9sEAHPiGrJO6wetQAcgLKFNBZj9CuJwC/UkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJan6YhCvSKNCiRs9coBKEJN4fbuBGNmwzkqbqld+nG3z4CC8U6cCc1wPrmmeBR2W
	 6V5YYZnyiyw0XxZaB+NsTetqbrLOA6isMp2wSGka8i1XhR+VgKnmDpuCy1rTAKkmYq
	 9mrVQewu1Q9+aVAwgP3vzIyTVF7npvme3fI/2nms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 174/675] watchdog: airoha: Prevent division by zero when clock frequency is zero
Date: Thu, 30 Jul 2026 16:08:24 +0200
Message-ID: <20260730141448.836001785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen Yan <win847@gmail.com>

[ Upstream commit bcfcd7619f277842430d197556463b401b839ee9 ]

clk_get_rate() can return 0 when the clock provider is not properly
configured or the clock is unmanaged. The driver uses wdt_freq as a
divisor directly in airoha_wdt_probe() to compute max_timeout and in
airoha_wdt_get_timeleft() to compute the remaining time, which results
in a division by zero.

Add a check for wdt_freq == 0 in probe and return -EINVAL with
dev_err_probe() to prevent the division by zero and provide a
diagnostic message.

Fixes: 3cf67f3769b8 ("watchdog: Add support for Airoha EN7851 watchdog")
Signed-off-by: Wayen Yan <win847@gmail.com>
Link: https://lore.kernel.org/r/178347932594.81327.4834644880399144119@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/airoha_wdt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/airoha_wdt.c b/drivers/watchdog/airoha_wdt.c
index dc8ca11c14d81a..4bd333189b87ec 100644
--- a/drivers/watchdog/airoha_wdt.c
+++ b/drivers/watchdog/airoha_wdt.c
@@ -147,6 +147,9 @@ static int airoha_wdt_probe(struct platform_device *pdev)
 
 	/* Watchdog ticks at half the bus rate */
 	airoha_wdt->wdt_freq = clk_get_rate(bus_clk) / 2;
+	if (!airoha_wdt->wdt_freq)
+		return dev_err_probe(dev, -EINVAL,
+				     "invalid clock frequency\n");
 
 	/* Initialize struct watchdog device */
 	wdog_dev = &airoha_wdt->wdog_dev;
-- 
2.53.0



