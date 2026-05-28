Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9026233372A;
	Thu, 28 May 2026 20:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001594; cv=none; b=QnRT5yiViHU2QUtp0sbCNf6dkqudF/nrvSoE4/BY62BAnxqjGx7M0iS91Lp3yWNbbhSd5WZnb3d+2NmFmqzXqvdBqhWLlaRK03CIZKmfPj/8WrJJLbgN2uu0+kpyU8tHeltl426u1N6RahLwIhviixdI0ISp2J6xgVTPvpqWMOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001594; c=relaxed/simple;
	bh=J/Zh9r9uyLyt2V8gVYjRDZLKlVBU0BI+Vo43yLlgONM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRYsVolzgpYp93ZUfacIl8NvqaTeCvBg+mnFVhn3brbo5cb8Dzl5gIGAFULaZgUM3vCQ8Gx38sQRVAz/IUHESlWDYlbfn7MfE3bE64dTH9UajgWMWskpV5yuO4/1BeIOcE5GDZdTg0X6UQ4/1McKBddGtlXY8Wr4jn1M9T5vSCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XA2OEjaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XA2OEjaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0291F000E9;
	Thu, 28 May 2026 20:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001593;
	bh=qQ29Gk0zkZnV0u+3ddQvWdyajo3ddVl5SWrVxShGanc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XA2OEjaqLiBPogNlY/TRHgYcgWNn4Un2XLA5dlY5aOacuJbQFOeO8ESVoWcZK3IIl
	 p2itouPCgSJ3JD/toyzihaoYUzurpxTo2LXML5OLaR+o1JoXtcKey6uslfyr4z8m0P
	 jIgZgDC1qyQip7dGmbX3I8cUih+teOPbPMRxy5uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/186] net: mana: validate rx_req_idx to prevent out-of-bounds array access
Date: Thu, 28 May 2026 21:51:02 +0200
Message-ID: <20260528194933.904650486@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b5ec1250a674f..1234c62fcbc7d 100644
--- a/drivers/net/ethernet/microsoft/mana/hw_channel.c
+++ b/drivers/net/ethernet/microsoft/mana/hw_channel.c
@@ -232,6 +232,12 @@ static void mana_hwc_rx_event_handler(void *ctx, u32 gdma_rxq_id,
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



