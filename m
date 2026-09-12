Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDDF2DAFDE;
	Sat, 12 Sep 2026 15:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225469; cv=none; b=hCVO35SCFWRWJyzSaZYCc+8Qjf4YHhsdsceWNU1jNYx6UoFPmbejTRG9j/uYG4KAgFzcXf28KE4Wu7p45J9C7oqLD/zRfU1jacyg3u50mJ2qy1op54BABWQuFEwea9YTXLODwQOhzazfMVt7xKQmJConxGfvorDVr0MbrzFV+Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225469; c=relaxed/simple;
	bh=K6wyIJ0lEsI87knnIY5XNqCWbeuGYXsEOmxfE+oGAXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=awex7Q7MCuYfMU6t/3jTSBgqTM94FKq50SFhVpOstRzHFQMSoRl3Ka63GB55m+KwsWzEtnc2KZuia/6FI7SKYIV4OOJ1NfKIEDptvTeGVACZE9qTyLa2YFF1cqFqH/B0ohl+SCkiVc2UVnYlX7xq44Jr7XdG8yMWPwRE5UrtxwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqoFaraJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqoFaraJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B84C1F000FF;
	Sat, 12 Sep 2026 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225468;
	bh=3zSsPwkGeS0B3w1el3VtO7Bo505m9qbyzBxmw5khHUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GqoFaraJ1e0G/OsCmyNxN1ElDNR5i+R+tF7XFdeCnGNOKiaCeYfZyzdKo5sW8JwbY
	 DLvYFSTWcdZ/Cn7pruSJz4+5mRB3h+xmdAH0R1XM67Op3phnxd9/mZCmM8ZzXjedpB
	 FF2zHbMm7zl7lZj8EXHHaFtTaUCrgMjDFqNH7MwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1204/1424] clocksource/drivers/armada: Unwind timer clock on init failure
Date: Sat, 12 Sep 2026 09:00:36 +0200
Message-ID: <20260912065634.247874784@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 6ec565d6939ad..49735ced52bb8 100644
--- a/drivers/clocksource/timer-armada-370-xp.c
+++ b/drivers/clocksource/timer-armada-370-xp.c
@@ -346,7 +346,11 @@ static int __init armada_xp_timer_init(struct device_node *np)
 
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
@@ -384,7 +388,11 @@ static int __init armada_375_timer_init(struct device_node *np)
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
@@ -407,7 +415,11 @@ static int __init armada_370_timer_init(struct device_node *np)
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



