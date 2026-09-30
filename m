Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4296C3A784F;
	Wed, 30 Sep 2026 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788723; cv=none; b=Q0pVVfrQqN/mrXlEfjkTPhR48rF0IPLzfDWeCL97F+Pd2vOKjoBoOn2K9VF9J6+hOVvt6rb+Xs8HfsSmS3AW0kuoIhOuRMUK0FNqE1WhMIaQ4bN2aLtrZP/1N32V9Ap2INakFPtTHbSPLnRYJYVD0fOtYfsAm3QiKOiXpxuVDQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788723; c=relaxed/simple;
	bh=q2+51fj/aqCeNZCMYlt4sksoEYuDh4bvYedFMvHdVQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcS8SEXwSiv5IzNnFeck6wCvl0hqI8g2O2XuiGwdtCzlx4rKcZYB9BjJQj+wfDw7LZHZ72S9ywLKcNlZtAQaoB1BQr6O0YI78pzyZSIfYHdnGetcuDaO+Hifr5oiz8trBgNK0sFje7JA9SX+Z8EZmGfRD0l0MA+aoiHnt1R5WiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6GdVpR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6GdVpR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930A81F000FF;
	Wed, 30 Sep 2026 17:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788722;
	bh=yGQdfLw5IUTB5h4+7ei6wsTWUDdjoOCmqxPnZHaQMOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6GdVpR8NMxxpeGr2Dz230meQ1k2OsTcA64Nrb3Whx56JssMBFB1MmNlTlu/z6jnD
	 PYECeEpocNFJLLL1DXQGbCcUyqmQZCnhG3/8L9G6yfJXyunw/QF+mg4AZjhhXN/cZg
	 u9NG3XwbxcBeZydqM6hDZkIGHn1hpCdHrOn6cFOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengzhuo Wei <me@cherr.cc>,
	Mukesh Kumar Savaliya <mukesh.savaliya@oss.qualcomm.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 208/877] i2c: at91: release DMA channels on remove and probe error
Date: Wed, 30 Sep 2026 17:18:39 +0200
Message-ID: <20260930152419.215343016@linuxfoundation.org>
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
@@ -255,6 +255,7 @@ static int at91_twi_probe(struct platfor
 	if (rc) {
 		pm_runtime_disable(dev->dev);
 		pm_runtime_set_suspended(dev->dev);
+		at91_twi_dma_release(dev);
 
 		return rc;
 	}
@@ -270,6 +271,8 @@ static void at91_twi_remove(struct platf
 
 	i2c_del_adapter(&dev->adapter);
 
+	at91_twi_dma_release(dev);
+
 	pm_runtime_disable(dev->dev);
 	pm_runtime_set_suspended(dev->dev);
 }
--- a/drivers/i2c/busses/i2c-at91-master.c
+++ b/drivers/i2c/busses/i2c-at91-master.c
@@ -817,11 +817,21 @@ static int at91_twi_configure_dma(struct
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
 


