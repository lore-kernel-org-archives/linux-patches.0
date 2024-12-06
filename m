Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE021465AB;
	Fri,  6 Dec 2024 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498709; cv=none; b=HeD+OVMl+w1+E/IGiI0j67C9/7zQxzQmD3+bLppc7z0ycKNmmT6Nw+7xKaIfN3UvUAhGZ1KK0UCNuIquR/LF1UVueU0nAiXUNU3HWatRqGFUK0dMyrZeJIxfaJYmhtFT30rPoonpfibmlebFa5OzTFGiCCmqmo5Y9kwQ/vnAATQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498709; c=relaxed/simple;
	bh=F0VAuDF9VpPhXf1H2J9hiIWZhQiNaP3oB624V4ThMAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB3w/j9OqjThdHYwbeeSWRUJPdCdY6m/vb265TI/QteXAXoP0fOfJojFKMerfdPZv1mFNT+fk7uKYbWKjACowfPDt1HhHaylMYXxsIqxojPJmpfJkt4zwUH6Y8F4xbB26XIHrXQs4G4CgNwdXVIqAy5tIoz60hu+LsUq1K69Dyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eh2fU2/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eh2fU2/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3DACC4CED1;
	Fri,  6 Dec 2024 15:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498709;
	bh=F0VAuDF9VpPhXf1H2J9hiIWZhQiNaP3oB624V4ThMAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eh2fU2/ESU1RXGnZPiVYAmA3xNAmkAhNKLAdtqKgF5Li/q4lm3f/xImrBf/WqYxIv
	 duz/V4iGAxfrFWX7msa9d+iQEu45ZtAsrTd2McY7bgMk8KC9aS60kfJIVwVrCb8fup
	 EBL17zA/DifrRuLPmTAX+6sZCgFgY+vaJal/102s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Seo <mikeseohyungjin@gmail.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.6 665/676] tpm: Lock TPM chip in tpm_pm_suspend() first
Date: Fri,  6 Dec 2024 15:38:04 +0100
Message-ID: <20241206143719.346600451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

commit 9265fed6db601ee2ec47577815387458ef4f047a upstream.

Setting TPM_CHIP_FLAG_SUSPENDED in the end of tpm_pm_suspend() can be racy
according, as this leaves window for tpm_hwrng_read() to be called while
the operation is in progress. The recent bug report gives also evidence of
this behaviour.

Aadress this by locking the TPM chip before checking any chip->flags both
in tpm_pm_suspend() and tpm_hwrng_read(). Move TPM_CHIP_FLAG_SUSPENDED
check inside tpm_get_random() so that it will be always checked only when
the lock is reserved.

Cc: stable@vger.kernel.org # v6.4+
Fixes: 99d464506255 ("tpm: Prevent hwrng from activating during resume")
Reported-by: Mike Seo <mikeseohyungjin@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219383
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Tested-by: Mike Seo <mikeseohyungjin@gmail.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
[ Don't call tpm2_end_auth_session() for this function does not exist in 6.6.y.]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c      |    4 ----
 drivers/char/tpm/tpm-interface.c |   29 +++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -519,10 +519,6 @@ static int tpm_hwrng_read(struct hwrng *
 {
 	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
 
-	/* Give back zero bytes, as TPM chip has not yet fully resumed: */
-	if (chip->flags & TPM_CHIP_FLAG_SUSPENDED)
-		return 0;
-
 	return tpm_get_random(chip, data, max);
 }
 
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -394,6 +394,13 @@ int tpm_pm_suspend(struct device *dev)
 	if (!chip)
 		return -ENODEV;
 
+	rc = tpm_try_get_ops(chip);
+	if (rc) {
+		/* Can be safely set out of locks, as no action cannot race: */
+		chip->flags |= TPM_CHIP_FLAG_SUSPENDED;
+		goto out;
+	}
+
 	if (chip->flags & TPM_CHIP_FLAG_ALWAYS_POWERED)
 		goto suspended;
 
@@ -401,19 +408,18 @@ int tpm_pm_suspend(struct device *dev)
 	    !pm_suspend_via_firmware())
 		goto suspended;
 
-	rc = tpm_try_get_ops(chip);
-	if (!rc) {
-		if (chip->flags & TPM_CHIP_FLAG_TPM2)
-			tpm2_shutdown(chip, TPM2_SU_STATE);
-		else
-			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
-
-		tpm_put_ops(chip);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		tpm2_shutdown(chip, TPM2_SU_STATE);
+		goto suspended;
 	}
 
+	rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
+
 suspended:
 	chip->flags |= TPM_CHIP_FLAG_SUSPENDED;
+	tpm_put_ops(chip);
 
+out:
 	if (rc)
 		dev_err(dev, "Ignoring error %d while suspending\n", rc);
 	return 0;
@@ -462,11 +468,18 @@ int tpm_get_random(struct tpm_chip *chip
 	if (!chip)
 		return -ENODEV;
 
+	/* Give back zero bytes, as TPM chip has not yet fully resumed: */
+	if (chip->flags & TPM_CHIP_FLAG_SUSPENDED) {
+		rc = 0;
+		goto out;
+	}
+
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		rc = tpm2_get_random(chip, out, max);
 	else
 		rc = tpm1_get_random(chip, out, max);
 
+out:
 	tpm_put_ops(chip);
 	return rc;
 }


