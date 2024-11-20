Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F9D19E97F;
	Wed, 20 Nov 2024 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732125579; cv=none; b=VpxLfuoE9AEpWo7cNuj4W7wX4xZwupAf8+34exGluCCTbqVh1/hBhmAgJvl6zmp7No0/wyYW3yHuenfC6ND+L5lBL1TqyaX5K8Bhq9qRl1sJBk3g3AKGv4ZBPy4pnqKOLv29jiMlRHc2pbOWSeDxcYDqRGPviqOKwNP4da7PHeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732125579; c=relaxed/simple;
	bh=DZ38UxyzHdOC0ZPM6AsxHCE30MP5BwfG1PST2fUMSVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nT+9UtbJbe64XDXzywbqbwXXsTfygFkmVLHbuL+mtHeVNLKJhGCXOuHadbTbXdefV7FIEVb3+rbo3BPhHUxFGOHDJxF9mllWtP7iL+pqsyE0e0WkQseEjetXoIGgKo9jnwWjxdA+Z7vExuHZ1wpq/pCoT3fGet94trW8XXWO1qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azKfIHNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azKfIHNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553DAC4CECD;
	Wed, 20 Nov 2024 17:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732125579;
	bh=DZ38UxyzHdOC0ZPM6AsxHCE30MP5BwfG1PST2fUMSVk=;
	h=From:To:Cc:Subject:Date:From;
	b=azKfIHNdWD1IHqTeU5C444Y1BksEFRPL8GWfOYC3o5MTdJswd7pS2bO5Ab/5r+JiP
	 xVNIU9nxmGdj8G5oNGKbX37y9YyK2q3I9xwdA7JG4LxWqTIbIouPCbbrz7Er9Pox/X
	 3Fg5DhKJW+s9uizw7X3SL5DcZEpftLIMbhS1Dxecr4Bu3uGuQPvQBpp4R+PdCe+Tzi
	 VgxPyKRNO+4TMtJDFJaCh44v0gyxwT4MW5b+Fx3KrKvGiqGaoluGsMFSyADSxCnQ+7
	 LcTW73+GxoZkMV0R+OgIdCL66aR4xwgDYbL+55zg0WHofP1A1ThPUndLkqoyzcArX5
	 wp7jfvlkKgDvw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: jump_label: skip formatting generated file
Date: Wed, 20 Nov 2024 18:59:16 +0100
Message-ID: <20241120175916.58860-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After a source tree build of the kernel, and having used the `RSCPP`
rule, running `rustfmt` fails with:

    error: macros that expand to items must be delimited with braces or followed by a semicolon
     --> rust/kernel/arch_static_branch_asm.rs:1:27
      |
    1 | ...ls!("1: jmp " ... ".popsection \n\t")
      |       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
      |
    help: change the delimiters to curly braces
      |
    1 | ::kernel::concat_literals!{"1: jmp " ... ".popsection \n\t"}
      |                           ~                                ~
    help: add a semicolon
      |
    1 | ::kernel::concat_literals!("1: jmp " ... ".popsection \n\t");
      |                                                             +

This file is not meant to be formatted nor works on its own since it is
meant to be textually included.

Thus skip formatting it by prefixing its name with `generated_`.

Fixes: 169484ab6677 ("rust: add arch_static_branch")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile                                                 | 4 ++--
 rust/kernel/.gitignore                                        | 2 +-
 ..._branch_asm.rs.S => generated_arch_static_branch_asm.rs.S} | 0
 rust/kernel/jump_label.rs                                     | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)
 rename rust/kernel/{arch_static_branch_asm.rs.S => generated_arch_static_branch_asm.rs.S} (100%)

diff --git a/rust/Makefile b/rust/Makefile
index bc2a9071dd29..99db963637e6 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -36,7 +36,7 @@ always-$(CONFIG_RUST_KERNEL_DOCTESTS) += doctests_kernel_generated_kunit.c
 obj-$(CONFIG_RUST_KERNEL_DOCTESTS) += doctests_kernel_generated.o
 obj-$(CONFIG_RUST_KERNEL_DOCTESTS) += doctests_kernel_generated_kunit.o
 
-always-$(subst y,$(CONFIG_RUST),$(CONFIG_JUMP_LABEL)) += kernel/arch_static_branch_asm.rs
+always-$(subst y,$(CONFIG_RUST),$(CONFIG_JUMP_LABEL)) += kernel/generated_arch_static_branch_asm.rs
 
 # Avoids running `$(RUSTC)` for the sysroot when it may not be available.
 ifdef CONFIG_RUST
@@ -427,7 +427,7 @@ $(obj)/kernel.o: $(src)/kernel/lib.rs $(obj)/alloc.o $(obj)/build_error.o \
 	+$(call if_changed_rule,rustc_library)
 
 ifdef CONFIG_JUMP_LABEL
-$(obj)/kernel.o: $(obj)/kernel/arch_static_branch_asm.rs
+$(obj)/kernel.o: $(obj)/kernel/generated_arch_static_branch_asm.rs
 endif
 
 endif # CONFIG_RUST
diff --git a/rust/kernel/.gitignore b/rust/kernel/.gitignore
index d082731007c6..6ba39a178f30 100644
--- a/rust/kernel/.gitignore
+++ b/rust/kernel/.gitignore
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-/arch_static_branch_asm.rs
+/generated_arch_static_branch_asm.rs
diff --git a/rust/kernel/arch_static_branch_asm.rs.S b/rust/kernel/generated_arch_static_branch_asm.rs.S
similarity index 100%
rename from rust/kernel/arch_static_branch_asm.rs.S
rename to rust/kernel/generated_arch_static_branch_asm.rs.S
diff --git a/rust/kernel/jump_label.rs b/rust/kernel/jump_label.rs
index 2f2df03a3275..8974f04737f8 100644
--- a/rust/kernel/jump_label.rs
+++ b/rust/kernel/jump_label.rs
@@ -39,7 +39,7 @@ macro_rules! static_branch_unlikely {
 #[cfg(CONFIG_JUMP_LABEL)]
 const _: &str = include!(concat!(
     env!("OBJTREE"),
-    "/rust/kernel/arch_static_branch_asm.rs"
+    "/rust/kernel/generated_arch_static_branch_asm.rs"
 ));
 
 #[macro_export]
@@ -48,7 +48,7 @@ macro_rules! static_branch_unlikely {
 macro_rules! arch_static_branch {
     ($key:path, $keytyp:ty, $field:ident, $branch:expr) => {'my_label: {
         $crate::asm!(
-            include!(concat!(env!("OBJTREE"), "/rust/kernel/arch_static_branch_asm.rs"));
+            include!(concat!(env!("OBJTREE"), "/rust/kernel/generated_arch_static_branch_asm.rs"));
             l_yes = label {
                 break 'my_label true;
             },

base-commit: 22193c586b43ee88d66954395885742a6e4a49a9
-- 
2.47.0

