Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044623624BC;
	Sat, 12 Sep 2026 08:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203547; cv=none; b=cfSSbIMDPoq0mTKM8/++7zu0JbFGO7A5XvjXrrt+noXmUoA6QUML3014s8CSICXuj5+EomZZVuwjGLJ/LVPYqRTiGaUmYiiKzH9xg9bWE15KbHUyevS9+Al6utkBarHOkslRM95u1nOLumKfSshzewKITfEZfwd23eApJ/4epOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203547; c=relaxed/simple;
	bh=N4iVxOrIq0y7BKcmY13eL3pou3OIRHUdR9IPPwcMTFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEQN9wjOYpI2oWhT1okMgfuiSrh1BbxTe9vgxEKrDWVYy5cN8nTdtBfMsZyXXaaAyVOuJC7Slw92iQZ47slQNw1B/p0q3I3goPv0hnjF89rZ3tWAsyODsRnCQBqiEkVKAqEt9H7csDLaemIOtF/9iQZHItZ93sqVmphjwOM4bqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhybnBBA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhybnBBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4951F000FF;
	Sat, 12 Sep 2026 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203545;
	bh=pwUBGQ1Voc+u5UVOGq8tKjIYKllmgZGNjQflbwnoqQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhybnBBAXFRC2iEqT8fcuT0EydeMoPSBmlZGrqpkn//9lLN+UzOcVpkMW88aJZYdx
	 IPBZMYBA2HTzDwbmocE7DawL+SafNOSQeCvzLNoY+hZmnqTP75kL2ojZDApnURFkLa
	 IofE7eQuqbmAAzaEVaYbb+O6yPtsHsSkaP6gHXYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1431/1815] clocksource/drivers/armada: Unwind timer clock on init failure
Date: Sat, 12 Sep 2026 08:53:01 +0200
Message-ID: <20260912065722.611943564@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index a405a084cf72d..b5a984aa1cbbb 100644
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



