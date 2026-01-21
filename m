Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E8D3806BB;
	Wed, 21 Jan 2026 18:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020509; cv=none; b=WU5kqR333BmHSGATHxZ2U96kyuYNezvIxs1/2GYScvGZ8LcfCDnS+toYTsqstUSFL8rYYUZ3d66XplaZOL55cI7Ii6wQyLa2ZD6l/hlSc768vkcaDUivZgyxhpvspRJ4K4titMZnfAv3wGulIXpN5TH216vS3mG0SWqiIDZvvbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020509; c=relaxed/simple;
	bh=Q3yz+6fA5VMBV8R65dvFUGWmR94KAnZ78PvGHbmhPMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/jVtluz63DpbvaXjz1KsxFreglUknIa9UgZhzI9R7bCU/XuXPE4zHk1fKraJNwjw8lt4lllzCSSJrN3zkfbDhC4zEt0NUKvfWWS6jVXOn0iTNNuR1sFYvIzIFx0Yz3sRQHXCjfUK6oUzhGjRj48/oVC+VoHlvg6OeJJ/+qHw2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z0wGpWjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z0wGpWjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0934DC19424;
	Wed, 21 Jan 2026 18:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020508;
	bh=Q3yz+6fA5VMBV8R65dvFUGWmR94KAnZ78PvGHbmhPMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z0wGpWjPMTHmNiy8PL7zRu134PL4NulZNjLF4GpVvax9uTSHVPCWzMmKwQo8tq3bX
	 MlsO/ownMRukW3nf8flUTdL57J58il/RwTd4Wx4ihexqEUOCeTHUF1IIntWjk6F/S7
	 2znar5jSqT5uU2DaD/LcvQ8Vs0IDe32J3G/p+xg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Zhen Ni <zhen.ni@easystack.cn>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 172/198] dmaengine: fsl-edma: Fix clk leak on alloc_chan_resources failure
Date: Wed, 21 Jan 2026 19:16:40 +0100
Message-ID: <20260121181424.737559982@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

commit b18cd8b210417f90537d914ffb96e390c85a7379 upstream.

When fsl_edma_alloc_chan_resources() fails after clk_prepare_enable(),
the error paths only free IRQs and destroy the TCD pool, but forget to
call clk_disable_unprepare(). This causes the channel clock to remain
enabled, leaking power and resources.

Fix it by disabling the channel clock in the error unwind path.

Fixes: d8d4355861d8 ("dmaengine: fsl-edma: add i.MX8ULP edma support")
Cc: stable@vger.kernel.org
Suggested-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251014090522.827726-1-zhen.ni@easystack.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/fsl-edma-common.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dma/fsl-edma-common.c
+++ b/drivers/dma/fsl-edma-common.c
@@ -852,6 +852,7 @@ err_errirq:
 		free_irq(fsl_chan->txirq, fsl_chan);
 err_txirq:
 	dma_pool_destroy(fsl_chan->tcd_pool);
+	clk_disable_unprepare(fsl_chan->clk);
 
 	return ret;
 }


