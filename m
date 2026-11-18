Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056405;
	b=UTMhsKZKtbFqDb+L4lNmCrWLd1C4eGgSDcV++mRz8zBPHeyqKoa6AdWZedR8Sd+okage
	 u2FssqVeBKmawambXP4hfdM6Id5l4+ab4710VtEoNYT1P3S24slZlCS5O14/eohY1Do2z
	 N6wiXStSt1P/I/BaEUM4bJ78P0Y945Sg/HiwFWdT8AV3uP3RL6qidqcBopXvS9ynJgI+5
	 1TqfYlISQTJ123ylqNBI4MTO5kFfxNqxxkqHJAnE/VSXqdyPYHSfeMnybGGWUb/zmtLET
	 E/cb5mAwmd2w6pBpz9Sifn6elVD8Ejz5k7wuONbv4uj3PFqVh7O4XvOltC4/pJSkGiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hFd64xtx0egaGgeM95Wz9WWY/2QkBGXKavUrkXPGXQY=;
	b=zQqRPIzxV0ME4mixxzTiX2U6Ay0xbqf5hjujE1T7kSD+uNCAoJgFHAU6WU8vywKncgsK
	 b5pkEZZ3If6V26PHdvYnvl9fBPWbxPMqdu3EPDGLm32T1T+MOCU+cCsWjxRPfc+IDZA/a
	 752efZYz7Mc1xGtPfY/6smp489daEwrwXWlMsvClkqY9KoxjREoMq8rFYP+WivtOpgoHs
	 m8hw4qFusP307CN+KRvOSKSvNlZWvgy23UonH2wKuexuesQd1Js/ocKlo2yX3CXmEQh3/
	 HoeXuM7u7CQCz4NIM8EUm+AMiWVkw1U2eANmMHeNgALLPUtvZY6klBHxiNaGRAFIEOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzsAr8Kb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CB3606A31C;
	Thu, 19 Nov 2026 02:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rzsAr8Kb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BEF1F000C4;
	Thu, 19 Nov 2026 02:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056404;
	bh=hFd64xtx0egaGgeM95Wz9WWY/2QkBGXKavUrkXPGXQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzsAr8Kbioa/jJCAf6pSnzIe/Otzaki8L50Dw0eDmTxyF3CCmcg25mLCPJcbmDOcM
	 qn9NK+LkZHCNocn+PnXzUKolkTwYyS3sQP1Yv7s+v2+m3snQbWzJCbd8co2trxCm1T
	 GuAQH5VyVWfhm8sXicNUIwJbUQWyVmwscOSQEais=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1975/2214] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
Date: Wed, 18 Nov 2026 16:00:51 +0100
Message-ID: <20261118150129.902424226@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 59df57262e6fa9e6f4aa76d6d324134777c702a0 ]

Previously, the IRDMAQPSQ_PBLADDR FRWR WQE field was being populated
using a mask that was right-shifted, whereas it should have been the
address being right-shifted.

This ended up working fine in many cases because the lowermost 12 bits
are always zero (the addresses are page aligned) and the uppermost 12
bits are usually zero too, but it could break for DMA addresses that
are wider than 52 bits.

Fix this by right-shifting the address instead of the mask, similar
to how it was done in the original i40iw driver.

Tested with NFS over RDMA with some added debug logs to ensure it
was hitting both the direct (single page) path as well as multi
page (< 512).

Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20261015161756.3078300-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index e1c40776de440..709a3a4421adf 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1313,7 +1313,7 @@ irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
 			 info->first_pm_pbl_index >> 16);
 	set_64bit_val(wqe, 8,
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXHI, temp) |
-		      FIELD_PREP(IRDMAQPSQ_PBLADDR >> IRDMA_HW_PAGE_SHIFT, info->reg_addr_pa));
+		      FIELD_PREP(IRDMAQPSQ_PBLADDR, info->reg_addr_pa >> IRDMA_HW_PAGE_SHIFT));
 	set_64bit_val(wqe, 16,
 		      info->total_len |
 		      FIELD_PREP(IRDMAQPSQ_FIRSTPMPBLIDXLO, info->first_pm_pbl_index));
-- 
2.53.0



