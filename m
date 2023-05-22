Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6821C171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28BCC433D2;
	Mon, 22 May 2023 19:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783367;
	bh=nMt3l2rvRWPdWyfAMgfc2hIejuefC4dNk9zJSGIxHU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPI5S1Z/+hxi7vodEviEHLAZGiNCBvXu4SacooV9PwMMx8SA89ub5qDvgIV2jb/j8
	 YbYYUZSgYvaG1tsyk0Iir3ZQYWPnWso6SzzNIZmoJHVHYyvAWnAH77ebs3sib3e/ej
	 rbXlBI5uiCYvN7+PzeNVGTkYHDbgD7dUtSB8c1To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziwei Xiao <ziweixiao@google.com>,
	Bailey Forrest <bcf@google.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/292] gve: Remove the code of clearing PBA bit
Date: Mon, 22 May 2023 20:06:17 +0100
Message-Id: <20230522190406.398968803@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ziwei Xiao <ziweixiao@google.com>

[ Upstream commit f4c2e67c1773d2a2632381ee30e9139c1e744c16 ]

Clearing the PBA bit from the driver is race prone and it may lead to
dropped interrupt events. This could potentially lead to the traffic
being completely halted.

Fixes: 5e8c5adf95f8 ("gve: DQO: Add core netdev features")
Signed-off-by: Ziwei Xiao <ziweixiao@google.com>
Signed-off-by: Bailey Forrest <bcf@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_main.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index d3e3ac242bfc3..2e5e0a8872704 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -239,19 +239,6 @@ static int gve_napi_poll_dqo(struct napi_struct *napi, int budget)
 	bool reschedule = false;
 	int work_done = 0;
 
-	/* Clear PCI MSI-X Pending Bit Array (PBA)
-	 *
-	 * This bit is set if an interrupt event occurs while the vector is
-	 * masked. If this bit is set and we reenable the interrupt, it will
-	 * fire again. Since we're just about to poll the queue state, we don't
-	 * need it to fire again.
-	 *
-	 * Under high softirq load, it's possible that the interrupt condition
-	 * is triggered twice before we got the chance to process it.
-	 */
-	gve_write_irq_doorbell_dqo(priv, block,
-				   GVE_ITR_NO_UPDATE_DQO | GVE_ITR_CLEAR_PBA_BIT_DQO);
-
 	if (block->tx)
 		reschedule |= gve_tx_poll_dqo(block, /*do_clean=*/true);
 
-- 
2.39.2



