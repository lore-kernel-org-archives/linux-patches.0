Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720DD15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F88C433C1;
	Mon,  5 Dec 2022 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268960;
	bh=pGqEl1ICnamFC3P4nkHXzCfJhi4auGeH6yBPGtFKePY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TouPBGtwrvr3OrTN6hCLZbyKkh+/7IH1Lf9on/6FH0+BsKjzj4fsP7rHcaLIg5kh6
	 8GAxO/mIcxWU3w6b1Oyj3kSX8iGj68uoeyrGl6HQryVQkzfziQsNMbrMWcyKrmdb56
	 QNC2Xd0IHHOhq/fHZwGseXsEz++KgPdt1QMV8guA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/120] wifi: mac8021: fix possible oob access in ieee80211_get_rate_duration
Date: Mon,  5 Dec 2022 20:09:47 +0100
Message-Id: <20221205190807.981688725@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 3e8f7abcc3473bc9603323803aeaed4ffcc3a2ab ]

Fix possible out-of-bound access in ieee80211_get_rate_duration routine
as reported by the following UBSAN report:

UBSAN: array-index-out-of-bounds in net/mac80211/airtime.c:455:47
index 15 is out of range for type 'u16 [12]'
CPU: 2 PID: 217 Comm: kworker/u32:10 Not tainted 6.1.0-060100rc3-generic
Hardware name: Acer Aspire TC-281/Aspire TC-281, BIOS R01-A2 07/18/2017
Workqueue: mt76 mt76u_tx_status_data [mt76_usb]
Call Trace:
 <TASK>
 show_stack+0x4e/0x61
 dump_stack_lvl+0x4a/0x6f
 dump_stack+0x10/0x18
 ubsan_epilogue+0x9/0x43
 __ubsan_handle_out_of_bounds.cold+0x42/0x47
ieee80211_get_rate_duration.constprop.0+0x22f/0x2a0 [mac80211]
 ? ieee80211_tx_status_ext+0x32e/0x640 [mac80211]
 ieee80211_calc_rx_airtime+0xda/0x120 [mac80211]
 ieee80211_calc_tx_airtime+0xb4/0x100 [mac80211]
 mt76x02_send_tx_status+0x266/0x480 [mt76x02_lib]
 mt76x02_tx_status_data+0x52/0x80 [mt76x02_lib]
 mt76u_tx_status_data+0x67/0xd0 [mt76_usb]
 process_one_work+0x225/0x400
 worker_thread+0x50/0x3e0
 ? process_one_work+0x400/0x400
 kthread+0xe9/0x110
 ? kthread_complete_and_exit+0x20/0x20
 ret_from_fork+0x22/0x30

Fixes: db3e1c40cf2f ("mac80211: Import airtime calculation code from mt76")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/airtime.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/airtime.c b/net/mac80211/airtime.c
index 26d2f8ba7029..758ef63669e7 100644
--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -457,6 +457,9 @@ static u32 ieee80211_get_rate_duration(struct ieee80211_hw *hw,
 			 (status->encoding == RX_ENC_HE && streams > 8)))
 		return 0;
 
+	if (idx >= MCS_GROUP_RATES)
+		return 0;
+
 	duration = airtime_mcs_groups[group].duration[idx];
 	duration <<= airtime_mcs_groups[group].shift;
 	*overhead = 36 + (streams << 2);
-- 
2.35.1



