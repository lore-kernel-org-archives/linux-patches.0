Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C6A71B32;
	Mon, 15 Apr 2024 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191073; cv=none; b=sdVhTOHrVvEn8urQTFHTzZxzwZ7DJtI/z2JrWTdx0qmXF2Y5JiX+uHpLcrMDrzIROQX7rJ73zXCD/Y7UnJHt7kuTpH1pvlgbwvoEITu/jZqVLX9ThxWRRwM3X1NsweHx+mpZszFAOrUZ8F8bqr7iIjwmvggCDp24lyikMsWsESM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191073; c=relaxed/simple;
	bh=M2lTGW2V8iaEkTB1iK6b1la3gXvGLxLUyL5plU87SEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7zds/EzOB2+BJlRKbb8mQ1Yrsj3ap1c4Y4apY4mFWk5NmF0ejXliikQ8eUp03c0PrmV1JeBDsTYKAVshw1l60DPlVVB8Mk1eJaTmXFXZONZmwnuHgbLCMKIELdonC0M/tiVVVF5vcrHsECZAWesGkpSRii/JrgXkjbRvZcvyVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ktm7PXPG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ktm7PXPG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EF9C113CC;
	Mon, 15 Apr 2024 14:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191073;
	bh=M2lTGW2V8iaEkTB1iK6b1la3gXvGLxLUyL5plU87SEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ktm7PXPGlAFpnpaqLJa/3QufBQat7uwWMMn3dII0ZFGAUQk9dst0/+izXWj/lrU4Q
	 DV+zleD6/w7hjhQ5wL1EvZJmF02UCd0/RAOX0ga3XBhi1G9NsSHec8mQO+YRY97F5j
	 yuel/67xRqJQhB50Nxit86rcwQSdEcNMacQ4wTMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 024/172] mmc: omap: restore original power up/down steps
Date: Mon, 15 Apr 2024 16:18:43 +0200
Message-ID: <20240415142001.084912893@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 894ad61b85d6ba8efd4274aa8719d9ff1c89ea54 ]

Commit e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
moved Nokia N810 MMC power up/down from the board file into the MMC driver.

The change removed some delays, and ordering without a valid reason.
Restore power up/down to match the original code. This matters only on N810
where the 2nd GPIO is in use. Other boards will see an additional delay but
that should be a lesser concern than omitting delays altogether.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Message-ID: <20240223181439.1099750-6-aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/omap.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 50408771ae01c..13fa8588e38c1 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -1119,10 +1119,25 @@ static void mmc_omap_set_power(struct mmc_omap_slot *slot, int power_on,
 
 	host = slot->host;
 
-	if (slot->vsd)
-		gpiod_set_value(slot->vsd, power_on);
-	if (slot->vio)
-		gpiod_set_value(slot->vio, power_on);
+	if (power_on) {
+		if (slot->vsd) {
+			gpiod_set_value(slot->vsd, power_on);
+			msleep(1);
+		}
+		if (slot->vio) {
+			gpiod_set_value(slot->vio, power_on);
+			msleep(1);
+		}
+	} else {
+		if (slot->vio) {
+			gpiod_set_value(slot->vio, power_on);
+			msleep(50);
+		}
+		if (slot->vsd) {
+			gpiod_set_value(slot->vsd, power_on);
+			msleep(50);
+		}
+	}
 
 	if (slot->pdata->set_power != NULL)
 		slot->pdata->set_power(mmc_dev(slot->mmc), slot->id, power_on,
-- 
2.43.0



