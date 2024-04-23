Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313CA143888;
	Tue, 23 Apr 2024 21:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908510; cv=none; b=lKHowp9PkpYTgXtvp09Y69EQVp9Vcp/0+Anw8fR3YEuLRXNMDbBXe7KNwsJiYnFQwtb6HmBGHK6Ui9T+atG5aa4TItWcgjHle54HzgRY1nN6KibfEKNK5K0KI9jtNVVvgItwgAKcu71KH26qgIxKvR/Gpp+/km8KYidQ+v/3+m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908510; c=relaxed/simple;
	bh=2d0ku5CK1I7KH+Vc781cqF7VAnrMlc04qWlcCqiGjwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abeIAD3VH/09rBsgoI9g55JIHRrhUwZz8Iwiidk70+eQwknHempn+yIfA6KKNTA9LFYocLebJ1G34qgpWG8hDG0JVCSAS2qbHxrnqPugU6QPSUZjoxdPXf1k2RbMJOqyShu5JASO/mC8zXO6YqtGIcD477zmwUJi7bUX0IbXS6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rL71Bf8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rL71Bf8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B56C116B1;
	Tue, 23 Apr 2024 21:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908510;
	bh=2d0ku5CK1I7KH+Vc781cqF7VAnrMlc04qWlcCqiGjwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rL71Bf8lG9qXiQiiX44UtdnWRQ393YBap1kQgRpW74vevuKJ7JrCA5PPiY47im88K
	 cSZK9HDYhgRHonw2LnaF+X1gIfCzLj9KbVZxueE8Bu4+318ar6QNLaMbX2vj6zRWFp
	 sZaVmnOi+kEXhHk3N4sSj5sYCoYqzudPkxIvGSOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fabio Estevam <festevam@denx.de>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Matthias Kaehlcke <mka@chromium.org>
Subject: [PATCH 6.8 094/158] usb: misc: onboard_usb_hub: Disable the USB hub clock on failure
Date: Tue, 23 Apr 2024 14:38:36 -0700
Message-ID: <20240423213859.013781802@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

From: Fabio Estevam <festevam@denx.de>

commit 34b990e9bb54d20b9675ca9483be8668eed374d8 upstream.

In case regulator_bulk_enable() fails, the previously enabled USB hub
clock should be disabled.

Fix it accordingly.

Fixes: 65e62b8a955a ("usb: misc: onboard_usb_hub: Add support for clock input")
Cc: stable <stable@kernel.org>
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Acked-by: Matthias Kaehlcke <mka@chromium.org>
Link: https://lore.kernel.org/r/20240409162910.2061640-1-festevam@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/onboard_usb_hub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/onboard_usb_hub.c b/drivers/usb/misc/onboard_usb_hub.c
index c6101ed2d9d4..d8049275a023 100644
--- a/drivers/usb/misc/onboard_usb_hub.c
+++ b/drivers/usb/misc/onboard_usb_hub.c
@@ -78,7 +78,7 @@ static int onboard_hub_power_on(struct onboard_hub *hub)
 	err = regulator_bulk_enable(hub->pdata->num_supplies, hub->supplies);
 	if (err) {
 		dev_err(hub->dev, "failed to enable supplies: %pe\n", ERR_PTR(err));
-		return err;
+		goto disable_clk;
 	}
 
 	fsleep(hub->pdata->reset_us);
@@ -87,6 +87,10 @@ static int onboard_hub_power_on(struct onboard_hub *hub)
 	hub->is_powered_on = true;
 
 	return 0;
+
+disable_clk:
+	clk_disable_unprepare(hub->clk);
+	return err;
 }
 
 static int onboard_hub_power_off(struct onboard_hub *hub)
-- 
2.44.0



