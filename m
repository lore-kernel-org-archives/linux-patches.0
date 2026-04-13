Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4878726CE32;
	Mon, 13 Apr 2026 16:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097301; cv=none; b=C41gdutAuN0/WVeKscDRD8Sx9ouUb+sqIlEXIuzCDpBYU/lGvrvAJb9lTt4Xdwlj9JI4oiE1jJ0GakQ/h4BKU/juGod3Lm0sZDHahn452BxhOzFP+FoMXe4SpvpMZdqW0IZCnVmZL5iSJt3SiOvlhBM8fy4OdS/mZN0yuhz6i7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097301; c=relaxed/simple;
	bh=pF9XQ6CBKkOrbqCp7fsSAM5YXn3KnRv7V2Z7zY9eOAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmfqgrzrPdD8dp2idkSIM+OcD7ujl/3Nv8/GYHhUVeeTGIj1JBqDjGaTUTek3FGAIHIYdLjf+WymgVFppVly3YTg18z1Spau+/EzG3mDINPWWo0+3Ph7SiXa/jyKvC1F8S6uodyL09ITf2PHSy5o4qPqEMsnr/BmA0XRBRVIL68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzCvWFWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzCvWFWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F17C2BCAF;
	Mon, 13 Apr 2026 16:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097301;
	bh=pF9XQ6CBKkOrbqCp7fsSAM5YXn3KnRv7V2Z7zY9eOAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzCvWFWV93E7GB+pwDe6cgqzioEJs6UdsMmpPiFqoZDwsAzlvX2ENEGg+iGVJo2ZC
	 GA7syhpOk2rP7MW+doO0cCnRrHZ37wbv7D9fL+SwGTCqLlS9BzpN7mILbx7usqteiC
	 Xp2X5Qjela4UKLsdL5DD1SHftWOMQWU0Elv22ivY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/570] nfc: nci: free skb on nci_transceive early error paths
Date: Mon, 13 Apr 2026 17:53:33 +0200
Message-ID: <20260413155833.514966385@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4f1f56e264730..ca9543be400c4 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1027,18 +1027,23 @@ static int nci_transceive(struct nfc_dev *nfc_dev, struct nfc_target *target,
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



