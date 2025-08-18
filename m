Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767B812DDA1;
	Mon, 18 Aug 2025 13:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522082; cv=none; b=AagLi/3/sZQgtO0Ov+ZWcpnSNr2abw6mbesMMUx+Uqw9Kx2cN/ocGCfVZjoJbKJfp8gLSQT71LbLKt73XJORWhF+OMqrSmmzcNtIcvrNsdF8qJZsonFD3e836L8C/mBDC2gGjkvRVHo7yeNiowndAgdTVWvh6zqgsjgQ4n5DGpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522082; c=relaxed/simple;
	bh=32XH64Rrjoy8s5SNGkGg1GYD7/ckUlTm/81VrCk/8X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgYvIxJ1grMcqGRbzloMxI7TASwCjWQkyLpdizZU9X0eSYoMrjdoD8XvMqT5o9TaKNYvBFDWTNuV+V0V5BTCBu8aAlTyotS/JHeNPQZW4yFXZjP9hN50tTcVvEMyoqvDYjg8PbM1oBreWDlprpd9cGsagocWxXH6qQK46b8zGxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsDuLxJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsDuLxJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C6FC113D0;
	Mon, 18 Aug 2025 13:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522082;
	bh=32XH64Rrjoy8s5SNGkGg1GYD7/ckUlTm/81VrCk/8X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsDuLxJl0MIUtWyX4WvISui8aC1rsuCQDVbHdLd0RVH11gBDN6gF3BtiTt2w76y4Q
	 5iFw+p6L0QNPqhA1FRQGRe/NnK4FoumaSVv5rqvixJN5EvQng1wdXMgk2g6Vk3HQtt
	 QcoZ/Zv7yCR4VeyahVCeFf0njIbiUlx+EJ4Msk8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/444] wifi: mac80211: fix rx link assignment for non-MLO stations
Date: Mon, 18 Aug 2025 14:43:55 +0200
Message-ID: <20250818124456.690439953@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8e1d00efa62e..8c0d91dfd7e2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4283,10 +4283,16 @@ static bool ieee80211_rx_data_set_sta(struct ieee80211_rx_data *rx,
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



