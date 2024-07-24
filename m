Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3539A15EFC1;
	Wed, 24 Jul 2024 16:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721837729; cv=none; b=AUz491ky7WK+jYHjQAQoOE7eY76Z6uabBIC2+tK/VU4Qta+nUkPDLuQRz6XVXHiBxb4WHaT6F4HSkhd2n5MNBq/926FR7dcMhdRA2D1i5R2T6Kt2rNBL/QNPyaACShHVt2ff3ZSzCSV82Yo//vRb5wk2T9c+dlwKBEPAEJIaBP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721837729; c=relaxed/simple;
	bh=sDKbew3IsQNjST81obR6SPncq+a1HWISE2Uo/Fh6iUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bd1BE9jXFysYMeaI1TTQIR/rqqHkz2jnlVTucLlXZW4J+0gfraJ5TQTM/R0Tr84sgaltv2lWC+KEiFFKzIWBbcu168tEJERUbH1gRjDJywfEGkbdzWbMCDc/t0oNJytcrlnARg9hsXl/LTj73FOFPCwZXkoNU2icOU8/4w+MDqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oXcTe+nD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oXcTe+nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E02AC32781;
	Wed, 24 Jul 2024 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721837728;
	bh=sDKbew3IsQNjST81obR6SPncq+a1HWISE2Uo/Fh6iUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXcTe+nD5ieOmdhKhnHGhAeHOUA7ETE7Y/tN7k1DUru5yaqnGdxCk80p6+5ObC4uf
	 jjkcEvFEYTHHG+0k/cy+y4tKyJfsOeAS0I1YZMdBaRDlDvwNjsJK9yZU+jK7md9rz8
	 NRsv3/BY+KYrh5C+M5fVeM2KTI2Boyp0kOKZzqHD9805UegVVqcDzvpm3sX74lMLvB
	 CFMqQ272deKdQA7lmuxrwFAwC4EuuE5thYKIIigtLxS9QE0fDzL/7w0RPbp8yJtLme
	 A39xwIGu6AXEOCQOr1YZDcr084FMcsjaRe0uAA92OMKlAJob2D9GQyegzKwHKu6+wA
	 vlP8VHLYy73wg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH v2 2/6] x86/rust: support MITIGATION_RETPOLINE
Date: Wed, 24 Jul 2024 18:14:55 +0200
Message-ID: <20240724161501.1319115-3-ojeda@kernel.org>
In-Reply-To: <20240724161501.1319115-1-ojeda@kernel.org>
References: <20240724161501.1319115-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Support `MITIGATION_RETPOLINE` by enabling the target features that
Clang does.

The existing target feature being enabled was a leftover from
our old `rust` branch, and it is not enough: the target feature
`retpoline-external-thunk` only implies `retpoline-indirect-calls`, but
not `retpoline-indirect-branches` (see LLVM's `X86.td`), unlike Clang's
flag of the same name `-mretpoline-external-thunk` which does imply both
(see Clang's `lib/Driver/ToolChains/Arch/X86.cpp`).

Without this, `objtool` would complain if enabled for Rust, e.g.:

    rust/core.o: warning: objtool:
    _R...escape_default+0x13: indirect jump found in RETPOLINE build

In addition, change the comment to note that LLVM is the one disabling
jump tables when retpoline is enabled, thus we do not need to use
`-Zno-jump-tables` for Rust here -- see commit c58f2166ab39 ("Introduce
the "retpoline" x86 mitigation technique ...") [1]:

    The goal is simple: avoid generating code which contains an indirect
    branch that could have its prediction poisoned by an attacker. In
    many cases, the compiler can simply use directed conditional
    branches and a small search tree. LLVM already has support for
    lowering switches in this way and the first step of this patch is
    to disable jump-table lowering of switches and introduce a pass to
    rewrite explicit indirectbr sequences into a switch over integers.

As well as a live example at [2].

These should be eventually enabled via `-Ctarget-feature` when `rustc`
starts recognizing them (or via a new dedicated flag) [3].

Cc: Daniel Borkmann <daniel@iogearbox.net>
Link: https://github.com/llvm/llvm-project/commit/c58f2166ab3987f37cb0d7815b561bff5a20a69a [1]
Link: https://godbolt.org/z/G4YPr58qG [2]
Link: https://github.com/rust-lang/rust/issues/116852 [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 arch/x86/Makefile               | 2 +-
 scripts/generate_rust_target.rs | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 801fd85c3ef6..e8214bff1aeb 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -220,7 +220,7 @@ ifdef CONFIG_MITIGATION_RETPOLINE
   KBUILD_CFLAGS += $(RETPOLINE_CFLAGS)
   # Additionally, avoid generating expensive indirect jumps which
   # are subject to retpolines for small number of switch cases.
-  # clang turns off jump table generation by default when under
+  # LLVM turns off jump table generation by default when under
   # retpoline builds, however, gcc does not for x86. This has
   # only been fixed starting from gcc stable version 8.4.0 and
   # onwards, but not for older ones. See gcc bug #86952.
diff --git a/scripts/generate_rust_target.rs b/scripts/generate_rust_target.rs
index 641b713a033a..44952f0a3aac 100644
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -164,7 +164,14 @@ fn main() {
         );
         let mut features = "-3dnow,-3dnowa,-mmx,+soft-float".to_string();
         if cfg.has("MITIGATION_RETPOLINE") {
+            // The kernel uses `-mretpoline-external-thunk` (for Clang), which Clang maps to the
+            // target feature of the same name plus the other two target features in
+            // `clang/lib/Driver/ToolChains/Arch/X86.cpp`. These should be eventually enabled via
+            // `-Ctarget-feature` when `rustc` starts recognizing them (or via a new dedicated
+            // flag); see https://github.com/rust-lang/rust/issues/116852.
             features += ",+retpoline-external-thunk";
+            features += ",+retpoline-indirect-branches";
+            features += ",+retpoline-indirect-calls";
         }
         ts.push("features", features);
         ts.push("llvm-target", "x86_64-linux-gnu");
--
2.45.2
