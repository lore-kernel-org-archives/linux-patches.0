Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67112225397;
	Mon, 18 Aug 2025 13:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524867; cv=none; b=uFUzW7jzF6y4MHV7XaPAFlNxjUuQr7zbOQZOjOCz0oxMFemKl8qZKIHDGjmzGkrQjX/6ESdakzHrgY9HCrwZ/m1vzgR0yKpWBLka68swRqSeNWbh4RBgbu+sXLPfBcAMSb7NxWZSUFzmFgbSJf2gyoBowmdNk6OeDDSE5fcOwKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524867; c=relaxed/simple;
	bh=N99DexYOGN/gsq154IgcIcEyE6kvYiB5YHHCqUZ92VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qESkE142USA95MNLkYqhWY9pzwSJIPXg0a3GSw8ghyEKgj/uDHQKDK8C1xrMQ2iyD7yywxMJN369OFgbGdjwvqC7EcjP/vWXqMnYn4ivUFFeg1ZoUSbEhUFDyKpfiSJ7SxPNAdp3lzJ0IXxxOblzHfKyD+L6ywGZmMYCeuHIXJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qc0TDB97; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qc0TDB97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41999C4CEEB;
	Mon, 18 Aug 2025 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524867;
	bh=N99DexYOGN/gsq154IgcIcEyE6kvYiB5YHHCqUZ92VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qc0TDB97444p4VUE96pMBpiSVc694SioeYiuUg4IxlKCb09cHRpYaZHEoQQ+Nk2i5
	 mhbw+MVTyTrznS+2M5FIVI5Y88ly1X7UZVD/UAkrwIEtqkrlwQFCe4uXlA0h0tuuZI
	 2pt3N0HGS5dulVP8xKnGsHwQ8/k46ud84AES0REk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 087/570] bnxt: fill data page pool with frags if PAGE_SIZE > BNXT_RX_PAGE_SIZE
Date: Mon, 18 Aug 2025 14:41:14 +0200
Message-ID: <20250818124509.166598508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Wei <dw@davidwei.uk>

[ Upstream commit 39f8fcda2088382a4aa70b258d6f7225aa386f11 ]

The data page pool always fills the HW rx ring with pages. On arm64 with
64K pages, this will waste _at least_ 32K of memory per entry in the rx
ring.

Fix by fragmenting the pages if PAGE_SIZE > BNXT_RX_PAGE_SIZE. This
makes the data page pool the same as the header pool.

Tested with iperf3 with a small (64 entries) rx ring to encourage buffer
circulation.

Fixes: cd1fafe7da1f ("eth: bnxt: add support rx side device memory TCP")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://patch.msgid.link/20250812182907.1540755-1-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8d950b43846e..e165490af6ac 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -921,15 +921,21 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 
 static netmem_ref __bnxt_alloc_rx_netmem(struct bnxt *bp, dma_addr_t *mapping,
 					 struct bnxt_rx_ring_info *rxr,
+					 unsigned int *offset,
 					 gfp_t gfp)
 {
 	netmem_ref netmem;
 
-	netmem = page_pool_alloc_netmems(rxr->page_pool, gfp);
+	if (PAGE_SIZE > BNXT_RX_PAGE_SIZE) {
+		netmem = page_pool_alloc_frag_netmem(rxr->page_pool, offset, BNXT_RX_PAGE_SIZE, gfp);
+	} else {
+		netmem = page_pool_alloc_netmems(rxr->page_pool, gfp);
+		*offset = 0;
+	}
 	if (!netmem)
 		return 0;
 
-	*mapping = page_pool_get_dma_addr_netmem(netmem);
+	*mapping = page_pool_get_dma_addr_netmem(netmem) + *offset;
 	return netmem;
 }
 
@@ -1024,7 +1030,7 @@ static int bnxt_alloc_rx_netmem(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 	dma_addr_t mapping;
 	netmem_ref netmem;
 
-	netmem = __bnxt_alloc_rx_netmem(bp, &mapping, rxr, gfp);
+	netmem = __bnxt_alloc_rx_netmem(bp, &mapping, rxr, &offset, gfp);
 	if (!netmem)
 		return -ENOMEM;
 
-- 
2.50.1



