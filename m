Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF70325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300968; cv=none; b=eLHeyGRKT8FfNr27+xTTiMx+fmQd8Eymbxxh9D87ptDnzcOX8tGazlZk/n3XdoEY/kn3jVXWH8BHAO7tLZtQUuyryNtG9EATGjo1mlDZ1vs09hWWt1WmuXwm12N2b4tgKyT7YOtl9wkPfzUpHxA82hswwT2F0wABAt01v0O1zNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300968; c=relaxed/simple;
	bh=qBb3984FcUVkn6ObiM6blPgcfp4SWEUhlMD4uB277ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwAVcvxBQL8UzUIAvp2K6LfQLRr9Ogg5jM8W1c3Osqlgo2QeAX7vsl7dcDcHPBf/ALibzOFxKFGj7LSw4vLvk1hLujIdGX6xw82SLt6yfs8Zp7xfnVDBIMU8xwV/jsbFnaGid/R59qio0LssPsYz+AydQWmODmsrz9NVohw3+6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fPtgHS2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fPtgHS2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 474E8C116D0;
	Sat, 28 Feb 2026 17:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300967;
	bh=qBb3984FcUVkn6ObiM6blPgcfp4SWEUhlMD4uB277ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPtgHS2NX3IZPuFMdJn7lINH6RFXI20o8kl3gDepOejZgInXKOd2RNlxnsCMMdWSI
	 Pq4gcHLu/3TC6RzQY+0UGgLUqPgnOFjlP+/SLl0LuilJPNQWuyqWYBcdM7Wmo/UznE
	 sd/NAQD74TFua8bVKUBIs0ywbvf7fPAo94/bydDkEW3dvsHPRDBgOuoYBy97SXlxGu
	 Mmq4dpi+KmaHFLsbybD+lrDHGwTemM1rsQJD8pF47+JfaKTRcGEV9sc3cTESDnDGZq
	 KRSIuorJpfsL/y9VVFQVnTNTKbU+WHPT/C/K7S58/7LJKGlWkQ8bz9OKrwIL7z5GKT
	 G+UmWgreIqayg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/752] char: tpm: cr50: Remove IRQF_ONESHOT
Date: Sat, 28 Feb 2026 12:36:45 -0500
Message-ID: <20260228174750.1542406-94-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 1affd29ffbd50125a5492c6be1dbb1f04be18d4f ]

Passing IRQF_ONESHOT ensures that the interrupt source is masked until
the secondary (threaded) handler is done. If only a primary handler is
used then the flag makes no sense because the interrupt can not fire
(again) while its handler is running.

The flag also prevents force-threading of the primary handler and the
irq-core will warn about this.

Remove IRQF_ONESHOT from irqflags.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://patch.msgid.link/20260128095540.863589-10-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_i2c_cr50.c | 3 +--
 drivers/char/tpm/tpm_tis_spi_cr50.c | 2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_i2c_cr50.c b/drivers/char/tpm/tpm_tis_i2c_cr50.c
index fc6891a0b6936..b48cacacc0664 100644
--- a/drivers/char/tpm/tpm_tis_i2c_cr50.c
+++ b/drivers/char/tpm/tpm_tis_i2c_cr50.c
@@ -749,8 +749,7 @@ static int tpm_cr50_i2c_probe(struct i2c_client *client)
 
 	if (client->irq > 0) {
 		rc = devm_request_irq(dev, client->irq, tpm_cr50_i2c_int_handler,
-				      IRQF_TRIGGER_FALLING | IRQF_ONESHOT |
-				      IRQF_NO_AUTOEN,
+				      IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN,
 				      dev->driver->name, chip);
 		if (rc < 0) {
 			dev_err(dev, "Failed to probe IRQ %d\n", client->irq);
diff --git a/drivers/char/tpm/tpm_tis_spi_cr50.c b/drivers/char/tpm/tpm_tis_spi_cr50.c
index f4937280e9406..32920b4cecfb4 100644
--- a/drivers/char/tpm/tpm_tis_spi_cr50.c
+++ b/drivers/char/tpm/tpm_tis_spi_cr50.c
@@ -287,7 +287,7 @@ int cr50_spi_probe(struct spi_device *spi)
 	if (spi->irq > 0) {
 		ret = devm_request_irq(&spi->dev, spi->irq,
 				       cr50_spi_irq_handler,
-				       IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+				       IRQF_TRIGGER_RISING,
 				       "cr50_spi", cr50_phy);
 		if (ret < 0) {
 			if (ret == -EPROBE_DEFER)
-- 
2.51.0

