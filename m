Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032182;
	b=47egjU8twcjN9mCstmXnEZQ1Gubf6WuUM0bvo3SnyThuNflhI2qfD6VYHAv4Q7/Igw/1
	 F8jaWlEVe2ULEiyGgjBl9rszFpde8NTvHkDlhaiv4C3BFfld9P8x+RLR9NAuISDuuPgPQ
	 ovmy6ikdTsiYPw052g6j22GdoXG7zw0Kdq4EBCVMWMPAsrjZsQeThHeF1ktprm5VOlKIt
	 s6USzULX/XHlGlehWgQ/oTjxAn4RDCv7ApdXNgMYEqU6S4MXIarh7e2fuO0NPWI1eqxxR
	 dtzy3yvdmZlHgzbsO1IDdvzhbQhqTUe1MksNv7oe+2rw8g9pQlolS0bb5E+5f6KpN2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Moskcn3DPxQKZDRR2dhyP/c9zKNsnFz91fxml4yvYPM=;
	b=VTkkTtMmLek1fs+gW8x2ECB7/bmLfHu6IGxVka9DX92vpKneCbEQAoeNWzu/T09qapyT
	 R9edV3TZcCSVuc6p8PlOpx6FGMQlhyT1saLNwDcRd0eSnGkQKNAsrH1rF4h3ouNNKa4Lt
	 rwUCUHHGVSLvTMqpgXaSOGIB+PkZOWQFK0v6j3yJf5/YYaImf80fFjBGp1zThzktOE+iD
	 Xo9IU6vrKAtW1yxHix5Q0PzlPcNjnuX2u0gJnMpHw1kSRvid9PR7vIwmZlFZ7J8JQx+fK
	 1R/XkO0x27Qzl3Qzms1aVT0xL5bihsphxutOXrBZagmGGtLpNv+nEv8wj7seD3qx2zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nc1BHt0B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF840606A31C;
	Wed, 18 Nov 2026 20:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nc1BHt0B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EA671F000C4;
	Wed, 18 Nov 2026 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032182;
	bh=Moskcn3DPxQKZDRR2dhyP/c9zKNsnFz91fxml4yvYPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nc1BHt0Bn6PTUP1q9YamXMSMN/NguIRuaae92RVjLbJHbq0f5QUaoYkXIk87PvBds
	 WNycucb1mFL+328Z2IdrUhNcQYfPp5S40umv7nx/9OMEXHvQNj9/EtrXy4++fC91Pi
	 6cl48zcuDtq3Y8hydg3mgGV0Nk9cttsSYr8Nmz2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1284/1756] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
Date: Wed, 18 Nov 2026 15:56:51 +0100
Message-ID: <20261118150100.678123780@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 16dbb1d350425..9f9e6829a889c 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1326,7 +1326,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
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



