Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3051264A76;
	Tue,  8 Apr 2025 11:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110935; cv=none; b=t231NGUAV78O9I+BtoWGVMdkumLP85ibaQM90rGfPZSrLG9wyhEIJSVCZzCqY8bz/mR1nmhQ/GRMhBZWiPeVCab+7ZkxI29XFloc3LN5SDNa0D4zCQcFjYDq1uR0LLZ2DnmVC5G0hTAIiZjXhgSsujfBv37WWBEDFK9GkzfTJ48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110935; c=relaxed/simple;
	bh=vlI1ujjX4JEW1U5jwbnmyppUQhepynQCjs1oiiRkVgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1vJMJaGUJmQ3FVmvE8xyo9B9XdQEm8WUQPoX3m8/N7kJtvDS2V/+To+hTkrTlYYBPugy5lPk5wKTGj4dtWmf89hH5xfRfAdYPQeF+Axgd/RQOJ5Pg6aeXJSEm82MiSnbxQwpj8STep3IHLlQPEyu091VVluY+iGr4e5kvSU2Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jzVnwEEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jzVnwEEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330ACC4CEE5;
	Tue,  8 Apr 2025 11:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110935;
	bh=vlI1ujjX4JEW1U5jwbnmyppUQhepynQCjs1oiiRkVgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jzVnwEEFCVd6GtzSh4HPHYgBhWDHzwwzqql0GM8V1olSa0JoCmnl6xaJYdwOXO5AW
	 l+5aNcxDanOk5J9NPedwI28LogM3dxEIdXGuQNqFpZfXaSkNeTvPLH5asbkiA38m9g
	 h+/HE+9EwtfDWrNFRueQTirAc02wVkJPfoz+vRPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 248/731] vmxnet3: unregister xdp rxq info in the reset path
Date: Tue,  8 Apr 2025 12:42:25 +0200
Message-ID: <20250408104920.051858793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>

[ Upstream commit 0dd765fae295832934bf28e45dd5a355e0891ed4 ]

vmxnet3 does not unregister xdp rxq info in the
vmxnet3_reset_work() code path as vmxnet3_rq_destroy()
is not invoked in this code path. So, we get below message with a
backtrace.

Missing unregister, handled but fix driver
WARNING: CPU:48 PID: 500 at net/core/xdp.c:182
__xdp_rxq_info_reg+0x93/0xf0

This patch fixes the problem by moving the unregister
code of XDP from vmxnet3_rq_destroy() to vmxnet3_rq_cleanup().

Fixes: 54f00cce1178 ("vmxnet3: Add XDP support.")
Signed-off-by: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>
Signed-off-by: Ronak Doshi <ronak.doshi@broadcom.com>
Link: https://patch.msgid.link/20250320045522.57892-1-sankararaman.jayaraman@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 6793fa09f9d1a..3df6aabc7e339 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2033,6 +2033,11 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 
 	rq->comp_ring.gen = VMXNET3_INIT_GEN;
 	rq->comp_ring.next2proc = 0;
+
+	if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
+		xdp_rxq_info_unreg(&rq->xdp_rxq);
+	page_pool_destroy(rq->page_pool);
+	rq->page_pool = NULL;
 }
 
 
@@ -2073,11 +2078,6 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 		}
 	}
 
-	if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
-		xdp_rxq_info_unreg(&rq->xdp_rxq);
-	page_pool_destroy(rq->page_pool);
-	rq->page_pool = NULL;
-
 	if (rq->data_ring.base) {
 		dma_free_coherent(&adapter->pdev->dev,
 				  rq->rx_ring[0].size * rq->data_ring.desc_size,
-- 
2.39.5



