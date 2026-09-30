Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6044EA39A;
	Wed, 30 Sep 2026 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783555; cv=none; b=s2/Bd7L/pCmjTsQw857KGUkgdIprjsGgI01C7xmUs6HmMWnoXHX9+QnDwlIWRT5bm4IXZFRAUwSFeaE3SjyNRSwdOK84wPLu6aMkZM7A1Zue3RPy9lzrzOkWMqTLYR7b5afNZ1IDcOfAENx7hsr43CEGsYjejZgdDdzPCrZ2R+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783555; c=relaxed/simple;
	bh=ObZEN9ztldfYrbhcNn/HFljK7gH+fyvCmQ9ipzUK7/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aUVfLaTeBiQoRsdJdF3WeJzSUf2ADFvu8vav8qRTP1pagjriGMbA9V3ViVf7OOfyz1D4O/kWHba1FqIIkB/Q+nrB7J0UTo6ir3gg5HmvEpAA6hXpJe3uXPhMqHvTHeHe8saA/fPR5VYPYvsB0RyH6y8WlvVVhr0TRG0rYRMaiek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3uz4dRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3uz4dRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D001F000FF;
	Wed, 30 Sep 2026 15:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783551;
	bh=1bZp5wo7iyHnUjF9d7eTX/iKFnpIsYx18LL0MJfxOgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L3uz4dRlusyW6rbX5szPRJdMJvqKb2Tr/vMSCdyH58PAcllKUGbGvxIcieVDXIJ87
	 yOH9/51C3VWCiWo8x9nsdFbbxsV/ZbeJBfzKsDmCAPLJJWTlqtLzQNLpJsgolvI15j
	 89C1W2cinnnrC8q/dV/qUQt6EVWi6M8255JjAfqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 438/595] i2c: imx: release DMA channels on probe error
Date: Wed, 30 Sep 2026 17:25:31 +0200
Message-ID: <20260930152357.101638909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1313,6 +1313,8 @@ static int i2c_imx_probe(struct platform
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
 	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);


