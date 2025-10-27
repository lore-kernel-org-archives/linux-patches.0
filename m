Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D15C31B116;
	Mon, 27 Oct 2025 18:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590584; cv=none; b=lHQFPxHoSbzXZalNykkDSJ9vRnubSvIS9QmDAhD6CQFbjcKSlP1MV+/itW1tSuurlKH9ybyUkLsyedkn7fn1gUeQyZ8UDjULFrOFgqM9KZ/NwIBZlo/a7gWBdxUw1WOjtqpfSQcYiFDDpwTavkT3qZfXeCXuRwvlJyXcQgEnPgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590584; c=relaxed/simple;
	bh=/NgEGm/crFftReVjSK/hrwOk5jp3/3C2BLNuOW9+s/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHB1j0KBzvQRyOGPEFAiRic78aEXjNxPtiGMF+0Q+AsOhQpSYrc7c8W6kVYlz5GVuDn0F5QHgs72FvzpcLiI7rxRFKlR/fEkphw67BDQcDKnr2MNQTFZhcQ96QWeEgTR4cLNl+aQnMN2881sop6KIsaUtyS86KF/IxtSrehjkbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eua8Z3YX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eua8Z3YX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F310C4CEF1;
	Mon, 27 Oct 2025 18:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590584;
	bh=/NgEGm/crFftReVjSK/hrwOk5jp3/3C2BLNuOW9+s/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eua8Z3YXTKAjJPbQIGV5cCYyQT5XnzTAVtBn5lt6eQmsxquLZPTzZnHZTsW/3hDqL
	 hVajDKzDXmVbY6i9+r/dy4NMyYYVnBnwiJyRH9gVEZC7JJz0qf0TjNlG2jKjOvq8t1
	 uM3/yIwXDfoV86E85DjhgzVna/Y1+XmO1H31mJnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/224] tpm, tpm_tis: Claim locality before writing interrupt registers
Date: Mon, 27 Oct 2025 19:34:04 +0100
Message-ID: <20251027183511.612449703@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Stable-dep-of: 8a81236f2cb0 ("tpm_tis: Fix incorrect arguments in tpm_tis_probe_irq_single")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index a084f732c1804..60f4b8b9c6f14 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -633,16 +633,10 @@ static void tpm_tis_gen_interrupt(struct tpm_chip *chip)
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
@@ -665,10 +659,16 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
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
@@ -702,10 +702,12 @@ static int tpm_tis_probe_irq_single(struct tpm_chip *chip, u32 intmask,
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
2.51.0



