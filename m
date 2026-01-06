Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67880355024;
	Tue,  6 Jan 2026 17:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720210; cv=none; b=Pu8lKZbZYwMqIGKkCl0uI6LA1IgkUnvdYtddnlsMM8bdiPTLzJm95CJkxhe/DL65uWs7E9rYuXbGXyCGizDG9cLturxDy2k97yegTF47frzqtsItlxpVzcHoP9kAsYgwyLb7u9izys1BR2kEYFfePqI7RH2Xl/XHgR3aSgvA0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720210; c=relaxed/simple;
	bh=XONHfJYZaf8ipkFMoPIZQ8rjxjedR+uUABysHMdPk58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P9pK8LkS6SMPvb126vmkgwzBIEf38WIs99b5n9MjvQRkNL/rjNcNn+a/4qx8dM2Su+0Rm5vVDnmVf1zpN1SyBCO8jyX+enoaNHKwalif5YQBYhgyQlgNANQG9tkCZUOlz3iHOiqs4cziLzeFzm22xu3slzgCk4An/OLaWpHAuWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OWgB2aWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OWgB2aWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF43C19423;
	Tue,  6 Jan 2026 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720209;
	bh=XONHfJYZaf8ipkFMoPIZQ8rjxjedR+uUABysHMdPk58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OWgB2aWRQKEW6cPTcAxnEzCID2TpWsKIhwnBJwrnksFznNXY3jxOWw5lgc4WhQ316
	 cwCh7xnZ0SaOHthgL0ezvyD4xSZ1kHvDwJYLmV2ZeumiBdfE/ZAuezY18n3RwblzeJ
	 yZgIFdN4oByLNDx9SIKWg0NGo4OWO/f3kUjWZMJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lai Yi <yi1.lai@linux.intel.com>,
	Jonathan McDowell <noodles@meta.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
Subject: [PATCH 6.12 166/567] tpm: Cap the number of PCR banks
Date: Tue,  6 Jan 2026 17:59:08 +0100
Message-ID: <20260106170457.466752035@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>

commit faf07e611dfa464b201223a7253e9dc5ee0f3c9e upstream.

tpm2_get_pcr_allocation() does not cap any upper limit for the number of
banks. Cap the limit to eight banks so that out of bounds values coming
from external I/O cause on only limited harm.

Cc: stable@vger.kernel.org # v5.10+
Fixes: bcfff8384f6c ("tpm: dynamically allocate the allocated_banks array")
Tested-by: Lai Yi <yi1.lai@linux.intel.com>
Reviewed-by: Jonathan McDowell <noodles@meta.com>
Reviewed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@opinsys.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c |    1 -
 drivers/char/tpm/tpm1-cmd.c |    5 -----
 drivers/char/tpm/tpm2-cmd.c |    8 +++-----
 include/linux/tpm.h         |    8 +++++---
 4 files changed, 8 insertions(+), 14 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -282,7 +282,6 @@ static void tpm_dev_release(struct devic
 
 	kfree(chip->work_space.context_buf);
 	kfree(chip->work_space.session_buf);
-	kfree(chip->allocated_banks);
 #ifdef CONFIG_TCG_TPM2_HMAC
 	kfree(chip->auth);
 #endif
--- a/drivers/char/tpm/tpm1-cmd.c
+++ b/drivers/char/tpm/tpm1-cmd.c
@@ -799,11 +799,6 @@ int tpm1_pm_suspend(struct tpm_chip *chi
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
@@ -602,11 +602,9 @@ ssize_t tpm2_get_pcr_allocation(struct t
 
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
@@ -26,7 +26,9 @@
 #include <crypto/aes.h>
 
 #define TPM_DIGEST_SIZE 20	/* Max TPM v1.2 PCR size */
-#define TPM_MAX_DIGEST_SIZE SHA512_DIGEST_SIZE
+
+#define TPM2_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
+#define TPM2_MAX_PCR_BANKS	8
 
 struct tpm_chip;
 struct trusted_key_payload;
@@ -68,7 +70,7 @@ enum tpm2_curves {
 
 struct tpm_digest {
 	u16 alg_id;
-	u8 digest[TPM_MAX_DIGEST_SIZE];
+	u8 digest[TPM2_MAX_DIGEST_SIZE];
 } __packed;
 
 struct tpm_bank_info {
@@ -188,7 +190,7 @@ struct tpm_chip {
 	unsigned int groups_cnt;
 
 	u32 nr_allocated_banks;
-	struct tpm_bank_info *allocated_banks;
+	struct tpm_bank_info allocated_banks[TPM2_MAX_PCR_BANKS];
 #ifdef CONFIG_ACPI
 	acpi_handle acpi_dev_handle;
 	char ppi_version[TPM_PPI_VERSION_LEN + 1];


