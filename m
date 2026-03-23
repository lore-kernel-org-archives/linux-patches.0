Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F3C2877DA;
	Mon, 23 Mar 2026 16:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282996; cv=none; b=JAn1emvj2TREXXdQEm+LYmi8e90LdNITvk5lziNm/6MizTW3NSsGeovNa5WKN0fQL9kyeLxgArNLBjpCr7RMHYpFUtlEaZIlGEsHgLNzUAMMr+TBs6VH994bWItWep3ErC4DrDBMFbmlYMcTxoE3Xn2a/FBi3NigoTd5PYeLu+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282996; c=relaxed/simple;
	bh=9ceHOTshM1TqlmMaUI6YMDc2dNOBEYKKIO0r+YCCk6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L37RO+62n79IE+MajcKv/AF+P9BotIAswplurZbm9f6xwiBVeIuG3GbQubmt7eUVhOCfxhH6VONNXRuVhMh85y1YiUxNgH+pgJ80NVasi0WSV5/+WEdZhscJN8P/TnTa7+r4GT/rY33+SU1CWmaJOKFTqY/u9RuG1UtqvK02m3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fm0soZiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fm0soZiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE61C2BC9E;
	Mon, 23 Mar 2026 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282996;
	bh=9ceHOTshM1TqlmMaUI6YMDc2dNOBEYKKIO0r+YCCk6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fm0soZiqmS53IisG9yPpYL3YUPnlbZzKQ1k3JL/ZvsjNuq4+m2XbpZ64KIcAV7faP
	 9DxvkAimRyX4rpoqb8sq5sFMHx+maTOl6ca9jo1nBxmtpuI1w4lsDxIqsIj4C6RLKJ
	 wku9L2mpU2fmhgmQq5OlD/l3tVmoq1H6zQCyki6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 362/481] net: macb: Introduce gem_init_rx_ring()
Date: Mon, 23 Mar 2026 14:45:44 +0100
Message-ID: <20260323134533.934169698@linuxfoundation.org>
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

From: Kevin Hao <haokexin@gmail.com>

[ Upstream commit 1a7124ecd655bcaf1845197fe416aa25cff4c3ea ]

Extract the initialization code for the GEM RX ring into a new function.
This change will be utilized in a subsequent patch. No functional changes
are introduced.

Signed-off-by: Kevin Hao <haokexin@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260312-macb-versal-v1-1-467647173fa4@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 718d0766ce4c ("net: macb: Reinitialize tx/rx queue pointer registers and rx ring during resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/cadence/macb_main.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2638,6 +2638,14 @@ static void macb_init_tieoff(struct macb
 	desc->ctrl = 0;
 }
 
+static void gem_init_rx_ring(struct macb_queue *queue)
+{
+	queue->rx_tail = 0;
+	queue->rx_prepared_head = 0;
+
+	gem_rx_refill(queue);
+}
+
 static void gem_init_rings(struct macb *bp)
 {
 	struct macb_queue *queue;
@@ -2655,10 +2663,7 @@ static void gem_init_rings(struct macb *
 		queue->tx_head = 0;
 		queue->tx_tail = 0;
 
-		queue->rx_tail = 0;
-		queue->rx_prepared_head = 0;
-
-		gem_rx_refill(queue);
+		gem_init_rx_ring(queue);
 	}
 
 	macb_init_tieoff(bp);


