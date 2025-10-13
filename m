Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795DF3081D3;
	Mon, 13 Oct 2025 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368458; cv=none; b=uMM2S7D3V9uCg5m5FVj3PEVr+E+7GYZZO9oSD1nmkiIocQGccNEvrF+tqXnq/DaLpVxDq2AwEE9Nntm3EVmIfbU1p1Z46oBIRVuCCzCjCO0toRULpA5HUN24gp/oYo84jzM3+RxgXAiWsV1ZpZCZZMn3LPdXZb4uPbEgj/EDpVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368458; c=relaxed/simple;
	bh=UkiiO1vBNBT2ZNxLvaM92dJ7k7Ikcfs7xnGuPbrj+HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r91gwD1NAsSVKezjUZ8gGuF/AzPI10MpWqt3pPI2O704UPgIx4ogwMOV/ApahNxH0U/v6gjEdm26iubVfRxxZvKRiwXCEQWdG/WRry4BoiptAtJwN3dMWg4BC0pEvW9AXor1GDAYFBlNkklf+1evpNiCp3ZEUMq4WZS4yiF3tlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0q6jeB0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0q6jeB0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D47C4CEE7;
	Mon, 13 Oct 2025 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368458;
	bh=UkiiO1vBNBT2ZNxLvaM92dJ7k7Ikcfs7xnGuPbrj+HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0q6jeB0KM63Txv5bj+O+Yje/DhtIHKsQy7SmHTpk/POBC0A2mpwChpth8LJO5QDul
	 JRdvPgl0NoqtdIsBIezIw/WMo2FYVtjQuHmn8gUAiBCEkkKDxcTPDG/6E3B3+czBho
	 LxpdeJnXh89aHxKxajmREvLZo90UsVvEopYZ9Mg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/262] wifi: mac80211: fix Rx packet handling when pubsta information is not available
Date: Mon, 13 Oct 2025 16:45:10 +0200
Message-ID: <20251013144332.174950932@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>

[ Upstream commit 32d340ae675800672e1219444a17940a8efe5cca ]

In ieee80211_rx_handle_packet(), if the caller does not provide pubsta
information, an attempt is made to find the station using the address 2
(source address) field in the header. Since pubsta is missing, link
information such as link_valid and link_id is also unavailable. Now if such
a situation comes, and if a matching ML station entry is found based on
the source address, currently the packet is dropped due to missing link ID
in the status field which is not correct.

Hence, to fix this issue, if link_valid is not set and the station is an
ML station, make an attempt to find a link station entry using the source
address. If a valid link station is found, derive the link ID and proceed
with packet processing. Otherwise, drop the packet as per the existing
flow.

Fixes: ea9d807b5642 ("wifi: mac80211: add link information in ieee80211_rx_status")
Suggested-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Signed-off-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250917-fix_data_packet_rx_with_mlo_and_no_pubsta-v1-1-8cf971a958ac@oss.qualcomm.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8c0d91dfd7e2b..538c6eea645f2 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5280,12 +5280,20 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 			}
 
 			rx.sdata = prev_sta->sdata;
+			if (!status->link_valid && prev_sta->sta.mlo) {
+				struct link_sta_info *link_sta;
+
+				link_sta = link_sta_info_get_bss(rx.sdata,
+								 hdr->addr2);
+				if (!link_sta)
+					continue;
+
+				link_id = link_sta->link_id;
+			}
+
 			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
 				goto out;
 
-			if (!status->link_valid && prev_sta->sta.mlo)
-				continue;
-
 			ieee80211_prepare_and_rx_handle(&rx, skb, false);
 
 			prev_sta = sta;
@@ -5293,10 +5301,18 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 		if (prev_sta) {
 			rx.sdata = prev_sta->sdata;
-			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
-				goto out;
+			if (!status->link_valid && prev_sta->sta.mlo) {
+				struct link_sta_info *link_sta;
+
+				link_sta = link_sta_info_get_bss(rx.sdata,
+								 hdr->addr2);
+				if (!link_sta)
+					goto out;
 
-			if (!status->link_valid && prev_sta->sta.mlo)
+				link_id = link_sta->link_id;
+			}
+
+			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
 				goto out;
 
 			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
-- 
2.51.0



