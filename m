Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9DA21A76B5;
	Sat, 23 Nov 2024 22:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732400948; cv=none; b=k3xWgYHZxIMwNP7kczrNg/FTpvNivLTKA5wgr2x1RbCZRalKMTxLhtDF/H/qM4y4FUQoWN4sxiwWWkDC0nS0zlMXnO/PK1zbmLiIyYql+Y+Iz+Rygs6jqyNGRYzAKv/198mbZrmKOMYUYUmOIJzTkJPuGxGN5V/aET+2878DABk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732400948; c=relaxed/simple;
	bh=EfqQMqbewNi5Q0JETOl053CaTiHNe0XxlEiK6n0WTGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA3AeI8P8B8HMSL4EY8iH9joioJMawvuTunzAe0oDgxo7OtbS6Uyc/UjhYooSlcYhA5/xrTFdoRYFdaQU1iM0s6nE203Udm7aXD9tWeJs5lFBEcoCasbyJI/RLJ9IySXiLPKkAvbHXnANV3uRJviTnAzsrI2QppU7GHPe68gPwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tw5Zgmrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tw5Zgmrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AC8C4CED0;
	Sat, 23 Nov 2024 22:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732400947;
	bh=EfqQMqbewNi5Q0JETOl053CaTiHNe0XxlEiK6n0WTGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tw5ZgmrlXhLVac5/eeFisRRhfh29LiVwhkYm0odzharzUiqUcp8lThKgCZGNcU1HC
	 do6GhTC6NcF3wEfAOCMFm0Z06ZvHvosAtUTiBWGiacoem9oSuNC1esAvkDHWYW1n7g
	 HRXCP1gtiEOVO1xcIbDoCzHJx4pbFX+A25/94t+L8utZ8v82vzMrAlXom574nUwh7h
	 T6AZdQRtJ0AZEOkzWTgvxPdvplSf43NNu9E8rzJbyGdfqEP0Bk0vSrMvXen7x48crW
	 FeLOQM0eSmdixOkRfLCgJtHUTfEbOqaCaVFyCf6y1XFTnS4xjEja4DsjXicQY2RKl8
	 3ptb0NN3oQhXg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 3/3] rust: add `build_error!` to the prelude
Date: Sat, 23 Nov 2024 23:28:49 +0100
Message-ID: <20241123222849.350287-3-ojeda@kernel.org>
In-Reply-To: <20241123222849.350287-1-ojeda@kernel.org>
References: <20241123222849.350287-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The sibling `build_assert!` is already in the prelude, it makes sense
that a "core"/"language" facility like this is part of the prelude and
users should not be defining their own one (thus there should be no risk
of future name collisions and we would want to be aware of them anyway).

Thus add `build_error!` into the prelude.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/block/mq/operations.rs |  3 ++-
 rust/kernel/build_assert.rs        |  1 -
 rust/kernel/net/phy.rs             | 18 +++++++++---------
 rust/kernel/prelude.rs             |  2 +-
 rust/macros/lib.rs                 |  8 ++++----
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 962f16a5a530..864ff379dc91 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -9,6 +9,7 @@
     block::mq::request::RequestDataWrapper,
     block::mq::Request,
     error::{from_result, Result},
+    prelude::*,
     types::ARef,
 };
 use core::{marker::PhantomData, sync::atomic::AtomicU64, sync::atomic::Ordering};
@@ -35,7 +36,7 @@ pub trait Operations: Sized {
     /// Called by the kernel to poll the device for completed requests. Only
     /// used for poll queues.
     fn poll() -> bool {
-        crate::build_error!(crate::error::VTABLE_DEFAULT_ERROR)
+        build_error!(crate::error::VTABLE_DEFAULT_ERROR)
     }
 }
 
diff --git a/rust/kernel/build_assert.rs b/rust/kernel/build_assert.rs
index 347ba5ce50f4..6331b15d7c4d 100644
--- a/rust/kernel/build_assert.rs
+++ b/rust/kernel/build_assert.rs
@@ -14,7 +14,6 @@
 /// # Examples
 ///
 /// ```
-/// # use kernel::build_error;
 /// #[inline]
 /// fn foo(a: usize) -> usize {
 ///     a.checked_add(1).unwrap_or_else(|| build_error!("overflow"))
diff --git a/rust/kernel/net/phy.rs b/rust/kernel/net/phy.rs
index f488f6c55e9a..654311a783e9 100644
--- a/rust/kernel/net/phy.rs
+++ b/rust/kernel/net/phy.rs
@@ -587,17 +587,17 @@ pub trait Driver {
 
     /// Issues a PHY software reset.
     fn soft_reset(_dev: &mut Device) -> Result {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Sets up device-specific structures during discovery.
     fn probe(_dev: &mut Device) -> Result {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Probes the hardware to determine what abilities it has.
     fn get_features(_dev: &mut Device) -> Result {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Returns true if this is a suitable driver for the given phydev.
@@ -609,32 +609,32 @@ fn match_phy_device(_dev: &Device) -> bool {
     /// Configures the advertisement and resets auto-negotiation
     /// if auto-negotiation is enabled.
     fn config_aneg(_dev: &mut Device) -> Result {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Determines the negotiated speed and duplex.
     fn read_status(_dev: &mut Device) -> Result<u16> {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Suspends the hardware, saving state if needed.
     fn suspend(_dev: &mut Device) -> Result {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Resumes the hardware, restoring state if needed.
     fn resume(_dev: &mut Device) -> Result {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Overrides the default MMD read function for reading a MMD register.
     fn read_mmd(_dev: &mut Device, _devnum: u8, _regnum: u16) -> Result<u16> {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Overrides the default MMD write function for writing a MMD register.
     fn write_mmd(_dev: &mut Device, _devnum: u8, _regnum: u16, _val: u16) -> Result {
-        kernel::build_error!(VTABLE_DEFAULT_ERROR)
+        build_error!(VTABLE_DEFAULT_ERROR)
     }
 
     /// Callback for notification of link change.
diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 8bdab9aa0d16..ed076b3062ae 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -19,7 +19,7 @@
 #[doc(no_inline)]
 pub use macros::{module, pin_data, pinned_drop, vtable, Zeroable};
 
-pub use super::build_assert;
+pub use super::{build_assert, build_error};
 
 // `super::std_vendor` is hidden, which makes the macro inline for some reason.
 #[doc(no_inline)]
diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 1a30c8075ebd..d61bc6a56425 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -123,12 +123,12 @@ pub fn module(ts: TokenStream) -> TokenStream {
 /// used on the Rust side, it should not be possible to call the default
 /// implementation. This is done to ensure that we call the vtable methods
 /// through the C vtable, and not through the Rust vtable. Therefore, the
-/// default implementation should call `kernel::build_error!`, which prevents
+/// default implementation should call `build_error!`, which prevents
 /// calls to this function at compile time:
 ///
 /// ```compile_fail
 /// # // Intentionally missing `use`s to simplify `rusttest`.
-/// kernel::build_error!(VTABLE_DEFAULT_ERROR)
+/// build_error!(VTABLE_DEFAULT_ERROR)
 /// ```
 ///
 /// Note that you might need to import [`kernel::error::VTABLE_DEFAULT_ERROR`].
@@ -145,11 +145,11 @@ pub fn module(ts: TokenStream) -> TokenStream {
 /// #[vtable]
 /// pub trait Operations: Send + Sync + Sized {
 ///     fn foo(&self) -> Result<()> {
-///         kernel::build_error!(VTABLE_DEFAULT_ERROR)
+///         build_error!(VTABLE_DEFAULT_ERROR)
 ///     }
 ///
 ///     fn bar(&self) -> Result<()> {
-///         kernel::build_error!(VTABLE_DEFAULT_ERROR)
+///         build_error!(VTABLE_DEFAULT_ERROR)
 ///     }
 /// }
 ///
-- 
2.47.0

