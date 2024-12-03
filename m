Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644781F754A;
	Tue,  3 Dec 2024 15:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239306; cv=none; b=jZFAGCpIiZ9nryBsCqu6cp/8toqXxE0ZBO26x+9Vi0zyiRromKpQeG6FXZSsFERmK9LkEPEfIaxq87yBqo73OAJHelrd1FUZHChwfhBIiBwOKg+Km7pbv7x4o3RJR0cQ3i28rrbvhpNXrxo0c5Mmy8WkezjXYigbXoFOCL+ETxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239306; c=relaxed/simple;
	bh=VjuF5uFSwWcWfenEk/6G+rcsfMi02/pvQs5o8gCdd6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDO57VvwUAg2mY8iOLO6ZIS8Mjfdk7sB5W25b2PUJ6GmCKQiiwqHlcYrlFBo8JPHSKmrplY92WtYRv1I9qBG5feVz1i6NjDU7Wkl5gsTRr6+ZW8Y4H64Is8YzIL9nhBFVZXP+ng6YjC+0gnzpSlJWD3xHaDbdG5p+1+vbTWvQw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tJUfWfeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tJUfWfeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3EBC4CED8;
	Tue,  3 Dec 2024 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239305;
	bh=VjuF5uFSwWcWfenEk/6G+rcsfMi02/pvQs5o8gCdd6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJUfWfeAgL9WmHjhKr2zqNA7g43p5cjWM8iFNJ8KmAQcK3jOAkY1bkoZ/2Z8/w6m/
	 +xKCXFuTljpx+MzJoFBUTlI7/T45uooqHz9NuGW79noarnE2mhfCjVmqeQ8TPuf4ka
	 Pge6B5/IfF+8XEeNvlJDAb/MSQP2L3dAjbder6+8=
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
Subject: [PATCH 6.11 568/817] tg3: Set coherent DMA mask bits to 31 for BCM57766 chipsets
Date: Tue,  3 Dec 2024 15:42:20 +0100
Message-ID: <20241203144018.081992545@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 0ec5f01551f98..8d22830862067 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17805,6 +17805,9 @@ static int tg3_init_one(struct pci_dev *pdev,
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



