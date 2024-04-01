Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48AEA481C6;
	Mon,  1 Apr 2024 15:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986895; cv=none; b=Jmr0RhT+h4N5/V1kxnke6RWP/fJqjgx7m4VDafeeqJsO7fon4tyKGSOw3hehIK36B2JLgG9xh/fR1UdyM+8dwadtqOYpqcj6cTJD84+44SwzI4KEEHtceHvavewiPNKFyOmVna+gkxzup2/bvoEmRoJYVphGCBf33dRscMXZZME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986895; c=relaxed/simple;
	bh=Kjo1EpwBFMxxu0eo3uUD1vyVurPBKGJSchti1sfMuqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PH6gjukBDaWepFn6GRNwCt2C5aNPWNH5wGObK4mrVCQbJN9AQ85F17ROvaGXyfP3ZpY+7XVZHrMAjUTR2osKZI5iSp9YBiuI46XmX/lhn/J+8gbKUt6s/i5QHZzUGqLl8KRtW0ebRFqq71aq25gP9OYoR3xZq7n1BA9wOiIICHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=az1RmNs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="az1RmNs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1520C433F1;
	Mon,  1 Apr 2024 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986895;
	bh=Kjo1EpwBFMxxu0eo3uUD1vyVurPBKGJSchti1sfMuqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=az1RmNs3TOWplyCw8t8IVGJW9TloCg9PO557tZ4oaRFGBK17ciuqhXiemBDu1CEID
	 Y5zXyYNgmCJp5JhNYFXzhV2HyZSti985iq0xrDJTvANvKZORP3HLuLsQWkhZAfJUB8
	 7dWQ0KOn9CGd679uB7DGin185a4YOTy4SwQv/j8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 119/399] leds: trigger: netdev: Fix kernel panic on interface rename trig notify
Date: Mon,  1 Apr 2024 17:41:25 +0200
Message-ID: <20240401152552.741000958@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit 415798bc07dd1c1ae3a656aa026580816e0b9fe8 ]

Commit d5e01266e7f5 ("leds: trigger: netdev: add additional specific link
speed mode") in the various changes, reworked the way to set the LINKUP
mode in commit cee4bd16c319 ("leds: trigger: netdev: Recheck
NETDEV_LED_MODE_LINKUP on dev rename") and moved it to a generic function.

This changed the logic where, in the previous implementation the dev
from the trigger event was used to check if the carrier was ok, but in
the new implementation with the generic function, the dev in
trigger_data is used instead.

This is problematic and cause a possible kernel panic due to the fact
that the dev in the trigger_data still reference the old one as the
new one (passed from the trigger event) still has to be hold and saved
in the trigger_data struct (done in the NETDEV_REGISTER case).

On calling of get_device_state(), an invalid net_dev is used and this
cause a kernel panic.

To handle this correctly, move the call to get_device_state() after the
new net_dev is correctly set in trigger_data (in the NETDEV_REGISTER
case) and correctly parse the new dev.

Fixes: d5e01266e7f5 ("leds: trigger: netdev: add additional specific link speed mode")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240203235413.1146-1-ansuelsmth@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 8e5475819590e..df1b1d8468e60 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -504,12 +504,12 @@ static int netdev_trig_notify(struct notifier_block *nb,
 	trigger_data->duplex = DUPLEX_UNKNOWN;
 	switch (evt) {
 	case NETDEV_CHANGENAME:
-		get_device_state(trigger_data);
-		fallthrough;
 	case NETDEV_REGISTER:
 		dev_put(trigger_data->net_dev);
 		dev_hold(dev);
 		trigger_data->net_dev = dev;
+		if (evt == NETDEV_CHANGENAME)
+			get_device_state(trigger_data);
 		break;
 	case NETDEV_UNREGISTER:
 		dev_put(trigger_data->net_dev);
-- 
2.43.0



