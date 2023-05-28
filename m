Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FAA569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:29:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F96C4339B;
	Sun, 28 May 2023 19:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302190;
	bh=5m6EjNqXwzkcM4pOKEF2a6edBvuv9714xfiXJKGJ780=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7b3+N2prO2YYwfUaRXzMmx3O7FBZGe8tN02RIUGD+sz0BVZzvQqW8HyrzYl677uG
	 Z3T0TnV6t9TVvu7YqbOY1nf68cFo6QwaCHuRO6kzH2Vvdys+OGYwoRlg3RTBzTsptg
	 8fQd8frH6CuGgEndmJaeyMW52rg4V9Fd3GWcGvg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 008/127] tpm: Prevent hwrng from activating during resume
Date: Sun, 28 May 2023 20:09:44 +0100
Message-Id: <20230528190836.475610979@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
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
index 9c0a6aad81140..5be91591cb3b2 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -572,6 +572,10 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
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
index 77693389c3f9a..6a1e8f1572551 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -282,6 +282,7 @@ enum tpm_chip_flags {
 	TPM_CHIP_FLAG_ALWAYS_POWERED		= BIT(5),
 	TPM_CHIP_FLAG_FIRMWARE_POWER_MANAGED	= BIT(6),
 	TPM_CHIP_FLAG_FIRMWARE_UPGRADE		= BIT(7),
+	TPM_CHIP_FLAG_SUSPENDED			= BIT(8),
 };
 
 #define to_tpm_chip(d) container_of(d, struct tpm_chip, dev)
-- 
2.39.2



