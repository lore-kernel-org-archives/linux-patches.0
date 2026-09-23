Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E78534C134;
	Wed, 23 Sep 2026 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172856; cv=none; b=YZB+sq4eHARvPl7YdmSMWGckjuPFfE1u485rD+M4ECDWvXoxvlt/aesxI5g7y1wJ+NjKUa/QRS5dxqmWm5GGiVuVvV71fcrAh0XghfAbHxU7czhhjEvdFkdTbMJaXqfnlrLLaHHLfHKX1WLyQKCeSZ39sLx8t/9C6K9qygcuafk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172856; c=relaxed/simple;
	bh=cT8NKVmLq/sM63pAX6V+UQSiWHP6JT3YI4kHPp2/Tas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOt7l9sBdlSyAZSmbs75V9rCT+CkujcKSFHXCwU9uZ6qEUs9tUT7Tsqk1CI/A6oyrk6eSyodGHMOc25gOX3doIwjos6K6yHELF071Tk9dglUqU72nxnmnK8R6IXCjT65fkIGzdvWfLWsbqOjgKLNbLM3mL7/ZgHs+RhFuKQOldo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtLOCgTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtLOCgTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4DE1F000FF;
	Wed, 23 Sep 2026 14:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172855;
	bh=KnbTRNrPGOxXxMUC6aOgwv1s+DbezQ+HNHtpwMJ5+Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VtLOCgTuu20RsL5/IjffSbktdhMzVnmoIOjTqF2DbtmWIaY82I1Q0uJoLdcey7CP9
	 +2q7A52YBqgNffRkEztuq486A5uyaOfCwqYasd9EhVir4C46Vhuq299DHOO54qLaf9
	 p/BDkSNuiaTIrYla627BzxhhV7Vtqs3S2RmviYUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.spacemit.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 045/438] dmaengine: mmp_pdma: fix wrong extended DRCMR base for SpacemiT K3
Date: Wed, 23 Sep 2026 16:01:06 +0200
Message-ID: <20260923140645.952909105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.spacemit.com>

[ Upstream commit d1fc569fcbc7be6de06b034cf954a95e30ca1fb2 ]

The extended DRCMR window on SpacemiT K3 starts at 0x1100. Commit
6587b8661a0b ("dmaengine: mmp_pdma: add SpacemiT K3 support") incorrectly
set it to 0x1000, causing DRCMR accesses for request IDs >= 64 to target
offsets 0x100 too low.

The 0x1100 base has been verified on K3 silicon using real SPI and QSPI
DMA transactions. The K3 DMA documentation [1] was updated on June 24,
2026, to reflect the corrected register addresses.

Drop the bogus DRCMR_EXT_BASE_K3 macro and reuse
DRCMR_EXT_BASE_DEFAULT for the K3 ops.

Fixes: 6587b8661a0b ("dmaengine: mmp_pdma: add SpacemiT K3 support")
Link: https://www.spacemit.com/community/document/info?nodepath=hardware/key_stone/k3/k3_docs/k3_usermanual/16_peripherals/dma.md&lang=en [1]
Signed-off-by: Troy Mitchell <troy.mitchell@linux.spacemit.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260727-k3-pdma-fix-drcmr-base-v2-1-afba55cba1f3@linux.spacemit.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mmp_pdma.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index 386e85cd4882a..78e3e07e681df 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -52,7 +52,6 @@
 #define DCSR_EORINTR	BIT(9)	/* The end of Receive */
 
 #define DRCMR_BASE		0x0100
-#define DRCMR_EXT_BASE_K3	0x1000
 #define DRCMR_EXT_BASE_DEFAULT	0x1100
 #define DRCMR_REQ_LIMIT		64
 #define DRCMR_MAPVLD	BIT(7)	/* Map Valid (read / write) */
@@ -1219,7 +1218,7 @@ static const struct mmp_pdma_ops spacemit_k3_pdma_ops = {
 	.get_desc_dst_addr = get_desc_dst_addr_64,
 	.run_bits = (DCSR_RUN | DCSR_LPAEEN | DCSR_EORIRQEN | DCSR_EORSTOPEN),
 	.dma_width = 64,
-	.drcmr_ext_base = DRCMR_EXT_BASE_K3,
+	.drcmr_ext_base = DRCMR_EXT_BASE_DEFAULT,
 };
 
 static const struct of_device_id mmp_pdma_dt_ids[] = {
-- 
2.53.0



