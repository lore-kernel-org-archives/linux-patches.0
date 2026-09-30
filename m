Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC27C5172F5;
	Wed, 30 Sep 2026 17:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790666; cv=none; b=cugA44CKBkwyaKRNvnumkKJLK86fyhrdOHGDnofElOtJQ4F81eSkZX12WP95BvpA9jP0RIzPXF5+XQED3CjaeowL+jdGxEF3RPTUWouSIhMXw5fhRf/ZFo5qH2ghL651jOGoKvS7c+oy5hPrAR4e/hzCUg5b4pJ3NcpTZAjiMME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790666; c=relaxed/simple;
	bh=2xPcUTuXaheh0/JJZ6OxRqqpO6voBQT7uSMCPrs6aVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDprVe5MBbfggiY0fQU7ZVJh8E1612gjTB8bIQFemnO680D5P5vD8PxHQKHDU8fMaejMl5ePpc+beXJdowYBFxP3e7PiLRqZDzwuHHSNipKjxvdNoHLrKMhTFa5UPnyj1yablpUhTqxFFAnNzjDOR1QbQrCOJTPqhiHLoIZ0d/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3ZULBYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3ZULBYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229FE1F000FF;
	Wed, 30 Sep 2026 17:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790664;
	bh=23rgbSkQNxkLUqD/gN60YRwlVgmtOovoiV2Isq0LT8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3ZULBYVkUIDgz9jD81iNjq4nGPAHuS8yDEUvG/IABzgUA4A6oqBNUioWQaVmBC7X
	 XtFxo0MAwAxKWiFse9SePSHE0ZIkbMqt3/lp43/jO+sje/rDyLvH+oB0pCoAV215dc
	 2TyN73lIOg44Eu2+DJl1ILZo3nKTM2PqSk9zcAhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jouni Malinen <j@w1.fi>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/752] wifi: mac80211: always allow transmitting null-data on TXQs
Date: Wed, 30 Sep 2026 17:17:57 +0200
Message-ID: <20260930152358.302208227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 51129a2ca0482b006d0e12a0aa025ff1e1cad2cb ]

Jouni reported that certain sequences of tests caused some
WDS tests to fail after applying the upcoming hwsim changes
for NAN. I bisected that down to converting hwsim to TXQs,
and after a long debug session found that the 4-addr NDP was
getting dropped, because it goes out via a (management) TXQ
and is a data frame.

It's unclear to me now why this only happens in some test
sequences (e.g. "sigma_dut_sae_h2e_ap_loop ap_wds_sta" and
"sigma_dut_eap_ttls_all_akm_suites ap_wds_sta_open"), maybe
that affects timing and the frame is otherwise delayed in
some way.

Correct the check to only drop frames that actually carry
data, not NDPs.

Reported-by: Jouni Malinen <j@w1.fi>
Link: https://patch.msgid.link/20260417141601.851ddf4adb59.I3d668c0e1bdca9cd98f2fc46f84a066e68cc7a62@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 511bdb2e0aa29..b7865f3b97879 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3709,7 +3709,7 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 		 * injected frames or EAPOL frames from the local station.
 		 */
 		if (unlikely(!(info->flags & IEEE80211_TX_CTL_INJECTED) &&
-			     ieee80211_is_data(hdr->frame_control) &&
+			     ieee80211_is_data_present(hdr->frame_control) &&
 			     !ieee80211_vif_is_mesh(&tx.sdata->vif) &&
 			     tx.sdata->vif.type != NL80211_IFTYPE_OCB &&
 			     !is_multicast_ether_addr(hdr->addr1) &&
-- 
2.53.0



