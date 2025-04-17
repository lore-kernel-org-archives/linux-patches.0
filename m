Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA81256C6E;
	Thu, 17 Apr 2025 18:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914279; cv=none; b=t/DknIVU3WpwUXMEq0u3eU0xfeCT+YL7mx3FGC/2AO84fBhIQ3o5bOjsH0VIP0xzJob89C/6KFd3BP6bxuGrb0H5hBXhKW6k3v6Qsf1EudG5EpntIhzIeuqBmN9jPauPbg6U+c5RqDN91Y+HWwfsUsR+JEjyRueYl8swAkC3270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914279; c=relaxed/simple;
	bh=EcFFGlB2GeqqUroYtrY3ziKLrLxy/CzTB293S5J4/rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbcgfiKdJGysFA62Cv1SNbZvjOqPlanJKGsjiPTkGSBDnYzTYyqzv11Rs8TKn1w5Gn7px9O0QHZukFMJZgoZYXmz1x3B+NzkNNo/uggAWlQhRlcHmjw+iN6HlBzS1hloOA5dJYrCZsCyA8Y7CZwsWuW8KZ8698dZQAFya7VlVZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwtFWAQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwtFWAQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0766BC4CEE4;
	Thu, 17 Apr 2025 18:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914279;
	bh=EcFFGlB2GeqqUroYtrY3ziKLrLxy/CzTB293S5J4/rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwtFWAQEc3FROOq2fxCAiGBSjFAmJPUZ/f7Vhj94uj2bZr97YRzaMIYq9hJbtUVES
	 l1FSKmPCR6IuT3VqYYi25/MlnUSy491lT12hnihNkxuF0NATcMcqIA4zXbwwclhLYO
	 Xdk5g8yT1eGh7tNClGfGdweOtzksSu9SC7HJ1xLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan McDowell <noodles@meta.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 164/414] tpm, tpm_tis: Workaround failed command reception on Infineon devices
Date: Thu, 17 Apr 2025 19:48:42 +0200
Message-ID: <20250417175118.038220907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index fdef214b9f6bf..4cc2ab2d16cc5 100644
--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -464,7 +464,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, const u8 *buf, size_t len)
 
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
@@ -481,7 +484,10 @@ static int tpm_tis_send_data(struct tpm_chip *chip, const u8 *buf, size_t len)
 
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
@@ -546,9 +552,11 @@ static int tpm_tis_send_main(struct tpm_chip *chip, const u8 *buf, size_t len)
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
 
 	/* go and do it */
@@ -1144,6 +1152,9 @@ int tpm_tis_core_init(struct device *dev, struct tpm_tis_data *priv, int irq,
 		priv->timeout_max = TIS_TIMEOUT_MAX_ATML;
 	}
 
+	if (priv->manufacturer_id == TPM_VID_IFX)
+		set_bit(TPM_TIS_STATUS_VALID_RETRY, &priv->flags);
+
 	if (is_bsw()) {
 		priv->ilb_base_addr = ioremap(INTEL_LEGACY_BLK_BASE_ADDR,
 					ILB_REMAP_SIZE);
diff --git a/drivers/char/tpm/tpm_tis_core.h b/drivers/char/tpm/tpm_tis_core.h
index 690ad8e9b7319..970d02c337c7f 100644
--- a/drivers/char/tpm/tpm_tis_core.h
+++ b/drivers/char/tpm/tpm_tis_core.h
@@ -89,6 +89,7 @@ enum tpm_tis_flags {
 	TPM_TIS_INVALID_STATUS		= 1,
 	TPM_TIS_DEFAULT_CANCELLATION	= 2,
 	TPM_TIS_IRQ_TESTED		= 3,
+	TPM_TIS_STATUS_VALID_RETRY	= 4,
 };
 
 struct tpm_tis_data {
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index 20a40ade80308..6c3125300c009 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -335,6 +335,7 @@ enum tpm2_cc_attrs {
 #define TPM_VID_WINBOND  0x1050
 #define TPM_VID_STM      0x104A
 #define TPM_VID_ATML     0x1114
+#define TPM_VID_IFX      0x15D1
 
 enum tpm_chip_flags {
 	TPM_CHIP_FLAG_BOOTSTRAPPED		= BIT(0),
-- 
2.39.5



