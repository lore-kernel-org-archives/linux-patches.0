Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE95F8476
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DAE8C4339E;
	Tue, 28 Mar 2023 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680014694;
	bh=udEl2j5YVWeEbUuQRN9FybKotgtF6vf/q4Y+qacbC7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmVfRbJQ4ZZig0LQjd3foQ2yzJ9rgfaKodcjy3SIWLL3NJKEzQjerKwjPQUR3Fn80
	 e7rEDCh9sNSIsUmFGgcKNyTt4mowifEhCs965Hvf8erOL3FzrlpoDi/dU8c2pU7vH/
	 Ol6Kt74tlWLz1heO1xzMz+zQZCCiQ+81qoWKQHBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawn.guo@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 019/240] efi: earlycon: Reprobe after parsing config tables
Date: Tue, 28 Mar 2023 16:39:42 +0200
Message-Id: <20230328142620.456101490@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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

[ Upstream commit 8b3a149db461d3286d1e211112de3b44ccaeaf71 ]

Commit 732ea9db9d8a ("efi: libstub: Move screen_info handling to common
code") reorganized the earlycon handling so that all architectures pass
the screen_info data via a EFI config table instead of populating struct
screen_info directly, as the latter is only possible when the EFI stub
is baked into the kernel (and not into the decompressor).

However, this means that struct screen_info may not have been populated
yet by the time the earlycon probe takes place, and this results in a
non-functional early console.

So let's probe again right after parsing the config tables and
populating struct screen_info. Note that this means that earlycon output
starts a bit later than before, and so it may fail to capture issues
that occur while doing the early EFI initialization.

Fixes: 732ea9db9d8a ("efi: libstub: Move screen_info handling to common code")
Reported-by: Shawn Guo <shawn.guo@linaro.org>
Tested-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/earlycon.c | 16 +++++++++++++---
 drivers/firmware/efi/efi-init.c |  3 +++
 include/linux/efi.h             |  1 +
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/earlycon.c b/drivers/firmware/efi/earlycon.c
index 4d6c5327471ac..1bc6328646944 100644
--- a/drivers/firmware/efi/earlycon.c
+++ b/drivers/firmware/efi/earlycon.c
@@ -204,6 +204,14 @@ efi_earlycon_write(struct console *con, const char *str, unsigned int num)
 	}
 }
 
+static bool __initdata fb_probed;
+
+void __init efi_earlycon_reprobe(void)
+{
+	if (fb_probed)
+		setup_earlycon("efifb");
+}
+
 static int __init efi_earlycon_setup(struct earlycon_device *device,
 				     const char *opt)
 {
@@ -211,15 +219,17 @@ static int __init efi_earlycon_setup(struct earlycon_device *device,
 	u16 xres, yres;
 	u32 i;
 
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+	fb_wb = opt && !strcmp(opt, "ram");
+
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI) {
+		fb_probed = true;
 		return -ENODEV;
+	}
 
 	fb_base = screen_info.lfb_base;
 	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
 		fb_base |= (u64)screen_info.ext_lfb_base << 32;
 
-	fb_wb = opt && !strcmp(opt, "ram");
-
 	si = &screen_info;
 	xres = si->lfb_width;
 	yres = si->lfb_height;
diff --git a/drivers/firmware/efi/efi-init.c b/drivers/firmware/efi/efi-init.c
index 1639159493e3e..5cb7fb4549f0c 100644
--- a/drivers/firmware/efi/efi-init.c
+++ b/drivers/firmware/efi/efi-init.c
@@ -72,6 +72,9 @@ static void __init init_screen_info(void)
 		if (memblock_is_map_memory(screen_info.lfb_base))
 			memblock_mark_nomap(screen_info.lfb_base,
 					    screen_info.lfb_size);
+
+		if (IS_ENABLED(CONFIG_EFI_EARLYCON))
+			efi_earlycon_reprobe();
 	}
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 98598bd1d2fa5..ac22f7ca195a4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -688,6 +688,7 @@ efi_guid_to_str(efi_guid_t *guid, char *out)
 }
 
 extern void efi_init (void);
+extern void efi_earlycon_reprobe(void);
 #ifdef CONFIG_EFI
 extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if possible */
 #else
-- 
2.39.2



