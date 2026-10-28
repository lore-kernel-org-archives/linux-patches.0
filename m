Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211030;
	b=XirZT8uXTrm1utZmej5LWfYjYFEL++lhnCeqdmwRvJI6BWev2L79fNNjIe9tGAKy6Bd5
	 7ZmvZo6g6tQwQLUi5XxJ/6OhxzRXUvryC3F3tY/6UiBnrpdnrMkPkCWivqAfKMTuYwD6/
	 LxttdlrLA1nDO0J8VNuXeRSwpbRMR/fPz7W7Lj34s6mjq2tZ6cD++5PSqCFvg2QrQceTN
	 fkdUVt4hU5gpinSt79IeDb+mu7uPCHfFkvD9UJK0i8jDoCBgcU4wyBPE3R2DMYKm3yGUN
	 Rxzsh9GFTIL7HAhbQgtnh59T80ejakEnhWOAX6w2/SkOOETt+PkUQljej48esFy019A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=efv9C5KIwkivZp6bShM5FHd85yvkeMNXWUN1lNoxrXo=;
	b=KrpRZA4pqlweGW+gTIERT2ypixwz7Ny0Lmu+nd5MxISOWJ70cAJIif9jb2w68P0fKIen
	 TkMavfkGxeM5DBOZx2Aj8IvVytk8ezI0IWqWILCn4pj70/Uiy+e6+P0yrXkKq/ydIO9Km
	 I10kOFTgngHYwyWZFMBZ7h2WN7kFf0PcSIWYymu7bj8CHokd4vGkHLO+ROV0FCWiv96u/
	 eltgYPUHaEK/RTO3PHu7xZ16yPtl/Nw7OMZuuH9ZxvbxVuwZmJCKbqa058DRn+8kpHp0v
	 gUUhCBzU4yuMCIN/4lhosqFa5wToTLT24LpQzDtbTM7/FUI1NpxUn7UIp3dOOHHDOeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toV+TzM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1485B606A333;
	Wed, 28 Oct 2026 18:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=toV+TzM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F421F031E2;
	Wed, 28 Oct 2026 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211029;
	bh=efv9C5KIwkivZp6bShM5FHd85yvkeMNXWUN1lNoxrXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=toV+TzM+266cHfVQm4VYzphR0k5i4Jh+EygHoSfXFE/b6+vkaeSIPYT+lsFNnU70c
	 Bw8Lu+W/bYoGAW7sP7o+cbkPtoW7R6Qc9JRjyo92SCqES+dZu8Ghvjp5hIelC9RqPm
	 WK6nDgWxUQr0xa0nol8g4Yh2Rf3r4FaB1X1KieH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 235/571] wifi: cw1200: fix TX padding OOB read leaking heap data to device
Date: Wed, 28 Oct 2026 17:56:22 +0100
Message-ID: <20261028170013.581079204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -349,6 +349,7 @@ static int cw1200_bh_tx_helper(struct cw
 			       int *tx_burst)
 {
 	size_t tx_len;
+	size_t aligned_len;
 	u8 *data;
 	int ret;
 	struct wsm_hdr *wsm;
@@ -381,9 +382,14 @@ static int cw1200_bh_tx_helper(struct cw
 
 	atomic_inc(&priv->bh_tx);
 
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


