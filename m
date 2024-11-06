Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A211DED58;
	Wed,  6 Nov 2024 12:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896074; cv=none; b=IApdzOs5wzI+T6WHXanaOXSS2xduJuuB1qxywApjVojL7leYTbNk6f409rJ6Q0Mqp3FzfbofE6nzdyZveZonTzhePqjzs9RhO2b1sv1Zskh1l/YMTAx/TXzyjo8w2C1OTof5Wae1Y03QE9Z454dRG513cubenMolsNdK4EwBE1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896074; c=relaxed/simple;
	bh=ZpWzVzom94SMIvaRIfCrZ23pBi5ZkjKsuU93HdzkYM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUaj6WJvPnGO53UoeePZ61cChMmg+W5ZujopH9kzdY0vJX8UVDr26IHzQgkNWjojidKYFkMqTf56+2KSjQeRFXh/zzZ6tdY3a+8pAudmBnJ7RPG54ONWzWhArPP8d/fGvepWY7YkhYHZqA3/sLofr24soA6sIc3MDDBsIocJfHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8PjuiCf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8PjuiCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28A3C4CECD;
	Wed,  6 Nov 2024 12:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896074;
	bh=ZpWzVzom94SMIvaRIfCrZ23pBi5ZkjKsuU93HdzkYM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8PjuiCfQuc8Y6at1VLpx/7VWFZm3dUUBAEfmmg0nDiiymjloQOpI9mhERLXu6NyH
	 5ijiZT8Y8m8mxp5sxL5D+f4gLUAwpI1kcPs5iDT2iyMIYvoXhwDpROU+1cqJ3UspUL
	 70kMIGcj9cobQlFSw3ocD2c9ocLzyn60rn2BbR9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungwoo Kim <iam@sung-woo.kim>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 045/245] Bluetooth: hci: fix null-ptr-deref in hci_read_supported_codecs
Date: Wed,  6 Nov 2024 13:01:38 +0100
Message-ID: <20241106120320.336495111@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sungwoo Kim <iam@sung-woo.kim>

[ Upstream commit 1e67d8641813f1876a42eeb4f532487b8a7fb0a8 ]

Fix __hci_cmd_sync_sk() to return not NULL for unknown opcodes.

__hci_cmd_sync_sk() returns NULL if a command returns a status event.
However, it also returns NULL where an opcode doesn't exist in the
hci_cc table because hci_cmd_complete_evt() assumes status = skb->data[0]
for unknown opcodes.
This leads to null-ptr-deref in cmd_sync for HCI_OP_READ_LOCAL_CODECS as
there is no hci_cc for HCI_OP_READ_LOCAL_CODECS, which always assumes
status = skb->data[0].

KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 1 PID: 2000 Comm: kworker/u9:5 Not tainted 6.9.0-ga6bcb805883c-dirty #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue: hci7 hci_power_on
RIP: 0010:hci_read_supported_codecs+0xb9/0x870 net/bluetooth/hci_codec.c:138
Code: 08 48 89 ef e8 b8 c1 8f fd 48 8b 75 00 e9 96 00 00 00 49 89 c6 48 ba 00 00 00 00 00 fc ff df 4c 8d 60 70 4c 89 e3 48 c1 eb 03 <0f> b6 04 13 84 c0 0f 85 82 06 00 00 41 83 3c 24 02 77 0a e8 bf 78
RSP: 0018:ffff888120bafac8 EFLAGS: 00010212
RAX: 0000000000000000 RBX: 000000000000000e RCX: ffff8881173f0040
RDX: dffffc0000000000 RSI: ffffffffa58496c0 RDI: ffff88810b9ad1e4
RBP: ffff88810b9ac000 R08: ffffffffa77882a7 R09: 1ffffffff4ef1054
R10: dffffc0000000000 R11: fffffbfff4ef1055 R12: 0000000000000070
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88810b9ac000
FS:  0000000000000000(0000) GS:ffff8881f6c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6ddaa3439e CR3: 0000000139764003 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <TASK>
 hci_read_local_codecs_sync net/bluetooth/hci_sync.c:4546 [inline]
 hci_init_stage_sync net/bluetooth/hci_sync.c:3441 [inline]
 hci_init4_sync net/bluetooth/hci_sync.c:4706 [inline]
 hci_init_sync net/bluetooth/hci_sync.c:4742 [inline]
 hci_dev_init_sync net/bluetooth/hci_sync.c:4912 [inline]
 hci_dev_open_sync+0x19a9/0x2d30 net/bluetooth/hci_sync.c:4994
 hci_dev_do_open net/bluetooth/hci_core.c:483 [inline]
 hci_power_on+0x11e/0x560 net/bluetooth/hci_core.c:1015
 process_one_work kernel/workqueue.c:3267 [inline]
 process_scheduled_works+0x8ef/0x14f0 kernel/workqueue.c:3348
 worker_thread+0x91f/0xe50 kernel/workqueue.c:3429
 kthread+0x2cb/0x360 kernel/kthread.c:388
 ret_from_fork+0x4d/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244

Fixes: abfeea476c68 ("Bluetooth: hci_sync: Convert MGMT_OP_START_DISCOVERY")

Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index ae7a5817883aa..c0203a2b51075 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -206,6 +206,12 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 		return ERR_PTR(err);
 	}
 
+	/* If command return a status event skb will be set to NULL as there are
+	 * no parameters.
+	 */
+	if (!skb)
+		return ERR_PTR(-ENODATA);
+
 	return skb;
 }
 EXPORT_SYMBOL(__hci_cmd_sync_sk);
@@ -255,6 +261,11 @@ int __hci_cmd_sync_status_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 	u8 status;
 
 	skb = __hci_cmd_sync_sk(hdev, opcode, plen, param, event, timeout, sk);
+
+	/* If command return a status event, skb will be set to -ENODATA */
+	if (skb == ERR_PTR(-ENODATA))
+		return 0;
+
 	if (IS_ERR(skb)) {
 		if (!event)
 			bt_dev_err(hdev, "Opcode 0x%4.4x failed: %ld", opcode,
@@ -262,13 +273,6 @@ int __hci_cmd_sync_status_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 		return PTR_ERR(skb);
 	}
 
-	/* If command return a status event skb will be set to NULL as there are
-	 * no parameters, in case of failure IS_ERR(skb) would have be set to
-	 * the actual error would be found with PTR_ERR(skb).
-	 */
-	if (!skb)
-		return 0;
-
 	status = skb->data[0];
 
 	kfree_skb(skb);
-- 
2.43.0



