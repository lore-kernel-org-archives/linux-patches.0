Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622514;
	b=M5tygY9JRs61vN3otDp5tcN4ZEnq+ODkbNncsOKebukdw3VXbAnVbw6N9K/TYdcYF4g9
	 qbB3MZDn7On5LYgy3/Hbhsmu6Ksl1X42yU2eKg0U996BF90/8S5hUxm6Fj0T5l6mkAE3q
	 jV20yVXZG7KT3/mqQKAnIQN6BJfyRAFuu3VY++WNdbe4cLFbzxSsCinrCrV7+ndpy3YQp
	 6Mbttdijsw6ompkggc4O6X6C5EntEKmj6j7+Gcp3u6AWGoOfiIwp20uuyqtmG/PEMqJLi
	 +H6pLH2M6/OQYH4kVyOyLTpSOXYkB4LLGxnhTT4xXhav+n8IZEnRTeu2er5NvCcFh+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0ehQ+u0zXGifeNcXLVF3FwDhFlUH7R1PphHlobYqxxw=;
	b=cH+Dj1K0CBHQnCg0gYvBbY5U6dn671oLiJx0PZoFJG2/nur05agFgu/XYEodZAv+9sYH
	 jRNNsl3AWwpqSHBO5qWtpRFqW4vjuYz1X7VAlyYL8VshmDoArgn8bu6wSWuulhFUi0Qcl
	 NbeLHYolfaWvyAvDNx9DBsc+d+Wf5CwZrUTXlAXdd/9P4JvVil09EsMsiInkd+iR4k4H8
	 nWYRQAFbZ9P9NZciBaDaHZ6cdUObbvtm45NHZYIcWAagToKspKXSeg2F8Q38dCdYF5wSl
	 +qeuJitI9+2LW2dENbXUGyT4PRAizIzoQrIoZWOnDGl5qAGWoe2bhYm9yx0+hc1U0FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPZTSz7P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD535606A326;
	Wed, 25 Nov 2026 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPZTSz7P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0317E1F000D4;
	Wed, 25 Nov 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622514;
	bh=0ehQ+u0zXGifeNcXLVF3FwDhFlUH7R1PphHlobYqxxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPZTSz7P+uUu0AcUv02K4/dcTr+NXuNyx6CzERhrHI3ifGqwtyxeMrpVDuY65MwZA
	 WVInAl3yKBm3tADvJiXVmFlOVFyRPFI7t5HTLDzLzzNUqLjaA5/rVHkTtXCAa85b8Q
	 L51LhRRKdw0RPM/LntyVtb/ajWaPBLWOXMIRJHCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Yang <kang.yang@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 545/990] wifi: ath12k: fix skb leak on paddr mismatch in wifi7 mon RX pop
Date: Wed, 25 Nov 2026 15:31:52 +0100
Message-ID: <20261125143834.865710057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kang Yang <kang.yang@oss.qualcomm.com>

[ Upstream commit 4dfe8e3ac731c3372b5c1f1f73b0676c301c3916 ]

When rxcb->paddr does not match the MSDU-list paddr reported by
the link descriptor, ath12k_wifi7_dp_rx_mon_mpdu_pop() sets
drop_mpdu = true and continues to the next MSDU. At that point
the skb is still attached to the descriptor via desc_info->skb;
the local msdu variable only holds a copy of that pointer. The
continue skips the rest of the loop body, which would normally
DMA-unmap the buffer, free the skb, clear desc_info->skb, and
append the descriptor to used_list in the next_msdu block.

The descriptor therefore stays in_use with the skb attached
forever. The skb is never DMA-unmapped, delivered, freed or
replaced, and HW does not write into it either because the
descriptor is no longer posted to any SRNG. The descriptor is
also never returned to used_list, so
ath12k_dp_rx_bufs_replenish() cannot allocate a fresh buffer
for it and the RX refill ring gradually drains.

The skb is still reachable via dp->rxbaddr[][].skb and is
reclaimed at teardown by ath12k_dp_cc_cleanup(), so this is not
a kmemleak-style unreachable leak. Nevertheless, both the
descriptor slot and the skb memory are wasted for the module
lifetime, and under sustained mismatches monitor RX stalls.

Remove the continue so drop_mpdu remains true, execution reaches
the DMA unmap and dev_kfree_skb_any() below, and the descriptor
is returned to used_list via the next_msdu block for replenish.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 72bfbf19b7da ("wifi: ath12k: add support to reap and process mon dest ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260916060325.854-2-kang.yang@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
[ sashal: Renamed the file path from the wifi7 split (wifi7/dp_mon.c, ath12k_wifi7_dp_rx_mon_mpdu_pop) to ath12k/dp_mon.c with ath12k_dp_rx_mon_mpdu_pop; the one-line continue removal itself is unchanged. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/dp_mon.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/dp_mon.c b/drivers/net/wireless/ath/ath12k/dp_mon.c
index 3752fa0eed30b..a7cb7ba62f2d4 100644
--- a/drivers/net/wireless/ath/ath12k/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/dp_mon.c
@@ -4173,7 +4173,6 @@ ath12k_dp_rx_mon_mpdu_pop(struct ath12k *ar, int mac_id,
 					   i, (unsigned long)rxcb->paddr,
 					   (unsigned long)msdu_list.paddr[i]);
 				drop_mpdu = true;
-				continue;
 			}
 			if (!rxcb->unmapped) {
 				dma_unmap_single(ar->ab->dev, rxcb->paddr,
-- 
2.53.0



