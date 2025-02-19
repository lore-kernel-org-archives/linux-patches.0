Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B01A28629E;
	Wed, 19 Feb 2025 09:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957351; cv=none; b=gIscQF1HQu9HgXBYCZi9k8kq6SuzezDpIGEisr3Wt/fryiKwtiQ0ldJsMErItKRaKl9d7KxGbU4sxCYhuWYPzlbbQRQQsZNbBsfRbzXJ5jRb+GhZLjmmV4fsCOTeq9yuB5CqOKEaRAUAVw1yTAodH8wBxrbwK6S4qS5tzfMJjGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957351; c=relaxed/simple;
	bh=L/TterFDqxNkS8qOQ3qXmcdLOK2bqzzU+gsiNXj7F1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9VXrbckF7HZiMSFguIP8eUWlTAIUAGEEZS4TAEGbw93aB2EFxigXySNUX+XnK6sMAGN2SQf8XqCsJu3PjclPWqw4wz+uL70zJAkWejTs/hueG1Gef4YbB9K6IcZaRn/dTS3vB6m1DNwNzVGMVACn3L2lQgGqhhcOT9X8q2yv+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To1TGSc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To1TGSc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953BCC4CED1;
	Wed, 19 Feb 2025 09:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957351;
	bh=L/TterFDqxNkS8qOQ3qXmcdLOK2bqzzU+gsiNXj7F1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To1TGSc/q/rK6Yl1cQKlbK1wwL1ZSQcQm9zgtna9jIF1gouVIpK0cpJrRBIXh9pph
	 Rnh4foys/pzTGw4tOYXARf/yUWBeGtGyJuGw9+dsBwe101fevlV3enS1xA5psnZOl6
	 bgDHNrLPgLtAbwMWWHphEPRGZQsRAGhwNd0drNCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Strohman <andrew@andrewstrohman.com>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.1 496/578] batman-adv: fix panic during interface removal
Date: Wed, 19 Feb 2025 09:28:20 +0100
Message-ID: <20250219082712.503304512@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -67,12 +67,19 @@ static void batadv_v_elp_start_timer(str
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
@@ -142,7 +149,7 @@ static u32 batadv_v_elp_get_throughput(s
 
 default_throughput:
 	if (!(hard_iface->bat_v.flags & BATADV_WARNING_DEFAULT)) {
-		batadv_info(hard_iface->soft_iface,
+		batadv_info(soft_iface,
 			    "WiFi driver or ethtool info does not provide information about link speeds on interface %s, therefore defaulting to hardcoded throughput values of %u.%1u Mbps. Consider overriding the throughput manually or checking your driver.\n",
 			    hard_iface->net_dev->name,
 			    BATADV_THROUGHPUT_DEFAULT_VALUE / 10,


