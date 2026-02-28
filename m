Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BBC313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301108; cv=none; b=Nhp7t69YRCgWg5F3aQw1DsXM5Q3rNLlcL/3OGtpUOYC1K0Y4YaMqFnX1WMn4zqfRfJ+7bC2ubaAbk3BQRWCbi+Rvs/xjaSDc54Iz974PC+ItMze6EbS1rLt1DS8EVLwio46M64Vda+GhTqfBkHpo/ihzWmKj5/n5LxJwFScxYoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301108; c=relaxed/simple;
	bh=JCg/X8TwdiYEEg3roD6cWCBtwePevqOTlOuanY8rdgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSSvwsvXvS1nsQZXLNof2gnGgQS8gYLqBFSYHDIF9PntHfxmlvHy/bAblo2hq9sfhXdG/vi7PIbyFB59unKokPXSo3PHUeagV+G1F00Ofl/RH1LRscaR7FnBPUH0YJp/oa9dhknokYvntEYT3rLPZuc/Va5Kso63bwsgNPI06+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oDZEeNiI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oDZEeNiI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF5DC116D0;
	Sat, 28 Feb 2026 17:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301108;
	bh=JCg/X8TwdiYEEg3roD6cWCBtwePevqOTlOuanY8rdgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDZEeNiIY6LQdR6Mz21xcsJghmw76oo09Fd2rIJQV7hHCecnZQhPShyW3/76AoLaG
	 n2a0t9c/mE//dSNAaDatDG92JCjyDU6kNyaNga1OcdkgDzXCpikJdJBCm8d83RqAR+
	 JrB1JO8RdqHqZA0jyuNK+PQju/3sETUVpfG4+71ig6nSD4mXIfHRGVKGnScf5S3sEt
	 CT/P8BdGRDFTl/f9OhZbFTtsh2Us+tACyVfPysyfJrir2k9jcrDjSXjdBUbUju6tcs
	 XNhulurJ0KZOKWQa5Pt9ruT6KKY5b9a02IbHtE+LZiAVWwX9FjaorTexOmOVth/ICz
	 jsTIofbLqaqOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 262/752] wifi: rtw89: fix unable to receive probe responses under MLO connection
Date: Sat, 28 Feb 2026 12:39:33 -0500
Message-ID: <20260228174750.1542406-262-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 6f6d7a325fbde4f025ee1b1277f6f44727e21223 ]

During MLO connections, A1 of the probe responses we received are
in link address, these frames will then be dropped by mac80211 due to
not matching the MLD address in ieee80211_scan_accept_presp().
Fix this by using MLD address to scan when not using random MAC address.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260114013950.19704-13-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 080c4f8a655a8..c9851aafe649e 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -8042,6 +8042,7 @@ int rtw89_hw_scan_start(struct rtw89_dev *rtwdev,
 	struct cfg80211_scan_request *req = &scan_req->req;
 	const struct rtw89_chan *chan = rtw89_chan_get(rtwdev,
 						       rtwvif_link->chanctx_idx);
+	struct ieee80211_vif *vif = rtwvif_link_to_vif(rtwvif_link);
 	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
 	struct rtw89_chanctx_pause_parm pause_parm = {
 		.rsn = RTW89_CHANCTX_PAUSE_REASON_HW_SCAN,
@@ -8071,6 +8072,8 @@ int rtw89_hw_scan_start(struct rtw89_dev *rtwdev,
 	if (req->flags & NL80211_SCAN_FLAG_RANDOM_ADDR)
 		get_random_mask_addr(mac_addr, req->mac_addr,
 				     req->mac_addr_mask);
+	else if (ieee80211_vif_is_mld(vif))
+		ether_addr_copy(mac_addr, vif->addr);
 	else
 		ether_addr_copy(mac_addr, rtwvif_link->mac_addr);
 
-- 
2.51.0

