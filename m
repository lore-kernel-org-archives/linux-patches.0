Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9214372B4B;
	Fri,  4 Sep 2026 05:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500344; cv=none; b=Ln54ySVGTraoLM3MPWr34OwyQDPLD6ccUYNDobsqL5rrTf3L3nwOBgNLKN9WSiI6NU3qLtbfrFaeO1yk+z0IYwpb+y+tkPGOgQ7CEK3jXHCqvql7AvWU455wRH+s9qt5fLRq+J+yYsrVHH11LUWAOaXTKUa4W2B+gV2PlxM2ttg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500344; c=relaxed/simple;
	bh=0Ocb9uBTFVsWgQw3mciH1cPaPaaYEWqWfuAyKgZKt1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTOxO+1qE/+duwkzTuhyj5ZVTeB7iGXB4NX7+n+2b72HJp5mKeIH0z20NQPF+4Tz4fqD7uVhp6qT8lvX9o0L1reIeGvdh9bfbw7TnGZq/vzoRRn5AAdL9sBdh+L/uWAeaEHOHdDJI+DEoDvr4rr4sTbOxuiCYt+vQF9WOUPAS18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIO0H0PA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIO0H0PA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177171F00A3E;
	Fri,  4 Sep 2026 05:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500343;
	bh=6qnS8q+AlSMo0LFKGqeaMIBKAv1uQmxo9D6osrIe8gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIO0H0PAxAEcoLvnO2HEH/lKfYbqmowTP6+ka8bp86de4lTTLIE3Wxbr/BfNnEn6B
	 2MDHxLEy0KJHJ18GaTsLV5m7TIEUCHAnl7LWgnPU5OwSvyzd9f33gUmnajmYNXT966
	 FmcXHruwBrooO4yXkc3iSAqFqBRD2LryBvBEqYoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: [PATCH 6.18 023/552] rust: bug: skip arch-specific asm in `testlib` builds
Date: Fri,  4 Sep 2026 06:53:00 +0200
Message-ID: <20260904045748.350713704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
     ($flags:expr) => {
@@ -91,6 +94,7 @@ macro_rules! warn_flags {
 
 #[macro_export]
 #[doc(hidden)]
+#[cfg(not(testlib))]
 #[cfg(all(CONFIG_BUG, any(CONFIG_LOONGARCH, CONFIG_ARM)))]
 macro_rules! warn_flags {
     ($flags:expr) => {
@@ -101,7 +105,7 @@ macro_rules! warn_flags {
 
 #[macro_export]
 #[doc(hidden)]
-#[cfg(not(CONFIG_BUG))]
+#[cfg(any(testlib, not(CONFIG_BUG)))]
 macro_rules! warn_flags {
     ($flags:expr) => {};
 }


