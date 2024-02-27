Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C107413B2B3;
	Tue, 27 Feb 2024 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041460; cv=none; b=KuAStLyinx8nnEIQ6Zp6OXZ3OVoDtU1Bgw+iDwho/gild3VrL+H2mHxww05BInHzpB+kfjbFN9jCC4gwlXr26tri5sRDp/kL6tKG08bPR4vauQcy9clbjgco+50oMs6ZqOL9/0zvjYbR3cwMb4AWaSr21hANf44P3Mhq8R2LIh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041460; c=relaxed/simple;
	bh=XGkr42bSIUn+NCBKpyAr/FmvItt1FJfYYNzR+1NF9j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H2dsRbYBzYXv0erxSYD/XSI/+i32i7xk+bMJP5IrLMP+r3o1IdlxckbMSq3VPTKOo/nqSUrCzIx9CtTnFnK18FvqM2nkhz8hsp8zMOAU8XWbvGnfZfPJrCmTiSDohzyvU+Zs/BQpX/cJsbpCeVVxqUtzxTWtvD0IsBHYsnZYHhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSRzqv3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSRzqv3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42BDBC433F1;
	Tue, 27 Feb 2024 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041460;
	bh=XGkr42bSIUn+NCBKpyAr/FmvItt1FJfYYNzR+1NF9j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSRzqv3vcOOyTbytJL86d8TRBMG8ZvdMZHk7h5E/kOC/5m84E37kbWcY0/m+ZErY2
	 o8ekIxNWxyOnRd+9TvoQk7B5Dg1AdmTHFMMEPFBkpK3fAYQd/MMBK4t7WcBRCM0vCj
	 ZPmT+TELMy6MI9DVKk98HEF+/bPVImEwWuR6ymEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/52] dmaengine: shdma: increase size of dev_id
Date: Tue, 27 Feb 2024 14:26:00 +0100
Message-ID: <20240227131548.969886225@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131548.514622258@linuxfoundation.org>
References: <20240227131548.514622258@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 404290240827c3bb5c4e195174a8854eef2f89ac ]

We seem to have hit warnings of 'output may be truncated' which is fixed
by increasing the size of 'dev_id'

drivers/dma/sh/shdmac.c: In function ‘sh_dmae_probe’:
drivers/dma/sh/shdmac.c:541:34: error: ‘%d’ directive output may be truncated writing between 1 and 10 bytes into a region of size 9 [-Werror=format-truncation=]
  541 |                          "sh-dmae%d.%d", pdev->id, id);
      |                                  ^~
In function ‘sh_dmae_chan_probe’,
    inlined from ‘sh_dmae_probe’ at drivers/dma/sh/shdmac.c:845:9:
drivers/dma/sh/shdmac.c:541:26: note: directive argument in the range [0, 2147483647]
  541 |                          "sh-dmae%d.%d", pdev->id, id);
      |                          ^~~~~~~~~~~~~~
drivers/dma/sh/shdmac.c:541:26: note: directive argument in the range [0, 19]
drivers/dma/sh/shdmac.c:540:17: note: ‘snprintf’ output between 11 and 21 bytes into a destination of size 16
  540 |                 snprintf(sh_chan->dev_id, sizeof(sh_chan->dev_id),
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  541 |                          "sh-dmae%d.%d", pdev->id, id);
      |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sh/shdma.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sh/shdma.h b/drivers/dma/sh/shdma.h
index 2c0a969adc9fb..35987a35a8480 100644
--- a/drivers/dma/sh/shdma.h
+++ b/drivers/dma/sh/shdma.h
@@ -29,7 +29,7 @@ struct sh_dmae_chan {
 	const struct sh_dmae_slave_config *config; /* Slave DMA configuration */
 	int xmit_shift;			/* log_2(bytes_per_xfer) */
 	void __iomem *base;
-	char dev_id[16];		/* unique name per DMAC of channel */
+	char dev_id[32];		/* unique name per DMAC of channel */
 	int pm_error;
 	dma_addr_t slave_addr;
 };
-- 
2.43.0



