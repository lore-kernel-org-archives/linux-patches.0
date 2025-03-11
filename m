Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033AF25BACC;
	Tue, 11 Mar 2025 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706639; cv=none; b=et/dOIiWJ3Q5Yt641ApMVixLonS6D2GE5uoWakNjsBEGBTgnr7/nORFIL/MNCeqOGBedRRzKft+2uPnuoGxX2Qnmz4eqDliFPXpM9C4kedl2C59n/cqJcK2TyaYN3uxw+ap0rVMhVqbhSCfwc72rUb9W/k7HSQU4v+uEL6T70L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706639; c=relaxed/simple;
	bh=7chqXzqRFTlP4bKYWBhhDNRGWytmXFMk0yy3ArKbMAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bpbXndLpjlVRN8ZzS8bx5naPGqOF3K53SZRO7TQW8ABVpe6MTh5B9g0JzJpPICcl79zDgTQOZdpANJdC6mdcXR51SgKcvqRm/Pe0EtZ0wMNiVfezfnD6BJP8Us0Ln9ifMC9T6Tny7EmqbEX1KPtbeSD2PcKMJPLPn2G/q4/nEmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UT2gQA/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UT2gQA/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A654C4CEEA;
	Tue, 11 Mar 2025 15:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706638;
	bh=7chqXzqRFTlP4bKYWBhhDNRGWytmXFMk0yy3ArKbMAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UT2gQA/L3yY52j1AR80DQ6jyVZwk58+JXxow5g9MM+BRfCiZQ8g90NYQSWw/mIwCy
	 gJebHHq84XNpXHUj8BV1YMoe99tLOtMqEVerdGsJDARGjBEo6O2EycUKb/cl/besek
	 xQRgU9nx7Th/5HLlkNYCKH753afn2Cz8ilXN2Wnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Simon Horman <horms@kernel.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/462] bgmac: reduce max frame size to support just MTU 1500
Date: Tue, 11 Mar 2025 15:56:15 +0100
Message-ID: <20250311145802.671375090@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 752e5fcc2e77358936d36ef8e522d6439372e201 ]

bgmac allocates new replacement buffer before handling each received
frame. Allocating & DMA-preparing 9724 B each time consumes a lot of CPU
time. Ideally bgmac should just respect currently set MTU but it isn't
the case right now. For now just revert back to the old limited frame
size.

This change bumps NAT masquerade speed by ~95%.

Since commit 8218f62c9c9b ("mm: page_frag: use initial zero offset for
page_frag_alloc_align()"), the bgmac driver fails to open its network
interface successfully and runs out of memory in the following call
stack:

bgmac_open
  -> bgmac_dma_init
    -> bgmac_dma_rx_skb_for_slot
      -> netdev_alloc_frag

BGMAC_RX_ALLOC_SIZE = 10048 and PAGE_FRAG_CACHE_MAX_SIZE = 32768.

Eventually we land into __page_frag_alloc_align() with the following
parameters across multiple successive calls:

__page_frag_alloc_align: fragsz=10048, align_mask=-1, size=32768, offset=0
__page_frag_alloc_align: fragsz=10048, align_mask=-1, size=32768, offset=10048
__page_frag_alloc_align: fragsz=10048, align_mask=-1, size=32768, offset=20096
__page_frag_alloc_align: fragsz=10048, align_mask=-1, size=32768, offset=30144

So in that case we do indeed have offset + fragsz (40192) > size (32768)
and so we would eventually return NULL. Reverting to the older 1500
bytes MTU allows the network driver to be usable again.

Fixes: 8c7da63978f1 ("bgmac: configure MTU and add support for frames beyond 8192 byte size")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
[florian: expand commit message about recent commits]
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250127175159.1788246-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.h b/drivers/net/ethernet/broadcom/bgmac.h
index d1200b27af1ed..51ff5aceba99e 100644
--- a/drivers/net/ethernet/broadcom/bgmac.h
+++ b/drivers/net/ethernet/broadcom/bgmac.h
@@ -366,8 +366,7 @@
 #define BGMAC_RX_FRAME_OFFSET			30		/* There are 2 unused bytes between header and real data */
 #define BGMAC_RX_BUF_OFFSET			(NET_SKB_PAD + NET_IP_ALIGN - \
 						 BGMAC_RX_FRAME_OFFSET)
-/* Jumbo frame size with FCS */
-#define BGMAC_RX_MAX_FRAME_SIZE			9724
+#define BGMAC_RX_MAX_FRAME_SIZE			1536
 #define BGMAC_RX_BUF_SIZE			(BGMAC_RX_FRAME_OFFSET + BGMAC_RX_MAX_FRAME_SIZE)
 #define BGMAC_RX_ALLOC_SIZE			(SKB_DATA_ALIGN(BGMAC_RX_BUF_SIZE + BGMAC_RX_BUF_OFFSET) + \
 						 SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
-- 
2.39.5



