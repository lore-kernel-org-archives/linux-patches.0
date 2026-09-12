Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423D1399352;
	Sat, 12 Sep 2026 14:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224470; cv=none; b=N+iWdxK7/Mrcl+S1GzC2YcRTkHZTlwPQTMo5CqRPRHvMAnyubWTXSZ7aPXsGcuG9CHEdKuXhb34X5ZaBMnc4jpGEDpUcVT4kjx2apnTlX0KKf1gk1kI1NDc9Gh0L7DnPi9qVWIaBBikTcabAhd3OgygYB6w1bISd2Fp79jJWipA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224470; c=relaxed/simple;
	bh=3kma98ZGpalz7pa933rSRiMiSlAuwsIKU2fGmqrFr7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAUgayZKXCiP6EfuHObOV4NkAqol7oSuwIaR1baAVfa/WvmoLYKECNz04haz3VTTjKaRcpriwZawuMMhlv1Sx7mHfHX9RyBZzom0RlWh6z19dBz6ol57GqHRraLa7jB6Ca91+ohS5YfyEh3Ky9UtE/4TAQhjXyD2S3jZaJBo9v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l74sffiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l74sffiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD211F000FF;
	Sat, 12 Sep 2026 14:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224468;
	bh=Kow2Hpvgonm4Kt7wjBMFsHqw4IT4eNstV8xLI5OZato=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l74sffiASs2Pl+3U+CkGmHVZM4vKjxYGsb/fEsXgZxhLQDEWCAQP3UWmd1ZFdflBH
	 3JN4b2QaYzMoAiSDkOyvRBgoo+yVrlf5OEBKUkLu/CYiIvBsD0AnLj9WWrjubH9kNl
	 gljaDtZpkAlNpErJoYa9JI1lXvZLrtZeTy7jHm/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0955/1424] power: supply: isp1704_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:56:27 +0200
Message-ID: <20260912065628.702964727@linuxfoundation.org>
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



