Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512B6143C69;
	Sun, 15 Dec 2024 14:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734274681; cv=none; b=sgMtwWM6xz7XaCiIr3lmHJ4tJ4z/jeWA70e3rlxMcPyL4I92P79JWXh8NVTsSakKlmeeMML7fKFRCSCyoNTQQAFeajjVHuU6pO8IuYOgdIpEZyIxH07wKysoOO7d/uaFcQ1R1Ep9rILGXRHR9RBHfZoPtdOdaRAr/dZOcEQjqGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734274681; c=relaxed/simple;
	bh=bLqiIUlt20Jld63ONUwAvSfGMJlPjgwEaqK5EmB1zVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tAi/9a+B+UNpkfURH1m973um+Ac/A/Vyh94aF5/mxiTjS2fQFzrtpsq6nOoY3wUfULMhYFraCxGKhkmV9G+iWW0YQrOoGJGWKbmZZmtHBfG2f6x9L785CPL79j4EbxxI85jl0tZI6y26F3cv7EhdhhPUj3YXyajq89NKNLrSjE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eaE2pkxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eaE2pkxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CA5C4CECE;
	Sun, 15 Dec 2024 14:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734274680;
	bh=bLqiIUlt20Jld63ONUwAvSfGMJlPjgwEaqK5EmB1zVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaE2pkxslAyUy+Qk8zATSo4Oco1x7tU0xa2joPsC6z720WYRUtDhbR40b9sas5rTx
	 I6Df2GyIbSyZ/g85CjmOj9Dj5Fbwu/5UKlswY9E9X8MqKYO7xWHkMo1+IWbvqFBUSc
	 4871bhSf/P0boKECRv2kHfn002/gkFPVqMNxagvJZ37T2E3a9T4qg2Oic/7+e7tKB/
	 777K4tMHPdyvxoIPFJczxZvlK1wolA6PUBfJ3vapd4m8mrg6NihHyW9EAc8myStwws
	 wI8pFKR9CAdS6+J/M0+R0DcQiaMEHQsoKEgbR1VC7GbXUC2KnQyHcsUzyqd4jx+nL2
	 REoxdpKAmCKrA==
From: Miguel Ojeda <ojeda@kernel.org>
To: stable@vger.kernel.org
Cc: patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Christian Poveda <git@pvdrz.com>,
	=?UTF-8?q?Emilio=20Cobos=20=C3=81lvarez?= <emilio@crisal.io>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.12.y] rust: kbuild: set `bindgen`'s Rust target version
Date: Sun, 15 Dec 2024 15:57:40 +0100
Message-ID: <20241215145740.237008-1-ojeda@kernel.org>
In-Reply-To: <2024121500-switch-jab-65fc@gregkh>
References: <2024121500-switch-jab-65fc@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 rust/Makefile | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/rust/Makefile b/rust/Makefile
index b5e0a73b78f3..9f59baacaf77 100644
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
-- 
2.47.1

