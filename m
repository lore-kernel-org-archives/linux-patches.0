Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB35101C0
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAAAC433D2;
	Mon, 15 May 2023 17:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173246;
	bh=PfyDjqO/6tcjDC+GDrPObxuTvMlznqvtvK2/x5DRIuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqH2E/JdlZkGt11urPmA8XbAdSl2G1WIEYNgozV1XPe39MJfgwCIC5/gp/ehxz0MN
	 monmMP3w2zbYjAljhVnEVZzJ4Ync22ziD/Xz7s66GlzvDmt+RN6lcvsug2r16WqLks
	 bUUjzY4dSf/uLGojBmtLl72TItdpZNeqfjeoBrTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 032/282] tpm, tpm_tis: Do not skip reset of original interrupt vector
Date: Mon, 15 May 2023 18:26:50 +0200
Message-Id: <20230515161723.238443849@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
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

[ Upstream commit ed9be0e6c892a783800d77a41ca4c7255c6af8c5 ]

If in tpm_tis_probe_irq_single() an error occurs after the original
interrupt vector has been read, restore the interrupts before the error is
returned.

Since the caller does not check the error value, return -1 in any case that
the TPM_CHIP_FLAG_IRQ flag is not set. Since the return value of function
tpm_tis_gen_interrupt() is not longer used, make it a void function.

Fixes: 1107d065fdf1 ("tpm_tis: Introduce intermediate layer for TPM access")
Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 70f7859942287..cb0660304e480 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -613,7 +613,7 @@ static irqreturn_t tis_int_handler(int dummy, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
+static void tpm_tis_gen_interrupt(struct tpm_chip *chip)
 {
 	const char *desc = "attempting to generate an interrupt";
 	u32 cap2;
@@ -622,7 +622,7 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 
 	ret = request_locality(chip, 0);
 	if (ret < 0)
-		return ret;
+		return;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		ret = tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
@@ -630,8 +630,6 @@ static int tpm_tis_gen_interrupt(struct tpm_chip *chip)
 		ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
 
 	release_locality(chip, 0);
-
-	return ret;
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an
@@ -661,42 +659,37 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 
 	rc = tpm_tis_write8(priv, TPM_INT_VECTOR(priv->locality), irq);
 	if (rc < 0)
-		return rc;
+		goto restore_irqs;
 
 	rc = tpm_tis_read32(priv, TPM_INT_STATUS(priv->locality), &int_status);
 	if (rc < 0)
-		return rc;
+		goto restore_irqs;
 
 	/* Clear all existing */
 	rc = tpm_tis_write32(priv, TPM_INT_STATUS(priv->locality), int_status);
 	if (rc < 0)
-		return rc;
-
+		goto restore_irqs;
 	/* Turn on */
 	rc = tpm_tis_write32(priv, TPM_INT_ENABLE(priv->locality),
 			     intmask | TPM_GLOBAL_INT_ENABLE);
 	if (rc < 0)
-		return rc;
+		goto restore_irqs;
 
 	priv->irq_tested = false;
 
 	/* Generate an interrupt by having the core call through to
 	 * tpm_tis_send
 	 */
-	rc = tpm_tis_gen_interrupt(chip);
-	if (rc < 0)
-		return rc;
+	tpm_tis_gen_interrupt(chip);
 
+restore_irqs:
 	/* tpm_tis_send will either confirm the interrupt is working or it
 	 * will call disable_irq which undoes all of the above.
 	 */
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
-		rc = tpm_tis_write8(priv, original_int_vec,
-				TPM_INT_VECTOR(priv->locality));
-		if (rc < 0)
-			return rc;
-
-		return 1;
+		tpm_tis_write8(priv, original_int_vec,
+			       TPM_INT_VECTOR(priv->locality));
+		return -1;
 	}
 
 	return 0;
-- 
2.39.2



