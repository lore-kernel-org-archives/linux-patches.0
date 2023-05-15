Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F818FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F98C433EF;
	Mon, 15 May 2023 17:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172229;
	bh=zNLmtlvE92e+a6GUH7QTXZjn1URMTLYoWikuSwWheO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wBz4phU0C5D+gS23jW24TRVT2XabFuafvb3f2rwYYvL/VZvSs5BWf98JW86Cysofu
	 RvdHJ1W8QFjnloOcBsiQjDlSEwXajqB6C+ecN0I+McaCcb25CN6j3XanSCLpKz7s+p
	 5uM0nUPpbVSpG7674pQfSJN6vPOKNPYx8/Jznyg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/381] tpm, tpm_tis: Claim locality before writing interrupt registers
Date: Mon, 15 May 2023 18:25:19 +0200
Message-Id: <20230515161739.884029290@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
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

[ Upstream commit 15d7aa4e46eba87242a320f39773aa16faddadee ]

In tpm_tis_probe_single_irq() interrupt registers TPM_INT_VECTOR,
TPM_INT_STATUS and TPM_INT_ENABLE are modified to setup the interrupts.
Currently these modifications are done without holding a locality thus they
have no effect. Fix this by claiming the (default) locality before the
registers are written.

Since now tpm_tis_gen_interrupt() is called with the locality already
claimed remove locality request and release from this function.

Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Stable-dep-of: 955df4f87760 ("tpm, tpm_tis: Claim locality when interrupts are reenabled on resume")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 99cbf6fb062ce..52826a7edf800 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -721,16 +721,10 @@ static void tpm_tis_gen_interrupt(struct tpm_chip *chip)
 	cap_t cap;
 	int ret;
 
-	ret = request_locality(chip, 0);
-	if (ret < 0)
-		return;
-
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		ret = tpm2_get_tpm_pt(chip, 0x100, &cap2, desc);
 	else
 		ret = tpm1_getcap(chip, TPM_CAP_PROP_TIS_TIMEOUT, &cap, desc, 0);
-
-	release_locality(chip, 0);
 }
 
 /* Register the IRQ and issue a command that will cause an interrupt. If an
@@ -753,10 +747,16 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	}
 	priv->irq = irq;
 
+	rc = request_locality(chip, 0);
+	if (rc < 0)
+		return rc;
+
 	rc = tpm_tis_read8(priv, TPM_INT_VECTOR(priv->locality),
 			   &original_int_vec);
-	if (rc < 0)
+	if (rc < 0) {
+		release_locality(chip, priv->locality);
 		return rc;
+	}
 
 	rc = tpm_tis_write8(priv, TPM_INT_VECTOR(priv->locality), irq);
 	if (rc < 0)
@@ -790,10 +790,12 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
 	if (!(chip->flags & TPM_CHIP_FLAG_IRQ)) {
 		tpm_tis_write8(priv, original_int_vec,
 			       TPM_INT_VECTOR(priv->locality));
-		return -1;
+		rc = -1;
 	}
 
-	return 0;
+	release_locality(chip, priv->locality);
+
+	return rc;
 }
 
 /* Try to find the IRQ the TPM is using. This is for legacy x86 systems that
-- 
2.39.2



