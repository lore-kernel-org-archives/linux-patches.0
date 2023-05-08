Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CAD168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:52:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC9FC433EF;
	Mon,  8 May 2023 09:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539540;
	bh=y73gMz1bfIz38xc80Lv6Jvgt1rs2ikvzsumjn5xF5T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KyqitYhttub+H4UHR36bSSVImw0+DKy6fVvdIpcoYeqbbeVwaStvxRdUlVdl4R5Pp
	 5ZeOKqwT+oRrRUqRSMJuTVCw6rvxmI2eUmSx1QJIAqTpr0k7h6GrPzQdmK+iWyjI0W
	 JbVE9rKIYPobKxubfaOv1SlmptG4XRaoL+CfBZGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Dimov <martin@dmarto.com>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 6.1 037/611] tpm: Add !tpm_amd_is_rng_defective() to the hwrng_unregister() call site
Date: Mon,  8 May 2023 11:37:59 +0200
Message-Id: <20230508094423.014431264@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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

commit bd8621ca1510e6e802df9855bdc35a04a3cfa932 upstream.

The following crash was reported:

[ 1950.279393] list_del corruption, ffff99560d485790->next is NULL
[ 1950.279400] ------------[ cut here ]------------
[ 1950.279401] kernel BUG at lib/list_debug.c:49!
[ 1950.279405] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
[ 1950.279407] CPU: 11 PID: 5886 Comm: modprobe Tainted: G O 6.2.8_1 #1
[ 1950.279409] Hardware name: Gigabyte Technology Co., Ltd. B550M AORUS PRO-P/B550M AORUS PRO-P,
BIOS F15c 05/11/2022
[ 1950.279410] RIP: 0010:__list_del_entry_valid+0x59/0xc0
[ 1950.279415] Code: 48 8b 01 48 39 f8 75 5a 48 8b 72 08 48 39 c6 75 65 b8 01 00 00 00 c3 cc cc cc
cc 48 89 fe 48 c7 c7 08 a8 13 9e e8 b7 0a bc ff <0f> 0b 48 89 fe 48 c7 c7 38 a8 13 9e e8 a6 0a bc
ff 0f 0b 48 89 fe
[ 1950.279416] RSP: 0018:ffffa96d05647e08 EFLAGS: 00010246
[ 1950.279418] RAX: 0000000000000033 RBX: ffff99560d485750 RCX: 0000000000000000
[ 1950.279419] RDX: 0000000000000000 RSI: ffffffff9e107c59 RDI: 00000000ffffffff
[ 1950.279420] RBP: ffffffffc19c5168 R08: 0000000000000000 R09: ffffa96d05647cc8
[ 1950.279421] R10: 0000000000000003 R11: ffffffff9ea2a568 R12: 0000000000000000
[ 1950.279422] R13: ffff99560140a2e0 R14: ffff99560127d2e0 R15: 0000000000000000
[ 1950.279422] FS: 00007f67da795380(0000) GS:ffff995d1f0c0000(0000) knlGS:0000000000000000
[ 1950.279424] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1950.279424] CR2: 00007f67da7e65c0 CR3: 00000001feed2000 CR4: 0000000000750ee0
[ 1950.279426] PKRU: 55555554
[ 1950.279426] Call Trace:
[ 1950.279428] <TASK>
[ 1950.279430] hwrng_unregister+0x28/0xe0 [rng_core]
[ 1950.279436] tpm_chip_unregister+0xd5/0xf0 [tpm]

Add the forgotten !tpm_amd_is_rng_defective() invariant to the
hwrng_unregister() call site inside tpm_chip_unregister().

Cc: stable@vger.kernel.org
Reported-by: Martin Dimov <martin@dmarto.com>
Link: https://lore.kernel.org/linux-integrity/3d1d7e9dbfb8c96125bc93b6b58b90a7@dmarto.com/
Fixes: f1324bbc4011 ("tpm: disable hwrng for fTPM on some AMD designs")
Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
Tested-by: Martin Dimov <martin@dmarto.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm-chip.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -678,7 +678,8 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
 void tpm_chip_unregister(struct tpm_chip *chip)
 {
 	tpm_del_legacy_sysfs(chip);
-	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM) && !tpm_is_firmware_upgrade(chip))
+	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM) && !tpm_is_firmware_upgrade(chip) &&
+	    !tpm_amd_is_rng_defective(chip))
 		hwrng_unregister(&chip->hwrng);
 	tpm_bios_log_teardown(chip);
 	if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip))


