Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264902505D7;
	Tue, 20 May 2025 14:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750593; cv=none; b=dIS/+Zq9UXTc9TFZ/ezDXGq6U0DW976ZbBZLnLLuK+9hUbwZw52gYdW/n8GI8Gtlue6ZCfuJk+cnt0e+0E72CElc7zPiBgcL77JRqd/8bZ71RPdRT7eXKH3Vrm7fb1V2pAoW+9Dv9CZJJiEj7GAA94aNwQG8zb+by5i6VAp8Isw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750593; c=relaxed/simple;
	bh=TMCoR6QumvztVFvFZpfDEDqY8I2JX2hBrQn6mcN4QAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXFXRjLr/scDsjKntCdcMzTnMnJHZg7jExPMuoDm6nP8HKaAd3c9lKAfgRPCV5IKeN77FnCXVmVEuOGG4zHUlybVpxM4aHuA6KVNzLZt8uUDczhRFAbig62suAcdFssMc0yfgacXENWuFK89MyidGZvFRr+HdtqTUAHFuUGuSMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mc4mr3yK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mc4mr3yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B05C4CEE9;
	Tue, 20 May 2025 14:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750591;
	bh=TMCoR6QumvztVFvFZpfDEDqY8I2JX2hBrQn6mcN4QAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mc4mr3yKMs7IQCPVLF8i8/c0NytVzm1+X1fal+KKKNO9qIXg8ADv5wHdJZABP2lKN
	 Twjp9nKsr90EooNEBlwAMasqCssNc2bChiiXy22ZXRUGxMsRQOHwweGDPAoCtiRCOM
	 UyD7fg/H2QfwE19NT05s11QnU//ML1co87R2pcyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 059/145] tsnep: fix timestamping with a stacked DSA driver
Date: Tue, 20 May 2025 15:50:29 +0200
Message-ID: <20250520125812.891179454@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gerhard Engleder <gerhard@engleder-embedded.com>

[ Upstream commit b3ca9eef6646576ad506a96d941d87a69f66732a ]

This driver is susceptible to a form of the bug explained in commit
c26a2c2ddc01 ("gianfar: Fix TX timestamping with a stacked DSA driver")
and in Documentation/networking/timestamping.rst section "Other caveats
for MAC drivers", specifically it timestamps any skb which has
SKBTX_HW_TSTAMP, and does not consider if timestamping has been enabled
in adapter->hwtstamp_config.tx_type.

Evaluate the proper TX timestamping condition only once on the TX
path (in tsnep_xmit_frame_ring()) and store the result in an additional
TX entry flag. Evaluate the new TX entry flag in the TX confirmation path
(in tsnep_tx_poll()).

This way SKBTX_IN_PROGRESS is set by the driver as required, but never
evaluated. SKBTX_IN_PROGRESS shall not be evaluated as it can be set
by a stacked DSA driver and evaluating it would lead to unwanted
timestamps.

Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250514195657.25874-1-gerhard@engleder-embedded.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/engleder/tsnep_main.c | 30 ++++++++++++++--------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 0d030cb0b21c7..63aeb400051c4 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -67,6 +67,8 @@
 #define TSNEP_TX_TYPE_XDP_NDO_MAP_PAGE	(TSNEP_TX_TYPE_XDP_NDO | TSNEP_TX_TYPE_MAP_PAGE)
 #define TSNEP_TX_TYPE_XDP		(TSNEP_TX_TYPE_XDP_TX | TSNEP_TX_TYPE_XDP_NDO)
 #define TSNEP_TX_TYPE_XSK		BIT(12)
+#define TSNEP_TX_TYPE_TSTAMP		BIT(13)
+#define TSNEP_TX_TYPE_SKB_TSTAMP	(TSNEP_TX_TYPE_SKB | TSNEP_TX_TYPE_TSTAMP)
 
 #define TSNEP_XDP_TX		BIT(0)
 #define TSNEP_XDP_REDIRECT	BIT(1)
@@ -387,8 +389,7 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
 	if (entry->skb) {
 		entry->properties = length & TSNEP_DESC_LENGTH_MASK;
 		entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
-		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
-		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS))
+		if ((entry->type & TSNEP_TX_TYPE_SKB_TSTAMP) == TSNEP_TX_TYPE_SKB_TSTAMP)
 			entry->properties |= TSNEP_DESC_EXTENDED_WRITEBACK_FLAG;
 
 		/* toggle user flag to prevent false acknowledge
@@ -480,7 +481,8 @@ static int tsnep_tx_map_frag(skb_frag_t *frag, struct tsnep_tx_entry *entry,
 	return mapped;
 }
 
-static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
+static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count,
+			bool do_tstamp)
 {
 	struct device *dmadev = tx->adapter->dmadev;
 	struct tsnep_tx_entry *entry;
@@ -506,6 +508,9 @@ static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
 				entry->type = TSNEP_TX_TYPE_SKB_INLINE;
 				mapped = 0;
 			}
+
+			if (do_tstamp)
+				entry->type |= TSNEP_TX_TYPE_TSTAMP;
 		} else {
 			skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
@@ -559,11 +564,12 @@ static int tsnep_tx_unmap(struct tsnep_tx *tx, int index, int count)
 static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 					 struct tsnep_tx *tx)
 {
-	int count = 1;
 	struct tsnep_tx_entry *entry;
+	bool do_tstamp = false;
+	int count = 1;
 	int length;
-	int i;
 	int retval;
+	int i;
 
 	if (skb_shinfo(skb)->nr_frags > 0)
 		count += skb_shinfo(skb)->nr_frags;
@@ -580,7 +586,13 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	entry = &tx->entry[tx->write];
 	entry->skb = skb;
 
-	retval = tsnep_tx_map(skb, tx, count);
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    tx->adapter->hwtstamp_config.tx_type == HWTSTAMP_TX_ON) {
+		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+		do_tstamp = true;
+	}
+
+	retval = tsnep_tx_map(skb, tx, count, do_tstamp);
 	if (retval < 0) {
 		tsnep_tx_unmap(tx, tx->write, count);
 		dev_kfree_skb_any(entry->skb);
@@ -592,9 +604,6 @@ static netdev_tx_t tsnep_xmit_frame_ring(struct sk_buff *skb,
 	}
 	length = retval;
 
-	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
-		skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
-
 	for (i = 0; i < count; i++)
 		tsnep_tx_activate(tx, (tx->write + i) & TSNEP_RING_MASK, length,
 				  i == count - 1);
@@ -845,8 +854,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
 
 		length = tsnep_tx_unmap(tx, tx->read, count);
 
-		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
-		    (skb_shinfo(entry->skb)->tx_flags & SKBTX_IN_PROGRESS) &&
+		if (((entry->type & TSNEP_TX_TYPE_SKB_TSTAMP) == TSNEP_TX_TYPE_SKB_TSTAMP) &&
 		    (__le32_to_cpu(entry->desc_wb->properties) &
 		     TSNEP_DESC_EXTENDED_WRITEBACK_FLAG)) {
 			struct skb_shared_hwtstamps hwtstamps;
-- 
2.39.5



