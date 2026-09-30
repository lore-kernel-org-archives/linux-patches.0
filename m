Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C04347A0DD;
	Wed, 30 Sep 2026 16:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786061; cv=none; b=LJLcgC2QBQG9xA2/75DI01wlKth0iLoUQb3kMc9ukKLvhzXiBy051f7k17LGwAJv8KPSoUDMgmwpCR81s4T9AhF4kccPUnL2lPc+oErGy6CNZhCSFC3JIIsWa9mTiJhowCBc2z7jsAJcrYPJZVFTpdbE9ZOz0LwBrGf3rzsJgKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786061; c=relaxed/simple;
	bh=1J72jkcde4Lf/7krpgOCkVNgrDtNHrDHcgetvaCUOr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCN/LZku8ICKEmxpPTVhRKC6NNJyxWztQWxW4Z5OBMH1BXhir55ZrF2KPEl+HAymWIJxMcg4vFtlSpTxfTCq4K1EY6Q5DfBaEx3nUEIeVQOeNV9fhY0t6t3F1u/EqN+JE9FWVjLRXKt4Db74ZCBO3I7FhLj9q3cObnEMO6TS5bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vGYvWgWs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vGYvWgWs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C38E1F00898;
	Wed, 30 Sep 2026 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786059;
	bh=7M7dwpdCj9KnwrspCCoaBAuyXD7MT2nL+TlMp1SiwLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vGYvWgWsjveQCjOQpVCD9kLFA63sJTsQtM5SqHHcYg5uplEI/rOGPUxacZg3vN9k0
	 0gzZizoLFBpA9olZxWJ9d6HPc6jlGTN9pBhFD48IYcp5ZdXrdaiYiRiupDXrBmxsrf
	 fIYYWBA73OxNZGG5doNeQOk3fYXI7CG+E6etUBPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 726/982] i2c: at91: release DMA channels on remove and probe error
Date: Wed, 30 Sep 2026 17:24:22 +0200
Message-ID: <20260930152432.347547810@linuxfoundation.org>
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

commit f7eeb1af8537b05953fb1c88ab8b59d94059a381 upstream.

at91_twi_configure_dma() requests exclusive tx/rx DMA channels, but
nothing ever releases them on driver detach, and the probe error path
after the channels are acquired (i2c_add_numbered_adapter() failure)
returns without releasing them either, because the remove callback is
not invoked after a failed probe.

Move the release into a helper, call it from the existing
configure-failure path, the adapter-registration failure path, and
at91_twi_remove().

Fixes: 60937b2cdbf9 ("i2c: at91: add dma support")
Assisted-by: GLM:5.3
Signed-off-by: Shengzhuo Wei <me@cherr.cc>
Cc: <stable@vger.kernel.org> # v3.8+
Acked-by: Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20260827-i2c-dma-channel-leak-v1-1-271d4adc03a0@cherr.cc
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-at91-core.c   |    3 +++
 drivers/i2c/busses/i2c-at91-master.c |   12 +++++++++++-
 drivers/i2c/busses/i2c-at91.h        |    1 +
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-at91-core.c
+++ b/drivers/i2c/busses/i2c-at91-core.c
@@ -264,6 +264,7 @@ static int at91_twi_probe(struct platfor
 
 		pm_runtime_disable(dev->dev);
 		pm_runtime_set_suspended(dev->dev);
+		at91_twi_dma_release(dev);
 
 		return rc;
 	}
@@ -280,6 +281,8 @@ static int at91_twi_remove(struct platfo
 	i2c_del_adapter(&dev->adapter);
 	clk_disable_unprepare(dev->clk);
 
+	at91_twi_dma_release(dev);
+
 	pm_runtime_disable(dev->dev);
 	pm_runtime_set_suspended(dev->dev);
 
--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -819,11 +819,21 @@ static int at91_twi_configure_dma(struct
 error:
 	if (ret != -EPROBE_DEFER)
 		dev_info(dev->dev, "can't get DMA channel, continue without DMA support\n");
+	at91_twi_dma_release(dev);
+	return ret;
+}
+
+void at91_twi_dma_release(struct at91_twi_dev *dev)
+{
+	struct at91_twi_dma *dma = &dev->dma;
+
 	if (dma->chan_rx)
 		dma_release_channel(dma->chan_rx);
 	if (dma->chan_tx)
 		dma_release_channel(dma->chan_tx);
-	return ret;
+	dma->chan_rx = NULL;
+	dma->chan_tx = NULL;
+	dev->use_dma = false;
 }
 
 static int at91_init_twi_recovery_gpio(struct platform_device *pdev,
--- a/drivers/i2c/busses/i2c-at91.h
+++ b/drivers/i2c/busses/i2c-at91.h
@@ -172,6 +172,7 @@ void at91_twi_irq_restore(struct at91_tw
 void at91_init_twi_bus(struct at91_twi_dev *dev);
 
 void at91_init_twi_bus_master(struct at91_twi_dev *dev);
+void at91_twi_dma_release(struct at91_twi_dev *dev);
 int at91_twi_probe_master(struct platform_device *pdev, u32 phy_addr,
 			  struct at91_twi_dev *dev);
 


