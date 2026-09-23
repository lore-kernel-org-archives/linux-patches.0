Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95767332EC5;
	Wed, 23 Sep 2026 14:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175150; cv=none; b=iMXwEyCpxfGmYho5oO0m1osr76vtWzZFr+qxCdDvaR4feB7GE8wHiPpcJFbqRq4x+dCt7ldjNv809SxyGokzzkep8XfagyaI3R8kPOGvHfFn98hn7UQT+wV6cP92ME25crPFNsfVB3tsYZxiz0wdpBkXOdjMn6gk+yiiSAZSbW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175150; c=relaxed/simple;
	bh=8jRYDq+GvpY7xHAUOKrir0DgbyDBFgbNdka7THJlNj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6vQa9NKPYpViTZJXt1/FxkrVfHCMGhVY1OUZcsuHdkFXOTDaZR7XHkZaXSlWMTIkKlFEV1HdTpGSdu9F7VUbys6188IRbc15Vw8njlYc2hVsRj9tAXq/AoWhlUaqT3LOLow/0cmKx1bLNyhnnxs/ULoOQwmtV85HItT7v+HYKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqtCCffS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqtCCffS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631D51F00893;
	Wed, 23 Sep 2026 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175147;
	bh=n6iqhq656JKzDqMl2APypjpkXvQ5cYnZ0ClT4GTGvGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqtCCffSQoKb5IPoW5emeqWuet9VBdjvfn6BYNuYE9VUEc9UUKJJ0zw/LSn83u3IL
	 k1xDejCKK22P+aPwgkwA260RRtzwnzfvDWMdsSdfzaLd7LrEKgNPaAx1DoBHXVWOwy
	 7lGwNkLoahTYfepRaPiVrpmSwGGS65EuNpqBIG+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 335/398] wifi: mwifiex: prevent authentication frame length truncation
Date: Wed, 23 Sep 2026 16:06:49 +0200
Message-ID: <20260923140652.103803386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

commit fa00193eb991f92b007aefe7afb6a7566976dacf upstream.

mwifiex_cfg80211_authenticate() derives the authentication frame length
from req->ie_len and req->auth_data_len, both of type size_t, but stores
it in a u16.

NL80211_ATTR_AUTH_DATA only has a minimum length policy. Since nla_len is
a u16, a single attribute can carry up to 65531 bytes of payload, so the
sum can exceed U16_MAX before it is assigned to pkt_len. The truncated
pkt_len determines the skb frame area, while the copy length remains
req->auth_data_len - 4, resulting in a heap buffer overflow.

For example, with auth_data_len equal to 65510 and no IEs, the sum is
65546. It is truncated to 10 and then reduced by four to 6. The driver
appends only six bytes to the skb with skb_put(), but then copies 65506
user-provided bytes into the authentication body.

Reaching this path requires CAP_NET_ADMIN in the user namespace owning
the network namespace, an up station netdev, and a suitable BSS/SAE
authentication request.

Compute the length in size_t, reject values that cannot be represented by
the firmware's u16 frame length field, and only then assign it to pkt_len.

Fixes: 36995892c271 ("wifi: mwifiex: add host mlme for client mode")
Cc: stable@vger.kernel.org # 6.12+
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260820062155.3981976-1-lilinmao@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4271,6 +4271,7 @@ mwifiex_cfg80211_authenticate(struct wip
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct sk_buff *skb;
 	u16 pkt_len, auth_alg;
+	size_t frame_len;
 	int ret;
 	struct mwifiex_ieee80211_mgmt *mgmt;
 	struct mwifiex_txinfo *tx_info;
@@ -4343,10 +4344,17 @@ mwifiex_cfg80211_authenticate(struct wip
 
 	mwifiex_cancel_scan(adapter);
 
-	pkt_len = (u16)req->ie_len + req->auth_data_len +
+	frame_len = req->ie_len + req->auth_data_len +
 		MWIFIEX_MGMT_HEADER_LEN + MWIFIEX_AUTH_BODY_LEN;
 	if (req->auth_data_len >= 4)
-		pkt_len -= 4;
+		frame_len -= 4;
+
+	if (frame_len > U16_MAX) {
+		mwifiex_dbg(priv->adapter, ERROR,
+			    "auth frame too long: %zu bytes\n", frame_len);
+		return -EINVAL;
+	}
+	pkt_len = frame_len;
 
 	skb = dev_alloc_skb(MWIFIEX_MIN_DATA_HEADER_LEN +
 			    MWIFIEX_MGMT_FRAME_HEADER_SIZE +


