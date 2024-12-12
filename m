Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8C91F2381;
	Thu, 12 Dec 2024 16:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022568; cv=none; b=BsKogRgkswX+4mcJz1cvJZDWrYo/hqitpT4lFDoOUphPRU/kPTOmGRpSDTwWZglMiVecLKa91B9VRexRr2WWtWTNPnzDGXbL8Cf1cWEfl87kOtBggSdlpkFTrmj4bNiD8AZQ/jLK2P/D8xoIsySmKjxv396LVYEw9wBqqrBERXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022568; c=relaxed/simple;
	bh=BLhJ3L4HU5Uha8CT7F389E0s4p4nxzLNrPfStjYYYBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IiWjd5J2QfCe3fWH2uEM+rCfLnLWDtoryWn07s73Hp/2kMlAuN2ZpNy5uGHOKsAOzh+howhS74wwek11EiW3Ti6J98TOn5dqTBaEN+oZumqzkLJqY+XIdMqPMirWk9YyjQNosL2NrjpJyHemK3qgoBCSj3dnJCZBGQAFgqdvlXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuTjOS3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuTjOS3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EE3C4CED3;
	Thu, 12 Dec 2024 16:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022567;
	bh=BLhJ3L4HU5Uha8CT7F389E0s4p4nxzLNrPfStjYYYBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuTjOS3G3B6HpYMfDm9UBC/TzkFebxvvR/O/3BHojQq+6ces/kEjAJnGLwoLcgg6F
	 FWgmBFAQA5JtVwFewjvw8x40ejjFNtak6iE7sO5UIH6uihlt9v7h9OnTCWkFtpXGpC
	 1A/XTvbWqjO3rShMfws51Yn/9ILvLAEtOOdD3mTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salam Noureddine <noureddine@arista.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/565] tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets
Date: Thu, 12 Dec 2024 15:57:51 +0100
Message-ID: <20241212144322.369405931@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

[ Upstream commit 614f4d166eeeb9bd709b0ad29552f691c0f45776 ]

The hardware on Broadcom 1G chipsets have a known limitation
where they cannot handle DMA addresses that cross over 4GB.
When such an address is encountered, the hardware sets the
address overflow error bit in the DMA status register and
triggers a reset.

However, BCM57766 hardware is setting the overflow bit and
triggering a reset in some cases when there is no actual
underlying address overflow. The hardware team analyzed the
issue and concluded that it is happening when the status
block update has an address with higher (b16 to b31) bits
as 0xffff following a previous update that had lowest bits
as 0xffff.

To work around this bug in the BCM57766 hardware, set the
coherent dma mask from the current 64b to 31b. This will
ensure that upper bits of the status block DMA address are
always at most 0x7fff, thus avoiding the improper overflow
check described above. This work around is intended for only
status block and ring memories and has no effect on TX and
RX buffers as they do not require coherent memory.

Fixes: 72f2afb8a685 ("[TG3]: Add DMA address workaround")
Reported-by: Salam Noureddine <noureddine@arista.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://patch.msgid.link/20241119055741.147144-1-pavan.chebbi@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 757138c33b753..4fb1d2749c063 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17739,6 +17739,9 @@ static int tg3_init_one(struct pci_dev *pdev,
 	} else
 		persist_dma_mask = dma_mask = DMA_BIT_MASK(64);
 
+	if (tg3_asic_rev(tp) == ASIC_REV_57766)
+		persist_dma_mask = DMA_BIT_MASK(31);
+
 	/* Configure DMA attributes. */
 	if (dma_mask > DMA_BIT_MASK(32)) {
 		err = dma_set_mask(&pdev->dev, dma_mask);
-- 
2.43.0



