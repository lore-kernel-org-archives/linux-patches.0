Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60F31F943F;
	Tue, 17 Dec 2024 17:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456781; cv=none; b=BV9dxivFp3mYfPD6G8BOcwPY8qcJWA/KfZbxBedTAsGWBQKlS6Jb/qs4vkpYiqNwduRDSUMO/tinG+6QK7pI9wiEKzw0JLyoxVQE5Gq9lrsNIyPTSfblXt3Qj2XYPixtQQSqbZdp2w5AzBHbDV1iaIPuRMgrx3c2i4nQ6oZBFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456781; c=relaxed/simple;
	bh=JOhfd4fjlxyqH7xDTcf9QTKnphS5r+LjgVzNgDrm2pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PbqwiEP7p1xp1hC83vIE4OfXibGMrpTjbCG0FovZaTawuGiixDW8gZf996BJf68EzCp1njfiIg1dfnq6aaklmd2W7xJg6s1015DTghQDSj3828I6XDgJSE78DLHxp+uSi1BuidcZvWPt3KslUqF8ByCZQIFoMuZNvRHVj7yC0H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrnPO4xX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrnPO4xX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52925C4CED7;
	Tue, 17 Dec 2024 17:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456781;
	bh=JOhfd4fjlxyqH7xDTcf9QTKnphS5r+LjgVzNgDrm2pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrnPO4xXTu+l0OR0FFYe2/8d1ZaTvk97sp8Bw+wJA7owIH/M8RpRJuk/NxzOgBDVM
	 I3jZFjPb9KLKXJPqcywMxXRtsUWWIYb0+T7GTjC43aw5bylQqdAHaFYgyn6+3EgUHl
	 14Ya/Bb8jmhpGOk6gBar+vK7hskQxOcUY3Rv811M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Poveda <git@pvdrz.com>,
	=?UTF-8?q?Emilio=20Cobos=20=C3=81lvarez?= <emilio@crisal.io>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 163/172] rust: kbuild: set `bindgen`s Rust target version
Date: Tue, 17 Dec 2024 18:08:39 +0100
Message-ID: <20241217170553.090087629@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 7a5f93ea5862da91488975acaa0c7abd508f192b upstream.

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

Starting with `bindgen` 0.71.0 [4], we will be able to set any future
Rust version instead, i.e. we will be able to set here our minimum
supported Rust version. Christian implemented it [5] after seeing this
patch. Thanks!

Cc: Christian Poveda <git@pvdrz.com>
Cc: Emilio Cobos Álvarez <emilio@crisal.io>
Cc: stable@vger.kernel.org # needed for 6.12.y; unneeded for 6.6.y; do not apply to 6.1.y
Fixes: c844fa64a2d4 ("rust: start supporting several `bindgen` versions")
Link: https://github.com/rust-lang/rust-bindgen/blob/21c60f473f4e824d4aa9b2b508056320d474b110/bindgen/features.rs#L97-L105 [1]
Link: https://github.com/rust-lang/rust-bindgen/issues/2960 [2]
Link: https://github.com/rust-lang/rust-bindgen/blob/7d243056d335fdc4537f7bca73c06d01aae24ddc/bindgen/features.rs#L131-L150 [3]
Link: https://github.com/rust-lang/rust-bindgen/blob/main/CHANGELOG.md#0710-2024-12-06 [4]
Link: https://github.com/rust-lang/rust-bindgen/pull/2993 [5]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20241123180323.255997-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/Makefile |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/rust/Makefile
+++ b/rust/Makefile
@@ -267,9 +267,22 @@ endif
 
 bindgen_c_flags_final = $(bindgen_c_flags_lto) -D__BINDGEN__
 
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
+#
+# Starting with `bindgen` 0.71.0, we will be able to set any future Rust version
+# instead, i.e. we will be able to set here our minimum supported Rust version.
 quiet_cmd_bindgen = BINDGEN $@
       cmd_bindgen = \
-	$(BINDGEN) $< $(bindgen_target_flags) \
+	$(BINDGEN) $< $(bindgen_target_flags) --rust-target 1.68 \
 		--use-core --with-derive-default --ctypes-prefix core::ffi --no-layout-tests \
 		--no-debug '.*' --enable-function-attribute-detection \
 		-o $@ -- $(bindgen_c_flags_final) -DMODULE \


