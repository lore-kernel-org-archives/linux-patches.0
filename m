Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F398476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC10AC4339C;
	Tue, 28 Mar 2023 14:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015230;
	bh=fAn6+44pIN+NpgqXFxcUaNeJVdGcFMzV9lB5RaJZ5P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFyTX2MjON61UANtWZbZGGv4MRTQDKUUe9ImgacgqEA7owsAFLJaMlcnfw2wZ9ZWu
	 3SAcRo1hFkaMBU1L01n7TXcUVVyB/YMNexeZY+0dm6vcvJBuRFUgHBFZEbMkNX4ALY
	 n8vpyCIXxRxwx02Ki+rYXaxJvI4iB9AwKNFB2HGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.2 214/240] wifi: mac80211: fix qos on mesh interfaces
Date: Tue, 28 Mar 2023 16:42:57 +0200
Message-Id: <20230328142628.612410804@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

commit 4e348c6c6e23491ae6eb5e077848a42d0562339c upstream.

When ieee80211_select_queue is called for mesh, the sta pointer is usually
NULL, since the nexthop is looked up much later in the tx path.
Explicitly check for unicast address in that case in order to make qos work
again.

Cc: stable@vger.kernel.org
Fixes: 50e2ab392919 ("wifi: mac80211: fix queue selection for mesh/OCB interfaces")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230314095956.62085-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/wme.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -147,6 +147,7 @@ u16 ieee80211_select_queue_80211(struct
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 			   struct sta_info *sta, struct sk_buff *skb)
 {
+	const struct ethhdr *eth = (void *)skb->data;
 	struct mac80211_qos_map *qos_map;
 	bool qos;
 
@@ -154,8 +155,9 @@ u16 ieee80211_select_queue(struct ieee80
 	skb_get_hash(skb);
 
 	/* all mesh/ocb stations are required to support WME */
-	if (sta && (sdata->vif.type == NL80211_IFTYPE_MESH_POINT ||
-		    sdata->vif.type == NL80211_IFTYPE_OCB))
+	if ((sdata->vif.type == NL80211_IFTYPE_MESH_POINT &&
+	    !is_multicast_ether_addr(eth->h_dest)) ||
+	    (sdata->vif.type == NL80211_IFTYPE_OCB && sta))
 		qos = true;
 	else if (sta)
 		qos = sta->sta.wme;


