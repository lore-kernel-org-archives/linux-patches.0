Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA6F256C9F;
	Thu, 17 Apr 2025 18:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915861; cv=none; b=LzlQj75wG/QP90CBTmWMcan3gr8fDMO4YYTqIkK3jxv39FTmCXZwa9MEoXqV8Ucad0h3abZ2SpdOLU6sus9IYrCwWfUERHDJI7YneMhUtA++pSCmAYA4+iVmaJtydF6jVw0ZccRO1O3gmAcU/GgmwZcqudQTXTHkvPSBowUvaSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915861; c=relaxed/simple;
	bh=MC6ZBRGUDMXOuOYQuzQYtFPPWohKknVA39JU5KzEWao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1vHDvskzhE9B58afQ0zfWCqxpB1G9eVcLukRLk/M+hkyaI83RuuGEH59+5fl8OXNaXrq5b7MS3b6GBV5pjIeXDrdF2ImcgzB2r5QRKyyfB9lvzANA6FjiUHSe+11GnKHraaw/8kKVZ36LSlOSU+2ZODdgLkXJ3dZhn81Eb/sEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXhi0WUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXhi0WUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA319C4CEE7;
	Thu, 17 Apr 2025 18:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915861;
	bh=MC6ZBRGUDMXOuOYQuzQYtFPPWohKknVA39JU5KzEWao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXhi0WUVXznRh6PO3BXtZUq9kNf9Jp8HmJxgY7Ctq+9l216PuUi+gspF8C7735k8B
	 i+chLTEKH5zjrrq2g+tk84XuMzLv/yZsp5D8y0CLji7Djnd5LEUZP31xl3T5SxuMkk
	 zuKd0KVLpkt7ZPtYo9guz+5/L/xST3dsFJ3ABx5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Mike Seo <mikeseohyungjin@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.12 264/393] tpm: do not start chip while suspended
Date: Thu, 17 Apr 2025 19:51:13 +0200
Message-ID: <20250417175118.224912051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

commit 17d253af4c2c8a2acf84bb55a0c2045f150b7dfd upstream.

Checking TPM_CHIP_FLAG_SUSPENDED after the call to tpm_find_get_ops() can
lead to a spurious tpm_chip_start() call:

[35985.503771] i2c i2c-1: Transfer while suspended
[35985.503796] WARNING: CPU: 0 PID: 74 at drivers/i2c/i2c-core.h:56 __i2c_transfer+0xbe/0x810
[35985.503802] Modules linked in:
[35985.503808] CPU: 0 UID: 0 PID: 74 Comm: hwrng Tainted: G        W          6.13.0-next-20250203-00005-gfa0cb5642941 #19 9c3d7f78192f2d38e32010ac9c90fdc71109ef6f
[35985.503814] Tainted: [W]=WARN
[35985.503817] Hardware name: Google Morphius/Morphius, BIOS Google_Morphius.13434.858.0 10/26/2023
[35985.503819] RIP: 0010:__i2c_transfer+0xbe/0x810
[35985.503825] Code: 30 01 00 00 4c 89 f7 e8 40 fe d8 ff 48 8b 93 80 01 00 00 48 85 d2 75 03 49 8b 16 48 c7 c7 0a fb 7c a7 48 89 c6 e8 32 ad b0 fe <0f> 0b b8 94 ff ff ff e9 33 04 00 00 be 02 00 00 00 83 fd 02 0f 5
[35985.503828] RSP: 0018:ffffa106c0333d30 EFLAGS: 00010246
[35985.503833] RAX: 074ba64aa20f7000 RBX: ffff8aa4c1167120 RCX: 0000000000000000
[35985.503836] RDX: 0000000000000000 RSI: ffffffffa77ab0e4 RDI: 0000000000000001
[35985.503838] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[35985.503841] R10: 0000000000000004 R11: 00000001000313d5 R12: ffff8aa4c10f1820
[35985.503843] R13: ffff8aa4c0e243c0 R14: ffff8aa4c1167250 R15: ffff8aa4c1167120
[35985.503846] FS:  0000000000000000(0000) GS:ffff8aa4eae00000(0000) knlGS:0000000000000000
[35985.503849] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[35985.503852] CR2: 00007fab0aaf1000 CR3: 0000000105328000 CR4: 00000000003506f0
[35985.503855] Call Trace:
[35985.503859]  <TASK>
[35985.503863]  ? __warn+0xd4/0x260
[35985.503868]  ? __i2c_transfer+0xbe/0x810
[35985.503874]  ? report_bug+0xf3/0x210
[35985.503882]  ? handle_bug+0x63/0xb0
[35985.503887]  ? exc_invalid_op+0x16/0x50
[35985.503892]  ? asm_exc_invalid_op+0x16/0x20
[35985.503904]  ? __i2c_transfer+0xbe/0x810
[35985.503913]  tpm_cr50_i2c_transfer_message+0x24/0xf0
[35985.503920]  tpm_cr50_i2c_read+0x8e/0x120
[35985.503928]  tpm_cr50_request_locality+0x75/0x170
[35985.503935]  tpm_chip_start+0x116/0x160
[35985.503942]  tpm_try_get_ops+0x57/0x90
[35985.503948]  tpm_find_get_ops+0x26/0xd0
[35985.503955]  tpm_get_random+0x2d/0x80

Don't move forward with tpm_chip_start() inside tpm_try_get_ops(), unless
TPM_CHIP_FLAG_SUSPENDED is not set. tpm_find_get_ops() will return NULL in
such a failure case.

Fixes: 9265fed6db60 ("tpm: Lock TPM chip in tpm_pm_suspend() first")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: stable@vger.kernel.org
Cc: Jerry Snitselaar <jsnitsel@redhat.com>
Cc: Mike Seo <mikeseohyungjin@gmail.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c      |    5 +++++
 drivers/char/tpm/tpm-interface.c |    7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -168,6 +168,11 @@ int tpm_try_get_ops(struct tpm_chip *chi
 		goto out_ops;
 
 	mutex_lock(&chip->tpm_mutex);
+
+	/* tmp_chip_start may issue IO that is denied while suspended */
+	if (chip->flags & TPM_CHIP_FLAG_SUSPENDED)
+		goto out_lock;
+
 	rc = tpm_chip_start(chip);
 	if (rc)
 		goto out_lock;
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -445,18 +445,11 @@ int tpm_get_random(struct tpm_chip *chip
 	if (!chip)
 		return -ENODEV;
 
-	/* Give back zero bytes, as TPM chip has not yet fully resumed: */
-	if (chip->flags & TPM_CHIP_FLAG_SUSPENDED) {
-		rc = 0;
-		goto out;
-	}
-
 	if (chip->flags & TPM_CHIP_FLAG_TPM2)
 		rc = tpm2_get_random(chip, out, max);
 	else
 		rc = tpm1_get_random(chip, out, max);
 
-out:
 	tpm_put_ops(chip);
 	return rc;
 }


