Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B7732ABC0;
	Thu, 28 May 2026 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999212; cv=none; b=S6Z5TvkXj9f8ZeGpCiaEjNhCzLhtBWNiuatgWH9FHQi8A441xYWK9JDdMrAvfS9x3wd+RgKcOqw02HjnLCXMShppufLu34jdfImJ6Q5DgFmkkgCigDQMuSME3ZDMlsi1z5Lpb0a3uy7wI4gr6+/7RQr/mVWFor2WXZfMUPukJWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999212; c=relaxed/simple;
	bh=wh7AIXiDb5622f4gfAgwQamYbt52JfoklRfCMZWVCg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtBb18H4gAULMpMhLYI/4UKQyWSF/qpzB8JoaacwQkPGtr1bajO0XDh9HnR7oN/ZFQySo0BXLHezkIO7/hiQwwrlbwIEBMdVb6eQ+Its7jzrDbK1uiETyMLb9ITpDXtTfkmAtaYz72olIjQmOMs9MX2pqhijR4D3VZ6H2j/HJus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFJNc2NW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFJNc2NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B9E1F000E9;
	Thu, 28 May 2026 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999211;
	bh=CW4CdnV/9tCSSu5DT1NWE5lHAlcQSkBK8Vu1fsbNiyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFJNc2NW0YsyANmTDuecTwegAgBmcQB7Xr41Y1/4TOokkbRYWYQubhFG6Yt+EeyNV
	 WzYkdbLHGSNRLBCXXCr/DqOQkI1XH1gHAbzoaTLphllhmetfj0MW0EMQPUiqSXCTsU
	 tQgHLgSm/gnUdqRM9HRBNDthxjPQTCJr9OOCggoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 449/461] net: mana: validate rx_req_idx to prevent out-of-bounds array access
Date: Thu, 28 May 2026 21:49:38 +0200
Message-ID: <20260528194700.533979748@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya@linux.microsoft.com>

[ Upstream commit b809d0409991b75a6cff846a5ac27c3062953f84 ]

In mana_hwc_rx_event_handler(), rx_req_idx is derived from
sge->address in DMA-coherent memory. In Confidential VMs
(SEV-SNP/TDX), this memory is shared unencrypted and HW can modify
WQE contents at any time. No bounds check exists on rx_req_idx,
which can lead to an out-of-bounds access into reqs[].

Add bounds check on rx_req_idx in mana_hwc_rx_event_handler() before
using it to index the reqs[] array.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Aditya Garg <gargaditya@linux.microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://patch.msgid.link/20260520051553.857120-1-gargaditya@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/hw_channel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/microsoft/mana/hw_channel.c b/drivers/net/ethernet/microsoft/mana/hw_channel.c
index 12d73470fd6bb..dbaeedb6e7b1a 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -265,6 +265,12 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
 	rq_base_addr = hwc_rxq->msg_buf->mem_info.dma_handle;
 	rx_req_idx = (sge->address - rq_base_addr) / hwc->max_req_msg_size;
 
+	if (rx_req_idx >= hwc_rxq->msg_buf->num_reqs) {
+		dev_err(hwc->dev, "HWC RX: wrong rx_req_idx=%llu, num_reqs=%u\n",
+			rx_req_idx, hwc_rxq->msg_buf->num_reqs);
+		return;
+	}
+
 	rx_req = &hwc_rxq->msg_buf->reqs[rx_req_idx];
 	resp = (struct gdma_resp_hdr *)rx_req->buf_va;
 
-- 
2.53.0



