Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD7936D4E1;
	Wed, 30 Sep 2026 18:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792122; cv=none; b=CPX9CohBPkKDTKgoKrowkWWj1CVeo7+27IhEAhkGQveyWskSiYPLAKwaRU0sgQNN4nQA85BvcIYeVntU/o+B+ZgWJ3eygMguWlWUDJ74K+Z2qhJtToY/DU8aoyfCLSy1iW6acBWk9GRlO5CdcpgrV9fln6kAnnTwmDg4Sfy426I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792122; c=relaxed/simple;
	bh=T866hrGGU1GyPGZiEbc1yWxmeaFDwD+BzD+U3Tt0SIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJnUbjKOksAS5aLwEe08NXGrvcoEf1HbYkWscXk9d5NMSSFvEcqfm3xneo0VNxUw3ET1KjfN4ZfeBaGFyp0gd1xlq+Nbkv+T/ERf4+6OxqEn8Kndg6Qq5nUSparr6KM+FLgPVPc6589lo52U6G19gz3ZAV5T2iIN977Ty8QM1X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgfJoD7b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgfJoD7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77ABE1F000FF;
	Wed, 30 Sep 2026 18:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792121;
	bh=QEp6wcyrFRIVV8hqQs2mbKc3GdPkJN+0LTR8EN5epsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgfJoD7bE5y3Q8rAA+sY7AOMPbGkMELDJ/Zvdzze9L7YeS3F9Ya8GMJZ0+U6WjLjq
	 abbttv0CuX742YsUb/d/i7y+bqf4iSYmppSFTOjn8Twhx+jbgQvZvDBhAalJC+ScDU
	 tzWQEDSGKaIx+aiWiy1c2CD2ljQsKMAk1BuUMfbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 542/752] i2c: imx: release DMA channels on probe error
Date: Wed, 30 Sep 2026 17:26:52 +0200
Message-ID: <20260930152409.975588018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1581,6 +1581,8 @@ static int i2c_imx_probe(struct platform
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
 	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);


