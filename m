Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5273AB277;
	Mon, 23 Mar 2026 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282376; cv=none; b=Q81FaYsdk9Ux4+FfRqupcOWxGNp8DGYq2OSYZdnO9P+YsSntlDLmOV22bR70fXvgBXwkcoDykXtDfrjV0SHb8b+TfdbwAjEUm+dMHpYpcz77nISINg+ka85lVqpAmmZL8Qr4vz3eGC0fleZem5YE+l5tBsC5AXyZvekpcl6X2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282376; c=relaxed/simple;
	bh=Kn/MHoicoQJwG+baPsywfXKsPfTm2VwUMlyBe1aChzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kinOg1AhoVOUDYKJomRuKvxm8I5wBRCBW0FuKwaR6ggZ9Fa3j8E8yxT+E2rTZZV57brk29Y9FDMQ8Db7vdwgg05AgxDo4ADEJf+U93UoIAvUBi0FnpDWZ7hwMBFRVCebpYoJI638tMYpaOtazhWNZDjWRGHI4jlvX0XeySQk6hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbxarVTd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbxarVTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 502EAC4CEF7;
	Mon, 23 Mar 2026 16:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282376;
	bh=Kn/MHoicoQJwG+baPsywfXKsPfTm2VwUMlyBe1aChzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbxarVTdEebc3N5ksnPP7/ihHfamZZQjt9bmLHkE6ciREXsJg/0+aVPJNMcThvlH9
	 oPakXJUt1tL74DCdh2iDV/DK+6e9kDJ1fw3/qcriTxUjVT5iKyoliCo+QyI86ACm/T
	 ruifqz88/h68f76tIuV7PqR6tj4HfbdW7IIGllSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/481] nfc: nci: free skb on nci_transceive early error paths
Date: Mon, 23 Mar 2026 14:41:54 +0100
Message-ID: <20260323134528.483809471@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7bd4b0c4779f978a6528c9b7937d2ca18e936e2c ]

nci_transceive() takes ownership of the skb passed by the caller,
but the -EPROTO, -EINVAL, and -EBUSY error paths return without
freeing it.

Due to issues clearing NCI_DATA_EXCHANGE fixed by subsequent changes
the nci/nci_dev selftest hits the error path occasionally in NIPA,
and kmemleak detects leaks:

unreferenced object 0xff11000015ce6a40 (size 640):
  comm "nci_dev", pid 3954, jiffies 4295441246
  hex dump (first 32 bytes):
    6b 6b 6b 6b 00 a4 00 0c 02 e1 03 6b 6b 6b 6b 6b  kkkk.......kkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace (crc 7c40cc2a):
    kmem_cache_alloc_node_noprof+0x492/0x630
    __alloc_skb+0x11e/0x5f0
    alloc_skb_with_frags+0xc6/0x8f0
    sock_alloc_send_pskb+0x326/0x3f0
    nfc_alloc_send_skb+0x94/0x1d0
    rawsock_sendmsg+0x162/0x4c0
    do_syscall_64+0x117/0xfc0

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 6b62218718a06..cdc1aa8662544 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1023,18 +1023,23 @@ static int nci_transceive(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	struct nci_conn_info *conn_info;
 
 	conn_info = ndev->rf_conn_info;
-	if (!conn_info)
+	if (!conn_info) {
+		kfree_skb(skb);
 		return -EPROTO;
+	}
 
 	pr_debug("target_idx %d, len %d\n", target->idx, skb->len);
 
 	if (!ndev->target_active_prot) {
 		pr_err("unable to exchange data, no active target\n");
+		kfree_skb(skb);
 		return -EINVAL;
 	}
 
-	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags)) {
+		kfree_skb(skb);
 		return -EBUSY;
+	}
 
 	/* store cb and context to be used on receiving data */
 	conn_info->data_exchange_cb = cb;
-- 
2.51.0



