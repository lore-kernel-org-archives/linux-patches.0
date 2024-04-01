Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA6846551;
	Mon,  1 Apr 2024 15:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986996; cv=none; b=lYM24KwXVgTBjN3G9fd0sGdHFZG7Bnfkvujtz6ygFz3dKigzrCN1J1mZTOdOBhx5Z+PuAhGvDL3uYbtjwM8TbJzZwIgBALnSWck+Vv7vr8jMTzRTqADllPWOY1Y5G5tiFgJZMPlvlEMOiXxxjLW2I214LL9ffh0Y6LgAUJckkqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986996; c=relaxed/simple;
	bh=b1Al778IJ0tRtRJdncbOUYYmqJZG1qMa+yiKvqLFW88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzCCx2kv5xdeLziw0QTVqdV7cP7WJP4FN2fRX3k2JkGtOSddVzg0bYhzxRs/e2WEQs4PLdEHaP0EN8YOPlSaJZQVma3TAnVi4XW+j5s+LAtTcPNZc9WMUG0A3wkXdER64wtGCoaRFxd3G+mx63agKTs3ubnRLdrt/07+W7vCzRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KF3mXxNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KF3mXxNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1140EC433C7;
	Mon,  1 Apr 2024 15:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986996;
	bh=b1Al778IJ0tRtRJdncbOUYYmqJZG1qMa+yiKvqLFW88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KF3mXxNGgXLZPd+ddfuU3mMP04gT6FDYrByIIeYTgGnu2JDLqKqLPgJCC3e3TAyIO
	 1HT+gE+22BSWE9l9dW7lMDO9gf6CuoZ7BuSpjnpSj64AiX/SFsS5cU7NCdNbpQ5yoL
	 ob2hYMQjuiRc+5YG7igQPZvcSnHSyE/SBcdZ9o/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 151/399] tpm,tpm_tis: Avoid warning splat at shutdown
Date: Mon,  1 Apr 2024 17:41:57 +0200
Message-ID: <20240401152553.695952374@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



