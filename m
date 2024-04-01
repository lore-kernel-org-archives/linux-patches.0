Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BC61EB37;
	Mon,  1 Apr 2024 16:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989618; cv=none; b=LMehoYPlLAdQkUxR7mLnVl5ZA1HioWgb1cFO0pGVCykHt0OvHM5wpb0qzaTRWPtSHLJjZwgDbsblCtiNB51ZII05ZCKiN1ha+q5hrPidAmCKMNumKz7TX1xtlGjs7BFaBZ4VpLxxc8i0CvFSEymMWVeHUnI6wkFxic96lyTS69I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989618; c=relaxed/simple;
	bh=XWoMmq4P5uuecp37yxGpKgTX6PXSK3zBu6i+rGhh+n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3BsLbc9wZFmCmcZBy/GYo9ergisPgVVJIvbxYvadQh98O3GGh9qPMzbcPqEuJNPuB6EUk+7fq2T3nnaSQBXI2aUlYHBWE/u1UOjLf6xLPGnuM2CqoRm3AU+pqO9c6UKYptlmh/KethB2f2nfJL2lKEa0Qcs4pkecjlHLcP/Ogg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8yMnw2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8yMnw2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843B7C433C7;
	Mon,  1 Apr 2024 16:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989618;
	bh=XWoMmq4P5uuecp37yxGpKgTX6PXSK3zBu6i+rGhh+n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8yMnw2vEkB/KyUDRXkqcwr9LPxUeteRQxjt/qbld4mH2nt/WbSnG4xmAdLfE79dk
	 TL6tJCsz3itA8/d98TpvK6Phfh1Z7VAFHWXSYWR9t50hyvnoX6WdZ0aVru1Ue75MXa
	 fgtCtrUKYad/2HmF3VLN7Xl7+2g/q+v2qVJLIKcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/396] leds: trigger: netdev: Fix kernel panic on interface rename trig notify
Date: Mon,  1 Apr 2024 17:42:32 +0200
Message-ID: <20240401152550.993340715@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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



