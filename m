Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FC41DED5C;
	Wed, 19 Feb 2025 08:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955037; cv=none; b=vEQ2c4cJ+GbWD1mUgllj09mze1840U2ke+bfiFZEOeu2NTQDsoTuW4pz8AuE7FZ82lOQWZskMyMON51jlsWRNmmCBufvGQ5FaD/kTcAYAWM/FTtkJ/6X9E44ju6y1s9oeYe6wS0PawQMxdgSdkkBJIJ7fA8jW5DjEYGJbozF404=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955037; c=relaxed/simple;
	bh=Iaj24D2JuCl89UBW1jh7GDpUOPoN8X18n7MT/VfuV50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNAfOIP0gFGyVHb7nHLnV8LnLeEaFpF11HA5Jpm0koTren7M/7Nv0y/EYe2H07M/WGaabZ8Hryh5/q+iBTVc1qRnAVB694mcomE3Ea2DYVoTu5K3riw9+t/dZgecEWIpiRx0sHIX93ZaX1J0WXWWBiU5/9pzJanuA6OjfpOz2yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuO68Nw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuO68Nw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5141C4CEE6;
	Wed, 19 Feb 2025 08:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955037;
	bh=Iaj24D2JuCl89UBW1jh7GDpUOPoN8X18n7MT/VfuV50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuO68Nw+32/ws+mG0IN9ddYpQTjr4T5clozIyt08odBBgGR9Jc9z/SbIhmNIsUZQC
	 gUP/D7+Y4M1I3Iwn8UkSs/uzdqN2AZmWgGBktK2CSK2M/iA0B27VHwH2tbtCe2t5Rh
	 PusxzJAm4LQ0SmiDiSIn3Ae1xsnu/UdtxoQH1IFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Strohman <andrew@andrewstrohman.com>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.12 094/230] batman-adv: fix panic during interface removal
Date: Wed, 19 Feb 2025 09:26:51 +0100
Message-ID: <20250219082605.375549037@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Strohman <andrew@andrewstrohman.com>

commit ccb7276a6d26d6f8416e315b43b45e15ee7f29e2 upstream.

Reference counting is used to ensure that
batadv_hardif_neigh_node and batadv_hard_iface
are not freed before/during
batadv_v_elp_throughput_metric_update work is
finished.

But there isn't a guarantee that the hard if will
remain associated with a soft interface up until
the work is finished.

This fixes a crash triggered by reboot that looks
like this:

Call trace:
 batadv_v_mesh_free+0xd0/0x4dc [batman_adv]
 batadv_v_elp_throughput_metric_update+0x1c/0xa4
 process_one_work+0x178/0x398
 worker_thread+0x2e8/0x4d0
 kthread+0xd8/0xdc
 ret_from_fork+0x10/0x20

(the batadv_v_mesh_free call is misleading,
and does not actually happen)

I was able to make the issue happen more reliably
by changing hardif_neigh->bat_v.metric_work work
to be delayed work. This allowed me to track down
and confirm the fix.

Cc: stable@vger.kernel.org
Fixes: c833484e5f38 ("batman-adv: ELP - compute the metric based on the estimated throughput")
Signed-off-by: Andy Strohman <andrew@andrewstrohman.com>
[sven@narfation.org: prevent entering batadv_v_elp_get_throughput without
 soft_iface]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v_elp.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -66,12 +66,19 @@ static void batadv_v_elp_start_timer(str
 static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
 {
 	struct batadv_hard_iface *hard_iface = neigh->if_incoming;
+	struct net_device *soft_iface = hard_iface->soft_iface;
 	struct ethtool_link_ksettings link_settings;
 	struct net_device *real_netdev;
 	struct station_info sinfo;
 	u32 throughput;
 	int ret;
 
+	/* don't query throughput when no longer associated with any
+	 * batman-adv interface
+	 */
+	if (!soft_iface)
+		return BATADV_THROUGHPUT_DEFAULT_VALUE;
+
 	/* if the user specified a customised value for this interface, then
 	 * return it directly
 	 */
@@ -141,7 +148,7 @@ static u32 batadv_v_elp_get_throughput(s
 
 default_throughput:
 	if (!(hard_iface->bat_v.flags & BATADV_WARNING_DEFAULT)) {
-		batadv_info(hard_iface->soft_iface,
+		batadv_info(soft_iface,
 			    "WiFi driver or ethtool info does not provide information about link speeds on interface %s, therefore defaulting to hardcoded throughput values of %u.%1u Mbps. Consider overriding the throughput manually or checking your driver.\n",
 			    hard_iface->net_dev->name,
 			    BATADV_THROUGHPUT_DEFAULT_VALUE / 10,


