Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD93F30D401;
	Wed, 30 Sep 2026 19:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796330; cv=none; b=SX9Uf0PhQ+9QWMhhm5ce0xLT+/2g+JWtPdW9vwIMHlb4sk5IEg6s+VkFDMLssQDh0NsyiZItyj/HTy6JkEpamceUbW4NxUqrt4XKUCjEEJ+vlDmBBDdgaGYstJr0sEy8ADePuRuRso/o21Dy+X6BX8PJBqsSZ2DDIctugqVsfK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796330; c=relaxed/simple;
	bh=mEqcCtjKUIHGK/eEM375oYvY9k26812AblPGtGwH19o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itdhSYVGN2Hdy1Ck5gjiFdDWbNFdMl7baIspIqDZ0TgHrKuQ3+5+RhOaMO6rCVyx3OWhSJhpQ7hoWxiD5C9HTgTzF+5rqihi+mX04vzUGEuPywaAdR1XUhnRxFJelKMX9CM+x222Moghq7A+CKs18MyRryDZt8fSNZhWAnFvMgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JliSHVQ2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JliSHVQ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061B21F000FF;
	Wed, 30 Sep 2026 19:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796329;
	bh=ncOyeSORF6qZQFxjkZqHgMWyvJnXORyH7xf4q9Az1dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JliSHVQ2mU3GVjC1cAxloJKMcTlFmt0htk1U71DfdXlG5fIWW6SCt+ZocVVOz5DWo
	 NiuBC9bKJrA/SEob0tLVHqdcN9Gay0eH81WvHjcIv+1ijPTjeFFHu2CtD8czS+S97I
	 AS38HA0/JbjuOHUsOfeW2a28lZyyaocNl/roid/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 0875/1193] i2c: imx: release DMA channels on probe error
Date: Wed, 30 Sep 2026 17:25:59 +0200
Message-ID: <20260930152453.679909288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1609,6 +1609,8 @@ static int i2c_imx_probe(struct platform
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
 	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);


