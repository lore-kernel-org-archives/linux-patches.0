Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799074746C4;
	Sat, 12 Sep 2026 11:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211149; cv=none; b=oFXlbSeHFwWZ9TqVRZXMtXn3Tif6uiaOYkieNvFXRqm1WGe26rJfns/tbEBIe+c1a/9a4VFuaTxcF2QMD+FA3RnM0EWPSZ2Zr80kzFxzmyWR4QSfklg9WVq+MXzhBIK1cKgQeNC8E0FpkkKFIHpS6o5NJUdmu0heLum9Ap+C/Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211149; c=relaxed/simple;
	bh=zvbzJ7TTj0QLXuSq1+LzfI6x+QIkOLetFTfYnZnFc4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XICbFAmEq8d42+SwVdeRwuyCj+1odwae1tfaXyiPEiddkyVwv0w2PH1Dm+aGNWbyNJSClc+JtA9M/4PYhMmiZFxWWlVmSbA41XSPpAXRK4bpAUglFXA5ePEkhwVj7kiQeiU+UyJaLsgntFMWgz6H35RN5JqW5td1PTXncNfyCA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hf5wwJUE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hf5wwJUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D501F000FF;
	Sat, 12 Sep 2026 11:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211148;
	bh=7bBwzlEBkxlKQ7ta4dIitHRF4c93quEpxF7CWj4Z4aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hf5wwJUEdSoKd/WXUaBSs0woiVn2RJqNFnVUkPVnV2uMNkuNXWzmeeBUlSdg/C3sr
	 3FIvzeBsPXMdkyRFLbWS2Y0i5QeVn6VJ30HjqpAJEUrctuihcpI5/BO2uJuOWk2rZZ
	 yYzYSwkpy5xHAN93n/RPjqA1+RcQ0RQEur8B3pmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1171/1518] clocksource/drivers/armada: Unwind timer clock on init failure
Date: Sat, 12 Sep 2026 08:55:40 +0200
Message-ID: <20260912065649.962131873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 54284c1c06514..bcdec4d74628a 100644
--- a/drivers/clocksource/timer-armada-370-xp.c
+++ b/drivers/clocksource/timer-armada-370-xp.c
@@ -345,7 +345,11 @@ static int __init armada_xp_timer_init(struct device_node *np)
 
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
@@ -383,7 +387,11 @@ static int __init armada_375_timer_init(struct device_node *np)
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
@@ -406,7 +414,11 @@ static int __init armada_370_timer_init(struct device_node *np)
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



