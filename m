Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE085326C7;
	Wed, 23 Sep 2026 14:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173745; cv=none; b=VsGtG0KfcjH55FeUhcinzNwIiFfag7csA7QNS+ZbfJqfs5IX+Wg2HOi5kxzCvhIvCoMXe9vEvUKQzkJ60bfTzY6kC+RppYNaGxAW8RiQs+EGjVwrx8rMFwRs21T8euiH1nS1Swv+kpeWG2UlaDC69HL+x0Fgsx0rks+wZN26Yj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173745; c=relaxed/simple;
	bh=MNQY2ym90CetV5k0Ze0PPGbAVLRmC1ZMYJFY3fg7a/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+MtyiOi8Fhir6T1blcZRV3CLuZrn+fZX6jA6vtbATa8pLEKTrhHx/FxNBu4AjtbjMWq83vvfzg33Fab94LjTlFFDOC63ia2Fsa0Ira+tdHViebjqq63/AokcfKvwGmKTh33JIZ/K1W5Cf9sy+/tmGwad+Yt7BbN69EOyMOk3IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SU/P52PF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SU/P52PF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1AF1F000FF;
	Wed, 23 Sep 2026 14:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173743;
	bh=dsUrQrfc9Xus81ETLGzKvE0Y6fk/GiOzxm37bxOh6vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SU/P52PFrrGjeJ9opkwiyDIOTN6Q2m5Xwra3NrxaqjMKEL4L0Tj19VFewjvt834lZ
	 KKHSJHm5nAKyuspSDPWUK4Op9HaWFEAVdrALdlma7LA5NssZmAm1AT0xaxOK9nlXpU
	 1cOqjx6Z1GCJRXxuEg5XMayMNYRYrdGuDptIoNKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.2 328/438] i2c: imx: release DMA channels on probe error
Date: Wed, 23 Sep 2026 16:05:49 +0200
Message-ID: <20260923140653.308173651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1880,6 +1880,8 @@ static int i2c_imx_probe(struct platform
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
 	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);


