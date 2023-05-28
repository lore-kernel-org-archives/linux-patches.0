Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B1A611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60B9C4339B;
	Sun, 28 May 2023 19:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302468;
	bh=RlRDrxaw2aVbLPnaHvarkqZOVfQ6nQIry3BDRe9jlzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWlg1dPkJAzjKsofGsS4y5B55koHFj0bH9zqEKpJJXr8kfDONj1TspAkS4Asgi08z
	 nR169dAOWlPVMCDMYZ6wr8buEjocVGyjqaLt3+yWsGUs7oqqlu0yVsMV/Oa2jLRB8l
	 lAVLy4TwGBGFekVwRUtk0fEaf043KKDc3Tw42AkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/119] tpm: Prevent hwrng from activating during resume
Date: Sun, 28 May 2023 20:10:07 +0100
Message-Id: <20230528190835.610140251@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit 99d46450625590d410f86fe4660a5eff7d3b8343 ]

Set TPM_CHIP_FLAG_SUSPENDED in tpm_pm_suspend() and reset in
tpm_pm_resume(). While the flag is set, tpm_hwrng() gives back zero
bytes. This prevents hwrng from racing during resume.

Cc: stable@vger.kernel.org
Fixes: 6e592a065d51 ("tpm: Move Linux RNG connection to hwrng")
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm-chip.c      |  4 ++++
 drivers/char/tpm/tpm-interface.c | 10 ++++++++++
 include/linux/tpm.h              |  1 +
 3 files changed, 15 insertions(+)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 31d8074821524..95d847c9de79a 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -568,6 +568,10 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
 {
 	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
 
+	/* Give back zero bytes, as TPM chip has not yet fully resumed: */
+	if (chip->flags & TPM_CHIP_FLAG_SUSPENDED)
+		return 0;
+
 	return tpm_get_random(chip, data, max);
 }
 
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 7e513b7718320..0f941cb32eb17 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -412,6 +412,8 @@ int tpm_pm_suspend(struct device *dev)
 	}
 
 suspended:
+	chip->flags |= TPM_CHIP_FLAG_SUSPENDED;
+
 	if (rc)
 		dev_err(dev, "Ignoring error %d while suspending\n", rc);
 	return 0;
@@ -429,6 +431,14 @@ int tpm_pm_resume(struct device *dev)
 	if (chip == NULL)
 		return -ENODEV;
 
+	chip->flags &= ~TPM_CHIP_FLAG_SUSPENDED;
+
+	/*
+	 * Guarantee that SUSPENDED is written last, so that hwrng does not
+	 * activate before the chip has been fully resumed.
+	 */
+	wmb();
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_pm_resume);
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index cea64d58ef9f7..4e22e4f4cec85 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -281,6 +281,7 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_ALWAYS_POWERED		= BIT(5),
 	TPM_CHIP_FLAG_FIRMWARE_POWER_MANAGED	= BIT(6),
 	TPM_CHIP_FLAG_FIRMWARE_UPGRADE		= BIT(7),
+	TPM_CHIP_FLAG_SUSPENDED			= BIT(8),
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
-- 
2.39.2



