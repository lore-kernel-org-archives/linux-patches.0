Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CACA13DB92;
	Tue, 27 Feb 2024 13:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041616; cv=none; b=aNts3seDrtOPVqYsv3y1mMiG2ZoivMBdzE001Ykmmq8BM23yQO/ggGz9IHX3ePZhUOnZrJmc6WglZoA2sfZD99lmK7W8oQt68NQvGU9oJYP3DAtl2SpRzbPbifdooaFia2Gww4/zk3aqqBzG34N8/j3FdCL0Zlnc9LKPFwuwb2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041616; c=relaxed/simple;
	bh=dZ6pxFZJXUah6P0Bumo9geKZklNkU2fB3fh769B5hUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Lf5zX6On0Hc5cI3nFuMbyjKF3rYGFuh6qY0ujj4RCCgmlDNvv3eIWqtl6RecHSACvEFhNkQqGrBK+vB1tYg3y2jgAhjLTso9KA4kJw62BFv14GgqUbJS/EKIZopA4Y36w3gpTUu1qVsdBlCo+q4OPfT50MYXjLcNYeEF6MjNMVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fm4D7Ry0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fm4D7Ry0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC60C433C7;
	Tue, 27 Feb 2024 13:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041616;
	bh=dZ6pxFZJXUah6P0Bumo9geKZklNkU2fB3fh769B5hUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fm4D7Ry0wW52mu7DZpRxc6/ZehNBKmEsy4lLK86ieJRZWYOmcExwQEI4tsEqzbnqv
	 /u0+Qc7EPfmF2za4aKlfbAJI2vMNXzC9TwyNLGSrgIvBhbH///HAZxQgzgWZDgtBGZ
	 1qZgoXFrBbmOBk9lDNvKaSS+IeE+68gHzpv6XXkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/299] dmaengine: shdma: increase size of dev_id
Date: Tue, 27 Feb 2024 14:22:02 +0100
Message-ID: <20240227131626.202326168@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9c121a4b33ad8..f97d80343aea4 100644
--- a/drivers/dma/sh/shdma.h
+++ b/drivers/dma/sh/shdma.h
@@ -25,7 +25,7 @@ struct sh_dmae_chan {
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



