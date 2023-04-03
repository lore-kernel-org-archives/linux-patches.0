Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0955683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C55C433EF;
	Mon,  3 Apr 2023 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531546;
	bh=AYQK/nW9l4cl/DtggUNloxtu/0Ez46kxbDH+CvduZ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGu+2u0LtsRiPtDr8ceddhZ7W+giMYHnOVWAWfr9dhvun5+2RHwZQxosTgoBiPAZ6
	 VzCRIGFgZpSnUhQ6hZYWwxnyiktjxZ+Z5VOKfVtmBbnb22qXLKJzSuXqYkmbQ3RZcp
	 FxKfxl0CtXAaZT0W8vaG/O8ZVG8KviZYICD0K1Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Wang <zyytlz.wz@163.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 002/104] power: supply: da9150: Fix use after free bug in da9150_charger_remove due to race condition
Date: Mon,  3 Apr 2023 16:07:54 +0200
Message-Id: <20230403140404.035056916@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
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
index f9314cc0cd75f..6b987da586556 100644
--- a/drivers/power/supply/da9150-charger.c
+++ b/drivers/power/supply/da9150-charger.c
@@ -662,6 +662,7 @@ static int da9150_charger_remove(struct platform_device *pdev)
 
 	if (!IS_ERR_OR_NULL(charger->usb_phy))
 		usb_unregister_notifier(charger->usb_phy, &charger->otg_nb);
+	cancel_work_sync(&charger->otg_work);
 
 	power_supply_unregister(charger->battery);
 	power_supply_unregister(charger->usb);
-- 
2.39.2



