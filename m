Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7393611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464D4C433EF;
	Sun, 28 May 2023 19:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302628;
	bh=fLSOeWPYfwqTxvZ6Nw1u5as7Ln2Eox3g8CjW7VZm5OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rs07O5U8Sf2zBGwwLNZQzX0SzT5cnIix0Zu30npQLuUvi32feJOlj4vX7jzNk3TnK
	 5GMumxTQnDiYrVoWBil3HPFfhw84XkmErDIe29jbmta+tvonWaRjkdwVMBIa/JuRWS
	 ivUHUJjcG1mqRvyXjXXr6f37zNNyzNEJTxe6g7lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 081/119] power: supply: bq27xxx: After charger plug in/out wait 0.5s for things to stabilize
Date: Sun, 28 May 2023 20:11:21 +0100
Message-Id: <20230528190838.222005033@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 59a99cd462fbdf71f4e845e09f37783035088b4f upstream.

bq27xxx_external_power_changed() gets called when the charger is plugged
in or out. Rather then immediately scheduling an update wait 0.5 seconds
for things to stabilize, so that e.g. the (dis)charge current is stable
when bq27xxx_battery_update() runs.

Fixes: 740b755a3b34 ("bq27x00: Poll battery state")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -2099,8 +2099,8 @@ static void bq27xxx_external_power_chang
 {
 	struct bq27xxx_device_info *di = power_supply_get_drvdata(psy);
 
-	cancel_delayed_work_sync(&di->work);
-	schedule_delayed_work(&di->work, 0);
+	/* After charger plug in/out wait 0.5s for things to stabilize */
+	mod_delayed_work(system_wq, &di->work, HZ / 2);
 }
 
 int bq27xxx_battery_setup(struct bq27xxx_device_info *di)


