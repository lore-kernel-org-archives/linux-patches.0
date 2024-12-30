Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C47E15E8B;
	Mon, 30 Dec 2024 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574283; cv=none; b=J2FO/t9faU9tqpnWGy4LLGQGyyG0PzALkriKKkimKModkBHSYBxrfHShBUL96YswSJoTnxDN35nm5hndn/Q0LQYRqzYWyD+MgC93B7ZGW+C4biBzofhTHAEf7yz9RifbGJZQXLwc+HZmGr18T7wx+Io+UyRJ6qGsYJYEwBOgY0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574283; c=relaxed/simple;
	bh=xbb10+Kd0C8KBA1WGY9LeCosuLE7PYb1LG8LELwkWq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IlBQwV/a8m8St8dG6gMdLKDVtlQWCcPys125x5+coZGpEpA7gW7Yku6h4NKbAe6H4gwufRMm/r3aA3qnAaHiM46XLNhrJP4FzTYRw8hmDUp6fGXmcnANRblSe6zwyvlIudz7fvvo2TsY183ZN4L5lLwmvPh1/6lGSU536GKgbeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ew71yk91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ew71yk91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C84C4CED0;
	Mon, 30 Dec 2024 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574283;
	bh=xbb10+Kd0C8KBA1WGY9LeCosuLE7PYb1LG8LELwkWq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ew71yk91muD2ujBeKTLiveIaCeB4bKRMd1CUty33EWMs/aA3ywNrQd2iH4UMd7olU
	 pwFmh4bM97qkh/tdGJCVPPIVOUSWqc8ws4HDma27LIlkrc5DEKXKoAu33RCkMdp192
	 FmnFHofdBaW62s5TN8PbSwNETh9fN4z0p+FiReJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 083/114] dmaengine: loongson2-apb: Change GENMASK to GENMASK_ULL
Date: Mon, 30 Dec 2024 16:43:20 +0100
Message-ID: <20241230154221.289928584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Binbin Zhou <zhoubinbin@loongson.cn>

[ Upstream commit 4b65d5322e1d8994acfdb9b867aa00bdb30d177b ]

Fix the following smatch static checker warning:

drivers/dma/loongson2-apb-dma.c:189 ls2x_dma_write_cmd()
warn: was expecting a 64 bit value instead of '~(((0)) + (((~((0))) - (((1)) << (0)) + 1) & (~((0)) >> ((8 * 4) - 1 - (4)))))'

The GENMASK macro used "unsigned long", which caused build issues when
using a 32-bit toolchain because it would try to access bits > 31. This
patch switches GENMASK to GENMASK_ULL, which uses "unsigned long long".

Fixes: 71e7d3cb6e55 ("dmaengine: ls2x-apb: New driver for the Loongson LS2X APB DMA controller")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/87cdc025-7246-4548-85ca-3d36fdc2be2d@stanley.mountain/
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Link: https://lore.kernel.org/r/20241028093413.1145820-1-zhoubinbin@loongson.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ls2x-apb-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ls2x-apb-dma.c b/drivers/dma/ls2x-apb-dma.c
index 9652e8666722..b4f18be62945 100644
--- a/drivers/dma/ls2x-apb-dma.c
+++ b/drivers/dma/ls2x-apb-dma.c
@@ -31,7 +31,7 @@
 #define LDMA_ASK_VALID		BIT(2)
 #define LDMA_START		BIT(3) /* DMA start operation */
 #define LDMA_STOP		BIT(4) /* DMA stop operation */
-#define LDMA_CONFIG_MASK	GENMASK(4, 0) /* DMA controller config bits mask */
+#define LDMA_CONFIG_MASK	GENMASK_ULL(4, 0) /* DMA controller config bits mask */
 
 /* Bitfields in ndesc_addr field of HW descriptor */
 #define LDMA_DESC_EN		BIT(0) /*1: The next descriptor is valid */
-- 
2.39.5



