Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881E21C6AB;
	Mon,  4 Mar 2024 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589290; cv=none; b=LpbAUZ5Zq4qEf5zOuehsllODYLPcxsXSv2k9dh8S1pMkle8mCZq3arj0MErnZYowVuQgTzhittlXPMpDOfRs5WzgF4cKfhSwdvDdtbbnIlJalpGBSkToacPqQYxp/pf160+fzfkDQ0xvNpe7EUFJ1UuE344fvmL4/2GsO4wQ9zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589290; c=relaxed/simple;
	bh=CnjDx2YNly2UeAA4fJNVDcVLiBJczniXoBF/FZ/mqw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSgmUscAJ5rHN6SNgmB5h8I7A7dYT+vAzf+7y2Edpc2lMx957bwAjlKvzh1o45/2IGG8nIqT6moRnHdyfGOHWfGmQ15G9TVN6535jq/NI5eUC56e+5eI23bQeEBKsxllKv9XDIihrNZGDY5ZB3gZRHrwiSJrUVP/YQJ8MTIomLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tnFz+rgn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tnFz+rgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8BBC433F1;
	Mon,  4 Mar 2024 21:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589290;
	bh=CnjDx2YNly2UeAA4fJNVDcVLiBJczniXoBF/FZ/mqw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tnFz+rgn3nRkeV4OAS9YLFrvGqcyeDbqBjIz3fO5bgVRZB+23aESGR4vqpusxo/tP
	 g9UGpOCQN/aNXIGREzQqvTOBc4NzOUpUTIsj+/ryNBGJ3ZIuAw/+fz/86nD/38iyb/
	 kBQjVv3TLAH33UxGw9jR94iwPNE7qVmDMRjqBNTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Tadeusz Struk <tstruk@gigaio.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 53/84] dmaengine: ptdma: use consistent DMA masks
Date: Mon,  4 Mar 2024 21:24:26 +0000
Message-ID: <20240304211544.138430661@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Tadeusz Struk <tstruk@gigaio.com>

commit df2515a17914ecfc2a0594509deaf7fcb8d191ac upstream.

The PTDMA driver sets DMA masks in two different places for the same
device inconsistently. First call is in pt_pci_probe(), where it uses
48bit mask. The second call is in pt_dmaengine_register(), where it
uses a 64bit mask. Using 64bit dma mask causes IO_PAGE_FAULT errors
on DMA transfers between main memory and other devices.
Without the extra call it works fine. Additionally the second call
doesn't check the return value so it can silently fail.
Remove the superfluous dma_set_mask() call and only use 48bit mask.

Cc: stable@vger.kernel.org
Fixes: b0b4a6b10577 ("dmaengine: ptdma: register PTDMA controller as a DMA resource")
Reviewed-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Tadeusz Struk <tstruk@gigaio.com>
Link: https://lore.kernel.org/r/20240222163053.13842-1-tstruk@gigaio.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/ptdma/ptdma-dmaengine.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/dma/ptdma/ptdma-dmaengine.c
+++ b/drivers/dma/ptdma/ptdma-dmaengine.c
@@ -361,8 +361,6 @@ int pt_dmaengine_register(struct pt_devi
 	chan->vc.desc_free = pt_do_cleanup;
 	vchan_init(&chan->vc, dma_dev);
 
-	dma_set_mask_and_coherent(pt->dev, DMA_BIT_MASK(64));
-
 	ret = dma_async_device_register(dma_dev);
 	if (ret)
 		goto err_reg;


