Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C98391832;
	Wed, 23 Sep 2026 14:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174752; cv=none; b=YrUhdSgCOPcKTT2tK/QiysCLC7vpuJm/p9vB0HvDSTNVjcv75aMoIl8XF2tnuwL7LkUF5VuU/FiVdxfE5Rox7yOQgQA8fcshw4Ask8hmp+0riMlNHtXfmd6qUZupl+k6s3ejg4Qxlu5MzkD1lS2RD74bJMOUNJso0H295TMh9jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174752; c=relaxed/simple;
	bh=I3fcmIEqjNpd5eSKiXRUTzd+w99I/g4JWSHkiK8nOkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qh0vN+b1uvtZzIiXNefby3OG4K5tnOi+8hjSp9h6LJZ9b7/ANokLkzUXPiGl7RyhtjB12n4ZTaSliPmDQqcge78Ol2pu+ghywmX6D4VAWo/SLKgRCyDr9SOoLxOVxyRCSVhE+GthqDhPhJCJCyOmD8ny5gwoSb5zjUlnduyOl1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afpuaOiy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afpuaOiy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ABC31F000FF;
	Wed, 23 Sep 2026 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174750;
	bh=clAvvgj8u0scXF62l3fGETZo/bZDa265cpPSCmY6N8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afpuaOiyyJrOw7XUMun8m4DdSLOJG6KZgYG+rJpGBrjHpL6aPL4dIFj0zdLjRzXHQ
	 1uc795CmQVKqYOabOIO+Ti5RXj9Pk8VlWSHBaFz+6ms+2a5JlfhtHP2VITrZidFqVn
	 os/zjoBJCFzMocFqfoMbqVD2TtL2S2/Z2/s2xK8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Omar Avelar <omar.avelar@intel.com>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 215/398] x86/build/64: Prevent native builds from generating EGPR use
Date: Wed, 23 Sep 2026 16:04:49 +0200
Message-ID: <20260923140648.998605801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
@@ -255,10 +255,21 @@ config CC_HAS_MARCH_NATIVE
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
@@ -168,6 +168,11 @@ else
 
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


