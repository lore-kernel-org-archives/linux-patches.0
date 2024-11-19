Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2015443F;
	Tue, 19 Nov 2024 18:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732042678; cv=none; b=RlMt76UGUXAcuaVvBRDQUsDu9XQs6ZY5Kw3aYgNhJA3HdpTCOouRByrNqS55co4CkFbQBhH86nsaM1jh7mNJpRqHZCIjcw9Zo1z9O+Aoow4YBA9BCRcZfaWdQbs7tYlB/LTRQvd7tc19Dx1jzFkZKJ+XxVNs2CZVYIhU7iL0mss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732042678; c=relaxed/simple;
	bh=VO7UT3y5aNQ9ySDmMe3FBcvbH2S4dSbX6kZ/OKvhKD0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c6Vy4Mb9lHaQhWztpX15nJrjEs6rmzBNr4zy0Sjtk4Wc4927btoGTtdQHz4xONUGCvT5CALmW8hXfxGeEVhXoQ1FczhkAPs3bVqLCut5pTP22Tp/nSkvMVTzs9okxpc7DgpJLbWzWCIrE9z3IhW/Ng2wTgmx+MTIt43+ZMBJutM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZZ5mHonC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZZ5mHonC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45CDBC4CECF;
	Tue, 19 Nov 2024 18:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732042678;
	bh=VO7UT3y5aNQ9ySDmMe3FBcvbH2S4dSbX6kZ/OKvhKD0=;
	h=From:To:Cc:Subject:Date:From;
	b=ZZ5mHonCpd5YRDiH3kX/3wLVLhdlaZqMMeWmh8VFGSbg1tNvAlmcYAOtI40lDvB4h
	 dLJ3ZxDIFUZ1ei//2FG9ny8htRKzlbP2eV8n9phrgVSgICKkQneZUmHgaCUTQWzcN+
	 Of6CByvb25AGSHBzkhe6/6ZFktDY3QD3NMlUZZUYcxVWA64DqPBTxlHeF/0msojvmO
	 o45/yCMaLmLJYTXHjNuPevNKsJ8i+cJRAlnIb7+gb1QPEI8AtmJU7sWaeaSGUYXVBr
	 LOwTdPG1crxaR2UhwPSLTgZbU+my30DXNRII/+7cfrJ63J/Lbu5GRCQrrlurjVc/NW
	 1KOfAsX1PkHBg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Aaron Ballman <aaron@aaronballman.com>,
	Bill Wendling <isanbard@gmail.com>,
	Cole Nixon <nixontcole@gmail.com>,
	Connor Kuehl <cipkuehl@gmail.com>,
	Fangrui Song <i@maskray.me>,
	James Foster <jafosterja@gmail.com>,
	Jeff Takahashi <jeffrey.takahashi@gmail.com>,
	Jordan Cantrell <jordan.cantrell@mail.com>,
	Matthew Maurer <mmaurer@google.com>,
	Nikk Forbus <nicholas.forbus@gmail.com>,
	Qing Zhao <qing.zhao@oracle.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Tim Pugh <nwtpugh@gmail.com>,
	Kees Cook <kees@kernel.org>
Subject: [RFC PATCH] rust: allow Clang-native `RANDSTRUCT` configs
Date: Tue, 19 Nov 2024 19:57:47 +0100
Message-ID: <20241119185747.862544-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel supports `RANDSTRUCT_FULL` with Clang 16+, and `bindgen`
(which uses `libclang` under the hood) inherits the information, so the
generated bindings look correct.

For instance, running:

    bindgen x.h -- -frandomize-layout-seed=100

with:

    struct S1 {
        int a;
        int b;
    };

    struct S2 {
        int a;
        int b;
    } __attribute__((randomize_layout));

    struct S3 {
        void (*a)(void);
        void (*b)(void);
    };

    struct S4 {
        void (*a)(void);
        void (*b)(void);
    } __attribute__((no_randomize_layout));

may swap `S2`'s and `S3`'s members, but not `S1`'s nor `S4`'s:

    pub struct S1 {
        pub a: ::std::os::raw::c_int,
        pub b: ::std::os::raw::c_int,
    }

    pub struct S2 {
        pub b: ::std::os::raw::c_int,
        pub a: ::std::os::raw::c_int,
    }

    pub struct S3 {
        pub b: ::std::option::Option<unsafe extern "C" fn()>,
        pub a: ::std::option::Option<unsafe extern "C" fn()>,
    }

    pub struct S4 {
        pub a: ::std::option::Option<unsafe extern "C" fn()>,
        pub b: ::std::option::Option<unsafe extern "C" fn()>,
    }

Thus allow those configurations by requiring a Clang compiler to use
`RANDSTRUCT`. In addition, remove the `!GCC_PLUGIN_RANDSTRUCT` check
since it is not needed.

A simpler alternative would be to remove the `!RANDSTRUCT` check (keeping
the `!GCC_PLUGIN_RANDSTRUCT` one). However, if in the future GCC starts
supporting `RANDSTRUCT` natively, it would be likely that it would not
work unless GCC and Clang agree on the exact semantics of the flag. And,
as far as I can see, so far the randomization in Clang does not seem to be
guaranteed to remain stable across versions or platforms, i.e. only for a
given compiler Clang binary, given it is not documented and that LLVM's
`HEAD` has the revert in place for the expected field names in the test
(LLVM commit 8dbc6b560055 ("Revert "[randstruct] Check final randomized
layout ordering"")) [1][2]. And the GCC plugin definitely does not match,
e.g. its RNG is different (`std::mt19937` vs Bob Jenkins').

And given it is not supposed to be guaranteed to remain stable across
versions, it is a good idea to match the Clang and `bindgen`'s
`libclang` versions -- we already have a warning for that in
`scripts/rust_is_available.sh`. In the future, it would also be good to
have a build test to double-check layouts do actually match (but that
is true regardless of this particular feature).

Finally, make a required small change to take into account the anonymous
struct used in `randomized_struct_fields_*` in `struct task_struct`.

Cc: Aaron Ballman <aaron@aaronballman.com>
Cc: Bill Wendling <isanbard@gmail.com>
Cc: Cole Nixon <nixontcole@gmail.com>
Cc: Connor Kuehl <cipkuehl@gmail.com>
Cc: Fangrui Song <i@maskray.me>
Cc: James Foster <jafosterja@gmail.com>
Cc: Jeff Takahashi <jeffrey.takahashi@gmail.com>
Cc: Jordan Cantrell <jordan.cantrell@mail.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Matthew Maurer <mmaurer@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nikk Forbus <nicholas.forbus@gmail.com>
Cc: Qing Zhao <qing.zhao@oracle.com>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Tim Pugh <nwtpugh@gmail.com>
Link: https://reviews.llvm.org/D121556
Link: https://github.com/llvm/llvm-project/commit/8dbc6b560055ff5068ff45b550482ba62c36b5a5 [1]
Link: https://reviews.llvm.org/D124199 [2]
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I tried the Clang's native `RANDSTRUCT` support with Rust, and
apparently it seems to just work.

I checked first that `bindgen` was indeed randomizing the structs in
userspace (i.e. `libclang` seems to provide the right information),
then I checked our generated bindings were indeed also randomized, and
QEMU-booted a couple times the kernel and our (few) KUnit tests pass.

I also printed the offset of a couple of the `task_struct` randomized
members from both C and Rust independently (which I thought could be a
non-trivial case since `bindgen` transforms the anonymous struct into
another type), and they seem to match as well from a couple tries.

So a patch like this one may just work already, at least in some cases.
But a fair amount of testing is probably needed for this one, so if you
have a workload and some time, please give it a go!

 init/Kconfig        |  3 +--
 rust/kernel/task.rs | 22 ++++++++++++++++++++--
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 530a382ee0fe..d2a04c3c86ab 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1943,8 +1943,7 @@ config RUST
 	depends on HAVE_RUST
 	depends on RUST_IS_AVAILABLE
 	depends on !MODVERSIONS
-	depends on !GCC_PLUGIN_RANDSTRUCT
-	depends on !RANDSTRUCT
+	depends on !RANDSTRUCT || CC_IS_CLANG
 	depends on !DEBUG_INFO_BTF || PAHOLE_HAS_LANG_EXCLUDE
 	depends on !CFI_CLANG || RUSTC_VERSION >= 107900 && HAVE_CFI_ICALL_NORMALIZE_INTEGERS
 	select CFI_ICALL_NORMALIZE_INTEGERS if CFI_CLANG
diff --git a/rust/kernel/task.rs b/rust/kernel/task.rs
index 5bce090a3869..1012bb772f56 100644
--- a/rust/kernel/task.rs
+++ b/rust/kernel/task.rs
@@ -129,7 +129,16 @@ fn deref(&self) -> &Self::Target {
     pub fn group_leader(&self) -> &Task {
         // SAFETY: By the type invariant, we know that `self.0` is a valid task. Valid tasks always
         // have a valid `group_leader`.
-        let ptr = unsafe { *ptr::addr_of!((*self.0.get()).group_leader) };
+        let ptr = unsafe {
+            #[cfg(not(CONFIG_RANDSTRUCT))]
+            {
+                *ptr::addr_of!((*self.0.get()).group_leader)
+            }
+            #[cfg(CONFIG_RANDSTRUCT)]
+            {
+                *ptr::addr_of!((*self.0.get()).__bindgen_anon_1.group_leader)
+            }
+        };

         // SAFETY: The lifetime of the returned task reference is tied to the lifetime of `self`,
         // and given that a task has a reference to its group leader, we know it must be valid for
@@ -141,7 +150,16 @@ pub fn group_leader(&self) -> &Task {
     pub fn pid(&self) -> Pid {
         // SAFETY: By the type invariant, we know that `self.0` is a valid task. Valid tasks always
         // have a valid pid.
-        unsafe { *ptr::addr_of!((*self.0.get()).pid) }
+        unsafe {
+            #[cfg(not(CONFIG_RANDSTRUCT))]
+            {
+                *ptr::addr_of!((*self.0.get()).pid)
+            }
+            #[cfg(CONFIG_RANDSTRUCT)]
+            {
+                *ptr::addr_of!((*self.0.get()).__bindgen_anon_1.pid)
+            }
+        }
     }

     /// Determines whether the given task has pending signals.

base-commit: b2603f8ac8217bc59f5c7f248ac248423b9b99cb
--
2.47.0
