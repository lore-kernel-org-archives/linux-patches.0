Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DFC611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:37:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AAAC433D2;
	Sun, 28 May 2023 19:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302631;
	bh=78ixVGOmgrz3sYLWn6pU5OGTGLfayfzhPSwD1Tosud8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojpbM4M3HbwxbYIaI4uXqpM4Wl5timz+kqqHF02bbWKwv7S0EIdk3os13RvSU+M80
	 qFc9B0RSqsMwIh981FrRJvsej5txrBl0Dwci+XhHlK8Fj0u6OL23XHpKgLZdEyUlXS
	 6BxOGVM2SRou2B2hdWCyW77sJV5YIyo3NvqoEqKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 082/119] power: supply: bq25890: Call power_supply_changed() after updating input current or voltage
Date: Sun, 28 May 2023 20:11:22 +0100
Message-Id: <20230528190838.255166777@linuxfoundation.org>
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

commit ad3d9c779b1f09f3f3a6fefd07af407c7bc7c9a7 upstream.

The bq25892 model relies on external charger-type detection and once
that is done the bq25890_charger code will update the input current
and if pumpexpress is used also the input voltage.

In this case, when the initial power_supply_changed() call is made
from the interrupt handler, the input settings are 5V/0.5A which
on many devices is not enough power to charge (while the device is on).

On many devices the fuel-gauge relies in its external_power_changed
callback to timely signal userspace about charging <-> discharging
status changes. Add a power_supply_changed() call after updating
the input current or voltage. This allows the fuel-gauge driver
to timely recheck if the battery is charging after the new input
settings have been applied and then it can immediately notify
userspace about this.

Fixes: 48f45b094dbb ("power: supply: bq25890: Support higher charging voltages through Pump Express+ protocol")
Fixes: eab25b4f93aa ("power: supply: bq25890: On the bq25892 set the IINLIM based on external charger detection")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq25890_charger.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/power/supply/bq25890_charger.c
+++ b/drivers/power/supply/bq25890_charger.c
@@ -675,6 +675,7 @@ static void bq25890_charger_external_pow
 	}
 
 	bq25890_field_write(bq, F_IINLIM, input_current_limit);
+	power_supply_changed(psy);
 }
 
 static int bq25890_get_chip_state(struct bq25890_device *bq,
@@ -973,6 +974,8 @@ static void bq25890_pump_express_work(st
 	dev_info(bq->dev, "Hi-voltage charging requested, input voltage is %d mV\n",
 		 voltage);
 
+	power_supply_changed(bq->charger);
+
 	return;
 error_print:
 	bq25890_field_write(bq, F_PUMPX_EN, 0);


