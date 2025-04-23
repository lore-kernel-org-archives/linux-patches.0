Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5F228152D;
	Wed, 23 Apr 2025 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420819; cv=none; b=PbQKt6NGdV1nk/mRkLipjh09mJF2SmcHNxxNM9UgFci/iK3rhWudllgZXuX+GEEn1RjcqnHLCJ+EGJtm+YuL8Gixn2IQylcUZeyrqcxt4E24dBLKms2eyEpTuCeMuPS0GJgWU4WKsx1kKQhD7GiKOD6aGany9EqeMvl9JxDQCxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420819; c=relaxed/simple;
	bh=anVyIcMoCMy//efGweG1bep2zn0moQtcTBtVd8NXJUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OZBadwPZNw/eckcWEyZW+QKfiR8g/tt4Rg/F/jcBuz5cVUF8z7wyjDsuMBNb9A3ThUT5BKpTsDvVgJHKHNcJP1EfyD2w9sTdwEvgw7wIchTz++vC+k0MEi3t4w73h+36b2WIc1NCiPXllaPVvLvi8+k07l8oda4AeWydQ7hcOR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsBXqiT9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsBXqiT9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3CDC4CEE2;
	Wed, 23 Apr 2025 15:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420819;
	bh=anVyIcMoCMy//efGweG1bep2zn0moQtcTBtVd8NXJUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsBXqiT9KMKsehVnnfVzx/zzNJG8+z166vK4RAnup0+KRRGmK/6MR4dhhyqA1IdXz
	 fLOfFJ82Fr6gnqKipHTWmwjtr2wNNprSAc+NuFD1Gthexwx+tSTQfazQ7HSGCUFIfs
	 Q9UPbI80ahPR5zNt1pUIZONrtYMdVRDPxsYujyBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/291] tpm, tpm_tis: Workaround failed command reception on Infineon devices
Date: Wed, 23 Apr 2025 16:41:01 +0200
Message-ID: <20250423142627.315849932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan McDowell <noodles@meta.com>

[ Upstream commit de9e33df7762abbfc2a1568291f2c3a3154c6a9d ]

Some Infineon devices have a issue where the status register will get
stuck with a quick REQUEST_USE / COMMAND_READY sequence. This is not
simply a matter of requiring a longer timeout; the work around is to
retry the command submission. Add appropriate logic to do this in the
send path.

This is fixed in later firmware revisions, but those are not always
available, and cannot generally be easily updated from outside a
firmware environment.

Testing has been performed with a simple repeated loop of doing a
TPM2_CC_GET_CAPABILITY for TPM_CAP_PROP_MANUFACTURER using the Go code
at:

  https://the.earth.li/~noodles/tpm-stuff/timeout-reproducer-simple.go

It can take several hours to reproduce, and several million operations.

Signed-off-by: Jonathan McDowell <noodles@meta.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_tis_core.c | 17 ++++++++++++++---
 drivers/char/tpm/tpm_tis_core.h |  1 +
 include/linux/tpm.h             |  1 +
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis_core.c b/drivers/char/tpm/tpm_tis_core.c
index 5889d9edaf940..4e294a915925b 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -433,7 +433,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, const u8 *buf, size_t len)
 
 		if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 					&priv->int_queue, false) < 0) {
-			rc = -ETIME;
+			if (test_bit(TPM_TIS_STATUS_VALID_RETRY, &priv->flags))
+				rc = -EAGAIN;
+			else
+				rc = -ETIME;
 			goto out_err;
 		}
 		status = tpm_tis_status(chip);
@@ -450,7 +453,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, const u8 *buf, size_t len)
 
 	if (wait_for_tpm_stat(chip, TPM_STS_VALID, chip->timeout_c,
 				&priv->int_queue, false) < 0) {
-		rc = -ETIME;
+		if (test_bit(TPM_TIS_STATUS_VALID_RETRY, &priv->flags))
+			rc = -EAGAIN;
+		else
+			rc = -ETIME;
 		goto out_err;
 	}
 	status = tpm_tis_status(chip);
@@ -505,9 +511,11 @@ static int tpm_tis_send_main(struct tpm_chip *chip, const u8 *buf, size_t len)
 		if (rc >= 0)
 			/* Data transfer done successfully */
 			break;
-		else if (rc != -EIO)
+		else if (rc != -EAGAIN && rc != -EIO)
 			/* Data transfer failed, not recoverable */
 			return rc;
+
+		usleep_range(priv->timeout_min, priv->timeout_max);
 	}
 
 	rc = tpm_tis_verify_crc(priv, len, buf);
@@ -1044,6 +1052,9 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		priv->timeout_max = TIS_TIMEOUT_MAX_ATML;
 	}
 
+	if (priv->manufacturer_id == TPM_VID_IFX)
+		set_bit(TPM_TIS_STATUS_VALID_RETRY, &priv->flags);
+
 	if (is_bsw()) {
 		priv->ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
 					ILB_REMAP_SIZE);
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 610bfadb6acf1..be72681ab8ea2 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -88,6 +88,7 @@ enum tpm_tis_flags {
 	TPM_TIS_INVALID_STATUS		= 1,
 	TPM_TIS_DEFAULT_CANCELLATION	= 2,
 	TPM_TIS_IRQ_TESTED		= 3,
+	TPM_TIS_STATUS_VALID_RETRY	= 4,
 };
 
 struct tpm_tis_data {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index df5cd4245f299..dd0784a6e07d9 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -271,6 +271,7 @@ enum tpm2_cc_attrs {
 #define TPM_VID_WINBOND  0x1050
 #define TPM_VID_STM      0x104A
 #define TPM_VID_ATML     0x1114
+#define TPM_VID_IFX      0x15D1
 
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_BOOTSTRAPPED		= BIT(0),
-- 
2.39.5



