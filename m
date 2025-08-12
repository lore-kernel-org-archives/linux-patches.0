Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95BC2FE571;
	Tue, 12 Aug 2025 18:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024043; cv=none; b=m7q3Yk3L6yI9pSJfaRiuTa7lTTPJZgeJdzd0U0yizVVbizMqggOjtS4BCWNO8GDBkCtRVjTAdV7Jy94AKElrgUkyLQCzIRUophwWx72gZqjNdn52RWmClRqwK2pM0NB9q030DR3fYjamtV2ajWC8nDQVrHMUIcks5lqwjlaCor4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024043; c=relaxed/simple;
	bh=0EUm9J9D94tPi1uwVTKXTwzg6Y42cYUoOAxm59aRdsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NznYmUpZkDas17Nj1Cerg45iLqxsUvlpCFC0wjzGpNkD1Cd0+mugb9yKtenR+Pz9OFd5fO/s/CdL8dtgo9DkisF6JxuNGETUaj2l5fUcMLDzVZepNTzHOvfuynpWHed7lfQi8Y9KunKmy8tPrXf1NkUaUi4YnZY1qOmWERyUxm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZEigW3t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZEigW3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17690C4CEF0;
	Tue, 12 Aug 2025 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024043;
	bh=0EUm9J9D94tPi1uwVTKXTwzg6Y42cYUoOAxm59aRdsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZEigW3t6ts5/E42QQw4UUDvpjuk1JZAYrWqokxpHB1MwDoNoGfYLF2UrOMTbyj1s
	 j/0eIJ5+Im/YW5haYsUOM1EklmrpUqsY1xaxNRq2EHfu85vhiCgAdZmnk5Fjlsxsqh
	 Ih2kzyUPPP+J/62zickuFt771Uulwd9eRG2Q/2Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ac3c79181f6aecc5120c@syzkaller.appspotmail.com,
	Ivan Pravdin <ipravdin.official@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 257/627] Bluetooth: hci_devcd_dump: fix out-of-bounds via dev_coredumpv
Date: Tue, 12 Aug 2025 19:29:12 +0200
Message-ID: <20250812173429.094146491@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Pravdin <ipravdin.official@gmail.com>

[ Upstream commit 7af4d7b53502286c6cf946d397ab183e76d14820 ]

Currently both dev_coredumpv and skb_put_data in hci_devcd_dump use
hdev->dump.head. However, dev_coredumpv can free the buffer. From
dev_coredumpm_timeout documentation, which is used by dev_coredumpv:

    > Creates a new device coredump for the given device. If a previous one hasn't
    > been read yet, the new coredump is discarded. The data lifetime is determined
    > by the device coredump framework and when it is no longer needed the @free
    > function will be called to free the data.

If the data has not been read by the userspace yet, dev_coredumpv will
discard new buffer, freeing hdev->dump.head. This leads to
vmalloc-out-of-bounds error when skb_put_data tries to access
hdev->dump.head.

A crash report from syzbot illustrates this:

    ==================================================================
    BUG: KASAN: vmalloc-out-of-bounds in skb_put_data
    include/linux/skbuff.h:2752 [inline]
    BUG: KASAN: vmalloc-out-of-bounds in hci_devcd_dump+0x142/0x240
    net/bluetooth/coredump.c:258
    Read of size 140 at addr ffffc90004ed5000 by task kworker/u9:2/5844

    CPU: 1 UID: 0 PID: 5844 Comm: kworker/u9:2 Not tainted
    6.14.0-syzkaller-10892-g4e82c87058f4 #0 PREEMPT(full)
    Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
    Google 02/12/2025
    Workqueue: hci0 hci_devcd_timeout
    Call Trace:
     <TASK>
     __dump_stack lib/dump_stack.c:94 [inline]
     dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
     print_address_description mm/kasan/report.c:408 [inline]
     print_report+0xc3/0x670 mm/kasan/report.c:521
     kasan_report+0xe0/0x110 mm/kasan/report.c:634
     check_region_inline mm/kasan/generic.c:183 [inline]
     kasan_check_range+0xef/0x1a0 mm/kasan/generic.c:189
     __asan_memcpy+0x23/0x60 mm/kasan/shadow.c:105
     skb_put_data include/linux/skbuff.h:2752 [inline]
     hci_devcd_dump+0x142/0x240 net/bluetooth/coredump.c:258
     hci_devcd_timeout+0xb5/0x2e0 net/bluetooth/coredump.c:413
     process_one_work+0x9cc/0x1b70 kernel/workqueue.c:3238
     process_scheduled_works kernel/workqueue.c:3319 [inline]
     worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
     kthread+0x3c2/0x780 kernel/kthread.c:464
     ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:153
     ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
     </TASK>

    The buggy address ffffc90004ed5000 belongs to a vmalloc virtual mapping
    Memory state around the buggy address:
     ffffc90004ed4f00: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
     ffffc90004ed4f80: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
    >ffffc90004ed5000: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
                       ^
     ffffc90004ed5080: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
     ffffc90004ed5100: f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8 f8
    ==================================================================

To avoid this issue, reorder dev_coredumpv to be called after
skb_put_data that does not free the data.

Reported-by: syzbot+ac3c79181f6aecc5120c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ac3c79181f6aecc5120c
Fixes: b257e02ecc46 ("HCI: coredump: Log devcd dumps into the monitor")
Tested-by: syzbot+ac3c79181f6aecc5120c@syzkaller.appspotmail.com
Signed-off-by: Ivan Pravdin <ipravdin.official@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/coredump.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/coredump.c b/net/bluetooth/coredump.c
index 819eacb38762..720cb79adf96 100644
--- a/net/bluetooth/coredump.c
+++ b/net/bluetooth/coredump.c
@@ -249,15 +249,15 @@ static void hci_devcd_dump(struct hci_dev *hdev)
 
 	size = hdev->dump.tail - hdev->dump.head;
 
-	/* Emit a devcoredump with the available data */
-	dev_coredumpv(&hdev->dev, hdev->dump.head, size, GFP_KERNEL);
-
 	/* Send a copy to monitor as a diagnostic packet */
 	skb = bt_skb_alloc(size, GFP_ATOMIC);
 	if (skb) {
 		skb_put_data(skb, hdev->dump.head, size);
 		hci_recv_diag(hdev, skb);
 	}
+
+	/* Emit a devcoredump with the available data */
+	dev_coredumpv(&hdev->dev, hdev->dump.head, size, GFP_KERNEL);
 }
 
 static void hci_devcd_handle_pkt_complete(struct hci_dev *hdev,
-- 
2.39.5



