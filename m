Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FF61D146;
	Mon, 18 Dec 2023 14:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nvgDr0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1BEC433C8;
	Mon, 18 Dec 2023 14:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908100;
	bh=U8KDiLAT5uFsUc0g6dzcVjNTWqrCDBV4Djw14CvHNq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nvgDr0BpriS4/fpTtIsR80/Xe4sX94/f0xsKVouiAI8tOO11NtmFq978An12Z5Wb
	 zqgC5L8551Vvwed0leM8l+pNvpEQtQPAJh9QQH/YD5r7oBRlB5NyAinuAD9UnI8i77
	 BgcTqW8+RVlVy6GXiKBvNANFktDQU24R3UgfYrzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/166] bnxt_en: Fix skb recycling logic in bnxt_deliver_skb()
Date: Mon, 18 Dec 2023 14:49:51 +0100
Message-ID: <20231218135106.059204843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit aded5d1feb08e48d544845d3594d70c4d5fe6e54 ]

Receive SKBs can go through the VF-rep path or the normal path.
skb_mark_for_recycle() is only called for the normal path.  Fix it
to do it for both paths to fix possible stalled page pool shutdown
errors.

Fixes: 86b05508f775 ("bnxt_en: Use the unified RX page pool buffers for XDP and non-XDP")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20231208001658.14230-3-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4d2296f201adb..9f52b943fedec 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1749,13 +1749,14 @@ static void bnxt_tpa_agg(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 static void bnxt_deliver_skb(struct bnxt *bp, struct bnxt_napi *bnapi,
 			     struct sk_buff *skb)
 {
+	skb_mark_for_recycle(skb);
+
 	if (skb->dev != bp->dev) {
 		/* this packet belongs to a vf-rep */
 		bnxt_vf_rep_rx(bp, skb);
 		return;
 	}
 	skb_record_rx_queue(skb, bnapi->index);
-	skb_mark_for_recycle(skb);
 	napi_gro_receive(&bnapi->napi, skb);
 }
 
-- 
2.43.0



