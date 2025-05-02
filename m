Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB5A256C9D;
	Fri,  2 May 2025 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746194593; cv=none; b=CaaYq4ziJ6a5YgFEJLMYH6ALaIE5R+JtYZbd3v5tDuAa7alSjaTw0JcMvJifzg1qieH79MwOMWkE6Y0dTJoZtKC2LWmxF7WxpELqXVlVDKKGTYaBcYSh8sOZwKlEZa6jlDGQFpYRwURuPsvnMh2lS/VG0tLaO1vM8ckOxbJQbHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746194593; c=relaxed/simple;
	bh=rrnV+01T0+qPAKcB4Oo8Wm9xDzxUTNA9dV6DF4q3AcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSvZRfaCCvV9Q3w/lABZq7+YiAyCJMm7JWOBszGE2p8MQDs6a5EEMtoK1HVsOwh2y9VL9Wng4MLQUOiNJyQB2UVVL4IJOhAcNw3c5qoO9SMAyFhH5uENcOXIrvYEZjL11ZXzoKG2cxzkwHvu7hOn/hfYWHwZJRYxgZjiQrgrFsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qp0QSRIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qp0QSRIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF059C4CEEE;
	Fri,  2 May 2025 14:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746194593;
	bh=rrnV+01T0+qPAKcB4Oo8Wm9xDzxUTNA9dV6DF4q3AcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp0QSRIomAvKJbz+U5LCvGYCyU01BuMGu3kqGdK1A4+4bmZyu9GlSOh+wKfVTfJ5M
	 F/8lu7NqNVHB02N/VHVr+0JB0dc1O9AFH/exMehPZ4R2Km5eD1uTKrsODTH1KKKhIA
	 lyOsH8hppjF0o6RX/h5a7kKN9AxJqZj5zyYCSJrZkNnUV9DLLwqk5o8dW5bt5ThFW9
	 BofecH5FtLViHgdCpwPXK2G23yeJ9/rgiNUfnRZGiZ5LYH1pXxbYZTXkcajM9vRhNH
	 0NXg4qQk7JggluSY6yMIj3Uvx2BBy7vFbCG1xVAryQqKQzt5b63qFCVOU4n61TFvjX
	 emBDq/TryySKw==
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
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH 3/5] rust: clean Rust 1.88.0's `unnecessary_transmutes` lint
Date: Fri,  2 May 2025 16:02:35 +0200
Message-ID: <20250502140237.1659624-4-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-1-ojeda@kernel.org>
References: <20250502140237.1659624-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.88.0 (expected 2025-06-26) [1][2], `rustc` may
introduce a new lint that catches unnecessary transmutes, e.g.:

     error: unnecessary transmute
         --> rust/uapi/uapi_generated.rs:23242:18
          |
    23242 |         unsafe { ::core::mem::transmute(self._bitfield_1.get(0usize, 1u8) as u8) }
          |                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: replace this with: `(self._bitfield_1.get(0usize, 1u8) as u8 == 1)`
          |
          = note: `-D unnecessary-transmutes` implied by `-D warnings`
          = help: to override `-D warnings` add `#[allow(unnecessary_transmutes)]`

There are a lot of them (at least 300), but luckily they are all in
`bindgen`-generated code.

Thus clean all up by allowing it there.

Since unknown lints trigger a lint itself in older compilers, do it
conditionally so that we can keep the `unknown_lints` lint enabled.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/136083 [1]
Link: https://github.com/rust-lang/rust/issues/136067 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 init/Kconfig         | 3 +++
 rust/bindings/lib.rs | 1 +
 rust/uapi/lib.rs     | 1 +
 3 files changed, 5 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 63f5974b9fa6..4cdd1049283c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -140,6 +140,9 @@ config LD_CAN_USE_KEEP_IN_OVERLAY
 config RUSTC_HAS_COERCE_POINTEE
 	def_bool RUSTC_VERSION >= 108400
 
+config RUSTC_HAS_UNNECESSARY_TRANSMUTES
+	def_bool RUSTC_VERSION >= 108800
+
 config PAHOLE_VERSION
 	int
 	default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
diff --git a/rust/bindings/lib.rs b/rust/bindings/lib.rs
index 014af0d1fc70..a08eb5518cac 100644
--- a/rust/bindings/lib.rs
+++ b/rust/bindings/lib.rs
@@ -26,6 +26,7 @@
 
 #[allow(dead_code)]
 #[allow(clippy::undocumented_unsafe_blocks)]
+#[cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
 mod bindings_raw {
     // Manual definition for blocklisted types.
     type __kernel_size_t = usize;
diff --git a/rust/uapi/lib.rs b/rust/uapi/lib.rs
index 13495910271f..c98d7a8cde77 100644
--- a/rust/uapi/lib.rs
+++ b/rust/uapi/lib.rs
@@ -24,6 +24,7 @@
     unreachable_pub,
     unsafe_op_in_unsafe_fn
 )]
+#![cfg_attr(CONFIG_RUSTC_HAS_UNNECESSARY_TRANSMUTES, allow(unnecessary_transmutes))]
 
 // Manual definition of blocklisted types.
 type __kernel_size_t = usize;
-- 
2.49.0

