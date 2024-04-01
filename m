Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560FD47A5D;
	Mon,  1 Apr 2024 16:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988203; cv=none; b=p3C/PmI4F2TQm0bJ4JnKJQs+5CeyhEb1qeQE0ZaC0iqkFmB/DsvCqVUeiFC1o8ckrhYHieQCw8Lroq7y4BRPxlWjtWavSRW18RW/Pp1iEMONN9lbL/BEPuiJMFGy8AHAPDAdsuR1zZBsgG7K52t3hcjCPNzVmSSd+zsTgwBUF14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988203; c=relaxed/simple;
	bh=nVabI8nfMY3h/CUVFLmufdbzVMaHJgrNJYOo2t7KUL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=henIPlC9zYiIoDJWq2mVdN/Zs5M0ZDJ0reL+aawVeSeZxW/KJR6bTrj0U9gLsbcyteYikU0br/CIHnqsRCOWqdNIiTfWrHZ535D0Oqsd2gGR7F09GDUOkcmOlkZdSHp4SOMfDL0tSmfAliT5XP2zTMKa8JsrTIwJVyKyCBjiutg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts8Ct1J8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts8Ct1J8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF622C433C7;
	Mon,  1 Apr 2024 16:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988203;
	bh=nVabI8nfMY3h/CUVFLmufdbzVMaHJgrNJYOo2t7KUL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts8Ct1J8j3UXuM3IHaIufifbwYayiYY5Svix53aBBhEufeIgvdknOWAK5sWwrheZg
	 XBGzvKKD1HRsJsHT4L9htCoOvJgqtjmKhiMVNp6QUw0Da5yedL0loOXoV6ocK+a2I9
	 SYs6vfBayQlglGDUZHdVK3eXJfhb2UTNYweOVFuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 115/432] leds: trigger: netdev: Fix kernel panic on interface rename trig notify
Date: Mon,  1 Apr 2024 17:41:42 +0200
Message-ID: <20240401152556.557216847@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index d76214fa9ad86..79719fc8a08fb 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -462,12 +462,12 @@ static int netdev_trig_notify(struct notifier_block *nb,
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



