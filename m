Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814A3195;
	Sat, 23 Nov 2024 18:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732385031; cv=none; b=TwffDSvCjW8lFt6T3y5BLHZGvwrVE7Ie0SPZO63qzhFzuMcYMBfpQI+0CAaOFPdMvWX+fdOi0FRNTRCUkBSd9xaYMJMrZ5DEQi74tkg69y0kKRCZdSyGyzDBvSu0sqD9CbdzI4NBTSLxjMfGlVKUahxCVu2o5FPS+HsNWaud1y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732385031; c=relaxed/simple;
	bh=znf4LwmiKLLGvxbVhzTeQXiFCUGm6KOIppU0Ug6hGW0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZurrAxobwGZPPQqVUe3rzvjhLdH9DGibmOn/fRDPp4Ml3gle6my1c0R6uib3LyP23sCTekFTI6b2rOnTqeX/dw45ikseBq+Zeubu5Uz1QaUOMIzgYUJtbgJlNBqLWCx3zwY8LsMekMwVoT5tgO4cLWwX2daEmhuorJJvju6L05s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HLIvSPui; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HLIvSPui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6396C4CECD;
	Sat, 23 Nov 2024 18:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732385031;
	bh=znf4LwmiKLLGvxbVhzTeQXiFCUGm6KOIppU0Ug6hGW0=;
	h=From:To:Cc:Subject:Date:From;
	b=HLIvSPuiEtZKJN/TrqpXEnUBvGttyzazq113hZ7QXPDTWeMCgA5rKp2awtk/7jRfq
	 OZJjdVAw/ZhdR5IpCd5raLP5nvBPpYclin+qmbDL7/u5ynuUmOR0FN3PZ3wF3RrCBN
	 wEGhP1KUyypzzYF11KPH/Sfshqbi68rpgjPXN/6p9BC2Z3XzWQQze0/Zs7bxz9xCwy
	 oJ+9F/jq471bs8QxZ/k14XYsKRdOb/vuL3gsiUoOvh0Eu6NO2VJRlWCRtfeX75K25y
	 dzHNLthROWjOb7HzBz8MP35MFq3c/GDCuIs089IyT7z8y5R224gFKHsYUDYOahjZJp
	 rFoU39lLCdU+g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Christian Poveda <git@pvdrz.com>,
	=?UTF-8?q?Emilio=20Cobos=20=C3=81lvarez?= <emilio@crisal.io>
Subject: [PATCH] rust: kbuild: set `bindgen`'s Rust target version
Date: Sat, 23 Nov 2024 19:03:23 +0100
Message-ID: <20241123180323.255997-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Each `bindgen` release may upgrade the list of Rust targets. For instance,
currently, in their master branch [1], the latest ones are:

    Nightly => {
        vectorcall_abi: #124485,
        ptr_metadata: #81513,
        layout_for_ptr: #69835,
    },
    Stable_1_77(77) => { offset_of: #106655 },
    Stable_1_73(73) => { thiscall_abi: #42202 },
    Stable_1_71(71) => { c_unwind_abi: #106075 },
    Stable_1_68(68) => { abi_efiapi: #105795 },

By default, the highest stable release in their list is used, and users
are expected to set one if they need to support older Rust versions
(e.g. see [2]).

Thus, over time, new Rust features are used by default, and at some
point, it is likely that `bindgen` will emit Rust code that requires a
Rust version higher than our minimum (or perhaps enabling an unstable
feature). Currently, there is no problem because the maximum they have,
as seen above, is Rust 1.77.0, and our current minimum is Rust 1.78.0.

Therefore, set a Rust target explicitly now to prevent going forward in
time too much and thus getting potential build failures at some point.

Since we also support a minimum `bindgen` version, and since `bindgen`
does not support passing unknown Rust target versions, we need to use
the list of our minimum `bindgen` version, rather than the latest. So,
since `bindgen` 0.65.1 had this list [3], we need to use Rust 1.68.0:

    /// Rust stable 1.64
    ///  * `core_ffi_c` ([Tracking issue](https://github.com/rust-lang/rust/issues/94501))
    => Stable_1_64 => 1.64;
    /// Rust stable 1.68
    ///  * `abi_efiapi` calling convention ([Tracking issue](https://github.com/rust-lang/rust/issues/65815))
    => Stable_1_68 => 1.68;
    /// Nightly rust
    ///  * `thiscall` calling convention ([Tracking issue](https://github.com/rust-lang/rust/issues/42202))
    ///  * `vectorcall` calling convention (no tracking issue)
    ///  * `c_unwind` calling convention ([Tracking issue](https://github.com/rust-lang/rust/issues/74990))
    => Nightly => nightly;

    ...

    /// Latest stable release of Rust
    pub const LATEST_STABLE_RUST: RustTarget = RustTarget::Stable_1_68;

Thus add the `--rust-target 1.68` parameter. Add a comment as well
explaining this.

An alternative would be to use the currently running (i.e. actual) `rustc`
and `bindgen` versions to pick a "better" Rust target version. However,
that would introduce more moving parts depending on the user setup and
is also more complex to implement.

Cc: Christian Poveda <git@pvdrz.com>
Cc: Emilio Cobos Álvarez <emilio@crisal.io>
Link: https://github.com/rust-lang/rust-bindgen/blob/21c60f473f4e824d4aa9b2b508056320d474b110/bindgen/features.rs#L97-L105 [1]
Link: https://github.com/rust-lang/rust-bindgen/issues/2960 [2]
Link: https://github.com/rust-lang/rust-bindgen/blob/7d243056d335fdc4537f7bca73c06d01aae24ddc/bindgen/features.rs#L131-L150 [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/Makefile | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index f349e7b067ea..1ca63ffee6cd 100644
--- a/rust/Makefile
+++ b/rust/Makefile
@@ -278,9 +278,19 @@ endif
 # architecture instead of generating `usize`.
 bindgen_c_flags_final = $(bindgen_c_flags_lto) -fno-builtin -D__BINDGEN__
 
+# Each `bindgen` release may upgrade the list of Rust target versions. By
+# default, the highest stable release in their list is used. Thus we need to set
+# a `--rust-target` to avoid future `bindgen` releases emitting code that
+# `rustc` may not understand. On top of that, `bindgen` does not support passing
+# an unknown Rust target version.
+#
+# Therefore, the Rust target for `bindgen` can be only as high as the minimum
+# Rust version the kernel supports and only as high as the greatest stable Rust
+# target supported by the minimum `bindgen` version the kernel supports (that
+# is, if we do not test the actual `rustc`/`bindgen` versions running).
 quiet_cmd_bindgen = BINDGEN $@
       cmd_bindgen = \
-	$(BINDGEN) $< $(bindgen_target_flags) \
+	$(BINDGEN) $< $(bindgen_target_flags) --rust-target 1.68 \
 		--use-core --with-derive-default --ctypes-prefix ffi --no-layout-tests \
 		--no-debug '.*' --enable-function-attribute-detection \
 		-o $@ -- $(bindgen_c_flags_final) -DMODULE \

base-commit: b2603f8ac8217bc59f5c7f248ac248423b9b99cb
-- 
2.47.0

