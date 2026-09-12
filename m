Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9276D38F620;
	Sat, 12 Sep 2026 19:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242834; cv=none; b=Wn2QeFrya4tsm/qjGVKtpL9y37so2AsJ7vacL2RFzIw/U5wzncFpv1EgKXVEt6ozDTYcFmmnuuRD4Nb6EdmLU0IgyqEQFBrUpKEU92qQilmY6n5g0MZ2kUS4LcTNb5Bdtz3NfixP1pmcfscWzAEf50zonRCXIUpvcdgypnwN6/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242834; c=relaxed/simple;
	bh=lpdQlMUJn0EAPv0NwY43otjk9tozdtfB4UjwJPDKZaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ls0tSNIlAvLzkmB9MQ7mQ36dznhOfoAWJXaj60w90UWeEjbLnEINKeQ1caap37cAdN1wq5NdbrP/93lukA37MyWVaNlSWR5Ps7p3rR78VWDPB4Cg0ptwNKid9A04V2kkWjy10BGIwAQ/gv6Xu/e04eUH/S0dyNXCZAlRYjLxV00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P08A+juP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P08A+juP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED27A1F000FF;
	Sat, 12 Sep 2026 19:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242833;
	bh=z0CLCS3MmuWJSAf2nxRa/2GY1sfNYhYGshcjXAx7ZZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P08A+juPpR+4zCoZ6noFU0Rt8tagFJ60gpcWB3Oh8HluZAaTwrrTA8eFLWEJbjzZx
	 4h8Z8LwEhc0H5lKJ4kZt4rvXc9ZmTDc/YXfPzFG8kWNWYpR2tHwz7QnDR1xTJ6uSKc
	 8jFTnKSm6ufl8utGia/iJcqSocvtWJruagyhArp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 543/798] power: supply: isp1704_charger: cancel work on remove
Date: Sat, 12 Sep 2026 09:02:51 +0200
Message-ID: <20260912065529.573608239@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 60c5b8a9ef4dbc5d69bbc1a960fe55826cb3b643 ]

The USB notifier and initial VBUS detection can schedule isp->work. The
remove path unregisters the notifier and power supply, but does not wait
for queued or running work before tearing down the power supply state.

Cancel the work after unregistering the notifier. Do this before
unregistering the power supply.

This issue was found by a static analysis tool.

Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260728123423.781-5-getshell@seu.edu.cn
Fixes: ec46475f3e31 ("power_supply: Add isp1704 charger detection driver")
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/isp1704_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/isp1704_charger.c b/drivers/power/supply/isp1704_charger.c
index b6efc454e4f02..2233dc9cefe08 100644
--- a/drivers/power/supply/isp1704_charger.c
+++ b/drivers/power/supply/isp1704_charger.c
@@ -482,6 +482,7 @@ static int isp1704_charger_remove(struct platform_device *pdev)
 	struct isp1704_charger *isp = platform_get_drvdata(pdev);
 
 	usb_unregister_notifier(isp->phy, &isp->nb);
+	cancel_work_sync(&isp->work);
 	power_supply_unregister(isp->psy);
 	isp1704_charger_set_power(isp, 0);
 
-- 
2.53.0



