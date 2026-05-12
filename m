Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB143EDE5D;
	Tue, 12 May 2026 18:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609097; cv=none; b=CoS96us1Tt8qvohwoYBOl27cwNCeSsNINrXeUx814tVAO7I+mWzPRb9aik0uebP6M5wauxo2u0vIdi2SLu8WbUhXdt8YBZbg4FUTotGIE635hfjNr8SYrcoGAwRNv/dkw//jTi2toWVAZ43yrKwQNG7AViUir0486gllFqg18A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609097; c=relaxed/simple;
	bh=1hbogNVnGAvoqR05TLjMKpINC/m6PS4fLqa15/ECKXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6BeJzE8RQr8yRSu/C6Ay1wjum8H3ETIWZhwNRxitO0aQ3ap80nl4Ug+KveMwFs/Y54ulqiWJHhMpyVKF9xheD6bQqJkQGXfznmJ7pmqY2ZkHvLQZooAmJFL3bZEMqfLjEYqBMo4c2ZEx6GsmKcatw2qnvp9IO+j/CYXKZQ1Cd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eemw6R4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eemw6R4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24EE4C2BCB0;
	Tue, 12 May 2026 18:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609097;
	bh=1hbogNVnGAvoqR05TLjMKpINC/m6PS4fLqa15/ECKXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eemw6R4+E7ZAJmvwqU9pzdPWwTjPzng/8lKUNsS4/AWpbTpHE3+XY9NpwIvJg0C4b
	 XaQvgFde5PezRFH5zpW0MPRRa0l2MA/kbFJTLEEw3cQKSX8sFaut9JnV4EG6RIssg5
	 ITL/XiGiEpEyQ6JEOctt2IJI+8Hxor/hAu6q99L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.0 027/307] wifi: mac80211: drop stray static from fast-RX rx_result
Date: Tue, 12 May 2026 19:37:02 +0200
Message-ID: <20260512173940.697911221@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catherine <enderaoelyther@gmail.com>

commit 7a5b81e0c87a075afd572f659d8eb68c9c4cd2ba upstream.

ieee80211_invoke_fast_rx() is documented as safe for parallel RX, but
its per-invocation rx_result is declared static. Concurrent callers then
share one instance and can overwrite each other's result between
ieee80211_rx_mesh_data() and the switch on res.

That can make a packet that was queued or consumed by
ieee80211_rx_mesh_data() fall through into ieee80211_rx_8023(), or make
a packet that should continue return as queued.

Make res an automatic variable so each invocation keeps its own result.

Fixes: 3468e1e0c639 ("wifi: mac80211: add mesh fast-rx support")
Cc: stable@vger.kernel.org
Signed-off-by: Catherine <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260424131435.83212-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4928,7 +4928,7 @@ static bool ieee80211_invoke_fast_rx(str
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
-	static ieee80211_rx_result res;
+	ieee80211_rx_result res;
 	int orig_len = skb->len;
 	int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 	int snap_offs = hdrlen;


