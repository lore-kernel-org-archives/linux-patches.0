Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA59F1FA0
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 05:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C709C433CA;
	Tue, 18 Jul 2023 05:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689658106;
	bh=bvivGepDndSvptaKNIoTWkS98RX36lJSPuREir1yVK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2CLuNMUouQ4+jmHUauVjHLHjhnGbDLNwi3hpjl6buHdtgxvBSxyN3ibuaX6sInaw
	 P3atD44mpqqMaj+pe+YTnf6twknFRXg+5S7lkBG2SuZG8rcDDd9oOz+4nPFyVsRzWR
	 u0hs1nPQSoY/rApYzFlPRRGs5PeJTvfc6RpwAl66hdH1Xh/2LthmD3zzEUInqBPbtJ
	 cAnS2M2mgL08dvL7+KpPRtU0PdOmmXVEm/QJ69sisuL7zQlG+CdoOH+QHOkojwZwiZ
	 FHGPsTFPROOuqYKdKzRhkxHyHm23ez8fzil+og2/fQdZPAqfI3qhqExp/ooggm/CXi
	 6/YI6tsFh+knQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: David Gow <davidgow@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v2 2/7] rust: init: make doctests compilable/testable
Date: Tue, 18 Jul 2023 07:27:47 +0200
Message-ID: <20230718052752.1045248-3-ojeda@kernel.org>
In-Reply-To: <20230718052752.1045248-1-ojeda@kernel.org>
References: <20230718052752.1045248-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Rust documentation tests are going to be build/run-tested
with the KUnit integration added in a future patch, thus
update them to make them compilable/testable so that we
may start enforcing it.

Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init.rs | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index b4332a4ec1f4..e05563aad2ed 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -120,14 +120,24 @@
 //!   `slot` gets called.
 //!
 //! ```rust
-//! use kernel::{prelude::*, init};
+//! # #![allow(unreachable_pub, clippy::disallowed_names)]
+//! use kernel::{prelude::*, init, types::Opaque};
 //! use core::{ptr::addr_of_mut, marker::PhantomPinned, pin::Pin};
 //! # mod bindings {
+//! #     #![allow(non_camel_case_types)]
 //! #     pub struct foo;
 //! #     pub unsafe fn init_foo(_ptr: *mut foo) {}
 //! #     pub unsafe fn destroy_foo(_ptr: *mut foo) {}
 //! #     pub unsafe fn enable_foo(_ptr: *mut foo, _flags: u32) -> i32 { 0 }
 //! # }
+//! # // `Error::from_errno` is `pub(crate)` in the `kernel` crate, thus provide a workaround.
+//! # trait FromErrno {
+//! #     fn from_errno(errno: core::ffi::c_int) -> Error {
+//! #         // Dummy error that can be constructed outside the `kernel` crate.
+//! #         Error::from(core::fmt::Error)
+//! #     }
+//! # }
+//! # impl FromErrno for Error {}
 //! /// # Invariants
 //! ///
 //! /// `foo` is always initialized
@@ -158,7 +168,7 @@
 //!                 if err != 0 {
 //!                     // Enabling has failed, first clean up the foo and then return the error.
 //!                     bindings::destroy_foo(Opaque::raw_get(foo));
-//!                     return Err(Error::from_kernel_errno(err));
+//!                     return Err(Error::from_errno(err));
 //!                 }
 //!
 //!                 // All fields of `RawFoo` have been initialized, since `_p` is a ZST.
@@ -226,8 +236,7 @@
 ///
 /// ```rust
 /// # #![allow(clippy::disallowed_names, clippy::new_ret_no_self)]
-/// # use kernel::{init, pin_init, stack_pin_init, init::*, sync::Mutex, new_mutex};
-/// # use macros::pin_data;
+/// # use kernel::{init, macros::pin_data, pin_init, stack_pin_init, init::*, sync::Mutex, new_mutex};
 /// # use core::pin::Pin;
 /// #[pin_data]
 /// struct Foo {
@@ -277,7 +286,7 @@ macro_rules! stack_pin_init {
 ///
 /// # Examples
 ///
-/// ```rust
+/// ```rust,ignore
 /// # #![allow(clippy::disallowed_names, clippy::new_ret_no_self)]
 /// # use kernel::{init, pin_init, stack_try_pin_init, init::*, sync::Mutex, new_mutex};
 /// # use macros::pin_data;
@@ -303,7 +312,7 @@ macro_rules! stack_pin_init {
 /// pr_info!("a: {}", &*foo.a.lock());
 /// ```
 ///
-/// ```rust
+/// ```rust,ignore
 /// # #![allow(clippy::disallowed_names, clippy::new_ret_no_self)]
 /// # use kernel::{init, pin_init, stack_try_pin_init, init::*, sync::Mutex, new_mutex};
 /// # use macros::pin_data;
@@ -513,8 +522,7 @@ macro_rules! stack_try_pin_init {
 /// For instance:
 ///
 /// ```rust
-/// # use kernel::pin_init;
-/// # use macros::pin_data;
+/// # use kernel::{macros::pin_data, pin_init};
 /// # use core::{ptr::addr_of_mut, marker::PhantomPinned};
 /// #[pin_data]
 /// struct Buf {
@@ -841,7 +849,7 @@ macro_rules! init {
 /// # Examples
 ///
 /// ```rust
-/// use kernel::{init::PinInit, error::Error, InPlaceInit};
+/// use kernel::{init::{PinInit, zeroed}, error::Error};
 /// struct BigBuf {
 ///     big: Box<[u8; 1024 * 1024 * 1024]>,
 ///     small: [u8; 1024 * 1024],
-- 
2.41.0

