Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB86369206;
	Wed, 30 Sep 2026 15:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783538; cv=none; b=IH7rzZgZpTF4Mi41/vGnuM3beQdRy+O9nVZP2VJ+E17OTJMdjCPLfrP9j4CdV3C+hr14iIwWHnTptPGnT48ECJZOk5xJSgAvkZsc/vq0G3OFg/qWOHyoEV33WkRZFhj1nXj2+ZX8YHlHaAhplP4hGwbbXzFUxhswySoB0dDidaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783538; c=relaxed/simple;
	bh=s526Ssp+IrJjyS4h7nxI9nGkAMOARr11xPDT22kYQOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgzT32JK5D64Z/e9xk9vgrlSgAaZfft91kzfeMVJvhiJosy4v9SM1p/azgmIgMzJyKbtPkblGi2gC1U0ngUZYMer/H7XD9SwXXJAZh5ErvzfE/MGRgTcOvsoygkIRTVs3G7m4zW6y35UoNB/wxiRqdqA12mxdcvv5A4NtyGjQoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U/1Cccmc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U/1Cccmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AE11F00893;
	Wed, 30 Sep 2026 15:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783531;
	bh=9A4fggu+KvW95gmrkNIZKtK3Gq9xPHB3bEA0BuqflAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U/1CccmceP59lavijcGX7xw5ponD+X1ClhnUeb+F6OdnqWyiPxRM1kS3wLF3ybym8
	 K4u8H8EEN5BtmGSd0hTREh6pV/JZOI7RofRM2yuqpKvIMo7gGZCcqQ8OMxZdvmeUx1
	 Xr27/7kjJiOupQJvNiWdqES/Yl0nS7Lde/+sQ9z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.10 431/595] dmaengine: ti: k3-udma-glue: fix NULL dereference in k3_udma_glue_release_rx_chn()
Date: Wed, 30 Sep 2026 17:25:24 +0200
Message-ID: <20260930152356.950601590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>

commit 0294b6dd515256c03ea2dbf508ddd3826d788579 upstream.

If devm_kcalloc() for rx_chn->flows fails in a channel request function,
the error path calls k3_udma_glue_release_rx_chn(), which dereferences
the NULL rx_chn->flows pointer in k3_udma_glue_release_rx_flow().

Skip the flow release loop in k3_udma_glue_release_rx_chn() when
rx_chn->flows is not allocated.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70241913413 ("dmaengine: ti: k3-udma: Add glue layer for non DMAengine users")
Cc: stable@vger.kernel.org
Reported-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Signed-off-by: Alexander Chesnokov <Alexander.Chesnokov@kaspersky.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260812053426.3521589-1-Alexander.Chesnokov@kaspersky.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ti/k3-udma-glue.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/dma/ti/k3-udma-glue.c
+++ b/drivers/dma/ti/k3-udma-glue.c
@@ -925,8 +925,9 @@ void k3_udma_glue_release_rx_chn(struct
 		rx_chn->psil_paired = false;
 	}
 
-	for (i = 0; i < rx_chn->flow_num; i++)
-		k3_udma_glue_release_rx_flow(rx_chn, i);
+	if (rx_chn->flows)
+		for (i = 0; i < rx_chn->flow_num; i++)
+			k3_udma_glue_release_rx_flow(rx_chn, i);
 
 	if (xudma_rflow_is_gp(rx_chn->common.udmax, rx_chn->flow_id_base))
 		xudma_free_gp_rflow_range(rx_chn->common.udmax,


