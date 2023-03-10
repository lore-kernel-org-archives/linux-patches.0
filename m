Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1E7882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96204C433EF;
	Fri, 10 Mar 2023 15:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461134;
	bh=9NJBLsx4qiq15RUbJYGha3cnPvyqWDhaEgc5KV9Rns0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnrnZHSDjQFF7q/CLXUC0Cr3HFc9NeWwhnV/uj5E6ytLARu2MqB0gm6ugYfPpx94r
	 gS597bYSRPJNqX6eGCbFxm40gl5cRKcbhr7ep4x3eDKIRBDwFbecuZ3EgmHqKwojih
	 LdkXFEPmv+jOvS8Iqfwhm88gBajnpgmBH4MRFWTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie <ruanjinjie@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/136] watchdog: at91sam9_wdt: use devm_request_irq to avoid missing free_irq() in error path
Date: Fri, 10 Mar 2023 14:42:39 +0100
Message-Id: <20230310133708.189944829@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit 07bec0e09c1afbab4c5674fd2341f4f52d594f30 ]

free_irq() is missing in case of error in at91_wdt_init(), use
devm_request_irq to fix that.

Fixes: 5161b31dc39a ("watchdog: at91sam9_wdt: better watchdog support")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20221116094950.3141943-1-ruanjinjie@huawei.com
[groeck: Adjust multi-line alignment]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/at91sam9_wdt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 292b5a1ca8318..fed7be2464420 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -206,10 +206,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
 
 	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
-		err = request_irq(wdt->irq, wdt_interrupt,
-				  IRQF_SHARED | IRQF_IRQPOLL |
-				  IRQF_NO_SUSPEND,
-				  pdev->name, wdt);
+		err = devm_request_irq(dev, wdt->irq, wdt_interrupt,
+				       IRQF_SHARED | IRQF_IRQPOLL | IRQF_NO_SUSPEND,
+				       pdev->name, wdt);
 		if (err)
 			return err;
 	}
-- 
2.39.2



