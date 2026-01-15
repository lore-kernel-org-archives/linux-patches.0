Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FE63624C4;
	Thu, 15 Jan 2026 17:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498437; cv=none; b=hGgTG0s0tuGc7ZlMg84BRVrUIvSZ0L0BXgH7hkZt+1eCXuGuw1kTRscFR0flOuZJcOfD7AIhoiEH2tBro25jOgB8bLvucHpzrIRwlZShITkc2F14/Aimgt3Y5Z4PcopsbBUL8K+732td0bIz75/bFIF9W/tzhmu/cJCiO2/Nlk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498437; c=relaxed/simple;
	bh=HP0i7bcxLYTjfyKwVUn9TZyWXoNCGTTqlSmsa9yKKfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9UjQnf0XYYUrRqi98ivk813fMUiN1DsQO0M5qzmUnKuaj9Kbs2Ftl4X02y0qYu0Bq9ySNu+MrAth7EvRfiyjtyysTNtydsC5QWskwWv/IzVQ27CJArl58lS4/iWBuKoIWt337r4l8cylOa8o/yq7Mu7IE35fdKM1PAV7Jymv7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKw1pGV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKw1pGV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966FEC116D0;
	Thu, 15 Jan 2026 17:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498437;
	bh=HP0i7bcxLYTjfyKwVUn9TZyWXoNCGTTqlSmsa9yKKfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKw1pGV4kT4ecAvEoOWW3Y2KCvPr9iKnC/HdJR3b9Fg5ncfIb0fjsqbJWDOlQebL2
	 Ny+vYNyRxtQNpgkJhJQEOLLEiVsbHXHYEK+U2WOWUu/n5otVzOl39yXt/S5sP2xHDh
	 9mtK6Sc20rGUYjKuruYDv1qduCYGTMBu0s5ntTMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lai Yi <yi1.lai@linux.intel.com>,
	Jonathan McDowell <noodles@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 432/554] tpm: Cap the number of PCR banks
Date: Thu, 15 Jan 2026 17:48:18 +0100
Message-ID: <20260115164301.896387597@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>

[ Upstream commit faf07e611dfa464b201223a7253e9dc5ee0f3c9e ]

tpm2_get_pcr_allocation() does not cap any upper limit for the number of
banks. Cap the limit to eight banks so that out of bounds values coming
from external I/O cause on only limited harm.

Cc: stable@vger.kernel.org # v5.10+
Fixes: bcfff8384f6c ("tpm: dynamically allocate the allocated_banks array")
Tested-by: Lai Yi <yi1.lai@linux.intel.com>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
[ added backward-compatible define for TPM_MAX_DIGEST_SIZE to support older ima_init.c code still using that macro name ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c |    1 -
 drivers/char/tpm/tpm1-cmd.c |    5 -----
 drivers/char/tpm/tpm2-cmd.c |    8 +++-----
 include/linux/tpm.h         |    9 ++++++---
 4 files changed, 9 insertions(+), 14 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -269,7 +269,6 @@ static void tpm_dev_release(struct devic
 
 	kfree(chip->work_space.context_buf);
 	kfree(chip->work_space.session_buf);
-	kfree(chip->allocated_banks);
 	kfree(chip);
 }
 
--- a/drivers/char/tpm/tpm1-cmd.c
+++ b/drivers/char/tpm/tpm1-cmd.c
@@ -794,11 +794,6 @@ int tpm1_pm_suspend(struct tpm_chip *chi
  */
 int tpm1_get_pcr_allocation(struct tpm_chip *chip)
 {
-	chip->allocated_banks = kcalloc(1, sizeof(*chip->allocated_banks),
-					GFP_KERNEL);
-	if (!chip->allocated_banks)
-		return -ENOMEM;
-
 	chip->allocated_banks[0].alg_id = TPM_ALG_SHA1;
 	chip->allocated_banks[0].digest_size = hash_digest_size[HASH_ALGO_SHA1];
 	chip->allocated_banks[0].crypto_id = HASH_ALGO_SHA1;
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -574,11 +574,9 @@ ssize_t tpm2_get_pcr_allocation(struct t
 
 	nr_possible_banks = be32_to_cpup(
 		(__be32 *)&buf.data[TPM_HEADER_SIZE + 5]);
-
-	chip->allocated_banks = kcalloc(nr_possible_banks,
-					sizeof(*chip->allocated_banks),
-					GFP_KERNEL);
-	if (!chip->allocated_banks) {
+	if (nr_possible_banks > TPM2_MAX_PCR_BANKS) {
+		pr_err("tpm: out of bank capacity: %u > %u\n",
+		       nr_possible_banks, TPM2_MAX_PCR_BANKS);
 		rc = -ENOMEM;
 		goto out;
 	}
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -25,7 +25,10 @@
 #include <crypto/hash_info.h>
 
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
-#define TPM_MAX_DIGEST_SIZE SHA512_DIGEST_SIZE
+
+#define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
+#define TPM2_MAX_PCR_BANKS	8
+#define TPM_MAX_DIGEST_SIZE	TPM2_MAX_DIGEST_SIZE
 
 struct tpm_chip;
 struct trusted_key_payload;
@@ -51,7 +54,7 @@ enum tpm_algorithms {
 
 struct tpm_digest {
 	u16 alg_id;
-	u8 digest[TPM_MAX_DIGEST_SIZE];
+	u8 digest[TPM2_MAX_DIGEST_SIZE];
 } __packed;
 
 struct tpm_bank_info {
@@ -157,7 +160,7 @@ struct tpm_chip {
 	unsigned int groups_cnt;
 
 	u32 nr_allocated_banks;
-	struct tpm_bank_info *allocated_banks;
+	struct tpm_bank_info allocated_banks[TPM2_MAX_PCR_BANKS];
 #ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];


