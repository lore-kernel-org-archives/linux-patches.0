Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB23C3914ED;
	Thu, 30 Jul 2026 15:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426565; cv=none; b=p2rPhIiChJpCRC5rl66Wye2OIajXr9l9g+I3GtQMTnxkq0OA7IYXWbR68nd4bQLTazGWFvgEGDEJJ6s1jlWQrjEvR+eVdRJbHUyKO1qtrsAEWfZsut6H6U2q75xEuOm8ZFDuHWx15bFUOQgVmVfQNCM/EgOaPtsWfwEek1C0gHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426565; c=relaxed/simple;
	bh=/VndK2GnT2puCY2G+cFEM8XlY0FSDVBuFLPfDwU5GzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqgCdlaIFs/Q3EQDZtSFqQSR0AnaUDtXJkBmaZurQ5zwWPqMJyXYWVPSfDzslXJhaFcbC1aHq4NGUnGgqb+2FRQ9FxtRQzRiG6/oF3rF2OHJyCJkcbJ7CLNlBZ0T20aB0k4TdDdL3/3UjNTzlumdfxPbLihz7f+lMZiA3rfhR+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLhVpBZp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLhVpBZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BB71F000E9;
	Thu, 30 Jul 2026 15:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426564;
	bh=v+ddIzqAAYZOQIxCbI6vIoQnvgK9MAVVijmgwaDhZqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLhVpBZpaAt5ivWP1oNak/waabaPgcALMqctHRpLttgTOOtmCT1FSyYYIO4dQph1m
	 7CoA/QuPGKf9Ehywi+IahBvQFIMKTxkmaGlKuq+uTk7VPLxD+WYioyZen8fAm+Bwrf
	 1FFuxhfUDD5xc4lf5XNz8KhCIqEjv698E4ETzea8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Urgau <urgau@numericable.fr>,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 462/602] rust: allow `suspicious_runtime_symbol_definitions` lint for Rust >= 1.98
Date: Thu, 30 Jul 2026 16:14:14 +0200
Message-ID: <20260730141445.667376097@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 608045a91d9176d66b2114d0006bc8b57dff2ca9 upstream.

Starting with Rust 1.98.0 (expected 2026-08-20), Rust is introducing a
couple new lints, `invalid_runtime_symbol_definitions` (deny-by-default)
and `suspicious_runtime_symbol_definitions` (warn-by-default), which check
the signature of items whose symbol name is a runtime symbol expected by
`core`.

Our build hits the second one, i.e. the warning:

    error: suspicious definition of the runtime `strlen` symbol used by the standard library
         --> rust/bindings/bindings_generated.rs:20018:5
          |
    20018 |     pub fn strlen(s: *const ffi::c_char) -> usize;
          |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          |
          = note: expected `unsafe extern "C" fn(*const i8) -> usize`
                  found    `unsafe extern "C" fn(*const u8) -> usize`
          = help: either fix the signature or remove any attributes like `#[unsafe(no_mangle)]`, `#[unsafe(export_name = "strlen")]`, or `#[link_name = "strlen"]`
          = help: allow this lint if the signature is compatible
          = note: `-D suspicious-runtime-symbol-definitions` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(suspicious_runtime_symbol_definitions)]`

    error: suspicious definition of the runtime `strlen` symbol used by the standard library
         --> rust/uapi/uapi_generated.rs:14236:5
          |
    14236 |     pub fn strlen(s: *const ffi::c_char) -> usize;
          |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
          |
          = note: expected `unsafe extern "C" fn(*const i8) -> usize`
                  found    `unsafe extern "C" fn(*const u8) -> usize`
          = help: either fix the signature or remove any attributes like `#[unsafe(no_mangle)]`, `#[unsafe(export_name = "strlen")]`, or `#[link_name = "strlen"]`
          = help: allow this lint if the signature is compatible
          = note: `-D suspicious-runtime-symbol-definitions` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(suspicious_runtime_symbol_definitions)]`

Thus `allow` the lint in `bindings` and `uapi`.

A more targeted alternative to avoid `allow`ing it would be to pass
`--blocklist-function strlen` to `bindgen`, but we would perhaps need
to adjust if other C headers end up adding more (or Rust checking more).
Since it is just the less critical one that we hit, and since eventually
this should be properly fixed by getting upstream Rust to provide a flag
like GCC/Clang's `-funsigned-char` [2][3], just `allow` it for now.

Cc: Urgau <urgau@numericable.fr>
Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/155521 [1]
Link: https://github.com/rust-lang/rust/issues/138446 [2]
Link: https://github.com/Rust-for-Linux/linux/issues/355 [3]
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Tamir Duberstein <tamird@kernel.org>
Link: https://patch.msgid.link/20260615143225.471756-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 init/Kconfig         |    3 +++
 rust/bindings/lib.rs |    4 ++++
 rust/uapi/lib.rs     |    4 ++++
 3 files changed, 11 insertions(+)

--- a/init/Kconfig
+++ b/init/Kconfig
@@ -140,6 +140,9 @@ config LD_CAN_USE_KEEP_IN_OVERLAY
 config RUSTC_HAS_UNNECESSARY_TRANSMUTES
 	def_bool RUSTC_VERSION >= 108800
 
+config RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS
+	def_bool RUSTC_VERSION >= 109800
+
 config PAHOLE_VERSION
 	int
 	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -27,6 +27,10 @@
 #[allow(dead_code)]
 #[allow(clippy::undocumented_unsafe_blocks)]
 #[cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#[cfg_attr(
+    CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
+    allow(suspicious_runtime_symbol_definitions)
+)]
 mod bindings_raw {
     // Manual definition for blocklisted types.
     type __kernel_size_t = usize;
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -25,6 +25,10 @@
     unsafe_op_in_unsafe_fn
 )]
 #![cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#![cfg_attr(
+    CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
+    allow(suspicious_runtime_symbol_definitions)
+)]
 
 // Manual definition of blocklisted types.
 type __kernel_size_t = usize;


