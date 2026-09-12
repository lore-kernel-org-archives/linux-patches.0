Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3C12BDC0E;
	Sat, 12 Sep 2026 10:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208844; cv=none; b=PKYnxPzl25x0IAQvnRf9poMgIlfxlvnpbvtwXhBWXPOk81PgqLnWW+FZpHpIGhpt9a+G+G2wcfE722e1fyMGGcg3+5Xn5KXrP5nR0Y8T90iSPszJQu76CwUDGlCRQvfzd2uBiZXAdZv3x0uMWWIqrY5lBml0gHLlLH108Y5Ne08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208844; c=relaxed/simple;
	bh=Qp/kVbSGgby9Q40KkCcftwkKqu3asZdT0c9HkmZyU+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtI7bi9DPzZxsfEEA780VLYtYnkyS+s9RE4Jp3Aa9SK+bCpBW0oiuby5UrgCsaMk9oErv1eDwTQmnuAEMTMkCJ/4DekiUFrBj4DK2s8wPOkfQqaENQIz680IiURgMCf+94T2UNe3VmfjJpvwqduvBEJiZDMWHu6AHi3z6RKDfpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1NvekKM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1NvekKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707F31F000FF;
	Sat, 12 Sep 2026 10:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208842;
	bh=j3/prZVX0niVp34xlYQlHQzNJAMfXAYClZXvlW2ybqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1NvekKMMbnfT1uoqKG7KHI5ELjQz1Bsr6YVhnzyjRP8zmTXbkh3osMe7AH5Hn1Ej
	 YRPMYmBPyvL6W7bIkn+vlCilq30zsh0i/9yz1OHwfKDW51GgZZ+sB3LdbqIhLj5lBb
	 zanNiWJaVunAIHu+kdNL010s02Wjmwk5AOGAZxjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0701/1518] power: supply: isp1704_charger: cancel work on remove
Date: Sat, 12 Sep 2026 08:47:50 +0200
Message-ID: <20260912065639.291428623@linuxfoundation.org>
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
index 237912a922724..e329321d06dbd 100644
--- a/drivers/power/supply/isp1704_charger.c
+++ b/drivers/power/supply/isp1704_charger.c
@@ -482,6 +482,7 @@ static void isp1704_charger_remove(struct platform_device *pdev)
 	struct isp1704_charger *isp = platform_get_drvdata(pdev);
 
 	usb_unregister_notifier(isp->phy, &isp->nb);
+	cancel_work_sync(&isp->work);
 	power_supply_unregister(isp->psy);
 	isp1704_charger_set_power(isp, 0);
 }
-- 
2.53.0



