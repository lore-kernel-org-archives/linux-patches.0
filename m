Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCD747A6B;
	Mon,  1 Apr 2024 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989709; cv=none; b=aV2daIIxHDrQZXneUiTJQnCGemdAodvAuprZl41PetcS8pzteid4A4U9WRZMhO6j6s0yRF0kNB620SBpP1ufkmQ3NNL84kAtRImUkTSx2opDKD59dkDYsLnYH41a8BNba60muRWp1fL5nERCjlwOutr+7BL2wZWRWhyNilvpFZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989709; c=relaxed/simple;
	bh=7Dk+a5JHMW8zgo/n5uVBAZvIYD28SN/PCoImZgRDKvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LcouGK8PjJ9RTWA9B/qTPci2Fs45CKNREi2fOGT1Z7xIoZCaW3yuacfdBPhBQHtnv0Y38pd8MF5rivlRc4bJGpeldS9wdsiMXkKJ9Lmz6SBCJGdWal795zAmBmgrYMbovDlLYGt2EkTJbr4eHHScf8cJqjTL+pkf7cKSAzjht2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/ozkISZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/ozkISZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02A9C43390;
	Mon,  1 Apr 2024 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989709;
	bh=7Dk+a5JHMW8zgo/n5uVBAZvIYD28SN/PCoImZgRDKvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/ozkISZXh6yJzO2zzulShSgzwmk7Gfmz4JIE4zPEdVQ8TkbFDGkKXU7jx35wmMF+
	 nz1+FMHc1lT2lQQnYWcO1ZEuKnFH1444BFPcn/08dJNyKDiEPUaWzcPN6n8LUpkB9r
	 2OHW7r0IXrnQDDCGOXl3q0O3Fz2aWD8VLrST7e70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/396] tpm,tpm_tis: Avoid warning splat at shutdown
Date: Mon,  1 Apr 2024 17:42:59 +0200
Message-ID: <20240401152551.793422290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

[ Upstream commit b7ab4bbd0188f3985b821fa09456b11105a8dedf ]

If interrupts are not activated the work struct 'free_irq_work' is not
initialized. This results in a warning splat at module shutdown.

Fix this by always initializing the work regardless of whether interrupts
are activated or not.

cc: stable@vger.kernel.org
Fixes: 481c2d14627d ("tpm,tpm_tis: Disable interrupts after 1000 unhandled IRQs")
Reported-by: Jarkko Sakkinen <jarkko@kernel.org>
Closes: https://lore.kernel.org/all/CX32RFOMJUQ0.3R4YCL9MDCB96@kernel.org/
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 1b350412d8a6b..64c875657687d 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -919,8 +919,6 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	int rc;
 	u32 int_status;
 
-	INIT_WORK(&priv->free_irq_work, tpm_tis_free_irq_func);
-
 	rc = devm_request_threaded_irq(chip->dev.parent, irq, NULL,
 				       tis_int_handler, IRQF_ONESHOT | flags,
 				       dev_name(&chip->dev), chip);
@@ -1132,6 +1130,7 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	priv->phy_ops = phy_ops;
 	priv->locality_count = 0;
 	mutex_init(&priv->locality_count_mutex);
+	INIT_WORK(&priv->free_irq_work, tpm_tis_free_irq_func);
 
 	dev_set_drvdata(&chip->dev, priv);
 
-- 
2.43.0



