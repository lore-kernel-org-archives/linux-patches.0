Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7660D41C72;
	Tue,  6 Aug 2024 15:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722956795; cv=none; b=VF+WxT2VTAin3SqpPpqllUtNx/SI2xt1sg/BsOFiBzZLoHLDJJvgni9Ls7DXPVD4Vecs/WalDIx7pdjIWCwEORgy5S3MXkFz/tDivonqBAweuyKFPX4yVgvPjnN5X6TL1RNAvg0iO2k/iaukTt6hBby62BJ3UZ25udh15Ux/bac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722956795; c=relaxed/simple;
	bh=Ah6jgHgNtK5AriN+1EmUXXERGaccivbbBhGIB4QgMR8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gcLkIKz6kaZbZHPHkfwmCNoh1GVZ9LdHw3V4H2A6PddYbWNqH/4wazq30xYol8vxD69FxTCpLHPMEoOW8jVtRcwgdYVo5TiNKiyDrrE8hkIReAOwPqJxRfGDrCfUbvcQJTUdtx81qw0ypWM8tvd9GEvpAISIvLAzLbEMSeWBF8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAacxxOc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAacxxOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8D0C32786;
	Tue,  6 Aug 2024 15:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722956795;
	bh=Ah6jgHgNtK5AriN+1EmUXXERGaccivbbBhGIB4QgMR8=;
	h=From:To:Cc:Subject:Date:From;
	b=OAacxxOc1ipNL39a1PJiYKNCY8SYdicuwtfqqwt9bl/ULwsw7GQvmD/7hifJ5tqKk
	 qiV9N1YyzofNx+KRkcfJopGyWSI9syKErXgg+uU36fzIghJjTCbLUQXCF2kCrG2zwq
	 IkK8BthOgdtVh7rRk2nITllA7R4bPrYtdO8EBldmUtYX/95i37TA0lWhQ0UStAIWJP
	 H0cmmGq5eEFtU/+bmUxgSrLQgOdaH+PMZGeo2HN/NiHQhkbuJ+xMNQXhKXDGh0evBz
	 +jv80sorqXWC9IbFroFqAiGuCRMyE7fQzuF/B2WhpqouWaiOZRt1rk7UZtVt/Fp/5e
	 O5wxz3PmqA3PQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: add intrinsics to fix `-Os` builds
Date: Tue,  6 Aug 2024 17:06:19 +0200
Message-ID: <20240806150619.192882-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Alice reported [1] that an arm64 build failed with:

    ld.lld: error: undefined symbol: __extendsfdf2
    >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
    >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a
    >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
    >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a

    ld.lld: error: undefined symbol: __truncdfsf2
    >>> referenced by core.a6f5fc5794e7b7b3-cgu.0
    >>>               rust/core.o:(<f32>::midpoint) in archive vmlinux.a

Rust 1.80.0 or later together with `CONFIG_CC_OPTIMIZE_FOR_SIZE=y`
is what triggers it.

In addition, x86_64 builds also fail the same way.

Similarly, compiling with Rust 1.82.0 (currently in nightly) makes
another one appear, possibly due to the LLVM 19 upgrade there:

    ld.lld: error: undefined symbol: __eqdf2
    >>> referenced by core.20495ea57a9f069d-cgu.0
    >>>               rust/core.o:(<f64>::next_up) in archive vmlinux.a
    >>> referenced by core.20495ea57a9f069d-cgu.0
    >>>               rust/core.o:(<f64>::next_down) in archive vmlinux.a

Gary adds [1]:

> Usually the fix on rustc side is to mark those functions as `#[inline]`
>
> All of {midpoint,next_up,next_down} are indeed unstable functions not
> marked as inline...

Fix all those by adding those intrinsics to our usual workaround.

Cc: Gary Guo <gary@garyguo.net>
Reported-by: Alice Ryhl <aliceryhl@google.com>
Closes: https://rust-for-linux.zulipchat.com/#narrow/stream/288089-General/topic/v6.2E11-rc1.20doesn't.20build.20for.20arm64/near/455637364
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile             | 4 ++--
 rust/compiler_builtins.rs | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/rust/Makefile b/rust/Makefile
index 1f10f92737f2..77836388377d 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -354,8 +354,8 @@ rust-analyzer:
 		$(if $(KBUILD_EXTMOD),$(extmod_prefix),$(objtree))/rust-project.json
 
 redirect-intrinsics = \
-	__addsf3 __eqsf2 __gesf2 __lesf2 __ltsf2 __mulsf3 __nesf2 __unordsf2 \
-	__adddf3 __ledf2 __ltdf2 __muldf3 __unorddf2 \
+	__addsf3 __eqsf2 __extendsfdf2 __gesf2 __lesf2 __ltsf2 __mulsf3 __nesf2 __truncdfsf2 __unordsf2 \
+	__adddf3 __eqdf2 __ledf2 __ltdf2 __muldf3 __unorddf2 \
 	__muloti4 __multi3 \
 	__udivmodti4 __udivti3 __umodti3
 
diff --git a/rust/compiler_builtins.rs b/rust/compiler_builtins.rs
index bba2922c6ef7..f14b8d7caf89 100644
--- a/rust/compiler_builtins.rs
+++ b/rust/compiler_builtins.rs
@@ -40,16 +40,19 @@ pub extern "C" fn $ident() {
 define_panicking_intrinsics!("`f32` should not be used", {
     __addsf3,
     __eqsf2,
+    __extendsfdf2,
     __gesf2,
     __lesf2,
     __ltsf2,
     __mulsf3,
     __nesf2,
+    __truncdfsf2,
     __unordsf2,
 });
 
 define_panicking_intrinsics!("`f64` should not be used", {
     __adddf3,
+    __eqdf2,
     __ledf2,
     __ltdf2,
     __muldf3,

base-commit: de9c2c66ad8e787abec7c9d7eff4f8c3cdd28aed
-- 
2.46.0

