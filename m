Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78BE513546;
	Wed, 30 Sep 2026 16:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786063; cv=none; b=k7SqcKQhdOjHKKaLPN3M9viZivS0t3E3m67MLjtSg0MBeSK7IOwAw7L1eCzhGTkG8PZpS0K7o2ZNc7uiPF++6qRXhGzwSFQ9QRxy5eZOzKD358vherlr7iHqr6Ech7bp8Tzmemy68lx/K2l8X8ZEHwDnxXe7rf40G474YVayq9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786063; c=relaxed/simple;
	bh=X9Mxo77PpgPkcKUA8fdVuOMNCKnlqvMwiCx5dSl0ufk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDcFGsdkUcFK8QvjjXs39sbF2fTCPsoxT3QWXcB1GJBg5E1WTcl3wn5HWZTdjbwrUNOJWalqRzkdz2GaaKUmtO1xG6I8+AGQpCVlQYoMVZbr5Uu8PxhspD1Q/p2stR9Qa7dRV9qtUGkbzSNRrvYIupHq3HBQkXHbXzlQi0xzwzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4H1KfAK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4H1KfAK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFDD1F0089B;
	Wed, 30 Sep 2026 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786061;
	bh=wdxh0kY3lKqqLkSJsJXSnQGqv5AFSntjszADo5g7X/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4H1KfAKFOMsU8rmiGlsUZmhkdaJHMCJdK+8emrdLTekLa45nvasjoDAPncz3H0xv
	 mS1zvX1nnVr+T4v1R66eQo4jP3qcmh6Ju6EYyydvzphFLOpVAT9HVXwPaqqqrpx+KD
	 gjaooWuTacLySRI9RBAq4q/YYVhxythIvsXocSak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 727/982] i2c: imx: release DMA channels on probe error
Date: Wed, 30 Sep 2026 17:24:23 +0200
Message-ID: <20260930152432.368451837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1614,6 +1614,8 @@ static int i2c_imx_probe(struct platform
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	if (i2c_imx->dma)
+		i2c_imx_dma_free(i2c_imx);
 	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);


