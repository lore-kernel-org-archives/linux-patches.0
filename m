Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66312509F16;
	Tue, 13 Oct 2026 12:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893505; cv=none; b=rxFAitZqOb0beoHQs7uAL94PYp90GxDa4+auRo5EsjUmzJAl99kux9QDu4S1gX2WQeR20w6f5qhBSofgoDT41Lt9FNWzkdoRNR5XPpWqG14+Kgm8sIRFxwQEnjnf18YP8y+lf6daWKiIV0wjSXwF5/+frYJcHv4Bk12JKyUz5y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893505; c=relaxed/simple;
	bh=lTLm/KN6a+kC+edHq0jSWc4qSa01+oZz0TA/On53SXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D33v901n0AzBdsFDwiIHr5sUaevmVMAWxlRjt0lvRVrVm0nlb9IiXwfTeaANV+rm3IFKlxBphLpNXEQAfR/uqWarzwcdVPuxpN4U2Er29VNwRdU7RDMYfepIZbwXWPkfuuqSsqca0HnfIu7EragDmuhC00SjygZV/LVuxgylLe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TtxDy/io; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TtxDy/io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5BF1F00893;
	Tue, 13 Oct 2026 12:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893504;
	bh=8DeJ53Yhxq9p16HY6JgLj63CH5foDD1rW+ohZiZ8OUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtxDy/iogdBIvmkTKp5VaUvPCsEh9+nuBctpkPY/tItiFZxczpnLwIvW3PmI0I13c
	 6eIFnf0nW9tXrcX9C5PIBFbNCvHbO0v2av8QbT4PyHdQXvnxL1o2JxcERXbCyut02D
	 Z9QGa9wzqbgLfSUy6/FIe1F5nDhwLybl6/JNgQgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarika Sharma <sarika.sharma@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 246/621] wifi: mac80211: fix missing RX bitrate update for mesh forwarding path
Date: Tue, 13 Oct 2026 13:34:01 +0200
Message-ID: <20261013112926.700470980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Sarika Sharma <sarika.sharma@oss.qualcomm.com>

[ Upstream commit cc18fffa3a51792637169872886df3407bd5bb84 ]

Currently, RX bitrate statistics are not updated for packets received
on the mesh forwarding path during fast RX processing. This results in
incomplete RX rate tracking in station dump outputs for mesh scenarios.

Update ieee80211_invoke_fast_rx() to record the RX rate using
sta_stats_encode_rate() and store it in the last_rate field of
ieee80211_sta_rx_stats when RX_QUEUED is returned from
ieee80211_rx_mesh_data(). This ensures that RX bitrate is properly
accounted for in both RSS and non-RSS paths.

Signed-off-by: Sarika Sharma <sarika.sharma@oss.qualcomm.com>
Link: https://patch.msgid.link/20251024043627.1640447-1-sarika.sharma@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: d71c841be5d9 ("wifi: mac80211: capture fast-RX rate before mesh reuses skb->cb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3a9d7020d8d53..dd47faeb6afad 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4918,6 +4918,11 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 
 	/* after this point, don't punt to the slowpath! */
 
+	if (fast_rx->uses_rss)
+		stats = this_cpu_ptr(rx->link_sta->pcpu_rx_stats);
+	else
+		stats = &rx->link_sta->rx_stats;
+
 	if (rx->key && !(status->flag & RX_FLAG_MIC_STRIPPED) &&
 	    pskb_trim(skb, skb->len - fast_rx->icv_len))
 		goto drop;
@@ -4952,6 +4957,8 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	res = ieee80211_rx_mesh_data(rx->sdata, rx->sta, rx->skb);
 	switch (res) {
 	case RX_QUEUED:
+		stats->last_rx = jiffies;
+		stats->last_rate = sta_stats_encode_rate(status);
 		return true;
 	case RX_CONTINUE:
 		break;
@@ -4965,11 +4972,6 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
  drop:
 	dev_kfree_skb(skb);
 
-	if (fast_rx->uses_rss)
-		stats = this_cpu_ptr(rx->link_sta->pcpu_rx_stats);
-	else
-		stats = &rx->link_sta->rx_stats;
-
 	stats->dropped++;
 	return true;
 }
-- 
2.53.0



