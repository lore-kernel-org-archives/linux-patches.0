Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8326335C6A3;
	Tue, 21 Jul 2026 21:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670294; cv=none; b=OqnrolYNolqN7QVuBbNVaHmvTvOFWnYNwi6zI7CT2GUlG95ZstoiafKrfElcUcAF3WbM+QRR1NpkkZkR5abSx3q03Y+75aaWHihY3811FXF/UqBG+reUpU8NRGnGWYUzuRSUzy+TodEqcw0GihF5W2/qx+PxNuLQ19bNmf4KBOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670294; c=relaxed/simple;
	bh=RMgvag4kIFK4faCH4RBXy2j39SWgM3F8YkFloS4OkTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ3dYBdBmOEdZ1TosP+mO6CfhKD2pGNMHKlUUx1WXs2x4+I/zJydMQMpnKYGwuSNqMCLh7II6zGZ8tsZ6kNTF/qOfmTLBLOJC9OB79NdMBTDe0RyYRuFTAl4dIc0pjeboVc04BCyJdgJHoSKjmOxKI38RrIekCoPlZb9lQqSTqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3LREc69; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3LREc69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F671F000E9;
	Tue, 21 Jul 2026 21:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670293;
	bh=dACZoshIiem4gcvI0412iiEYidxdGjuW+pph0slva+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3LREc69f5eUcF+Z7hYHhg9jkGpyQecGhyqLpKjAACxbAXn5kEbr9dBNLyeXNltjU
	 Uc7aoSidLAEmEddsuDEPRrgzGpQ7AuGEyXei+BzpY2NktzbNqBcxsSvmcl9/eAEAq8
	 pzA+vPQHa2k8CM8lMu8XE6RYNXf2ycBtBm6FsbfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0877/1067] net: wwan: t7xx: destroy DMA pool on CLDMA late init failure
Date: Tue, 21 Jul 2026 17:24:38 +0200
Message-ID: <20260721152444.152646313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 2bd6f26d4ce1e87de4d736b1e8896daf3acf1c0e upstream.

t7xx_cldma_late_init() creates md_ctrl->gpd_dmapool before
initializing the TX and RX rings. If any ring initialization
fails, the error path frees the already initialized rings but
leaves the DMA pool allocated.

Destroy md_ctrl->gpd_dmapool on the late-init failure path
to avoid leaking the DMA pool.

Fixes: 39d439047f1d ("net: wwan: t7xx: Add control DMA interface")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260621031714.3605022-1-haoxiang_li2024@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wwan/t7xx/t7xx_hif_cldma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
+++ b/drivers/net/wwan/t7xx/t7xx_hif_cldma.c
@@ -1051,6 +1051,9 @@ err_free_tx_ring:
 	while (i--)
 		t7xx_cldma_ring_free(md_ctrl, &md_ctrl->tx_ring[i], DMA_TO_DEVICE);
 
+	dma_pool_destroy(md_ctrl->gpd_dmapool);
+	md_ctrl->gpd_dmapool = NULL;
+
 	return ret;
 }
 


