Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208722;
	b=3opoYHJKtXKciKSSa2Yd8hr1kN4Lzq/CnMbrOYSY0dSd2G87Sa41FobvzBjZ6yIEtSqC
	 PU6s93drXEVvcZ+OLcivRa0ttzUuycJ1hhMt6IANqqqXM8OMT/3qo/Z4URkU7DaIl3nLb
	 F4Zdqc+CACVokuiY3XH2WQ8ap3A+Kv77AEKIToYdIdWZ2YWnLDuZfKCLsc+nDwlivA8Op
	 O8qKax3v11wxvLL3Wrh494a0tdTgZyjo9GLUgIpnPOrw1Ncb1p5EG2RrYoC5/qxndI83t
	 aOOg4htqKEzODc9+5zB0R3U0vSGXvNLgn2Tkffh8VWOVpzjlPgvxYD5WgvYWFwD3OSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4HmCWa+U1HE+3siSzoSUJVYe7XxHmv0N6HbScYUQ7bo=;
	b=iI6Z/KTOLZvCdZMbt9l0DlUjJtiQk68AER0q3ObdslzgYvSPS7rtStsp4BBNfUja/Q91
	 yGu11NAcpIIwcPaMkA2f7gfPybPTCAzMU1WE1o1NQTWPozFPnXoDu1JfBJwWJzFrwGH8x
	 v/XbttEA6KC/pkM77U1bJE85J8ibbuObXxpo1G9nPKmibSFc7U+1ZfNM3Urf64zCdgXOo
	 MJwqp4CRD55YEo3zH+3omRZY0adcA4j7B6OOE/vwiBk/bsRG2fdmP0wHYbBb4HiLMcgK3
	 a+W0X+DqKZqMyjGMC/aAhNx1rEuCILwhWkxu1Nlh7K+jJ7yBPdQp7B4HxPyNpOiJBkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="tBD9/kTC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A17B606A31A;
	Wed, 28 Oct 2026 17:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tBD9/kTC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F331F01825;
	Wed, 28 Oct 2026 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208721;
	bh=4HmCWa+U1HE+3siSzoSUJVYe7XxHmv0N6HbScYUQ7bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tBD9/kTC1HnimIvZYO7H7wywKyowBhpOZ/zixILI2yDPFMCIgttnUTWagzMyMIden
	 ML+cXc4e0umoJhJYWU4FRPXl/wT4MttwwKaPX1AmYcFNX1iH7fpjpJu4AEWtfQF0Nr
	 fta0LySJYklRqYRu5NKCRbrTsfBknETj5hg/zC/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 218/516] wifi: cw1200: fix TX padding OOB read leaking heap data to device
Date: Wed, 28 Oct 2026 17:56:10 +0100
Message-ID: <20261028170008.665745639@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tianchu Chen <flynnnchen@tencent.com>

commit 7c1611780823b76219cb1478db53dfd890c4a9a2 upstream.

The TX path rounds the transfer size up to the bus alignment
(align_size(), up to 511 bytes for SDIO, 1 byte for SPI) but sends
the padded length straight from the frame buffer, which has no room
reserved for the padding.  cw1200_data_write() therefore reads past
the end of the frame and the bus transfer carries those bytes to the
device.  A bogus device can collect up to 511 bytes of kernel heap
data per TX frame.

The RX path does not have this problem: it allocates the skb with
the aligned length (alloc_len) before reading.

Compute the exact padding with the bus align_size() callback, make
sure queued TX frames have tailroom for it, and zero the padding
bytes before the transfer so nothing past the frame is exposed.

This is not expected to change driver behavior on most cases: frame
contents and transfer sizes are unchanged, only the content of the
padding bytes (previously undefined stale memory, now zero), which
the device never reads since the WSM header carries the real frame
length.  The skb expansion can only fail under memory exhaustion,
in which case the frame is dropped like on the existing error paths
of cw1200_tx().

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/7982b4a7e64f74e2068790ec389ca680a081f730@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/st/cw1200/bh.c   |    8 +++++++-
 drivers/net/wireless/st/cw1200/txrx.c |   14 ++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -352,6 +352,7 @@ static int cw1200_bh_tx_helper(struct cw
 			       int *tx_burst)
 {
 	size_t tx_len;
+	size_t aligned_len;
 	u8 *data;
 	int ret;
 	struct wsm_hdr *wsm;
@@ -384,9 +385,14 @@ static int cw1200_bh_tx_helper(struct cw
 
 	atomic_add(1, &priv->bh_tx);
 
-	tx_len = priv->hwbus_ops->align_size(
+	aligned_len = priv->hwbus_ops->align_size(
 		priv->hwbus_priv, tx_len);
 
+	/* Zero the bus alignment padding so no stale data is sent. */
+	if (aligned_len > tx_len)
+		memset(data + tx_len, 0, aligned_len - tx_len);
+	tx_len = aligned_len;
+
 	/* Check if not exceeding CW1200 capabilities */
 	if (WARN_ON_ONCE(tx_len > EFFECTIVE_BUF_SIZE))
 		pr_debug("Write aligned len: %zu\n", tx_len);
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -14,6 +14,7 @@
 #include "wsm.h"
 #include "bh.h"
 #include "sta.h"
+#include "hwbus.h"
 #include "debug.h"
 
 #define CW1200_INVALID_RATE_ID (0xFF)
@@ -716,6 +717,7 @@ void cw1200_tx(struct ieee80211_hw *dev,
 	struct ieee80211_sta *sta;
 	struct wsm_tx *wsm;
 	bool tid_update = false;
+	size_t pad_len;
 	u8 flags = 0;
 	int ret;
 
@@ -765,6 +767,18 @@ void cw1200_tx(struct ieee80211_hw *dev,
 	rcu_read_lock();
 	sta = rcu_dereference(t.sta);
 
+	/*
+	 * The bus transfer is padded up to the bus alignment and the
+	 * padding is transferred from the frame buffer.  Make sure the
+	 * buffer has room for the padding so the device never receives
+	 * data past the end of the frame.
+	 */
+	pad_len = priv->hwbus_ops->align_size(priv->hwbus_priv, skb->len) -
+		skb->len;
+	if (skb_tailroom(skb) < pad_len &&
+	    pskb_expand_head(skb, 0, pad_len, GFP_ATOMIC))
+		goto drop;
+
 	spin_lock_bh(&priv->ps_state_lock);
 	{
 		tid_update = cw1200_tx_h_pm_state(priv, &t);


