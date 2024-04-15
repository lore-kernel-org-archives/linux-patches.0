Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92ED374C4;
	Mon, 15 Apr 2024 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191583; cv=none; b=nZr9Hawro0jTAy2Hb4jse2WGwkng3iKfgYA5cPsMtHzN7m3AGilGb32yh4nMnaas1nNc+g+EkVS1LwUSB4dq2g4JYa0zTpYk5WM8SOQU4vpt3k7TeH7HAjxTqEERcmxxX4gkIr+346i6Ebt4Ez+OPV1KzWUXnJfZW84rOGEl8C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191583; c=relaxed/simple;
	bh=FaGn/zwyfFvnLEW9ssAVlnd+ug/VGH22A9tDIPunc9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZbnVIV2aVtDAErTsK0sFefrJqj7fvMo3k9l57cJmLziSNIcdujhJhKVO++bda6McwX/wi/isQ9+bq/AuhJvBA5HW/wTaYM3jNKbt3R1OI2i/BaNfLpf8bg3zqE8nsA1QW515pT4Halk+tOJv2oPG8+8toHj5upGLM/81k3eQOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVd1UveW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVd1UveW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F763C113CC;
	Mon, 15 Apr 2024 14:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191583;
	bh=FaGn/zwyfFvnLEW9ssAVlnd+ug/VGH22A9tDIPunc9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVd1UveWZ62zwhCtOglx4Lrn2dBA7vvUr5FQInsYp1NamJjdmbO9khOq92FclTw4v
	 zYBxdJvgWl8Bl66utB/fskZxSeojt4cyRuzDNKMJHKmOiU03tQzP56cibOuuSlww96
	 L+ufjQjqQ1Tz+3PhjtV/HW99+Chxr02Hm39FUT3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/122] mmc: omap: restore original power up/down steps
Date: Mon, 15 Apr 2024 16:19:44 +0200
Message-ID: <20240415141953.951747093@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



