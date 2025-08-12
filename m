Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C2318FC91;
	Tue, 12 Aug 2025 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022185; cv=none; b=ROvcRNuhivkzJusUN7uEsHcd0H34M+iTxe/RsSwE5eQzPS6gDIBDXncX9GAf4mA+9uOcPBVg/xz0UM5vCsQi5eHPtllhr/8RJd8HAkPs9NdMzqMw8gwdSFMAnDHpS34k2JrhpdjOJrpBLItTa0u+hnMCPQ25am7BJNmmWS1Yk+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022185; c=relaxed/simple;
	bh=OOIx9aJ53lvv0pVzhcuPLEqJp7J9z9r0cXMuGCy/xUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmXA1kpFmItX2Fa47YCYhAq5mjVh/moZPTZ2wXB0eltCY9D7NmuQ1JxPUf4OqAGDtuiPEkg44IxAkLmNVO6Te+WO2JnduxTH+GNeWruPe8PvYG7fpecyh5jUkPmWii7HxuR2kIdaXzWEIw5di/SXQ3A57VQ5wRnyr/G9RccOzsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pROC0wgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pROC0wgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96194C4CEF0;
	Tue, 12 Aug 2025 18:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022185;
	bh=OOIx9aJ53lvv0pVzhcuPLEqJp7J9z9r0cXMuGCy/xUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pROC0wgnLateS0samiK7gtfAxJoAWqAAoalLlxAb4WiimHDFxEk6katW6h6/ctWuH
	 kfL28AJCfP/7XN1V9ev3psEDbM7jMP+ot/EWSo04fRgCKgNGgQwNbVMtRoXVBfMor8
	 mLF7AEQtwKEkWCeYil86HiOpYeeWwF0RpMygmh9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zong-Zhe Yang <kevin_yang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 081/369] wifi: rtw89: avoid NULL dereference when RX problematic packet on unsupported 6 GHz band
Date: Tue, 12 Aug 2025 19:26:18 +0200
Message-ID: <20250812173017.833550008@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Zong-Zhe Yang <kevin_yang@realtek.com>

[ Upstream commit 7e04f01bb94fe61c73cc59f0495c3b6c16a83231 ]

With a quite rare chance, RX report might be problematic to make SW think
a packet is received on 6 GHz band even if the chip does not support 6 GHz
band actually. Since SW won't initialize stuffs for unsupported bands, NULL
dereference will happen then in the sequence, rtw89_vif_rx_stats_iter() ->
rtw89_core_cancel_6ghz_probe_tx(). So, add a check to avoid it.

The following is a crash log for this case.

 BUG: kernel NULL pointer dereference, address: 0000000000000032
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP NOPTI
 CPU: 1 PID: 1907 Comm: irq/131-rtw89_p Tainted: G     U             6.6.56-05896-g89f5fb0eb30b #1 (HASH:1400 4)
 Hardware name: Google Telith/Telith, BIOS Google_Telith.15217.747.0 11/12/2024
 RIP: 0010:rtw89_vif_rx_stats_iter+0xd2/0x310 [rtw89_core]
 Code: 4c 89 7d c8 48 89 55 c0 49 8d 44 24 02 48 89 45 b8 45 31 ff eb 11
 41 c6 45 3a 01 41 b7 01 4d 8b 6d 00 4d 39 f5 74 42 8b 43 10 <41> 33 45
 32 0f b7 4b 14 66 41 33 4d 36 0f b7 c9 09 c1 74 d8 4d 85
 RSP: 0018:ffff9f3080138ca0 EFLAGS: 00010246
 RAX: 00000000b8bf5770 RBX: ffff91b5e8c639c0 RCX: 0000000000000011
 RDX: ffff91b582de1be8 RSI: 0000000000000000 RDI: ffff91b5e8c639e6
 RBP: ffff9f3080138d00 R08: 0000000000000000 R09: 0000000000000000
 R10: ffff91b59de70000 R11: ffffffffc069be50 R12: ffff91b5e8c639e4
 R13: 0000000000000000 R14: ffff91b5828020b8 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff91b8efa40000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000032 CR3: 00000002bf838000 CR4: 0000000000750ee0
 PKRU: 55555554
 Call Trace:
  <IRQ>
  ? __die_body+0x68/0xb0
  ? page_fault_oops+0x379/0x3e0
  ? exc_page_fault+0x4f/0xa0
  ? asm_exc_page_fault+0x22/0x30
  ? __pfx_rtw89_vif_rx_stats_iter+0x10/0x10 [rtw89_core (HASH:1400 5)]
  ? rtw89_vif_rx_stats_iter+0xd2/0x310 [rtw89_core (HASH:1400 5)]
  __iterate_interfaces+0x59/0x110 [mac80211 (HASH:1400 6)]
  ? __pfx_rtw89_vif_rx_stats_iter+0x10/0x10 [rtw89_core (HASH:1400 5)]
  ? __pfx_rtw89_vif_rx_stats_iter+0x10/0x10 [rtw89_core (HASH:1400 5)]
  ieee80211_iterate_active_interfaces_atomic+0x36/0x50 [mac80211 (HASH:1400 6)]
  rtw89_core_rx_to_mac80211+0xfd/0x1b0 [rtw89_core (HASH:1400 5)]
  rtw89_core_rx+0x43a/0x980 [rtw89_core (HASH:1400 5)]

Fixes: c6aa9a9c4725 ("wifi: rtw89: add RNR support for 6 GHz scan")
Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250618124649.11436-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 83b22bd0ce81..c336c66ac8e3 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2014,6 +2014,11 @@ static void rtw89_core_cancel_6ghz_probe_tx(struct rtw89_dev *rtwdev,
 	if (rx_status->band != NL80211_BAND_6GHZ)
 		return;
 
+	if (unlikely(!(rtwdev->chip->support_bands & BIT(NL80211_BAND_6GHZ)))) {
+		rtw89_debug(rtwdev, RTW89_DBG_UNEXP, "invalid rx on unsupported 6 GHz\n");
+		return;
+	}
+
 	ssid_ie = cfg80211_find_ie(WLAN_EID_SSID, ies, skb->len);
 
 	list_for_each_entry(info, &pkt_list[NL80211_BAND_6GHZ], list) {
-- 
2.39.5



