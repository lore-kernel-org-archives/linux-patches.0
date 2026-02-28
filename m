Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D032D3E9F86
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301070; cv=none; b=epm5IvbWfkc/LeLFk7NWsgiEtVZ0mwvJRa8TOCnTEyZ/0yCPGTuOntqnB5vYT42vcZy011MtuC9lhQfKd6Il3vW993ZTebaYB7+qIvcx1Deldpva1JlR/RnqYBaHs2NFTTJ0jYlRxyw8zqxz2iYqoye+vRrK198pWkGQCRm1TJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301070; c=relaxed/simple;
	bh=PRhyiLXJEkJyR4tDp6iDYpalkIQVH02kJMwoKwrf8Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2ty5+pP9j5fYWkcUUYl+yNFYNnwUJKNQRfh7as5+rVvWmI6XvPhF3itMMWxLg+kTjN0Ei/GWTQ88f6CWkcMLTbuM+rQGR2fmmi/x3TAvgUyqRa/lFYhD09zhTHktyjIsa4vnr1AshdeMbvuA2VEpjvqbz6F1r+t0IYvmEuYJJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVQDJhkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVQDJhkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4161EC19423;
	Sat, 28 Feb 2026 17:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301070;
	bh=PRhyiLXJEkJyR4tDp6iDYpalkIQVH02kJMwoKwrf8Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XVQDJhkV7MJrIBO+4/zMNjV17leDbSYycURQoRWJOpLeLM+y1jfPX8Y9CIec3DsZS
	 JHt50bkGDIM1MEvrZnkj16RoTzd0vxuZO2yHzpzH8DI399r5Q8W+TVD98cdeHtkgbk
	 evcqBeq53zL/xtlG5JGPqAmnxhl0eSVyAAkv6nfbQZ4amWQ7Az6I4ebzz8q5K35mkf
	 +xgHgffdgjklQ1RTO4Ge6vGRsbhTexAzMF9tSKKQSkcWwxkJpIRAv+psEEeEksa9O7
	 bd47NqK6R20z8Cz0gKi5JAZPmsWeCMWyWHlQBUJT5q6tMX7/KH1dsjYpMfHyKtlIFa
	 g5y1nDJ0ALxXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/752] wifi: rtw88: 8822b: Avoid WARNING in rtw8822b_config_trx_mode()
Date: Sat, 28 Feb 2026 12:38:46 -0500
Message-ID: <20260228174750.1542406-215-sashal@kernel.org>
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

From: Bitterblue Smith <rtl8821cerfe2@gmail.com>

[ Upstream commit 44d1f624bbdd2d60319374ba85f7195a28d00c90 ]

rtw8822b_set_antenna() can be called from userspace when the chip is
powered off. In that case a WARNING is triggered in
rtw8822b_config_trx_mode() because trying to read the RF registers
when the chip is powered off returns an unexpected value.

Call rtw8822b_config_trx_mode() in rtw8822b_set_antenna() only when
the chip is powered on.

------------[ cut here ]------------
write RF mode table fail
WARNING: CPU: 0 PID: 7183 at rtw8822b.c:824 rtw8822b_config_trx_mode.constprop.0+0x835/0x840 [rtw88_8822b]
CPU: 0 UID: 0 PID: 7183 Comm: iw Tainted: G        W  OE       6.17.5-arch1-1 #1 PREEMPT(full)  01c39fc421df2af799dd5e9180b572af860b40c1
Tainted: [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: LENOVO 82KR/LNVNB161216, BIOS HBCN18WW 08/27/2021
RIP: 0010:rtw8822b_config_trx_mode.constprop.0+0x835/0x840 [rtw88_8822b]
Call Trace:
 <TASK>
 rtw8822b_set_antenna+0x57/0x70 [rtw88_8822b 370206f42e5890d8d5f48eb358b759efa37c422b]
 rtw_ops_set_antenna+0x50/0x80 [rtw88_core 711c8fb4f686162be4625b1d0b8e8c6a5ac850fb]
 ieee80211_set_antenna+0x60/0x100 [mac80211 f1845d85d2ecacf3b71867635a050ece90486cf3]
 nl80211_set_wiphy+0x384/0xe00 [cfg80211 296485ee85696d2150309a6d21a7fbca83d3dbda]
 ? netdev_run_todo+0x63/0x550
 genl_family_rcv_msg_doit+0xfc/0x160
 genl_rcv_msg+0x1aa/0x2b0
 ? __pfx_nl80211_pre_doit+0x10/0x10 [cfg80211 296485ee85696d2150309a6d21a7fbca83d3dbda]
 ? __pfx_nl80211_set_wiphy+0x10/0x10 [cfg80211 296485ee85696d2150309a6d21a7fbca83d3dbda]
 ? __pfx_nl80211_post_doit+0x10/0x10 [cfg80211 296485ee85696d2150309a6d21a7fbca83d3dbda]
 ? __pfx_genl_rcv_msg+0x10/0x10
 netlink_rcv_skb+0x59/0x110
 genl_rcv+0x28/0x40
 netlink_unicast+0x285/0x3c0
 ? __alloc_skb+0xdb/0x1a0
 netlink_sendmsg+0x20d/0x430
 ____sys_sendmsg+0x39f/0x3d0
 ? import_iovec+0x2f/0x40
 ___sys_sendmsg+0x99/0xe0
 ? refill_obj_stock+0x12e/0x240
 __sys_sendmsg+0x8a/0xf0
 do_syscall_64+0x81/0x970
 ? do_syscall_64+0x81/0x970
 ? ksys_read+0x73/0xf0
 ? do_syscall_64+0x81/0x970
 ? count_memcg_events+0xc2/0x190
 ? handle_mm_fault+0x1d7/0x2d0
 ? do_user_addr_fault+0x21a/0x690
 ? exc_page_fault+0x7e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>
---[ end trace 0000000000000000 ]---

Link: https://github.com/lwfinger/rtw88/issues/366
Signed-off-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/fb9a3444-9319-4aa2-8719-35a6308bf568@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index 89b6485b229a8..4d88cc2f41485 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -1005,7 +1005,8 @@ static int rtw8822b_set_antenna(struct rtw_dev *rtwdev,
 	hal->antenna_tx = antenna_tx;
 	hal->antenna_rx = antenna_rx;
 
-	rtw8822b_config_trx_mode(rtwdev, antenna_tx, antenna_rx, false);
+	if (test_bit(RTW_FLAG_POWERON, rtwdev->flags))
+		rtw8822b_config_trx_mode(rtwdev, antenna_tx, antenna_rx, false);
 
 	return 0;
 }
-- 
2.51.0

