Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EAC53B34B;
	Wed, 23 Sep 2026 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174931; cv=none; b=aksj1eOncdSxxFoKoZL6eqr8ZrhobAgKKSx+8CxKRiP3jAWYoRA6FQBkLb6lbAENzAHUTXKefSFsIxcpZqdUWJpllDZQVx5NwInVSLu0KJVY3486Xk/SSnygP+d9fJ36WpV0ZvguKSxKxkf9Wn5ktaL1i9HlJmUWH3CujONvqZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174931; c=relaxed/simple;
	bh=6hnhpmTLuokuf29LD8aW1gfqTCh1W+97/gYx5wQ8nhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8+KkAkCy+t0t3LRQHGUABgIgfPGnTsv1/gbA0sF0WPTUut64AIcPIuI2xdga8ucE/2JXnThZUmVS0lwYf/mIOEX0kMgrPDCTHaPOrkSEh1onLEaEtHuxdaG1P/7Thzdiwv4a2MriPQLtj1hjSEMs3M3V6GpEy5JuMjL/Ug1qT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPODK8cn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPODK8cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3181F000FF;
	Wed, 23 Sep 2026 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174929;
	bh=WdnYr3jZfXGbQgFmTNklGFbIxOWwpJxb+mJgeWipp6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mPODK8cnt7t+A4PL2QXG3tK6j09OOvUN4KU/tkqV61d4kcdhB4WfizWquuqpqhGvP
	 NT+ZM1WxvfbNZVM9GAsUAemzP6T08WUIo9XqqIjfL6vUJjvj1BeQgj58kNdUkLT6yp
	 48GQ6SwhdbhJVqCKGYrVdvuSXFDiIvCZWkreg9f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 269/398] i2c: imx: release DMA channels on probe error
Date: Wed, 23 Sep 2026 16:05:43 +0200
Message-ID: <20260923140650.388133343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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


