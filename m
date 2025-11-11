Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDDE26ED5E;
	Tue, 11 Nov 2025 01:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823383; cv=none; b=WxT9GZPNeMsGsJJyku2pItdeAFmnd3nRr0aNjq6NbdsYKDqXa/beP8yMyiBHUJRI9wb7UoWMOe17iJiaBkKmEMQ0xoZpVFI5tzuzx3jjhA4rOXnAFdoAYeHTHFyn26hUhg+KvYoKCImPwu9TmXb/mISGAYszLDX93QwsIl2kfmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823383; c=relaxed/simple;
	bh=4Gf5DcR0ZvFoqHzHpLB5aBnisnQUXC5karz4Y5QDvsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MX79jVOKCPR5DlMUJPH25G6MxoWxS5LgDMZtenr1HcPmpXPysMCB8ucTNYKmA8vastaBsf9ozWF4r+S4QQB2hD3tlVkn59RsbB57AJQYkC1pnsvCGKEIVWCSnr8fhUJRevkaoiYY2JH9gfEfKJ1IXME8eJKnPxSjd6QmowBAuEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XcXxu+0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XcXxu+0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F763C113D0;
	Tue, 11 Nov 2025 01:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823382;
	bh=4Gf5DcR0ZvFoqHzHpLB5aBnisnQUXC5karz4Y5QDvsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XcXxu+0ud6NVi6kzzBvCbmTuko5erODpf4sBKLc33FaciAsHP86EnsumKuoSUrONB
	 rSHnMkeAypqP5Qsu5i6oHOlegQse2WCrSlxn0lzlWNZ3LB2EJi/kPgKSGxByR/rUeW
	 l1au2gSQof3XvsCfLQ9CZQPXuOP7cKueoNLKmfzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Chung Chen <damon.chen@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/565] wifi: rtw89: fix BSSID comparison for non-transmitted BSSID
Date: Tue, 11 Nov 2025 09:41:27 +0900
Message-ID: <20251111004532.113766549@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Kuan-Chung Chen <damon.chen@realtek.com>

[ Upstream commit c4c16c88e78417424b4e3f33177e84baf0bc9a99 ]

For non-transmitted connections, beacons are received from the
transmitted BSSID. Fix this to avoid missing beacon statistics.

Signed-off-by: Kuan-Chung Chen <damon.chen@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250811123950.15697-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index df8fad7a2aea6..1147abf771547 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2074,6 +2074,7 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 	struct ieee80211_bss_conf *bss_conf;
 	struct rtw89_vif_link *rtwvif_link;
 	const u8 *bssid = iter_data->bssid;
+	const u8 *target_bssid;
 
 	if (rtwdev->scanning &&
 	    (ieee80211_is_beacon(hdr->frame_control) ||
@@ -2098,7 +2099,10 @@ static void rtw89_vif_rx_stats_iter(void *data, u8 *mac,
 		goto out;
 	}
 
-	if (!ether_addr_equal(bss_conf->bssid, bssid))
+	target_bssid = ieee80211_is_beacon(hdr->frame_control) &&
+		       bss_conf->nontransmitted ?
+		       bss_conf->transmitter_bssid : bss_conf->bssid;
+	if (!ether_addr_equal(target_bssid, bssid))
 		goto out;
 
 	if (ieee80211_is_beacon(hdr->frame_control)) {
-- 
2.51.0



