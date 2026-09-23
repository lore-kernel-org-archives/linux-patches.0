Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233524A2A72;
	Wed, 23 Sep 2026 14:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173529; cv=none; b=b9ZpL9bekJz8GZQ1qUT5HMTziKYpdk3dKnMYkoOi53VT/Gcm8ccYs2zwdBSsfhy7FdG5F9r/B4jX1Tq42gPYc21Di26Lsb/asBqqf7XguLk9hp59dLNHDMP+S3x8+EK/KOakPtv7ysZhUhBgvSIXIosLA6xRGfNa9E6TqGaR/E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173529; c=relaxed/simple;
	bh=NGdd6Q0Pkd+zwvSr8Bwj8KgvRli3UqUT+dS9m8YB9Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEl4d7wgVmJvq1i46d6FSUwOSxVzhWO3NM3eQPO6Nknnh65ygWTl2WCV4FrP9hBn4A32KKFN+AOV5lR42ZQQ7gKc9oK3zMCnihWomTBTA4BEF/HNHXi3L18B8Xzz44mcSUK+k7UI6AjpPFC6hXF83rRoIa0w5n7Zom4rK++vz+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbkX9h1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbkX9h1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8AC1F000FF;
	Wed, 23 Sep 2026 14:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173528;
	bh=Mcun79obQq0ph/zYGMSyPX3jNXAEq574n8FB2Cep1Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbkX9h1k4hG+vBK6CbrrUyalCQER6wpjxocJBVd6ZnIZnHBrscatBppjDOB5X3FpN
	 HtU7VX1iSJTBxvl6PUEM41AECeLttMZwzqxuKw0VU14OOdH6Bdg4FDTfWf4cpT/w5L
	 yaWgguwwhKwh+9bVZgKaaN7C9QIKGYGXlFTfQ+ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Avelar <omar.avelar@intel.com>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 257/438] x86/build/64: Prevent native builds from generating EGPR use
Date: Wed, 23 Sep 2026 16:04:38 +0200
Message-ID: <20260923140651.432523731@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Chang S. Bae <chang.seok.bae@intel.com>

commit 63edf5a009ae366369a1b484cd9ae4ee7c51946c upstream.

Omar reports that CONFIG_X86_NATIVE_CPU=y allows builds to opportunistically
emit instructions using %r16-%r31 (EGPRs) when the build host supports APX
since the commit:

  ea1dcca1de12 ("x86/kbuild/64: Add the CONFIG_X86_NATIVE_CPU option to locally optimize the kernel with '-march=native'")

But the kernel is not yet prepared to use new registers internally. For
example, there is no context-switch support for general in-kernel use.

Explicitly disable EGPR use when building with -march=native.

For C, since GCC 14 and Clang 18, both compilers support suppressing EGPR
use with -mno-apx-features=egpr, whose availability can be detected via
cc-option.

For Rust, pass features=-apxf through the generated JSON to avoid
unstable-feature warnings, see

  https://github.com/rust-lang/rust/issues/139284

Note Rust only accepts the option to disable APX instructions entirely or not.

Support for this gating also depends on the Rust/LLVM combination. Rust
1.88 introduced the `apxf` feature option, but versions prior to 1.93 may
emit an `apxf` attribute to the backend that only LLVM 23 or later can
interpret. Restrict native Rust builds accordingly.

Fixes: ea1dcca1de12 ("x86/kbuild/64: Add the CONFIG_X86_NATIVE_CPU option to locally optimize the kernel with '-march=native'")
Reported-by: Omar Avelar <omar.avelar@intel.com>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916230003.1144622-1-chang.seok.bae@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig.cpu            |   11 +++++++++++
 arch/x86/Makefile               |    5 +++++
 scripts/generate_rust_target.rs |    5 +++++
 3 files changed, 21 insertions(+)

--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -204,10 +204,21 @@ config CC_HAS_MARCH_NATIVE
 	# usage warnings that only appear wth '-march=native'.
 	depends on CC_IS_GCC || CLANG_VERSION >= 190100
 
+config RUSTC_HAS_APXF
+	# The kernel isn't ready for in-kernel APX instructions. Without
+	# explicit frontend gating of APX, the backend may emit those
+	# instructions in native builds.
+	#
+	# Rust 1.88 added the `apxf` feature option, but versions before 1.93
+	# emit an `apxf` target attribute that only LLVM 23+ can interpret.
+	def_bool (RUSTC_VERSION >= 108800 && RUSTC_LLVM_MAJOR_VERSION >= 23) || \
+		 RUSTC_VERSION >= 109300
+
 config X86_NATIVE_CPU
 	bool "Build and optimize for local/native CPU"
 	depends on X86_64
 	depends on CC_HAS_MARCH_NATIVE
+	depends on !RUST || RUSTC_HAS_APXF
 	help
 	  Optimize for the current CPU used to compile the kernel.
 	  Use this option if you intend to build the kernel for your
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -161,6 +161,11 @@ else
 
 ifdef CONFIG_X86_NATIVE_CPU
         KBUILD_CFLAGS += -march=native
+        # Prevent the compiler from generating EGPR use. The kernel is
+        # not yet prepared for general in-kernel use.
+        KBUILD_CFLAGS += $(call cc-option,-mno-apx-features=egpr)
+
+        # generate_rust_target.rs handles Rust APX gating.
         KBUILD_RUSTFLAGS += -Ctarget-cpu=native
 else
         KBUILD_CFLAGS += -march=x86-64 -mtune=generic
--- a/scripts/generate_rust_target.rs
+++ b/scripts/generate_rust_target.rs
@@ -224,6 +224,11 @@ fn main() {
             features += ",+harden-sls-ijmp";
             features += ",+harden-sls-ret";
         }
+        if cfg.has("X86_NATIVE_CPU") {
+            // Prevent the backend from generating APX instructions. The kernel is not yet prepared
+            // for general in-kernel EGPR use.
+            features += ",-apxf";
+        }
         ts.push("features", features);
         ts.push("llvm-target", "x86_64-linux-gnu");
         ts.push("supported-sanitizers", ["kcfi", "kernel-address"]);


