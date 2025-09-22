Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8447A2F28E0;
	Mon, 22 Sep 2025 19:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570037; cv=none; b=SoYlso9mndIb+8dk4LJXicg1ax4X1U3AnnXRqP06VQj8J6cjy228bGDahNKIzMn3v2+Xmpo6Cag+xGQCFPYvzOq+8IxMl53B1QQYo8f3cWD6OChPMpP+86ghLuDqJjlcWLqQ9oX8+A7Dp++hDd5DPow7zmdtTEq/C4Q7hfWROX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570037; c=relaxed/simple;
	bh=/JsK0Olw/cRu+/PLXSlxRbluQXUiQYcftH0s9GbEtjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YskuHwwJLf9KiMSVYIe2W5t8fCR54xbgGm2ijqCbkM7B/A+83AQqNigc37vZMHFbM5aJOzt3wBCCQ/Qxi6nXECxGDIpWTFcAE874wff/Rbg9nqG7LcR3MlgFPUn7ePi7diQ9EaNAHFWs4xZ25GMmY6oQTfKMvz+jvq5aS5yGDbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpFEnGMC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpFEnGMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17488C4CEF5;
	Mon, 22 Sep 2025 19:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570037;
	bh=/JsK0Olw/cRu+/PLXSlxRbluQXUiQYcftH0s9GbEtjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpFEnGMCoNrRqTMxiD7khfmoZlSGjImaCZ/4pBP1iVkor7JdhgKIzDQgnDoBm5TvX
	 Xa0PCZXicmohtiZc+ChHixSqa2ElBt4pJNv2vB39yMhvIvUWAbFpxp9SBCgIsT79VK
	 Zlv7oZvags1vh5KJuDkpSgO+tIB96jmxtHT9U614=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>,
	Ronak Doshi <ronak.doshi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.12 090/105] vmxnet3: unregister xdp rxq info in the reset path
Date: Mon, 22 Sep 2025 21:30:13 +0200
Message-ID: <20250922192411.264402793@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sankararaman Jayaraman <sankararaman.jayaraman@broadcom.com>

commit 0dd765fae295832934bf28e45dd5a355e0891ed4 upstream.

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
[ Ajay: Modified to apply on v6.6, v6.12 ]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2051,6 +2051,11 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_que
 
 	rq->comp_ring.gen = VMXNET3_INIT_GEN;
 	rq->comp_ring.next2proc = 0;
+
+	if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
+		xdp_rxq_info_unreg(&rq->xdp_rxq);
+	page_pool_destroy(rq->page_pool);
+	rq->page_pool = NULL;
 }
 
 
@@ -2091,11 +2096,6 @@ static void vmxnet3_rq_destroy(struct vm
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


