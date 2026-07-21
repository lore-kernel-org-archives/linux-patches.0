Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8283D37647B;
	Tue, 21 Jul 2026 20:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665739; cv=none; b=YIM2N7cScltPbet0DEFuCIHVXS6ZUU1x05l+pPnd6irTkMV/fgNv94DRNgxyoiMYqhyR70ul2ZIBT6+02ZczBxxntHOfk4jB6mRaKgyfw2xFqwWTyLMSLrLA43xvaLzyR6q/PzRzguJkaK35NRlTm9+p4LPXhT8zdDhLKqFFv1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665739; c=relaxed/simple;
	bh=Hue6XNIRVhZFc7We8+GkP9iG18r/jIbHd4EwPa4c7kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nTcIwZujbc0JZ0ErVKgUlLy9R3R5D1OMv73SBkwajiRC1e9RAPznyvB8rBYg/P+CruVbRJ0KVx7CqhoPqXJt3Bhqiez3XIz3L/K8f/j4ofb2b/QRhpGJzTOot9kJqa9H2MutwhJH0INA6Wl58E0rBMsFRpA84lAtJ1xc93EBvco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRKtwBgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRKtwBgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28271F000E9;
	Tue, 21 Jul 2026 20:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665737;
	bh=fDvNWd+wgj2n/Fz1MpOywrgq5rVIOCm4y/RxHRU7Egk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRKtwBgGZQZ3wFF4vE7kb05aJFfs59Pqbly6+25p/elWssyeNd1j56Fm1hNDnZgpM
	 I75JU8QqU21Nxyho8mFctbbUyj8hzkyQeHCPdCQKddH6UfPbFw15AQmq5u4k8/sylV
	 sXMHWrc486w5ZZy31HM67Q+k04WwvaOH5lcIxIpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shin-Yi Lin <isaiah@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0373/1266] wifi: rtw89: Correct data type for scan index to avoid infinite loop
Date: Tue, 21 Jul 2026 17:13:30 +0200
Message-ID: <20260721152450.171493290@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shin-Yi Lin <isaiah@realtek.com>

[ Upstream commit 08fdcb529df6df3562dd2b0035f88dd5be8b3c68 ]

A kernel soft lockup was observed during Wi-Fi scanning on the 6GHz band.
The CPU becomes stuck in rtw89_hw_scan_add_chan_ax for over 20 seconds,
leading to a system panic.

RIP points to 0f b6 c3 (movzbl %bl, %eax), which zero-extends
the low 8 bits of RBX into RAX.
RBX (the counter i) has reached a huge value: 0x137466a1.

  watchdog: BUG: soft lockup - CPU#2 stuck for 26s! [kworker/u16:4:6124]
  Workqueue: events_unbound cfg80211_wiphy_work [cfg80211]
  RIP: 0010:rtw89_hw_scan_add_chan_ax+0xb3/0x6e0 [rtw89_core]
  Code: a0 48 89 45 a8 44 89 6d 9c 44 89 75 98 eb 29 66 66 2e 0f 1f
  84 00 00 00 00 00 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 83 c3 01
  <0f> b6 c3 41 3b 44 24 74 0f 83 0b 02 00 00 0f b6 c3 48 8d 14 80 49
  RSP: 0018:ffffcb48cbaa39f8 EFLAGS: 00000202
  RAX: 0000000000000005 RBX: 00000000137466a1 RCX: 0000000000000000
  RDX: ffff89ffc9d851a8 RSI: 0000000000004f0d RDI: 0000000096af0130
  RBP: ffffcb48cbaa3a60 R08: 0000000000000000 R09: ffff8a00b7502080
  R10: ffff8a00b75ff600 R11: 0000000000000000 R12: ffff89ffc7553870
  R13: ffff8a00b7ac8f19 R14: ffff8a00b75020d8 R15: ffff89ffc3d54d80
  FS:  0000000000000000(0000) GS:ffff8a014f962000(0000)
  knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007558d7f9f4c4 CR3: 0000000178040001 CR4: 00000000001706f0
  Call Trace:
   <TASK>
   rtw89_hw_scan_prep_chan_list_ax+0x8a/0x400 [rtw89_core]
   rtw89_hw_scan_start+0x546/0x8a0 [rtw89_core]
   ? rtw89_fw_h2c_default_cmac_tbl+0x13c/0x1f0 [rtw89_core]
   rtw89_ops_hw_scan+0xae/0x120 [rtw89_core]
   drv_hw_scan+0xbb/0x180 [mac80211]
   __ieee80211_start_scan+0x2fc/0x750 [mac80211]
   ieee80211_request_scan+0xe/0x20 [mac80211]
   ieee80211_scan+0x123/0x190 [mac80211]
   rdev_scan+0x40/0x110 [cfg80211]
   cfg80211_scan_6ghz+0x5a1/0xa30 [cfg80211]

By objdump with source:

	for (i = 0; i < req->n_6ghz_params; i++) {
   5fbc0:	83 c3 01             	add    $0x1,%ebx --> i++
   5fbc3:	0f b6 c3             	movzbl %bl,%eax  --> get counter
   fbc6:	41 3b 44 24 74       	cmp    0x74(%r12),%eax

   * RBX: 00000000137466a1 -> %bl = a1 -> EAX = 000000a1 (161)

Fixes: c6aa9a9c4725 ("wifi: rtw89: add RNR support for 6 GHz scan")
Signed-off-by: Shin-Yi Lin <isaiah@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260420034051.17666-7-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index 539537360914c6..48ed0e5dbed8fe 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -3641,7 +3641,7 @@ static int rtw89_update_6ghz_rnr_chan(struct rtw89_dev *rtwdev,
 	struct sk_buff *skb;
 	bool found;
 	int ret = 0;
-	u8 i;
+	u32 i;
 
 	if (!req->n_6ghz_params)
 		return 0;
-- 
2.53.0



