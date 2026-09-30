Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92563314A86;
	Wed, 30 Sep 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788785; cv=none; b=j1drRv+Ank+2k3aNPo8vsQ13/g6W/Bkrqs+9aUqEDkR0SS58zpDqljBXU9Dw9hE45kHjFlg6UGGoaCZ/WVDaW1/tsGmDO5AaJW7JP/Sz/+nhS4k6rpIkKnRvaaNRvNrXMWl3O9wGMYwm2v2FjuYyI+nE1HSk+YcW1QCCpmNp8xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788785; c=relaxed/simple;
	bh=McAAk2MdHUaCPz+aXE+4DpZv13lkHLWFK/XpE2gRcME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUkE2rCw/k/a6Z7AkGPjijUF+6KdQe360x1VrgW+Yo4rJpYWHqTl8QRHUiDTOfDr0Ug4wQvmj+60HN/IRZSXgNtjSW3cSYcIMsArvKKdSFqjGl+hZD0TfZYdFEMH/1q3RjsA0aJ8KJEPFUboOXU8dUudmWJCadF2K5VLtxQ+2hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1uQqlLD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1uQqlLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9F01F000FF;
	Wed, 30 Sep 2026 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788784;
	bh=gUDptQLtsGpeDlHSt34tALng4YkgERcpWCoK7T9bjdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y1uQqlLDR2BzBfK9cocNUkx1sP2KZaJ+FGQpjrIjHg82bggjbI9kSKNlTfrZf2IAI
	 MU64eVS439K9/F4OgF1yJe1viXW0z33W4vX9OLRYYBVhUkK2pvnjnsyriC27VrDF14
	 cUGipzlxnGf00Ir03O8aN1VyD67GvEPjPHGUtJ9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 210/877] i2c: imx: release DMA channels on probe error
Date: Wed, 30 Sep 2026 17:18:41 +0200
Message-ID: <20260930152419.259205414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengzhuo Wei <me@cherr.cc>

commit e9f03b9625e2eeaca357b065c92d5b14064a1583 upstream.

i2c_imx_dma_request() acquires exclusive tx/rx DMA channels and is
optional: on errors other than -EPROBE_DEFER the driver falls back to
PIO mode and probe continues. If i2c_add_numbered_adapter() then fails,
probe returns through clk_notifier_unregister without releasing the
channels, because the remove callback is not invoked after a failed
probe.

Release the channels on the probe error path, mirroring
i2c_imx_remove().

Fixes: ce1a78840ff7 ("i2c: imx: add DMA support for freescale i2c driver")
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Cc: <stable@vger.kernel.org> # v3.19+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260827-i2c-dma-channel-leak-v1-2-271d4adc03a0@cherr.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1557,6 +1557,8 @@ static int i2c_imx_probe(struct platform
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
 	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);


