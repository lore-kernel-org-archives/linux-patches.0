Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB9018026;
	Tue, 14 May 2024 11:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686508; cv=none; b=KPNXY3gTQmIJi3upxJqbE2p1FfbgyErx2yH6L1U9SNRmHgTjCoaxncnGiR/twZc8bYV5jVSdJUeV8a4UkiUn9QykjIHMvyOrV4HpicqZX/tKLWqO0fa2hFFzV6iap+EXoblEUjokFI7eEzdbyuPNnvWjMFlNIsQ3OAKBTt7SksY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686508; c=relaxed/simple;
	bh=hoJT3CvfPA2bcRUNKQ3qDV7hCOL2/Tdl16aC5yawDRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEJCioUnUgI2RTn8SZH6mVvjCjiJ9kk6gv6VlY2lslb6WcuZf/yqhkneBb/CDzwmQ+XCcKffQWmB7Bs/wKH5YturQPqOqT4gn99u2UXdkFyIvy2+le57g0zjjaMsbnEnSDhwXsa0D7mkrI+BGoXM+WnK0R44NtT60KEfWNmTGJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd6zt9Sx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd6zt9Sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD392C2BD10;
	Tue, 14 May 2024 11:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686508;
	bh=hoJT3CvfPA2bcRUNKQ3qDV7hCOL2/Tdl16aC5yawDRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jd6zt9Sxh03JvjUPaClkhAPdz5wiMtxEGZKFTFDEPY39EH4wceEedbfRLcriwGYJq
	 jm4rPdyov0VJK9ii8dPk3lrGxs58zWMHaLnQ6JhjPIV9949ugGdOmTSpL0SlRss0gQ
	 iH07FhQXupza8poZ3X4TY7rWTEMJpmVe+WHk7E6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukasz Majewski <lukma@denx.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/236] hsr: Simplify code for announcing HSR nodes timer setup
Date: Tue, 14 May 2024 12:18:45 +0200
Message-ID: <20240514101026.547714180@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Majewski <lukma@denx.de>

[ Upstream commit 4893b8b3ef8db2b182d1a1bebf6c7acf91405000 ]

Up till now the code to start HSR announce timer, which triggers sending
supervisory frames, was assuming that hsr_netdev_notify() would be called
at least twice for hsrX interface. This was required to have different
values for old and current values of network device's operstate.

This is problematic for a case where hsrX interface is already in the
operational state when hsr_netdev_notify() is called, so timer is not
configured to trigger and as a result the hsrX is not sending supervisory
frames to HSR ring.

This error has been discovered when hsr_ping.sh script was run. To be
more specific - for the hsr1 and hsr2 the hsr_netdev_notify() was
called at least twice with different IF_OPER_{LOWERDOWN|DOWN|UP} states
assigned in hsr_check_carrier_and_operstate(hsr). As a result there was
no issue with sending supervisory frames.
However, with hsr3, the notify function was called only once with
operstate set to IF_OPER_UP and timer responsible for triggering
supervisory frames was not fired.

The solution is to use netif_oper_up() and netif_running() helper
functions to assess if network hsrX device is up.
Only then, when the timer is not already pending, it is started.
Otherwise it is deactivated.

Fixes: f421436a591d ("net/hsr: Add support for the High-availability Seamless Redundancy protocol (HSRv0)")
Signed-off-by: Lukasz Majewski <lukma@denx.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240507111214.3519800-1-lukma@denx.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_device.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 89e694f1c3bd3..ad75724b69adf 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -71,39 +71,36 @@ static bool hsr_check_carrier(struct hsr_port *master)
 	return false;
 }
 
-static void hsr_check_announce(struct net_device *hsr_dev,
-			       unsigned char old_operstate)
+static void hsr_check_announce(struct net_device *hsr_dev)
 {
 	struct hsr_priv *hsr;
 
 	hsr = netdev_priv(hsr_dev);
-
-	if (READ_ONCE(hsr_dev->operstate) == IF_OPER_UP && old_operstate != IF_OPER_UP) {
-		/* Went up */
-		hsr->announce_count = 0;
-		mod_timer(&hsr->announce_timer,
-			  jiffies + msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
+	if (netif_running(hsr_dev) && netif_oper_up(hsr_dev)) {
+		/* Enable announce timer and start sending supervisory frames */
+		if (!timer_pending(&hsr->announce_timer)) {
+			hsr->announce_count = 0;
+			mod_timer(&hsr->announce_timer, jiffies +
+				  msecs_to_jiffies(HSR_ANNOUNCE_INTERVAL));
+		}
+	} else {
+		/* Deactivate the announce timer  */
+		timer_delete(&hsr->announce_timer);
 	}
-
-	if (READ_ONCE(hsr_dev->operstate) != IF_OPER_UP && old_operstate == IF_OPER_UP)
-		/* Went down */
-		del_timer(&hsr->announce_timer);
 }
 
 void hsr_check_carrier_and_operstate(struct hsr_priv *hsr)
 {
 	struct hsr_port *master;
-	unsigned char old_operstate;
 	bool has_carrier;
 
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	/* netif_stacked_transfer_operstate() cannot be used here since
 	 * it doesn't set IF_OPER_LOWERLAYERDOWN (?)
 	 */
-	old_operstate = READ_ONCE(master->dev->operstate);
 	has_carrier = hsr_check_carrier(master);
 	hsr_set_operstate(master, has_carrier);
-	hsr_check_announce(master->dev, old_operstate);
+	hsr_check_announce(master->dev);
 }
 
 int hsr_get_max_mtu(struct hsr_priv *hsr)
-- 
2.43.0



