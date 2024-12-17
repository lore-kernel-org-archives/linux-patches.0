Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B811F8F16;
	Tue, 17 Dec 2024 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456744; cv=none; b=tkhw6bgeziIZSWCi85VUli5DppzhweJglQr0YNd5efpUH23ku+ax3Sc/6zmphZY/W6ZP5/r4AC2a5IELdL1jGySeTuIyNZII1CTqn9kc5U0nadiJEDWOe0lq/Cm3LBCsuhKDhiSnRbufddkyBK7AKP5XeCr3Pw1uPkgms+08C1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456744; c=relaxed/simple;
	bh=SdVr5qGS7U9aMGlEFEFsUBnTPPdbdD42o+zj8Wk7U1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1z8uXeZw+o2LlqPLWWlnF+ND4sQpm/Gwff2L3qgsfQBsjA0ISpPoyTCls6NU5D8o1L9y/I17vdwfI4EHbvjLwehYXgpDQFfZWSGlZH8ziciD96TnliNMwZ1EUKIf8xxx01MpAxLv/dimDMhCnrADalkwPhF9ojuKlyKjt3UAxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pUu945Gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pUu945Gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B3BC4CED3;
	Tue, 17 Dec 2024 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456744;
	bh=SdVr5qGS7U9aMGlEFEFsUBnTPPdbdD42o+zj8Wk7U1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUu945GsKiHXqyqbYKQuDSRJkfYOUCd4i3u3FUYk2/6K0CQSPi7IB+e2NDk1NiJWQ
	 fVpSi1Z4C+5UwM6hPN+Dv7jtobQ64wZ7N3ll4THdHxdIQb87JdYT4spYSnz4fgEugI
	 mPOWuf1jKXWvMI1mljWQLLuNynot4T9mjiF3movE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 153/172] Bluetooth: btmtk: avoid UAF in btmtk_process_coredump
Date: Tue, 17 Dec 2024 18:08:29 +0100
Message-ID: <20241217170552.672472742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit b548f5e9456c568155499d9ebac675c0d7a296e8 ]

hci_devcd_append may lead to the release of the skb, so it cannot be
accessed once it is called.

==================================================================
BUG: KASAN: slab-use-after-free in btmtk_process_coredump+0x2a7/0x2d0 [btmtk]
Read of size 4 at addr ffff888033cfabb0 by task kworker/0:3/82

CPU: 0 PID: 82 Comm: kworker/0:3 Tainted: G     U             6.6.40-lockdep-03464-g1d8b4eb3060e #1 b0b3c1cc0c842735643fb411799d97921d1f688c
Hardware name: Google Yaviks_Ufs/Yaviks_Ufs, BIOS Google_Yaviks_Ufs.15217.552.0 05/07/2024
Workqueue: events btusb_rx_work [btusb]
Call Trace:
 <TASK>
 dump_stack_lvl+0xfd/0x150
 print_report+0x131/0x780
 kasan_report+0x177/0x1c0
 btmtk_process_coredump+0x2a7/0x2d0 [btmtk 03edd567dd71a65958807c95a65db31d433e1d01]
 btusb_recv_acl_mtk+0x11c/0x1a0 [btusb 675430d1e87c4f24d0c1f80efe600757a0f32bec]
 btusb_rx_work+0x9e/0xe0 [btusb 675430d1e87c4f24d0c1f80efe600757a0f32bec]
 worker_thread+0xe44/0x2cc0
 kthread+0x2ff/0x3a0
 ret_from_fork+0x51/0x80
 ret_from_fork_asm+0x1b/0x30
 </TASK>

Allocated by task 82:
 stack_trace_save+0xdc/0x190
 kasan_set_track+0x4e/0x80
 __kasan_slab_alloc+0x4e/0x60
 kmem_cache_alloc+0x19f/0x360
 skb_clone+0x132/0xf70
 btusb_recv_acl_mtk+0x104/0x1a0 [btusb]
 btusb_rx_work+0x9e/0xe0 [btusb]
 worker_thread+0xe44/0x2cc0
 kthread+0x2ff/0x3a0
 ret_from_fork+0x51/0x80
 ret_from_fork_asm+0x1b/0x30

Freed by task 1733:
 stack_trace_save+0xdc/0x190
 kasan_set_track+0x4e/0x80
 kasan_save_free_info+0x28/0xb0
 ____kasan_slab_free+0xfd/0x170
 kmem_cache_free+0x183/0x3f0
 hci_devcd_rx+0x91a/0x2060 [bluetooth]
 worker_thread+0xe44/0x2cc0
 kthread+0x2ff/0x3a0
 ret_from_fork+0x51/0x80
 ret_from_fork_asm+0x1b/0x30

The buggy address belongs to the object at ffff888033cfab40
 which belongs to the cache skbuff_head_cache of size 232
The buggy address is located 112 bytes inside of
 freed 232-byte region [ffff888033cfab40, ffff888033cfac28)

The buggy address belongs to the physical page:
page:00000000a174ba93 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x33cfa
head:00000000a174ba93 order:1 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0x4000000000000840(slab|head|zone=1)
page_type: 0xffffffff()
raw: 4000000000000840 ffff888100848a00 0000000000000000 0000000000000001
raw: 0000000000000000 0000000080190019 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff888033cfaa80: fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc
 ffff888033cfab00: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
>ffff888033cfab80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                     ^
 ffff888033cfac00: fb fb fb fb fb fc fc fc fc fc fc fc fc fc fc fc
 ffff888033cfac80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

Check if we need to call hci_devcd_complete before calling
hci_devcd_append. That requires that we check data->cd_info.cnt >=
MTK_COREDUMP_NUM instead of data->cd_info.cnt > MTK_COREDUMP_NUM, as we
increment data->cd_info.cnt only once the call to hci_devcd_append
succeeds.

Fixes: 0b7015132878 ("Bluetooth: btusb: mediatek: add MediaTek devcoredump support")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 480e4adba9fa..85e99641eaae 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -395,6 +395,7 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btmtk_data *data = hci_get_priv(hdev);
 	int err;
+	bool complete = false;
 
 	if (!IS_ENABLED(CONFIG_DEV_COREDUMP)) {
 		kfree_skb(skb);
@@ -416,19 +417,22 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 		fallthrough;
 	case HCI_DEVCOREDUMP_ACTIVE:
 	default:
+		/* Mediatek coredump data would be more than MTK_COREDUMP_NUM */
+		if (data->cd_info.cnt >= MTK_COREDUMP_NUM &&
+		    skb->len > MTK_COREDUMP_END_LEN)
+			if (!memcmp((char *)&skb->data[skb->len - MTK_COREDUMP_END_LEN],
+				    MTK_COREDUMP_END, MTK_COREDUMP_END_LEN - 1))
+				complete = true;
+
 		err = hci_devcd_append(hdev, skb);
 		if (err < 0)
 			break;
 		data->cd_info.cnt++;
 
-		/* Mediatek coredump data would be more than MTK_COREDUMP_NUM */
-		if (data->cd_info.cnt > MTK_COREDUMP_NUM &&
-		    skb->len > MTK_COREDUMP_END_LEN)
-			if (!memcmp((char *)&skb->data[skb->len - MTK_COREDUMP_END_LEN],
-				    MTK_COREDUMP_END, MTK_COREDUMP_END_LEN - 1)) {
-				bt_dev_info(hdev, "Mediatek coredump end");
-				hci_devcd_complete(hdev);
-			}
+		if (complete) {
+			bt_dev_info(hdev, "Mediatek coredump end");
+			hci_devcd_complete(hdev);
+		}
 
 		break;
 	}
-- 
2.39.5



