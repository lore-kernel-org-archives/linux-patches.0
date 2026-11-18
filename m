Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049952;
	b=HDmR7TAZsuAm8LhHv3195IzHuVqlg89Y+TQ7IUP7OiX/J6WVRUV8RhnkMKKa+NvvQjTi
	 KyZllwwKH7sihkAgAkixE9KwYVZThALvTd8GFgajvxwfjErB7pcADDg17oXbCYB5mN5dC
	 3rDsimY60F90uOUkJK8RGMlmjhYS/P4jz97EsH5BXN15+LQUpZOrjYEYLKZv+a9pxardV
	 okIDmqFEgUk6tSLZ9TYi7zevypcxED8qYJkrhANiNvWlvzsjMHYKPggqqE4MxLaS/ncCs
	 Gom5flzgE4sGU8ajqdHpnOrZ/7gyWxSpylszgkp0Wl4HnX+9i6/LPYFQb+V/t9xG79A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wGe34Ii1aHtbKBVGdeyR/VmiSzTdQhFnGuUD7H88qR0=;
	b=GWOEcSPs9KrKMKQqmH/KKaaOqF69SVrcFDZgVDrMxYMYr8ER92O8UDKISDQQAyzZkQhW
	 avE833OUI9w99XLZCnIc9DzMXSJweoHzjyhNJCLPYJcxSWAkTNd4HtBlcxlHfJ6IPIK6d
	 8nk1KWiXxc2oXct4+e8/U27XfLsfUkb3nKAoCORo7GKmWv+9A0JBpvAwSULCZd38+8h8B
	 1M6GwqaImAy4T4sbbRQtah4+NrMqmojZOEZnbslEEyvCVOVeJtCPNcqlqHc31jFa6JWRn
	 ZS9jkBIR7Yvj4ITJXuGCAEX+sXTiyV8rnD+wu/X6tOyHoT/zCYFoYRGq/ci611b5BGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkwRQC8J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534BE606A31C;
	Thu, 19 Nov 2026 00:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UkwRQC8J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A928D1F000C4;
	Thu, 19 Nov 2026 00:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049952;
	bh=wGe34Ii1aHtbKBVGdeyR/VmiSzTdQhFnGuUD7H88qR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkwRQC8JAJUkO/IULRha2VNuwuX+sOqBWamTF0LtpXYbn6AL6N8qafA965h38YSw4
	 uceJGC4/Audce6Qr3jBIMIX0Bna+Q7F0XfhwABOfQlYt+YoR3x2InHAbsMetGDy/St
	 RqluA60wHQsasXlu/5/4Pc/f9jt1IJxf2aYkxIao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2533/2857] RDMA/irdma: Fix FRWR IRDMAQPSQ_PBLADDR field population
Date: Wed, 18 Nov 2026 15:59:27 +0100
Message-ID: <20261118150332.738477676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9525144a4c4e5..df0aaa44e315f 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -1329,7 +1329,7 @@ int irdma_sc_mr_fast_register(struct irdma_sc_qp *qp,
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



