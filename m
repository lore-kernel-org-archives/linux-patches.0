Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77B91F76A1;
	Tue, 17 Dec 2024 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456196; cv=none; b=ECJAOkD9HN2KN6hmBi9BTYBy3SV8F3f8WePqof1BgFczMjWNEiHxcAVJt9FS91+eoanVP/Z3klX0tieAiKuzivrQlcYpS/4/18sryAKZrp/i975jCI5+PFAYom6RvW9pXJQPxbyRXcweraR/9xlXoBir0775lwsCBYr7+V6eb8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456196; c=relaxed/simple;
	bh=ZgEizlhTjI3gsv0VeNEgeuneNTihN8Cw+PS5iacRX0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Di2pkR7oUAavrxi+tNOApBYSWaHTY1/zaSwpyyJpCV145aQWSIal6if4lJ7KaClTtLC5nt72tZqtO2lKjHqaQelXE+07x0b+lwHdInEn+6YWRRq0wu7A333EQ7SPAAB5eJI+7RfIZ8+1gdk/pYABnU/x+SO9ZvX1rnNOZZlKUOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JCSQFlYa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JCSQFlYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4EAC4CEDE;
	Tue, 17 Dec 2024 17:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456196;
	bh=ZgEizlhTjI3gsv0VeNEgeuneNTihN8Cw+PS5iacRX0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JCSQFlYapVo/Otm8NduIl8WPx4liOq6o2URo/i4SLkH+AqttUY6MZsFqysajixARZ
	 WYcRd5bJOj9IkRy+PZxMxNLMahVpBLAOGK62KJH7dd3grwGhUBfXOnotzZVGp7jeCs
	 4v+hlfvJuEKuH3AIwJ/3u/n8+yMSQZD2H4bDrQfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/109] Bluetooth: btmtk: avoid UAF in btmtk_process_coredump
Date: Tue, 17 Dec 2024 18:08:14 +0100
Message-ID: <20241217170537.142164356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 812fd2a8f853..4c53ab22d09b 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -371,6 +371,7 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 {
 	struct btmediatek_data *data = hci_get_priv(hdev);
 	int err;
+	bool complete = false;
 
 	if (!IS_ENABLED(CONFIG_DEV_COREDUMP)) {
 		kfree_skb(skb);
@@ -392,19 +393,22 @@ int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
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



