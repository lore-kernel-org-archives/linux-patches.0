Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088D11C288;
	Wed,  3 Jan 2024 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeX83d8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6316BC433C8;
	Wed,  3 Jan 2024 17:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301460;
	bh=cGihLv3mHP3oHGC4/Gcab/J+g8+j0LVbz3DbfFO/ak8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeX83d8iswG28efflXxl9PkdGotPOD3xFUr4fRh575Dtg+/PpsA1oW8GObUWn9+8N
	 WxDqWZ3cWXJIPxcg91jwASfqteBOeVNXvOX8XuddDtckxy/Kh+t1AwuiwcX62EM/i9
	 FJIlYfemqOW6Z3QCABh/u4jU2eIzbrk6lVkB5vhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Yongjun <weiyongjun1@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/95] scsi: bnx2fc: Fix skb double free in bnx2fc_rcv()
Date: Wed,  3 Jan 2024 17:54:47 +0100
Message-ID: <20240103164859.983316386@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 08c94d80b2da481652fb633e79cbc41e9e326a91 ]

skb_share_check() already drops the reference to the skb when returning
NULL. Using kfree_skb() in the error handling path leads to an skb double
free.

Fix this by removing the variable tmp_skb, and return directly when
skb_share_check() returns NULL.

Fixes: 01a4cc4d0cd6 ("bnx2fc: do not add shared skbs to the fcoe_rx_list")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Link: https://lore.kernel.org/r/20221114110626.526643-1-weiyongjun@huaweicloud.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e2586472ecad4..6090434ad6f36 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -432,7 +432,6 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 	struct fcoe_ctlr *ctlr;
 	struct fcoe_rcv_info *fr;
 	struct fcoe_percpu_s *bg;
-	struct sk_buff *tmp_skb;
 
 	interface = container_of(ptype, struct bnx2fc_interface,
 				 fcoe_packet_type);
@@ -444,11 +443,9 @@ static int bnx2fc_rcv(struct sk_buff *skb, struct net_device *dev,
 		goto err;
 	}
 
-	tmp_skb = skb_share_check(skb, GFP_ATOMIC);
-	if (!tmp_skb)
-		goto err;
-
-	skb = tmp_skb;
+	skb = skb_share_check(skb, GFP_ATOMIC);
+	if (!skb)
+		return -1;
 
 	if (unlikely(eth_hdr(skb)->h_proto != htons(ETH_P_FCOE))) {
 		printk(KERN_ERR PFX "bnx2fc_rcv: Wrong FC type frame\n");
-- 
2.43.0



