Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214088;
	b=Z38022iRdJWP5DZ3sNn9fhSYoGpbL9/u5ndVzcUixaeOMLuW5531vCKBvsTRsys0pDbF
	 eXsbCdTZ7Y0r+Ftxf+xy5PzPXBZdBvx2fwCt83PzcnjhjlFaY+MLlGNPwWkvyMR0AbcJK
	 /TnkT4G2mh4D0wNHuhzYEasWT6FtMSPcn5Q6n1pe5rA2mrN52M7rl7/sZcYq6NTrn4A1n
	 /c1odBY2EZGcCr6bN+1SLADLJ2GavSLM4NkOyA3mAm+4lcfQ+jBQcQhCfIARFbdiYMQsJ
	 yjYByzYhelWy/ahmyN0YBF4kglNw1WYfyDlfiYoJfh7uMqEzIAPQMtbQ4BmBC3gwd+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Whs+Ef51SuVJzoJtowjipTv74h6wEsVMsTR5Dr1Oq4w=;
	b=0/1K4NspfbLx26CBgDnNEkmYBVSnEleHTxmJYdESN/kjPAPZQip6S+cAXj44ZTpZGB2f
	 ub/vsf4eh2d0g+Mek6VM7cCTU1Ym4qWhmsk0W5d1BZhwBlvEIHu4/sHTLk/z9vRe0Bx1e
	 LHf4Or1i/Q/72EWOhN2z5Ajgz2RIFH6wY7OEFLzLAlE/OhfWrVWORQT6WxL0REKMnUGrg
	 uNRZ+ePydeQ980TBh+OLcKQ7EgEJhFslkl1DGLexcXfBvdIGffYbWLH26uv7Ecej6EkWO
	 OXoCyI0oY3jCXcB60ZmX0yBbr2zdTRBQt41f+txe7eaI+kAzeQ7GFIuxRCUo5KdVLfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x5e1/V0m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A966606A31C;
	Wed, 28 Oct 2026 19:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x5e1/V0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599DC1F01825;
	Wed, 28 Oct 2026 19:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214087;
	bh=Whs+Ef51SuVJzoJtowjipTv74h6wEsVMsTR5Dr1Oq4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5e1/V0m6a/1KiRpOVHZuNP8CXw8dJS7EM7VeOcNa+XHF4XPquRYgVne3HLzjWs8r
	 eGXDH37pTPO93FfWvaVXCgVR9Pdv8BcepMZFMONeb9kHXJ6OwyMSkDqMYLSIsIyqBd
	 BWblBOMhkYwvSR6JWbg+riYZH3/rrKEjCZOXFxbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0735/1887] wifi: rtw89: fix race between cancel_hw_scan and hw_scan completion
Date: Wed, 28 Oct 2026 17:47:11 +0100
Message-ID: <20261028170516.174127450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit ba4bb0402c60e945c4c396c51f0acac3c3e3ea5c ]

The rtwdev->scanning flag isn't protected by mutex originally, so
cancel_hw_scan can pass the condition, but suddenly hw_scan completion
unset the flag and calls ieee80211_scan_completed() that will free
local->hw_scan_req. Then, cancel_hw_scan raises null-ptr-deref and
use-after-free. Fix it by moving the check condition to where
protected by mutex.

 KASAN: null-ptr-deref in range [0x0000000000000088-0x000000000000008f]
 CPU: 2 PID: 6922 Comm: kworker/2:2 Tainted: G           OE
 Hardware name: LENOVO 2356AD1/2356AD1, BIOS G7ETB6WW (2.76 ) 09/10/2019
 Workqueue: events cfg80211_conn_work [cfg80211]
 RIP: 0010:rtw89_fw_h2c_scan_offload_be+0xc33/0x13c3 [rtw89_core]
 Code: 00 45 89 6c 24 1c 0f 85 23 01 00 00 48 8b 85 20 ff ff ff 48 8d
 RSP: 0018:ffff88811fd9f068 EFLAGS: 00010206
 RAX: dffffc0000000000 RBX: ffff88811fd9f258 RCX: 0000000000000001
 RDX: 0000000000000011 RSI: 0000000000000001 RDI: 0000000000000089
 RBP: ffff88811fd9f170 R08: 0000000000000000 R09: 0000000000000000
 R10: ffff88811fd9f108 R11: 0000000000000000 R12: ffff88810e47f960
 R13: 0000000000000000 R14: 000000000000ffff R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff8881d6f00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007531dfca55b0 CR3: 00000001be296004 CR4: 00000000001706e0
 Call Trace:
  <TASK>
  ? show_regs+0x61/0x73
  ? __die_body+0x20/0x73
  ? die_addr+0x4f/0x7b
  ? exc_general_protection+0x191/0x1db
  ? asm_exc_general_protection+0x27/0x30
  ? rtw89_fw_h2c_scan_offload_be+0xc33/0x13c3 [rtw89_core]
  ? rtw89_fw_h2c_scan_offload_be+0x458/0x13c3 [rtw89_core]
  ? __pfx_rtw89_fw_h2c_scan_offload_be+0x10/0x10 [rtw89_core]
  ? do_raw_spin_lock+0x75/0xdb
  ? __pfx_do_raw_spin_lock+0x10/0x10
  rtw89_hw_scan_offload+0xb5e/0xbf7 [rtw89_core]
  ? _raw_spin_unlock+0xe/0x24
  ? __mutex_lock.constprop.0+0x40c/0x471
  ? __pfx_rtw89_hw_scan_offload+0x10/0x10 [rtw89_core]
  ? __mutex_lock_slowpath+0x13/0x1f
  ? mutex_lock+0xa2/0xdc
  ? __pfx_mutex_lock+0x10/0x10
  rtw89_hw_scan_abort+0x58/0xb7 [rtw89_core]
  rtw89_ops_cancel_hw_scan+0x120/0x13b [rtw89_core]
  ieee80211_scan_cancel+0x468/0x4d0 [mac80211]
  ieee80211_prep_connection+0x858/0x899 [mac80211]
  ieee80211_mgd_auth+0xbea/0xdde [mac80211]
  ? __pfx_ieee80211_mgd_auth+0x10/0x10 [mac80211]
  ? cfg80211_find_elem+0x15/0x29 [cfg80211]
  ? is_bss+0x1b7/0x1d7 [cfg80211]
  ieee80211_auth+0x18/0x27 [mac80211]
  cfg80211_mlme_auth+0x3bb/0x3e7 [cfg80211]
  cfg80211_conn_do_work+0x410/0xb81 [cfg80211]
  ? __pfx_cfg80211_conn_do_work+0x10/0x10 [cfg80211]
  ? __kasan_check_read+0x11/0x1f
  ? psi_group_change+0x8bc/0x944
  ? __kasan_check_write+0x14/0x22
  ? mutex_lock+0x8e/0xdc
  ? __pfx_mutex_lock+0x10/0x10
  ? __pfx___radix_tree_lookup+0x10/0x10
  cfg80211_conn_work+0x245/0x34d [cfg80211]
  ? __pfx_cfg80211_conn_work+0x10/0x10 [cfg80211]
  ? update_cfs_rq_load_avg+0x3bc/0x3d7
  ? sched_clock_noinstr+0x9/0x1a
  ? sched_clock+0x10/0x24
  ? sched_clock_cpu+0x7e/0x42e
  ? newidle_balance+0x796/0x937
  ? __pfx_sched_clock_cpu+0x10/0x10
  ? __pfx_newidle_balance+0x10/0x10
  ? __kasan_check_read+0x11/0x1f
  ? psi_group_change+0x8bc/0x944
  ? _raw_spin_unlock+0xe/0x24
  ? raw_spin_rq_unlock+0x47/0x54
  ? raw_spin_rq_unlock_irq+0x9/0x1f
  ? finish_task_switch.isra.0+0x347/0x586
  ? __schedule+0x27bf/0x2892
  ? mutex_unlock+0x80/0xd0
  ? do_raw_spin_lock+0x75/0xdb
  ? __pfx___schedule+0x10/0x10
  process_scheduled_works+0x58c/0x821
  worker_thread+0x4c7/0x586
  ? __kasan_check_read+0x11/0x1f
  kthread+0x285/0x294
  ? __pfx_worker_thread+0x10/0x10
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x29/0x6f
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1b/0x30
  </TASK>

Fixes: 895907779752 ("rtw89: 8852a: add ieee80211_ops::hw_scan")
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20250107114254.6769-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index 2c3a72900b9fb..7827f90d5bdcf 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -808,11 +808,14 @@ static void rtw89_ops_cancel_hw_scan(struct ieee80211_hw *hw,
 	if (!RTW89_CHK_FW_FEATURE(SCAN_OFFLOAD, &rtwdev->fw))
 		return;
 
+	mutex_lock(&rtwdev->mutex);
+
 	if (!rtwdev->scanning)
-		return;
+		goto out;
 
-	mutex_lock(&rtwdev->mutex);
 	rtw89_hw_scan_abort(rtwdev, vif);
+
+out:
 	mutex_unlock(&rtwdev->mutex);
 }
 
-- 
2.53.0



