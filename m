Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5607B611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D487CC433EF;
	Sun, 28 May 2023 19:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302463;
	bh=+ng182VXoaorijH+aJoj0N5R4C3zmDVwf1vMsbSuGBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nN302edBia1XNJWdB4jBkk5k/VogUjHypU2GI10FpatWSKYoeX+xACiRT30JQohZz
	 4lGwZR7uvhg+CTr7caLefXpEL11wNwvxpBVhCwDLQOOPz7y3BkbxJZnHF3ArRfKk6a
	 wcKv0I5rT0hFOGBqVJ5hsUd/XSBgxy4vIv32jykE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/119] tpm, tpm_tis: startup chip before testing for interrupts
Date: Sun, 28 May 2023 20:10:05 +0100
Message-Id: <20230528190835.546402889@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

[ Upstream commit 548eb516ec0f7a484a23a902835899341164b8ea ]

In tpm_tis_gen_interrupt() a request for a property value is sent to the
TPM to test if interrupts are generated. However after a power cycle the
TPM responds with TPM_RC_INITIALIZE which indicates that the TPM is not
yet properly initialized.
Fix this by first starting the TPM up before the request is sent. For this
the startup implementation is removed from tpm_chip_register() and put
into the new function tpm_chip_startup() which is called before the
interrupts are tested.

Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Stable-dep-of: 99d464506255 ("tpm: Prevent hwrng from activating during resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-chip.c     | 38 +++++++++++++++++++++------------
 drivers/char/tpm/tpm.h          |  1 +
 drivers/char/tpm/tpm_tis_core.c |  5 +++++
 3 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 5165f6d3da228..47c2861af45a3 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -601,6 +601,30 @@ static int tpm_get_pcr_allocation(struct tpm_chip *chip)
 	return rc;
 }
 
+/*
+ * tpm_chip_startup() - performs auto startup and allocates the PCRs
+ * @chip: TPM chip to use.
+ */
+int tpm_chip_startup(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm_chip_start(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm_auto_startup(chip);
+	if (rc)
+		goto stop;
+
+	rc = tpm_get_pcr_allocation(chip);
+stop:
+	tpm_chip_stop(chip);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_chip_startup);
+
 /*
  * tpm_chip_register() - create a character device for the TPM chip
  * @chip: TPM chip to use.
@@ -616,20 +640,6 @@ int tpm_chip_register(struct tpm_chip *chip)
 {
 	int rc;
 
-	rc = tpm_chip_start(chip);
-	if (rc)
-		return rc;
-	rc = tpm_auto_startup(chip);
-	if (rc) {
-		tpm_chip_stop(chip);
-		return rc;
-	}
-
-	rc = tpm_get_pcr_allocation(chip);
-	tpm_chip_stop(chip);
-	if (rc)
-		return rc;
-
 	tpm_sysfs_add_device(chip);
 
 	tpm_bios_log_setup(chip);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 830014a266090..88d3bd76e0760 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -263,6 +263,7 @@ static inline void tpm_msleep(unsigned int delay_msec)
 		     delay_msec * 1000);
 };
 
+int tpm_chip_startup(struct tpm_chip *chip);
 int tpm_chip_start(struct tpm_chip *chip);
 void tpm_chip_stop(struct tpm_chip *chip);
 struct tpm_chip *tpm_find_get_ops(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index a5c22fb4ad428..9f76c9a5aa422 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -1124,6 +1124,11 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 	/* INTERRUPT Setup */
 	init_waitqueue_head(&priv->read_queue);
 	init_waitqueue_head(&priv->int_queue);
+
+	rc = tpm_chip_startup(chip);
+	if (rc)
+		goto out_err;
+
 	if (irq != -1) {
 		/*
 		 * Before doing irq testing issue a command to the TPM in polling mode
-- 
2.39.2



