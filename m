Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EBE5683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019EFC4339B;
	Mon,  3 Apr 2023 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531071;
	bh=5RJSKIK5ew6Sg+i0x6krCE1POLGK0hC9xrp4doolEGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpi/QC74kNWxwvizLxisFTto0dMCNiQ7ZhVEKEaXRvGIHSPTcnolXyGFpKVDq4B+O
	 pAKQSXiUJZ4DbPgxQfhlD+x9j3x1MtFolaTsLe96nlQD8yS49dXzEskQlYx2Nf6P4l
	 kmsu5aZbnyrEjeFG1oR28sGaEGamlPHwzY5wmmvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 01/66] power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition
Date: Mon,  3 Apr 2023 16:08:09 +0200
Message-Id: <20230403140351.708118231@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zheng Wang <zyytlz.wz@163.com>

[ Upstream commit 06615d11cc78162dfd5116efb71f29eb29502d37 ]

In da9150_charger_probe, &charger->otg_work is bound with
da9150_charger_otg_work. da9150_charger_otg_ncb may be
called to start the work.

If we remove the module which will call da9150_charger_remove
to make cleanup, there may be a unfinished work. The possible
sequence is as follows:

Fix it by canceling the work before cleanup in the da9150_charger_remove

CPU0                  CPUc1

                    |da9150_charger_otg_work
da9150_charger_remove      |
power_supply_unregister  |
device_unregister   |
power_supply_dev_release|
kfree(psy)          |
                    |
                    | 	power_supply_changed(charger->usb);
                    |   //use

Fixes: c1a281e34dae ("power: Add support for DA9150 Charger")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/da9150-charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/da9150-charger.c b/drivers/power/supply/da9150-charger.c
index 60099815296e7..b2d38eb32288a 100644
--- a/drivers/power/supply/da9150-charger.c
+++ b/drivers/power/supply/da9150-charger.c
@@ -666,6 +666,7 @@ static int da9150_charger_remove(struct platform_device *pdev)
 
 	if (!IS_ERR_OR_NULL(charger->usb_phy))
 		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+	cancel_work_sync(&charger->otg_work);
 
 	power_supply_unregister(charger->battery);
 	power_supply_unregister(charger->usb);
-- 
2.39.2



