Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1341FE44A;
	Thu, 30 Jul 2026 14:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422814; cv=none; b=HS7RM15QezkkCVIMJoMqX44nZvNWPktycV9jG1tl21Hd8fbwWa4DtzqjG2FcOxUe59p6R4kVPhzyIT6HzrbSVsfuwXoeqielJ9+0nbv5mRMQPsIekPoOuseuvk/aBJjtDxjVTxPFS6UMSb4gtkGUIX8CiHlhRbStKl58N/EeZ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422814; c=relaxed/simple;
	bh=6rt2LCJxy3UkAt+drd5w/OS7L8oyYKfIJG7Hrwcfnzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEhcAzmQncBgsIPAslnaQNes5wGQqT78PdDu94VlakxGM00H/r23nTzWKuSmrdjsiMHqMw28nFFtVMr3PkTrGJB3sgw487Cfbb0+Q0DravL22yOQ2hDI1ono2TMxSPwDtOzoOqz12wUw2DInCJ2ZE5vvM+HiXK6oTX40vcNoVGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PWQez2E8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWQez2E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A351F000E9;
	Thu, 30 Jul 2026 14:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422813;
	bh=QlXwREh1EMftH2secE6qcQN6eAiBjlq9CzSSD4j1YLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PWQez2E8uEpMz2X0eEHTNsYLCOWcq5ibmtZEE3K3WkjkhnpsBa1ZcV6VJTuBYL+Ui
	 xMncabPVvlk7MZStmgNwsWodWn73ZpzBEavlGrc4cCXttkUVxhlbQG81F21vENnoV+
	 KX21cZTYJJsqvHVCT1+hS0zvCTWqrQQ2Fqhv3yJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Urgau <urgau@numericable.fr>,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.1 566/744] rust: allow `suspicious_runtime_symbol_definitions` lint for Rust >= 1.98
Date: Thu, 30 Jul 2026 16:13:59 +0200
Message-ID: <20260730141456.315838960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -190,6 +190,9 @@ config RUSTC_HAS_FILE_WITH_NUL
 config RUSTC_HAS_FILE_AS_C_STR
 	def_bool RUSTC_VERSION >= 109100
 
+config RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS
+	def_bool RUSTC_VERSION >= 109800
+
 config PAHOLE_VERSION
 	int
 	default "$(PAHOLE_VERSION)"
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -27,6 +27,10 @@
 #[allow(clippy::ref_as_ptr)]
 #[allow(clippy::undocumented_unsafe_blocks)]
 #[cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#[cfg_attr(
+    CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
+    allow(suspicious_runtime_symbol_definitions)
+)]
 mod bindings_raw {
     use pin_init::{MaybeZeroable, Zeroable};
 
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -24,6 +24,10 @@
     unsafe_op_in_unsafe_fn
 )]
 #![cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
+#![cfg_attr(
+    CONFIG_RUSTC_HAS_SUSPICIOUS_RUNTIME_SYMBOL_DEFINITIONS,
+    allow(suspicious_runtime_symbol_definitions)
+)]
 #![feature(cfi_encoding)]
 
 // Manual definition of blocklisted types.


