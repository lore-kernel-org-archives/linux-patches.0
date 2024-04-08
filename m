Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2E971753;
	Mon,  8 Apr 2024 13:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583640; cv=none; b=IPLKBgymMKJEz/JxwSXa5zcH+b2e2mTPHUawPD1fPGaGauqfj6Fg8MRV+aAjF/GNOnb3wSadp8MP4KEBZOez/Mc63t6TjDx/Q7eQZrUuFTCMtVZIs8+pld+++9A3/vcg55NJe5UpUHYR8E2vOVNx7dUNh2dRmUiDXUpGD2xL8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583640; c=relaxed/simple;
	bh=LIFtvVGpy5xr4UrRrMkGzRMNsYo4/j6/J91cjvr+aUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K77Qg22YPy4FUZ2H+NvlQFbgwv3L31PE4mkt81SdrZVwUSN5FHZh+6hXS+iZ+RY1bDwP0HoiFrIxInhRAoIp2FOUrp5mEiU4pYN+MROwcWDeemzu0PhM/iyeXcgrE85Jg3w//zRQhquzQgjGRVT5w+Tk15UpvhKypTtzCmTEYYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTk/PtJv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTk/PtJv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4A6C433F1;
	Mon,  8 Apr 2024 13:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583640;
	bh=LIFtvVGpy5xr4UrRrMkGzRMNsYo4/j6/J91cjvr+aUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MTk/PtJvIGUhFTwmBWW7M3G1TrYCyAWDvZe6YvcQa7eZy6UIxKg24bqfg3OJhM6FR
	 uwHWLNGf5QU9RYR1vDkLkYNEIjhco3bvrOxnzusE6Rng6xntIcA76x/id7y92B/XSE
	 Xc16Ta+A/f+QJUO6qR2943+HhvliXbXNYyR1U2d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Elena Reshetova <elena.reshetova@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 218/252] x86/coco: Require seeding RNG with RDRAND on CoCo systems
Date: Mon,  8 Apr 2024 14:58:37 +0200
Message-ID: <20240408125313.424877985@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 99485c4c026f024e7cb82da84c7951dbe3deb584 upstream.

There are few uses of CoCo that don't rely on working cryptography and
hence a working RNG. Unfortunately, the CoCo threat model means that the
VM host cannot be trusted and may actively work against guests to
extract secrets or manipulate computation. Since a malicious host can
modify or observe nearly all inputs to guests, the only remaining source
of entropy for CoCo guests is RDRAND.

If RDRAND is broken -- due to CPU hardware fault -- the RNG as a whole
is meant to gracefully continue on gathering entropy from other sources,
but since there aren't other sources on CoCo, this is catastrophic.
This is mostly a concern at boot time when initially seeding the RNG, as
after that the consequences of a broken RDRAND are much more
theoretical.

So, try at boot to seed the RNG using 256 bits of RDRAND output. If this
fails, panic(). This will also trigger if the system is booted without
RDRAND, as RDRAND is essential for a safe CoCo boot.

Add this deliberately to be "just a CoCo x86 driver feature" and not
part of the RNG itself. Many device drivers and platforms have some
desire to contribute something to the RNG, and add_device_randomness()
is specifically meant for this purpose.

Any driver can call it with seed data of any quality, or even garbage
quality, and it can only possibly make the quality of the RNG better or
have no effect, but can never make it worse.

Rather than trying to build something into the core of the RNG, consider
the particular CoCo issue just a CoCo issue, and therefore separate it
all out into driver (well, arch/platform) code.

  [ bp: Massage commit message. ]

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Elena Reshetova <elena.reshetova@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240326160735.73531-1-Jason@zx2c4.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/core.c        |   41 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/coco.h |    2 ++
 arch/x86/kernel/setup.c     |    2 ++
 3 files changed, 45 insertions(+)

--- a/arch/x86/coco/core.c
+++ b/arch/x86/coco/core.c
@@ -3,13 +3,17 @@
  * Confidential Computing Platform Capability checks
  *
  * Copyright (C) 2021 Advanced Micro Devices, Inc.
+ * Copyright (C) 2024 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  */
 
 #include <linux/export.h>
 #include <linux/cc_platform.h>
+#include <linux/string.h>
+#include <linux/random.h>
 
+#include <asm/archrandom.h>
 #include <asm/coco.h>
 #include <asm/processor.h>
 
@@ -148,3 +152,40 @@ u64 cc_mkdec(u64 val)
 	}
 }
 EXPORT_SYMBOL_GPL(cc_mkdec);
+
+__init void cc_random_init(void)
+{
+	/*
+	 * The seed is 32 bytes (in units of longs), which is 256 bits, which
+	 * is the security level that the RNG is targeting.
+	 */
+	unsigned long rng_seed[32 / sizeof(long)];
+	size_t i, longs;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		return;
+
+	/*
+	 * Since the CoCo threat model includes the host, the only reliable
+	 * source of entropy that can be neither observed nor manipulated is
+	 * RDRAND. Usually, RDRAND failure is considered tolerable, but since
+	 * CoCo guests have no other unobservable source of entropy, it's
+	 * important to at least ensure the RNG gets some initial random seeds.
+	 */
+	for (i = 0; i < ARRAY_SIZE(rng_seed); i += longs) {
+		longs = arch_get_random_longs(&rng_seed[i], ARRAY_SIZE(rng_seed) - i);
+
+		/*
+		 * A zero return value means that the guest doesn't have RDRAND
+		 * or the CPU is physically broken, and in both cases that
+		 * means most crypto inside of the CoCo instance will be
+		 * broken, defeating the purpose of CoCo in the first place. So
+		 * just panic here because it's absolutely unsafe to continue
+		 * executing.
+		 */
+		if (longs == 0)
+			panic("RDRAND is defective.");
+	}
+	add_device_randomness(rng_seed, sizeof(rng_seed));
+	memzero_explicit(rng_seed, sizeof(rng_seed));
+}
--- a/arch/x86/include/asm/coco.h
+++ b/arch/x86/include/asm/coco.h
@@ -22,6 +22,7 @@ static inline void cc_set_mask(u64 mask)
 
 u64 cc_mkenc(u64 val);
 u64 cc_mkdec(u64 val);
+void cc_random_init(void);
 #else
 static inline u64 cc_mkenc(u64 val)
 {
@@ -32,6 +33,7 @@ static inline u64 cc_mkdec(u64 val)
 {
 	return val;
 }
+static inline void cc_random_init(void) { }
 #endif
 
 #endif /* _ASM_X86_COCO_H */
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -35,6 +35,7 @@
 #include <asm/bios_ebda.h>
 #include <asm/bugs.h>
 #include <asm/cacheinfo.h>
+#include <asm/coco.h>
 #include <asm/cpu.h>
 #include <asm/efi.h>
 #include <asm/gart.h>
@@ -1120,6 +1121,7 @@ void __init setup_arch(char **cmdline_p)
 	 * memory size.
 	 */
 	sev_setup_arch();
+	cc_random_init();
 
 	efi_fake_memmap();
 	efi_find_mirror();


