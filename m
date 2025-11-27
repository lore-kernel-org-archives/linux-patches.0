Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54801333743;
	Thu, 27 Nov 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255494; cv=none; b=EiKmw1ycAodj521xfVaYIAIFy5YURQ0MDQ2bjZFuPEMG9CN8Z5pNuTmRF8p1J0usSq0OwW2aRJ35Dkk6Cf6/LN5jt+eSMtgfZ3DNhqPZf9zqEpGAMEcmQMNMlCMIDNxPuONVBi7A05Q7uaRq5o2zOvEa/snYmwJfNtWs0bP/c24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255494; c=relaxed/simple;
	bh=mpRPUnbGVv/1cYoHO7YiVJMN4b+UL+SfHZE24tcYyGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adE7NMvQNembsImrTRmV07Yhl1kprAGXckp3MMte7rIBGk+MrvmDXUKSIfjwP0eRnPLi30A5yRcU1Mea45XsoU/Y1LdJjvQQTUD18LgzwTDi56Ln3m+kWgynfb7e2YN0Azo88YuW6n7gbBhaTcT4fCemUE4GvXkPcTdJPRwmJHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtYs9IuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtYs9IuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0165C4CEF8;
	Thu, 27 Nov 2025 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255494;
	bh=mpRPUnbGVv/1cYoHO7YiVJMN4b+UL+SfHZE24tcYyGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtYs9IuYbh2C/93rhxGjc3u/nzW4fHHEWg/Z7znfLtzOAt76hRRqZV7fLdt+VZ+l4
	 AZLUjVY81su17FnvLm/M9vUZ8dTPpCK6T8FdRopwkDafgy0Owey1DUUx99FJwjrkLk
	 /F/zsdhgeMcVJiovkGG+adE6Slv3q1qhtwjl9wnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.17 013/175] mtd: rawnand: cadence: fix DMA device NULL pointer dereference
Date: Thu, 27 Nov 2025 15:44:26 +0100
Message-ID: <20251127144043.441819878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>

commit 5c56bf214af85ca042bf97f8584aab2151035840 upstream.

The DMA device pointer `dma_dev` was being dereferenced before ensuring
that `cdns_ctrl->dmac` is properly initialized.

Move the assignment of `dma_dev` after successfully acquiring the DMA
channel to ensure the pointer is valid before use.

Fixes: d76d22b5096c ("mtd: rawnand: cadence: use dma_map_resource for sdma address")
Cc: stable@vger.kernel.org
Signed-off-by: Niravkumar L Rabara <niravkumarlaxmidas.rabara@altera.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2871,7 +2871,7 @@ cadence_nand_irq_cleanup(int irqnum, str
 static int cadence_nand_init(struct cdns_nand_ctrl *cdns_ctrl)
 {
 	dma_cap_mask_t mask;
-	struct dma_device *dma_dev = cdns_ctrl->dmac->device;
+	struct dma_device *dma_dev;
 	int ret;
 
 	cdns_ctrl->cdma_desc = dma_alloc_coherent(cdns_ctrl->dev,
@@ -2915,6 +2915,7 @@ static int cadence_nand_init(struct cdns
 		}
 	}
 
+	dma_dev = cdns_ctrl->dmac->device;
 	cdns_ctrl->io.iova_dma = dma_map_resource(dma_dev->dev, cdns_ctrl->io.dma,
 						  cdns_ctrl->io.size,
 						  DMA_BIDIRECTIONAL, 0);


