Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9F715CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8CFC433D6;
	Tue,  8 Nov 2022 14:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916971;
	bh=J+lXettr8JKf+v4ZiEaNDEMz1c+HOy3EPyr5uTWUKrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWRsuYUxN/PSCfD7UNgYYgC/E4UZRr/Fa7YLolwn5VPTCQWJcrOvKP8yNX8fSImlo
	 QPWMYUj3JyDr4YB6jE2oRc59zAJ7xTUlIRNRoxQ7yysZ8s+P+nPDSgnuGvGax9hqRA
	 TPrcxoO45gDPoWd+HKBUDJj7BnAFPBfYA4rEDhjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 6.0 150/197] efi: random: reduce seed size to 32 bytes
Date: Tue,  8 Nov 2022 14:39:48 +0100
Message-Id: <20221108133401.789280122@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

commit 161a438d730dade2ba2b1bf8785f0759aba4ca5f upstream.

We no longer need at least 64 bytes of random seed to permit the early
crng init to complete. The RNG is now based on Blake2s, so reduce the
EFI seed size to the Blake2s hash size, which is sufficient for our
purposes.

While at it, drop the READ_ONCE(), which was supposed to prevent size
from being evaluated after seed was unmapped. However, this cannot
actually happen, so READ_ONCE() is unnecessary here.

Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/efi.c |    2 +-
 include/linux/efi.h        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -608,7 +608,7 @@ int __init efi_config_parse_tables(const
 
 		seed = early_memremap(efi_rng_seed, sizeof(*seed));
 		if (seed != NULL) {
-			size = READ_ONCE(seed->size);
+			size = min(seed->size, EFI_RANDOM_SEED_SIZE);
 			early_memunmap(seed, sizeof(*seed));
 		} else {
 			pr_err("Could not map UEFI random seed!\n");
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1192,7 +1192,7 @@ efi_status_t efi_random_get_seed(void);
 	arch_efi_call_virt_teardown();					\
 })
 
-#define EFI_RANDOM_SEED_SIZE		64U
+#define EFI_RANDOM_SEED_SIZE		32U // BLAKE2S_HASH_SIZE
 
 struct linux_efi_random_seed {
 	u32	size;


