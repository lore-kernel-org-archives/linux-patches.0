Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044BE3C2F;
	Wed, 21 Feb 2024 13:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522445; cv=none; b=rdkTfstFqVk1PRWRDt6C9i/U7LYKbIrAVr+BUv3FtfPXYxKWe7tIoZuaB6GmldnQ5RxvaEMTcEpouk85DcFGMOn0ELTBkvhLrOyMH5opIci5q5iShIJbLyR/Ayz3GaitGhSZIVerCqOG4ugw/Hq8qA/+iaLUZmSLuYHMiuGO26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522445; c=relaxed/simple;
	bh=kagAMGh3WIni5H3MNxDwXmwTKKNjFt09IS6auYbMrAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phvINKHmLek0mwvyOvLseVRZtB9ky6vKmyGFV9bCXrueDm//J8MhVe7dBC6ZtD6rs+9TIwt7WvdgcYVW7VmQRKetqRX79sKKv3GrALzG2k2lrGYhzBfOUzqVgubta6fP/nx+uVVy0ilRmsHK4x3OcYiGGX6kl8kBTs68936dqiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5krjPI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5krjPI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6523FC433F1;
	Wed, 21 Feb 2024 13:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522444;
	bh=kagAMGh3WIni5H3MNxDwXmwTKKNjFt09IS6auYbMrAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5krjPI+tQaFCJJnRwS0WcS4vvNyJ0AOU4KdM7bBflKCOvYeP9LEZNzBNyObZeG3V
	 rEdfrGK+7u1mCEq49LWdOk6SrOpYkb1tMTnU0PmpSGX5xqRnj7VWfGunG1omipzd9S
	 2YrIOENAQwrDg7jzZg+UKId02i8CyPZVJfLT3PVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiji Yang <yangshiji66@outlook.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/476] wifi: rt2x00: restart beacon queue when hardware reset
Date: Wed, 21 Feb 2024 14:03:36 +0100
Message-ID: <20240221130014.032398156@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiji Yang <yangshiji66@outlook.com>

[ Upstream commit a11d965a218f0cd95b13fe44d0bcd8a20ce134a8 ]

When a hardware reset is triggered, all registers are reset, so all
queues are forced to stop in hardware interface. However, mac80211
will not automatically stop the queue. If we don't manually stop the
beacon queue, the queue will be deadlocked and unable to start again.
This patch fixes the issue where Apple devices cannot connect to the
AP after calling ieee80211_restart_hw().

Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/TYAP286MB031530EB6D98DCE4DF20766CBCA4A@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00dev.c |  3 +++
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 388675d073ce..10ae5e313dda 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -101,6 +101,7 @@ void rt2x00lib_disable_radio(struct rt2x00_dev *rt2x00dev)
 	rt2x00link_stop_tuner(rt2x00dev);
 	rt2x00queue_stop_queues(rt2x00dev);
 	rt2x00queue_flush_queues(rt2x00dev, true);
+	rt2x00queue_stop_queue(rt2x00dev->bcn);
 
 	/*
 	 * Disable radio.
@@ -1268,6 +1269,7 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->intf_ap_count = 0;
 	rt2x00dev->intf_sta_count = 0;
 	rt2x00dev->intf_associated = 0;
+	rt2x00dev->intf_beaconing = 0;
 
 	/* Enable the radio */
 	retval = rt2x00lib_enable_radio(rt2x00dev);
@@ -1294,6 +1296,7 @@ void rt2x00lib_stop(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->intf_ap_count = 0;
 	rt2x00dev->intf_sta_count = 0;
 	rt2x00dev->intf_associated = 0;
+	rt2x00dev->intf_beaconing = 0;
 }
 
 static inline void rt2x00lib_set_if_combinations(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index dea5babd30fe..f81b0ab0b4c5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -598,6 +598,17 @@ void rt2x00mac_bss_info_changed(struct ieee80211_hw *hw,
 	 */
 	if (changes & BSS_CHANGED_BEACON_ENABLED) {
 		mutex_lock(&intf->beacon_skb_mutex);
+
+		/*
+		 * Clear the 'enable_beacon' flag and clear beacon because
+		 * the beacon queue has been stopped after hardware reset.
+		 */
+		if (test_bit(DEVICE_STATE_RESET, &rt2x00dev->flags) &&
+		    intf->enable_beacon) {
+			intf->enable_beacon = false;
+			rt2x00queue_clear_beacon(rt2x00dev, vif);
+		}
+
 		if (!bss_conf->enable_beacon && intf->enable_beacon) {
 			rt2x00dev->intf_beaconing--;
 			intf->enable_beacon = false;
-- 
2.43.0



