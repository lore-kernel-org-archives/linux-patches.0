Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B953208239;
	Tue, 12 Nov 2024 10:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408314; cv=none; b=ZCRjCNBWKkLIpUcZVCTExktPuqoDBIVe9Gm1IPu2ru6sdam0hCTSWMUyp1kRVoPgqgX/3XHVhBbnFe7FuI2KNRJaAM4dWRD3k8ThFg4OjuaL/63SkF6XOUKYRSYqStjlWnp8dDOAxnZRLQASfBMNGdFCpRIzNqhWRRvNL41/WYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408314; c=relaxed/simple;
	bh=rsLXAjFxW5lU4L5bhuIE/UK+4iBx9b+pjZtTmqcKZBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LnT37WdtQyq/GLaeOlkCJazp/OnofiRq3QM4XjPF3rX/ckfj/45T//m2/ufr6prN0mTXkPlSLzVU6QlpwhDuFhRebvOFDEvQz7uht/xIVYD/WSNwQNKN1y1qL6Q3yW3k3PFNcGav1kN1XhNLiMBqumc5DS5V+7avq3bZMx4YZ1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrH9s3wd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrH9s3wd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56BD0C4CECD;
	Tue, 12 Nov 2024 10:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408313;
	bh=rsLXAjFxW5lU4L5bhuIE/UK+4iBx9b+pjZtTmqcKZBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrH9s3wdm3/mFVHZgVYwmrAV0k75+WOxQ85WbLD1/Xdw4VgJyDk0KiWG0PuGJvzD4
	 g2t4YQ9VEREIKhg9DYeLrNREkMBxbJX0H1lRH/o/96xEXLRPF3DGBIXoNyYq9q3j/X
	 Ex3U05Lj//cRt1xCjwL3C41U+DBvH/sEEdg9kTaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Seo <mikeseohyungjin@gmail.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.11 097/184] tpm: Lock TPM chip in tpm_pm_suspend() first
Date: Tue, 12 Nov 2024 11:20:55 +0100
Message-ID: <20241112101904.586023723@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c      |    4 ----
 drivers/char/tpm/tpm-interface.c |   32 ++++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 14 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -525,10 +525,6 @@ static int tpm_hwrng_read(struct hwrng *
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
@@ -370,6 +370,13 @@ int tpm_pm_suspend(struct device *dev)
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
 
@@ -377,21 +384,19 @@ int tpm_pm_suspend(struct device *dev)
 	    !pm_suspend_via_firmware())
 		goto suspended;
 
-	rc = tpm_try_get_ops(chip);
-	if (!rc) {
-		if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-			tpm2_end_auth_session(chip);
-			tpm2_shutdown(chip, TPM2_SU_STATE);
-		} else {
-			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
-		}
-
-		tpm_put_ops(chip);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		tpm2_end_auth_session(chip);
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
@@ -440,11 +445,18 @@ int tpm_get_random(struct tpm_chip *chip
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


