Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9E715E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ld1Q1ME6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC326C433C8;
	Mon, 23 Oct 2023 11:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061136;
	bh=4xye0hcPHsQ2X2LNac0KPpGEuLTK+mpoJBBnJoRW+3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ld1Q1ME68xPqfA1eZBJX8WDLWGGXeHD1ps8Ak7Rrm3hBFXLit2YBHdr9DBH/6oSWy
	 DLB/zl1Ls/JCyTu00Ikuq+Bx0CUKjmT1oiBf4Hlcz4nG151e6R3rxmND+IQZH2deSD
	 Kyou6EgWG8iksxES8tUppju36pLQ0XvXZic9uoNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gong <quic_wgong@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/137] wifi: mac80211: allow transmitting EAPOL frames with tainted key
Date: Mon, 23 Oct 2023 12:57:22 +0200
Message-ID: <20231023104823.773976353@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 61304336c67358d49a989e5e0060d8c99bad6ca8 ]

Lower layer device driver stop/wake TX by calling ieee80211_stop_queue()/
ieee80211_wake_queue() while hw scan. Sometimes hw scan and PTK rekey are
running in parallel, when M4 sent from wpa_supplicant arrive while the TX
queue is stopped, then the M4 will pending send, and then new key install
from wpa_supplicant. After TX queue wake up by lower layer device driver,
the M4 will be dropped by below call stack.

When key install started, the current key flag is set KEY_FLAG_TAINTED in
ieee80211_pairwise_rekey(), and then mac80211 wait key install complete by
lower layer device driver. Meanwhile ieee80211_tx_h_select_key() will return
TX_DROP for the M4 in step 12 below, and then ieee80211_free_txskb() called
by ieee80211_tx_dequeue(), so the M4 will not send and free, then the rekey
process failed becaue AP not receive M4. Please see details in steps below.

There are a interval between KEY_FLAG_TAINTED set for current key flag and
install key complete by lower layer device driver, the KEY_FLAG_TAINTED is
set in this interval, all packet including M4 will be dropped in this
interval, the interval is step 8~13 as below.

issue steps:
      TX thread                 install key thread
1.   stop_queue                      -idle-
2.   sending M4                      -idle-
3.   M4 pending                      -idle-
4.     -idle-                  starting install key from wpa_supplicant
5.     -idle-                  =>ieee80211_key_replace()
6.     -idle-                  =>ieee80211_pairwise_rekey() and set
                                 currently key->flags |= KEY_FLAG_TAINTED
7.     -idle-                  =>ieee80211_key_enable_hw_accel()
8.     -idle-                  =>drv_set_key() and waiting key install
                                 complete from lower layer device driver
9.   wake_queue                     -waiting state-
10.  re-sending M4                  -waiting state-
11.  =>ieee80211_tx_h_select_key()  -waiting state-
12.  drop M4 by KEY_FLAG_TAINTED    -waiting state-
13.    -idle-                   install key complete with success/fail
                                  success: clear flag KEY_FLAG_TAINTED
                                  fail: start disconnect

Hence add check in step 11 above to allow the EAPOL send out in the
interval. If lower layer device driver use the old key/cipher to encrypt
the M4, then AP received/decrypt M4 correctly, after M4 send out, lower
layer device driver install the new key/cipher to hardware and return
success.

If lower layer device driver use new key/cipher to send the M4, then AP
will/should drop the M4, then it is same result with this issue, AP will/
should kick out station as well as this issue.

issue log:
kworker/u16:4-5238  [000]  6456.108926: stop_queue:           phy1 queue:0, reason:0
wpa_supplicant-961  [003]  6456.119737: rdev_tx_control_port: wiphy_name=phy1 name=wlan0 ifindex=6 dest=ARRAY[9e, 05, 31, 20, 9b, d0] proto=36488 unencrypted=0
wpa_supplicant-961  [003]  6456.119839: rdev_return_int_cookie: phy1, returned 0, cookie: 504
wpa_supplicant-961  [003]  6456.120287: rdev_add_key:         phy1, netdev:wlan0(6), key_index: 0, mode: 0, pairwise: true, mac addr: 9e:05:31:20:9b:d0
wpa_supplicant-961  [003]  6456.120453: drv_set_key:          phy1 vif:wlan0(2) sta:9e:05:31:20:9b:d0 cipher:0xfac04, flags=0x9, keyidx=0, hw_key_idx=0
kworker/u16:9-3829  [001]  6456.168240: wake_queue:           phy1 queue:0, reason:0
kworker/u16:9-3829  [001]  6456.168255: drv_wake_tx_queue:    phy1 vif:wlan0(2) sta:9e:05:31:20:9b:d0 ac:0 tid:7
kworker/u16:9-3829  [001]  6456.168305: cfg80211_control_port_tx_status: wdev(1), cookie: 504, ack: false
wpa_supplicant-961  [003]  6459.167982: drv_return_int:       phy1 - -110

issue call stack:
nl80211_frame_tx_status+0x230/0x340 [cfg80211]
cfg80211_control_port_tx_status+0x1c/0x28 [cfg80211]
ieee80211_report_used_skb+0x374/0x3e8 [mac80211]
ieee80211_free_txskb+0x24/0x40 [mac80211]
ieee80211_tx_dequeue+0x644/0x954 [mac80211]
ath10k_mac_tx_push_txq+0xac/0x238 [ath10k_core]
ath10k_mac_op_wake_tx_queue+0xac/0xe0 [ath10k_core]
drv_wake_tx_queue+0x80/0x168 [mac80211]
__ieee80211_wake_txqs+0xe8/0x1c8 [mac80211]
_ieee80211_wake_txqs+0xb4/0x120 [mac80211]
ieee80211_wake_txqs+0x48/0x80 [mac80211]
tasklet_action_common+0xa8/0x254
tasklet_action+0x2c/0x38
__do_softirq+0xdc/0x384

Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Link: https://lore.kernel.org/r/20230801064751.25803-1-quic_wgong@quicinc.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 8f8dc2625d535..d5c89c6758f2c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -644,7 +644,8 @@ ieee80211_tx_h_select_key(struct ieee80211_tx_data *tx)
 		}
 
 		if (unlikely(tx->key && tx->key->flags & KEY_FLAG_TAINTED &&
-			     !ieee80211_is_deauth(hdr->frame_control)))
+			     !ieee80211_is_deauth(hdr->frame_control)) &&
+			     tx->skb->protocol != tx->sdata->control_port_protocol)
 			return TX_DROP;
 
 		if (!skip_hw && tx->key &&
-- 
2.40.1



