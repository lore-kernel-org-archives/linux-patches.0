Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7945E3F8F4;
	Mon,  1 Apr 2024 16:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988319; cv=none; b=ac3BzZfUE4YdcnSv6MweshD/qhlJCa9CW1LfhgV9+/dtGwp1Yl6a3EDBtQ0U03z6ZoFXMdvGlZI+QFYsGgiLC4pZagbx3XdWGiz9+HqJO4v9aLMpQzXWAQCdSOltY9eNrfftuclSZYhHTTI5xHYXtSp8CCss35PytWjwiASs9t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988319; c=relaxed/simple;
	bh=mVI9l0/ROdhIn1rVr+CvLkXqMdbqfH51Kw19qKakmgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb6oa+5+hFlw3n7WVgIB3l0fn4McYAA3InbnpJeiOaIaStbDKu7FvdZPpEc+gYtwM/cSwMMX43RA9YdLpc98IQ/LwZlQUMvpahBPRffUgoRBmkmP52tzaScjqWrmOZrvvgC/B936K0e2C7wZJWa8cgP5WAFSmek+kee4rU5TmZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fut8EG+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fut8EG+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD57C433C7;
	Mon,  1 Apr 2024 16:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988319;
	bh=mVI9l0/ROdhIn1rVr+CvLkXqMdbqfH51Kw19qKakmgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fut8EG+UkOzzs9CqT43cwFgyZPauyAcBDd5kJSoD6AXa0F7MWnpNLiO3b8sh2mq8t
	 9kWyexu7Spw7enyIQnCWXwN4mA18QBzMDZE6JWxxXamK7tnWVmPGEpyLigZxLUd9iA
	 ZZTKBbPdqrfFe7Zy8+0QAPZOqnqGDExr/pv0uUMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 150/432] tpm,tpm_tis: Avoid warning splat at shutdown
Date: Mon,  1 Apr 2024 17:42:17 +0200
Message-ID: <20240401152557.611528336@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



