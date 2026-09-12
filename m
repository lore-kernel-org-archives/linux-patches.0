Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61A71C5799;
	Sat, 12 Sep 2026 18:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239497; cv=none; b=eW28YeWaOKQTI8jxvlelTqvGDwDq3CFcRdqSsAanhS1Pk22nI/2tIN/G194LeIaegwE3v7edwKraWO9DU3I5zzAfihLkUaL9HY0gPzwIYQjBQZ+lgWOLqqk1rmlVEGyDa8d0QrOpgAxNbSuT53862WZk7AwPdjIJAqvKGoqJxCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239497; c=relaxed/simple;
	bh=h6gmkIA4wspTQKa6XNdqOXbbkskvoz8Jql9dVDLDg8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxHcVbSiVhWr+8e7TOHT1NLY2WhfEm6sB59W17yQY9iulCfHwUip3CGxXBTmC/anTMinfveXRs12Tax89Tb622GKUO4vtFms+z2ZkgY5isf5DZnNOJ3IKQSWEG43lHwW+DMXuJuB6M3HwBq9WioaQR+bh/1bT8W8XIgztoXQ1xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hyg6Dvdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hyg6Dvdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4404A1F000FF;
	Sat, 12 Sep 2026 18:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239496;
	bh=t7Z7Tv0mzdL2sfv1GcKKa1b+lWT2KQLOCGh8SjiARiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hyg6Dvdv0/zVTXy1rMVsDhBmgfOoE7UXWo67siEAVliIPhH2fdkVhDfpXzPEkwI5p
	 jDAUNLJVGzpQZnRv1rsdPQ3pv9mjSi831Rj3ok+4dgrb188TCSSiSd73g3cEthqsXx
	 plNQgPpdVThWQuAk90h8jxP1Yi0K81xC05jmREnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 634/935] power: supply: isp1704_charger: cancel work on remove
Date: Sat, 12 Sep 2026 09:01:04 +0200
Message-ID: <20260912065541.381546080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



