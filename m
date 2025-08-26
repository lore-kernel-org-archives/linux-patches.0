Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5199A246790;
	Tue, 26 Aug 2025 12:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212959; cv=none; b=bkQrQO6pY7iaI/W+p2HczjEoK6Y5FxGJPTdCtGvBQTq3Oe346884asGTuJeIpqtT3fs9WqPnGTb32NL7sdWdFvtPdBOXbv7b1mG/CIe58RBfzgcGo+YEyMO/7gYqzqKfBmgeYf76m1/y4Woj0aYP9rHqXHhS50MjC9wl3/x3kng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212959; c=relaxed/simple;
	bh=b8gYumdyEqvnYvcB5SkCz5KNjzsbqBBZuUxeS56LyTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWY84KrBsWI3bTHee08rvC8tRzTRbDyR572d+x0oZxayFVEG0oQBCHdNDlmxjPRU3ibNqgN8dXJ3bGyEkloLcdXWfLZSpNccvN2NI/0aD9t/BflG9ZdaJIJwONp6jcfanUbvfvK379zSOdTKvo5V1S+5JgFUNh6tYFbopmFTgZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qX8kxKFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qX8kxKFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF82AC116B1;
	Tue, 26 Aug 2025 12:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212959;
	bh=b8gYumdyEqvnYvcB5SkCz5KNjzsbqBBZuUxeS56LyTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qX8kxKFQTXhWyF3EMLAq8+Zzxowinx8XRzpKJSrl2gwFzFtPeOKWxOdUd+lAZipQi
	 +PHJbNgKBXHmI3rogUqm6w2IG/ah10QMPjL0+T4pzAifkO2K3iZlPRas6cOvWkGhpZ
	 pAPleaGCYtNMmvVWDfQWu4Q9YIDa6Q5EAVNUiJzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/587] wifi: mac80211: fix rx link assignment for non-MLO stations
Date: Tue, 26 Aug 2025 13:05:17 +0200
Message-ID: <20250826110957.219280011@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Chandrakanthan <quic_haric@quicinc.com>

[ Upstream commit cc2b722132893164bcb3cee4f08ed056e126eb6c ]

Currently, ieee80211_rx_data_set_sta() does not correctly handle the
case where the interface supports multiple links (MLO), but the station
does not (non-MLO). This can lead to incorrect link assignment or
unexpected warnings when accessing link information.

Hence, add a fix to check if the station lacks valid link support and
use its default link ID for rx->link assignment. If the station
unexpectedly has valid links, fall back to the default link.

This ensures correct link association and prevents potential issues
in mixed MLO/non-MLO environments.

Signed-off-by: Hari Chandrakanthan <quic_haric@quicinc.com>
Signed-off-by: Sarika Sharma <quic_sarishar@quicinc.com>
Link: https://patch.msgid.link/20250630084119.3583593-1-quic_sarishar@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 58665b6ae635..210337ef23cf 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4221,10 +4221,16 @@ static bool ieee80211_rx_data_set_sta(struct ieee80211_rx_data *rx,
 		rx->link_sta = NULL;
 	}
 
-	if (link_id < 0)
-		rx->link = &rx->sdata->deflink;
-	else if (!ieee80211_rx_data_set_link(rx, link_id))
+	if (link_id < 0) {
+		if (ieee80211_vif_is_mld(&rx->sdata->vif) &&
+		    sta && !sta->sta.valid_links)
+			rx->link =
+				rcu_dereference(rx->sdata->link[sta->deflink.link_id]);
+		else
+			rx->link = &rx->sdata->deflink;
+	} else if (!ieee80211_rx_data_set_link(rx, link_id)) {
 		return false;
+	}
 
 	return true;
 }
-- 
2.39.5



