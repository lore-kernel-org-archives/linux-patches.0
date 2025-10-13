Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844FB30ACF6;
	Mon, 13 Oct 2025 15:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369876; cv=none; b=oQRdh64PZsls3L5Fw052KYp+qPe1p+Zy5GrTzAbndUnGEQo9XJb4ROyZhXBKd6WVT2TyA+g4uskospMc9TpEdQ3OmJBB18U89KaLMpa9gXBpdZb6WCoTPAXtyCflK3HofuwIsiHo7Cpvh1ydqa5mjUi9y0Xe5oGkiJA7Xt/fuW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369876; c=relaxed/simple;
	bh=H/R25WAKionlmuX7qDI0us+tK/BDEBu+9XU3mD6kgTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+b/E7YJerFOO40S2BrGLrugvYdivqGeBEIMOFHD6DyQXFTDP4oLYBi2CD0ClVGgdlKp0qSOaqoK0OJyc25+Gbqa0NkKJE+8H8YijujZyo0/R/pub+p13cbDn1KLUWznN7QsZm8nknBs/Y2jepE1bB41olpAuXGGh0AVNrhH0pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRwZk2oj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRwZk2oj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09E75C4CEE7;
	Mon, 13 Oct 2025 15:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369876;
	bh=H/R25WAKionlmuX7qDI0us+tK/BDEBu+9XU3mD6kgTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRwZk2ojGANZ1REQzdDHKo4jV8YGd/xM10zH3DokDHDUG/eit0+j9ki8lH4AIeAtM
	 Bv6z0sAw02d2UKg/7loTRuT96BFPPIYvBbdVcnytBxT1qRpd9E8p9bQ+BvcZP6HL6n
	 Ls72JxD4GMAWsu7VlcaouuJuEMQqKXFP2xyKhtZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 399/563] wifi: mac80211: fix Rx packet handling when pubsta information is not available
Date: Mon, 13 Oct 2025 16:44:20 +0200
Message-ID: <20251013144425.737008880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 4d4ff4d4917a2..59baca24aa6b9 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -5230,12 +5230,20 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
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
@@ -5243,10 +5251,18 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 
 		if (prev_sta) {
 			rx.sdata = prev_sta->sdata;
-			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
-				goto out;
+			if (!status->link_valid && prev_sta->sta.mlo) {
+				struct link_sta_info *link_sta;
 
-			if (!status->link_valid && prev_sta->sta.mlo)
+				link_sta = link_sta_info_get_bss(rx.sdata,
+								 hdr->addr2);
+				if (!link_sta)
+					goto out;
+
+				link_id = link_sta->link_id;
+			}
+
+			if (!ieee80211_rx_data_set_sta(&rx, prev_sta, link_id))
 				goto out;
 
 			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
-- 
2.51.0



