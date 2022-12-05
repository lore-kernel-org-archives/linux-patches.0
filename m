Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A593215C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7FBC433D7;
	Mon,  5 Dec 2022 19:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267937;
	bh=+6AwVFpJ3IrcMwPMn8PQ1Uc+3EOdScRD7/5USYoD4C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+lC07V6iKk8HLSZmwyFGhFoCWv4rjSiRjht85DJyrEHjIPg9567vUHxaqLQjD/Xe
	 WrRMjZSK7d7+Y0oicnbDRrE2PEmgMP6qJhrzdSqZ2c0z1A5k5DAq5xIedfS6n2PIJC
	 B+R9PQxkZ+zy1RqiNMDfmgUFZcXJXRqL5dJZXAuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com,
	Liu Shixin <liushixin2@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 027/105] NFC: nci: fix memory leak in nci_rx_data_packet()
Date: Mon,  5 Dec 2022 20:08:59 +0100
Message-Id: <20221205190804.065749341@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Liu Shixin <liushixin2@huawei.com>

[ Upstream commit 53270fb0fd77fe786d8c07a0793981d797836b93 ]

Syzbot reported a memory leak about skb:

unreferenced object 0xffff88810e144e00 (size 240):
  comm "syz-executor284", pid 3701, jiffies 4294952403 (age 12.620s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff83ab79a9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:497
    [<ffffffff82a5cf64>] alloc_skb include/linux/skbuff.h:1267 [inline]
    [<ffffffff82a5cf64>] virtual_ncidev_write+0x24/0xe0 drivers/nfc/virtual_ncidev.c:116
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:759 [inline]
    [<ffffffff815f6503>] do_loop_readv_writev fs/read_write.c:743 [inline]
    [<ffffffff815f6503>] do_iter_write+0x253/0x300 fs/read_write.c:863
    [<ffffffff815f66ed>] vfs_writev+0xdd/0x240 fs/read_write.c:934
    [<ffffffff815f68f6>] do_writev+0xa6/0x1c0 fs/read_write.c:977
    [<ffffffff848802d5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff848802d5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84a00087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

In nci_rx_data_packet(), if we don't get a valid conn_info, we will return
directly but forget to release the skb.

Reported-by: syzbot+cdb9a427d1bc08815104@syzkaller.appspotmail.com
Fixes: 4aeee6871e8c ("NFC: nci: Add dynamic logical connections support")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Link: https://lore.kernel.org/r/20221118082419.239475-1-liushixin2@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/data.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 9e3f9460f14f..5d46d8dfad72 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -291,8 +291,10 @@ void nci_rx_data_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 nci_plen(skb->data));
 
 	conn_info = nci_get_conn_info_by_conn_id(ndev, nci_conn_id(skb->data));
-	if (!conn_info)
+	if (!conn_info) {
+		kfree_skb(skb);
 		return;
+	}
 
 	/* strip the nci data header */
 	skb_pull(skb, NCI_DATA_HDR_SIZE);
-- 
2.35.1



