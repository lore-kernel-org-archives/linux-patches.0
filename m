Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CD9189901;
	Wed,  4 Sep 2024 20:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482737; cv=none; b=SHwWW8pTYTKd7B+sqnWSp0RSvKSGWzO4tqWoi69KSO0Ell46Tms9O4EUcpQua04NEnNTES7HwR14qQNnsjKTcnVY/7mDRUU9z6k9ejs94frpY7ln59ESZRWrNbkCOqiadhT8veq3EkIk6hiceM+wiHpK1dlFSIN4+i2biI1JaSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482737; c=relaxed/simple;
	bh=cBnyB+G22zZM8jvLBjn3o4X1EmQK4MqorlwyKyCTf9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWif67RDiRhDUHVlahwhSwanceEkFUkWPPMhM0yYu4iBBQHZXrH84AEzVVbujHqUWVPqQfy5J5I6KeOXxZspclBt45P6AVgolZoPx6dOLnV6y+AvZUZsS5rE7AGTuCYVtt8+UnqCrM5VCt+d1jgxQGc0VRQhn9VKW8LsWnKihW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMqpNZmv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMqpNZmv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F9BC4CEC8;
	Wed,  4 Sep 2024 20:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482737;
	bh=cBnyB+G22zZM8jvLBjn3o4X1EmQK4MqorlwyKyCTf9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMqpNZmv8k3eO1eYwnnKP187I5CEFxSqg+kzToGlDhRdxXTB42lj2sTFI0iMS4JUo
	 nrWIB28EDnsepmQ5gqAm91KjoV/SiJt9j1KeD4GiEfnRsBzENCHZ61sz+nZieVXa2h
	 fsST0DSvEBX8wGoLvzJfmpK+aAkIP7bsHg0mCnd/wToE51h+bC4xIyLBPLeshb1Gkn
	 XFrekKtPXA6A0Z857mb5q8yESoPWH4P79UqfhAGpOLtLsL9x75AJZPNbLboiR2rj0T
	 n/X/iYXTWq0Kd9JfAh9+VGEKq710LI8JCBhRBs8nXBl3+n4AfumbktIIX0kHByLyir
	 YkukUqhpwZdzw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 15/19] rust: enable Clippy's `check-private-items`
Date: Wed,  4 Sep 2024 22:43:43 +0200
Message-ID: <20240904204347.168520-16-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Rust 1.76.0, Clippy added the `check-private-items` lint configuration
option. When turned on (the default is off), it makes several lints
check private items as well.

In our case, it affects two lints we have enabled [1]:
`missing_safety_doc` and `unnecessary_safety_doc`.

It also seems to affect the new `too_long_first_doc_paragraph` lint [2],
even though the documentation does not mention it.

Thus allow the few instances remaining we currently hit and enable
the lint.

Link: https://doc.rust-lang.org/nightly/clippy/lint_configuration.html#check-private-items [1]
Link: https://rust-lang.github.io/rust-clippy/master/index.html#/too_long_first_doc_paragraph [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 .clippy.toml                   | 2 ++
 rust/kernel/init.rs            | 1 +
 rust/kernel/init/__internal.rs | 2 ++
 rust/kernel/init/macros.rs     | 1 +
 rust/kernel/print.rs           | 1 +
 5 files changed, 7 insertions(+)

diff --git a/.clippy.toml b/.clippy.toml
index ad9f804fb677..e4c4eef10b28 100644
--- a/.clippy.toml
+++ b/.clippy.toml
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+check-private-items = true
+
 disallowed-macros = [
     # The `clippy::dbg_macro` lint only works with `std::dbg!`, thus we simulate
     # it here, see: https://github.com/rust-lang/rust-clippy/issues/11303.
diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index aec26a4decb1..10ec90a5f5d8 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -125,6 +125,7 @@
 //! use core::{ptr::addr_of_mut, marker::PhantomPinned, pin::Pin};
 //! # mod bindings {
 //! #     #![allow(non_camel_case_types)]
+//! #     #![allow(clippy::missing_safety_doc)]
 //! #     pub struct foo;
 //! #     pub unsafe fn init_foo(_ptr: *mut foo) {}
 //! #     pub unsafe fn destroy_foo(_ptr: *mut foo) {}
diff --git a/rust/kernel/init/__internal.rs b/rust/kernel/init/__internal.rs
index 163eb072f296..549ae227c2ea 100644
--- a/rust/kernel/init/__internal.rs
+++ b/rust/kernel/init/__internal.rs
@@ -54,6 +54,7 @@ unsafe fn __pinned_init(self, slot: *mut T) -> Result<(), E> {
 pub unsafe trait HasPinData {
     type PinData: PinData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __pin_data() -> Self::PinData;
 }
 
@@ -83,6 +84,7 @@ fn make_closure<F, O, E>(self, f: F) -> F
 pub unsafe trait HasInitData {
     type InitData: InitData;
 
+    #[allow(clippy::missing_safety_doc)]
     unsafe fn __init_data() -> Self::InitData;
 }
 
diff --git a/rust/kernel/init/macros.rs b/rust/kernel/init/macros.rs
index 93af8f3d8d4d..8733ba3834ab 100644
--- a/rust/kernel/init/macros.rs
+++ b/rust/kernel/init/macros.rs
@@ -989,6 +989,7 @@ fn drop(&mut self) {
         //
         // The functions are `unsafe` to prevent accidentally calling them.
         #[allow(dead_code)]
+        #[allow(clippy::missing_safety_doc)]
         impl<$($impl_generics)*> $pin_data<$($ty_generics)*>
         where $($whr)*
         {
diff --git a/rust/kernel/print.rs b/rust/kernel/print.rs
index fe53fc469c4f..45af17095a24 100644
--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -14,6 +14,7 @@
 use crate::str::RawFormatter;
 
 // Called from `vsprintf` with format specifier `%pA`.
+#[allow(clippy::missing_safety_doc)]
 #[no_mangle]
 unsafe extern "C" fn rust_fmt_argument(
     buf: *mut c_char,
-- 
2.46.0

