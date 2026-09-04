Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBE3515D2;
	Fri,  4 Sep 2026 05:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498339; cv=none; b=hhioQErtQEdHw8fZNWnYUlt3nbRISWO1qZG9rC6+CSj8TAR22WfaAQXwcPcgVmd93d324LZEhiQd3LkWPG1G+RQ/FUh1sI7Mkb7tMeYuFTETKQeXZyzQBKCSi3+KgA1rsX22T5TAM9RzT8WTFQbtCB9G87Lyu4OqmU784PZqEac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498339; c=relaxed/simple;
	bh=nzCGzvzX6XHuObztr7ub4BHi4lSQK95+SNRBqwhd/s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhIBMkuavSFLG8QFO+JLFj8mlozdOhI/DW2tPkm0KHqecain1Kgijy6GvhS5L9rXm2+RKsMWKfEvZZpgcR3pOH6uzcJaZ0usRjKNn/LquC8eaDVsc3fADrgos7oMuohqDwTJpVUKUyzHd2O1CBM1Qz8JU+hd3zOh5A5C1uS+w5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCt7uMfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCt7uMfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A411F00A3E;
	Fri,  4 Sep 2026 05:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498338;
	bh=tXudOnGMMF2BMfX43DSetSmP9kPI9jNbt8buj49h+Z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sCt7uMfMnkNZ2e0Sq0jGcI82NdHVTma1qOnh7oXmb52/ALtkxGBTuEV64pWxgagHK
	 rGJIz/a18P1BqbrJwi0wBGIvXmkbdhvYnnwt6RUeDBLoamFu/HDeU2w21eChoLqyPW
	 LzVATuOT7g4D6bX8dvAydE2h9CSS4sFsYOSI43m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: [PATCH 7.2 027/713] rust: bug: skip arch-specific asm in `testlib` builds
Date: Fri,  4 Sep 2026 06:49:55 +0200
Message-ID: <20260904045804.438654783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 5d9668f3930609ead91f39b059ef4fe53db04942 upstream.

Running `make rusttest` with `ARCH=` set to an architecture other than
the host's fails, e.g. `ARCH=arm64` on an x86_64 host:

error: invalid instruction mnemonic 'brk'
  --> rust/kernel/bug.rs:63:17
   |
63 | /                 concat!(
64 | |                     "/* {size} */",
65 | |                     include!(concat!(env!("OBJTREE"), "/rust/kernel/generated_arch_warn_asm.rs")),
66 | |                     include!(concat!(env!("OBJTREE"), "/rust/kernel/generated_arch_reachable_asm.rs")));
   | |_______________________________________________________________________________________________________^
   |
note: instantiated into assembly here
  --> <inline asm>:1:115
   |
 1 |     /* 8 */.pushsection __bug_table,"aw"; .align 2; 14470: .long 14471f - .;.short 2305;.align 2; .popsection; 14471:brk 0x800
   |                                                                                                                      ^^^

The reason is that `rusttest` builds the `kernel` crate as a host
library: it passes the `CONFIG_*` cfgs of the configured architecture,
but not `--target`, so code generation happens for the
host. `warn_flags!` then selects the arch-specific inline asm arm
based on `CONFIG_*`, and the host assembler rejects it.

This does not happen with the current `master` because `warn_on!` has
no user inside the `kernel` crate itself yet, but it will as soon as
one is added.

Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/all/CANiq72n4=fz=JNKY0Jdm8BnLa=RmHB2B7s0bO47YTJ7hygqBZg@mail.gmail.com/
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: stable@vger.kernel.org
Fixes: dff64b072708 ("rust: Add warn_on macro")
Link: https://patch.msgid.link/20260808022608.1125174-1-tomo@flapping.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bug.rs |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -8,6 +8,7 @@
 
 #[macro_export]
 #[doc(hidden)]
+#[cfg(not(testlib))]
 #[cfg(all(CONFIG_BUG, not(CONFIG_UML), not(CONFIG_LOONGARCH), not(CONFIG_ARM)))]
 #[cfg(CONFIG_DEBUG_BUGVERBOSE)]
 macro_rules! warn_flags {
@@ -47,6 +48,7 @@ macro_rules! warn_flags {
 
 #[macro_export]
 #[doc(hidden)]
+#[cfg(not(testlib))]
 #[cfg(all(CONFIG_BUG, not(CONFIG_UML), not(CONFIG_LOONGARCH), not(CONFIG_ARM)))]
 #[cfg(not(CONFIG_DEBUG_BUGVERBOSE))]
 macro_rules! warn_flags {
@@ -73,6 +75,7 @@ macro_rules! warn_flags {
 
 #[macro_export]
 #[doc(hidden)]
+#[cfg(not(testlib))]
 #[cfg(all(CONFIG_BUG, CONFIG_UML))]
 macro_rules! warn_flags {
     ($file:expr, $flags:expr) => {
@@ -91,6 +94,7 @@ macro_rules! warn_flags {
 
 #[macro_export]
 #[doc(hidden)]
+#[cfg(not(testlib))]
 #[cfg(all(CONFIG_BUG, any(CONFIG_LOONGARCH, CONFIG_ARM)))]
 macro_rules! warn_flags {
     ($file:expr, $flags:expr) => {
@@ -101,7 +105,7 @@ macro_rules! warn_flags {
 
 #[macro_export]
 #[doc(hidden)]
-#[cfg(not(CONFIG_BUG))]
+#[cfg(any(testlib, not(CONFIG_BUG)))]
 macro_rules! warn_flags {
     ($file:expr, $flags:expr) => {};
 }


