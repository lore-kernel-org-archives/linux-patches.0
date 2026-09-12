Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694753A7820;
	Sat, 12 Sep 2026 20:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243411; cv=none; b=o1MHFhi3RbwbLV+Viz+e6MWfoHjJkegEadY+nD0G/f7+5jYj9BC9fjI01oDM11vFjjxCb66BF2khxctR+aXyilKNlu7q8E3cAEl20oi3gbt92mFGYG/n13ur3LDBTv8OqTPwYlyPtWA4E3HrIafRrG/teF9MrqmY3GuvVG7KA7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243411; c=relaxed/simple;
	bh=L+Z5FyDM3eFXQ1Re75j62WUujR8+P60yJzuzvZWjj70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYlvMc/Mn6Z+T2beQCf7eErpA/1eO/jq8v7Xl6B7MN+Z7CcvOstAjTJ5MdNLCmlKH0adVBYY4uLaqyjUItUrNVqz1qXsizWureuc225iSiEIUIcY2vQx37/ExRXSPXqlOfbpwPncPsjB9cuqHPJaeApXFeetHmWoxziQ7mNeeXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8h0Pujp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8h0Pujp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF771F000FF;
	Sat, 12 Sep 2026 20:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243410;
	bh=XynV/xvTQIEnWSTbBqwD2RF/V7J1IZgB/BIQiPfohiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8h0PujpY1jOdQD5bXmnhydiGaU3sohCN09g1KR6iWsYXm8fel/RxlSv+xqLl9wcP
	 GS4efpZu5vug/uzgkWR/5JHuE94Q9Fl0AUsavPI84SUUnVPAis6EJ67V1dmXUUwSat
	 Bz4nS/ygAwPu7kmSbeeku0/4iZYu1N4Y40YYiXAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 703/798] clocksource/drivers/armada: Unwind timer clock on init failure
Date: Sat, 12 Sep 2026 09:05:31 +0200
Message-ID: <20260912065533.205490822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 8b4127f6db40381229f3564d34ac35f36311c201 ]

The Armada timer init paths enable their clock before calling the
common initialization routine. If that routine returns an error, the
clock is left enabled even though the timer was not initialized
successfully.

Fixes: 12549e27c63c ("clocksource/drivers/time-armada-370-xp: Convert init function to return error")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Link: https://patch.msgid.link/20260802213545.565913-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-armada-370-xp.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/timer-armada-370-xp.c b/drivers/clocksource/timer-armada-370-xp.c
index e3acc3c631b72..a3e803fb8b1ee 100644
--- a/drivers/clocksource/timer-armada-370-xp.c
+++ b/drivers/clocksource/timer-armada-370-xp.c
@@ -349,7 +349,11 @@ static int __init armada_xp_timer_init(struct device_node *np)
 
 	timer_clk = clk_get_rate(clk);
 
-	return armada_370_xp_timer_common_init(np);
+	ret = armada_370_xp_timer_common_init(np);
+	if (ret)
+		clk_disable_unprepare(clk);
+
+	return ret;
 }
 TIMER_OF_DECLARE(armada_xp, "marvell,armada-xp-timer",
 		       armada_xp_timer_init);
@@ -387,7 +391,11 @@ static int __init armada_375_timer_init(struct device_node *np)
 		timer25Mhz = false;
 	}
 
-	return armada_370_xp_timer_common_init(np);
+	ret = armada_370_xp_timer_common_init(np);
+	if (ret)
+		clk_disable_unprepare(clk);
+
+	return ret;
 }
 TIMER_OF_DECLARE(armada_375, "marvell,armada-375-timer",
 		       armada_375_timer_init);
@@ -410,7 +418,11 @@ static int __init armada_370_timer_init(struct device_node *np)
 	timer_clk = clk_get_rate(clk) / TIMER_DIVIDER;
 	timer25Mhz = false;
 
-	return armada_370_xp_timer_common_init(np);
+	ret = armada_370_xp_timer_common_init(np);
+	if (ret)
+		clk_disable_unprepare(clk);
+
+	return ret;
 }
 TIMER_OF_DECLARE(armada_370, "marvell,armada-370-timer",
 		       armada_370_timer_init);
-- 
2.53.0



