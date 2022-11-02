Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E7629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E1EC433D6;
	Wed,  2 Nov 2022 03:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359813;
	bh=dymtWmbAw2K873+g42pvLr+y0fCYwofUpmXE5EwcFVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aj2VQCa5YbtHORr0A/BpCHo5lMLB2vLYUZGRcYEDDwijKd5z+litXQ+4j6Uy7x6Pu
	 rxvH4M7tgtmP/stniefwErMi/iMYmd1cW3//67wPzt9TJYjqF1BB1RjFcs0s2ajyLp
	 e2wpdCkHhO+YjzonaAqkk6Rn9UxnHr3OgIDwgooI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexander Aring <aahringo@redhat.com>,
	Stefan Schmidt <stefan@datenfreihafen.org>
Subject: [PATCH 4.19 38/78] mac802154: Fix LQI recording
Date: Wed,  2 Nov 2022 03:34:23 +0100
Message-Id: <20221102022054.109168316@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
References: <20221102022052.895556444@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 5a5c4e06fd03b595542d5590f2bc05a6b7fc5c2b upstream.

Back in 2014, the LQI was saved in the skb control buffer (skb->cb, or
mac_cb(skb)) without any actual reset of this area prior to its use.

As part of a useful rework of the use of this region, 32edc40ae65c
("ieee802154: change _cb handling slightly") introduced mac_cb_init() to
basically memset the cb field to 0. In particular, this new function got
called at the beginning of mac802154_parse_frame_start(), right before
the location where the buffer got actually filled.

What went through unnoticed however, is the fact that the very first
helper called by device drivers in the receive path already used this
area to save the LQI value for later extraction. Resetting the cb field
"so late" led to systematically zeroing the LQI.

If we consider the reset of the cb field needed, we can make it as soon
as we get an skb from a device driver, right before storing the LQI,
as is the very first time we need to write something there.

Cc: stable@vger.kernel.org
Fixes: 32edc40ae65c ("ieee802154: change _cb handling slightly")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20221020142535.1038885-1-miquel.raynal@bootlin.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac802154/rx.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac802154/rx.c
+++ b/net/mac802154/rx.c
@@ -140,7 +140,7 @@ static int
 ieee802154_parse_frame_start(struct sk_buff *skb, struct ieee802154_hdr *hdr)
 {
 	int hlen;
-	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
+	struct ieee802154_mac_cb *cb = mac_cb(skb);
 
 	skb_reset_mac_header(skb);
 
@@ -302,8 +302,9 @@ void
 ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
 {
 	struct ieee802154_local *local = hw_to_local(hw);
+	struct ieee802154_mac_cb *cb = mac_cb_init(skb);
 
-	mac_cb(skb)->lqi = lqi;
+	cb->lqi = lqi;
 	skb->pkt_type = IEEE802154_RX_MSG;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);


