Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26E7D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2A7C433EF;
	Mon, 12 Jun 2023 10:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686567021;
	bh=eHqA/XNTgPzNyWaSNWkVQYCmkusbEx6uTjAX+yi3Nxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VZ+G564oy4XTBlvoOf8WCV+lmYCLZ6BEZJYFh89ChX5C8VYbxj/gAXY5VYAmKgTxL
	 CBzFdwnu7mV/bS9uAGe2Gjm7zLzPJaYuBBG3R8IRoBkp4m+ck0l93/x+6lfkAxWTrh
	 7SFsO3CGKQa4doAkMZx2/6DJ58fdreDYKgAUK1aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 121/160] ARM: at91: pm: fix imbalanced reference counter for ethernet devices
Date: Mon, 12 Jun 2023 12:27:33 +0200
Message-ID: <20230612101720.588270328@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit ccd4923d18d5698a5910d516646ce125b9155d47 ]

The of_find_device_by_node() function is returning a struct platform_device
object with the embedded struct device member's reference counter
incremented. This needs to be dropped when done with the platform device
returned by of_find_device_by_node().

at91_pm_eth_quirk_is_valid() calls of_find_device_by_node() on
suspend and resume path. On suspend it calls of_find_device_by_node() and
on resume and failure paths it drops the counter of
struct platform_device::dev.

In case ethernet device may not wakeup there is a put_device() on
at91_pm_eth_quirk_is_valid() which is wrong as it colides with
put_device() on resume path leading to the reference counter of struct
device embedded in struct platform_device to be messed, stack trace to be
displayed (after 5 consecutive suspend/resume cycles) and execution to
hang.

Along with this the error path of at91_pm_config_quirks() had been also
adapted to decrement propertly the reference counter of struct device
embedded in struct platform_device.

Fixes: b7fc72c63399 ("ARM: at91: pm: add quirks for pm")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20230518062511.2988500-1-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 60dc56d8acfb9..437dd0352fd44 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -334,16 +334,14 @@ static bool at91_pm_eth_quirk_is_valid(struct at91_pm_quirk_eth *eth)
 		pdev = of_find_device_by_node(eth->np);
 		if (!pdev)
 			return false;
+		/* put_device(eth->dev) is called at the end of suspend. */
 		eth->dev = &pdev->dev;
 	}
 
 	/* No quirks if device isn't a wakeup source. */
-	if (!device_may_wakeup(eth->dev)) {
-		put_device(eth->dev);
+	if (!device_may_wakeup(eth->dev))
 		return false;
-	}
 
-	/* put_device(eth->dev) is called at the end of suspend. */
 	return true;
 }
 
@@ -439,14 +437,14 @@ static int at91_pm_config_quirks(bool suspend)
 				pr_err("AT91: PM: failed to enable %s clocks\n",
 				       j == AT91_PM_G_ETH ? "geth" : "eth");
 			}
-		} else {
-			/*
-			 * Release the reference to eth->dev taken in
-			 * at91_pm_eth_quirk_is_valid().
-			 */
-			put_device(eth->dev);
-			eth->dev = NULL;
 		}
+
+		/*
+		 * Release the reference to eth->dev taken in
+		 * at91_pm_eth_quirk_is_valid().
+		 */
+		put_device(eth->dev);
+		eth->dev = NULL;
 	}
 
 	return ret;
-- 
2.39.2



