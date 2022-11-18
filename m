Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4AD443B
	for <patches@lists.linux.dev>; Fri, 18 Nov 2022 13:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FE1C433C1;
	Fri, 18 Nov 2022 13:33:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RJUXvtvl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1668778383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nh+wKp8yEnal64w+3O1z4UzVRdj34fdKJzoeu8AGeCc=;
	b=RJUXvtvljmI7nM8jcrYjPJSKIeKiEHKTM0jT3pZbVZlfbnEdta+WRkCwltOF8J8+FwHPvq
	/+3ggZVwSf20Q0cmbQyDlGNU1SSUYo70B34KakKLgRUCu7nO0a9tVhojBiu0pzZMdQ2XVj
	z7cfy8Phi9lOzGsdGyNKQ7R98T1JaOI=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c42b9edb (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Fri, 18 Nov 2022 13:33:03 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-efi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2 5/5] efi: random: refresh non-volatile random seed when RNG is initialized
Date: Fri, 18 Nov 2022 14:32:39 +0100
Message-Id: <20221118133239.2515648-6-Jason@zx2c4.com>
In-Reply-To: <20221118133239.2515648-1-Jason@zx2c4.com>
References: <20221118133239.2515648-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

EFI has a rather unique benefit that it has access to some limited
non-volatile storage, where the kernel can store a random seed. Register
a notification for when the RNG is initialized, and at that point, store
a new random seed.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/firmware/efi/efi.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index f12cc29bd4b8..f8edf6164833 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -337,6 +337,24 @@ static void __init efi_debugfs_init(void)
 static inline void efi_debugfs_init(void) {}
 #endif
 
+static void refresh_nv_rng_seed(struct work_struct *work)
+{
+	u8 seed[EFI_RANDOM_SEED_SIZE];
+
+	get_random_bytes(seed, sizeof(seed));
+	efi.set_variable(LINUX_EFI_RANDOM_NV_SEED_VAR, &LINUX_EFI_RANDOM_SEED_TABLE_GUID,
+			 EFI_VARIABLE_NON_VOLATILE | EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS, sizeof(seed), seed);
+	memzero_explicit(seed, sizeof(seed));
+}
+static int refresh_nv_rng_seed_notification(struct notifier_block *nb, unsigned long action, void *data)
+{
+	static DECLARE_WORK(work, refresh_nv_rng_seed);
+	schedule_work(&work);
+	return 0;
+}
+static struct notifier_block refresh_nv_rng_seed_nb = { .notifier_call = refresh_nv_rng_seed_notification };
+
 /*
  * We register the efi subsystem with the firmware subsystem and the
  * efivars subsystem with the efi subsystem, if the system was booted with
@@ -413,6 +431,7 @@ static int __init efisubsys_init(void)
 		platform_device_register_simple("efi_secret", 0, NULL, 0);
 #endif
 
+	execute_with_initialized_rng(&refresh_nv_rng_seed_nb);
 	return 0;
 
 err_remove_group:
-- 
2.38.1

