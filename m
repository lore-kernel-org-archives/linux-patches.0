Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB41031E0EB;
	Mon, 18 Aug 2025 13:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523692; cv=none; b=ZlXugYbgMgCsRNExNTsYMDQIUGYwC1MRyIrxitsoD5pGd1lyPZl98OclDeGVjkv0DOrUVSLb4xWlLf09z1oFSSuCe+QY2Kp8a4gKJEdlXkWb3u4IOQPvLdCtn4k+b0mFmN2pOhC0eEvh2GIjxnbe0BsiJQhx02LT3S2luuBlFpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523692; c=relaxed/simple;
	bh=jBO6kAMJW29OlQh1iyHkzujPafBTkNsjNoBJDtKBX08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aK1BxVUiEeJ/kyBoxnAOMNR/4ERIN5v+m2o07KnIxTgssmoiIC1VuvH+ytyiEF75eNvLQqKwhB6sEEvqVA6NmDzUc2rXY5t/UF7H8BXDuxXzhr8yxaCL8uVRgim5atpWQ3Dmw/GuYSV8rm1i+i3AhDg+oppFGpA/r7YA0PDfSlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjXipJ25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjXipJ25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A5EC4CEEB;
	Mon, 18 Aug 2025 13:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523692;
	bh=jBO6kAMJW29OlQh1iyHkzujPafBTkNsjNoBJDtKBX08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjXipJ25W9DqCatPLYvj08rHitZ5PqFC77YRgI5MXpIHTYuCCj1dacPFDB4aBp2ZJ
	 SfHxAnmhvbLBH05TekRfIcqhhjEEQd+Ovauwyj/L7CFozV5KusvtM7Bvg8mvr2bM0J
	 x3c4O48s/5ZpGKW7kfWDUdZ/5UhQZUXpQAQ6vHYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hari Chandrakanthan <quic_haric@quicinc.com>,
	Sarika Sharma <quic_sarishar@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 249/515] wifi: mac80211: fix rx link assignment for non-MLO stations
Date: Mon, 18 Aug 2025 14:43:55 +0200
Message-ID: <20250818124507.981193488@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8ec06cf0a9f0..7b801dd3f569 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4211,10 +4211,16 @@ static bool ieee80211_rx_data_set_sta(struct ieee80211_rx_data *rx,
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



