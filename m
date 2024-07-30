Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8710B1A618C;
	Tue, 30 Jul 2024 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356602; cv=none; b=ktMOMhMALpH5FMH5eDOJW8FI0wllHZGELsnG0bV3XOBZhDdzljvWmW/7HURn4fK0LpyiDIjTC7Tim7Yp/YuVMzCdtjdJ80X0Udc3UeU4Lbk9lOhGl+VKICUuQZEV73xkotLZaWPlZajjKusbQRsOsmBRisMi2OO+1ErjILSwxHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356602; c=relaxed/simple;
	bh=1SnRJVVU+DOZc778FZ3UOHStS+Oi1JO+jDxxeOfNX4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jvo1wwZ9F7CxNnZs9648gIEiOgRJtBKpYh8vP7g4qTCjf1F5YbHZL5bpbzxonuTkknY+97iw3d/JwvSo8mx6qyCeJ0RAgo/ZtIYMZkAkt0+xEL/ff6ff2WUQfOR60Pp2IXIO6cjHDswPdWMtzGHfDCfh5rW9QWLBkr6k+NCI9sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvJR1qax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvJR1qax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBD87C32782;
	Tue, 30 Jul 2024 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356602;
	bh=1SnRJVVU+DOZc778FZ3UOHStS+Oi1JO+jDxxeOfNX4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvJR1qaxC9rt0MtZJ8ef9Pw95oc9W8tkMvR9XiRuMkNIekU9y6A675r98zaBaJncK
	 7T+qGFWmu++PxIYdrYDQc8O6gxeJ8csrHakC8lHRcTUNJhIfAAqhQtcs79kXiF9BAM
	 i1DZwUHP+h7tLXDUvhJm8aWJIoNYfZoR0d4An+WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	P Praneesh <quic_ppranees@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 166/809] wifi: ath12k: change DMA direction while mapping reinjected packets
Date: Tue, 30 Jul 2024 17:40:42 +0200
Message-ID: <20240730151731.163816062@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: P Praneesh <quic_ppranees@quicinc.com>

[ Upstream commit 33322e3ef07409278a18c6919c448e369d66a18e ]

For fragmented packets, ath12k reassembles each fragment as a normal
packet and then reinjects it into HW ring. In this case, the DMA
direction should be DMA_TO_DEVICE, not DMA_FROM_DEVICE. Otherwise,
an invalid payload may be reinjected into the HW and
subsequently delivered to the host.

Given that arbitrary memory can be allocated to the skb buffer,
knowledge about the data contained in the reinjected buffer is lacking.
Consequently, there’s a risk of private information being leaked.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.1.1-00209-QCAHKSWPL_SILICONZ-1

Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Co-developed-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Signed-off-by: P Praneesh <quic_ppranees@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240520070045.631029-2-quic_ppranees@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_rx.c b/drivers/net/wireless/ath/ath12k/dp_rx.c
index e5fb5cb000f04..37e5bca9570fe 100644
--- a/drivers/net/wireless/ath/ath12k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/dp_rx.c
@@ -3030,7 +3030,7 @@ static int ath12k_dp_rx_h_defrag_reo_reinject(struct ath12k *ar,
 
 	buf_paddr = dma_map_single(ab->dev, defrag_skb->data,
 				   defrag_skb->len + skb_tailroom(defrag_skb),
-				   DMA_FROM_DEVICE);
+				   DMA_TO_DEVICE);
 	if (dma_mapping_error(ab->dev, buf_paddr))
 		return -ENOMEM;
 
@@ -3116,7 +3116,7 @@ static int ath12k_dp_rx_h_defrag_reo_reinject(struct ath12k *ar,
 	spin_unlock_bh(&dp->rx_desc_lock);
 err_unmap_dma:
 	dma_unmap_single(ab->dev, buf_paddr, defrag_skb->len + skb_tailroom(defrag_skb),
-			 DMA_FROM_DEVICE);
+			 DMA_TO_DEVICE);
 	return ret;
 }
 
-- 
2.43.0



