Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37401FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13B6C433D2;
	Fri,  3 Feb 2023 10:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419691;
	bh=p/TESxW3x2c13Ep18IXZqi2TzocwFHIWf5tuyhmRZmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfohrZ+sKkGnZH2Yd2MDczh4xy1BWWgR8Lg1CV2KWl4oIhGxBhsKrqX0w+DZZ5m3+
	 pziq5UXVto2S2mAxievyWGidjxxddKUasvV9rK+l8dy2b679T7CAYBhjL+iIs2wkdI
	 VPpTEDWY2nHVWcClbc6yEqImjAPSyJa8olGl0QBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sriram R <quic_srirrama@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 08/28] mac80211: Fix MLO address translation for multiple bss case
Date: Fri,  3 Feb 2023 11:12:56 +0100
Message-Id: <20230203101010.331917874@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sriram R <quic_srirrama@quicinc.com>

[ Upstream commit fa22b51ace8aa106267636f36170e940e676809c ]

When multiple interfaces are present in the local interface
list, new skb copy is taken before rx processing except for
the first interface. The address translation happens each
time only on the original skb since the hdr pointer is not
updated properly to the newly created skb.

As a result frames start to drop in userspace when address
based checks or search fails.

Signed-off-by: Sriram R <quic_srirrama@quicinc.com>
Link: https://lore.kernel.org/r/20221208040050.25922-1-quic_srirrama@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3262ebb24092..8f0d7c666df7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4859,6 +4859,9 @@ static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
 		 */
 		shwt = skb_hwtstamps(rx->skb);
 		shwt->hwtstamp = skb_hwtstamps(skb)->hwtstamp;
+
+		/* Update the hdr pointer to the new skb for translation below */
+		hdr = (struct ieee80211_hdr *)rx->skb->data;
 	}
 
 	if (unlikely(rx->sta && rx->sta->sta.mlo)) {
-- 
2.39.0



