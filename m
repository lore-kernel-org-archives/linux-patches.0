Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC51F3CD8A4;
	Fri,  4 Sep 2026 05:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498471; cv=none; b=DHPYquMA4GXnFKe1BAjpOrFMXZFZD9ZmrGtV4S2/LCBCtJRkuaUb0hTFidB/0OFYxBptO57nf31H/SlhEDSFX52iS0BOyuFUO/Nn2r7sHvQ1mfP3Vmv142eDY8pg4XzJBCd8x1kF8/4TY5N/0yXNfxPOG5PHuXXi4zyUU8RsYNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498471; c=relaxed/simple;
	bh=fO5JMrjvV1t3+7LQP4yEonH5MyNDkKKezrHml+hPbxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Knnz7+GvIxMbqjDKQEQJezqhHm4BvLU6Q/YL4w1SKqh1synh1Q98lFxLgwVLMl9Ql7IQEFE9eMRI3BNhGS7nJo72t6bOyMgo0ECSzqxZA2N4zcAg1KKPOz2PzfJ5sHoMWaxrPituYtTjTi76YGU7Ymcg1PSoXdC0wRZZCVb4VKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HVkmzdxu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HVkmzdxu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F641F00A3D;
	Fri,  4 Sep 2026 05:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498469;
	bh=AVZTEus+DpoUOrL35JWtQlkBMGWP7WDjFVKUbx0uwds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVkmzdxue2tj/y9R+0SowNXvPdqfIaY1+6RD9x585Gd6foHZEzD+eiqkYuz9e9VUr
	 j5clC3VrRtRYwobb0Gxs7P2pLaAQBO+pDoCjkU9yZSKHDtcoFkJkrQtp0uf/bA/faT
	 cPS7LguojacuW6z8LSoKEjpZBkjL+LT2+1O7ZcvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Younes Akhouayri <git@younes.io>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 037/713] rust: num: restrict bool conversion to unsigned Bounded
Date: Fri,  4 Sep 2026 06:50:05 +0200
Message-ID: <20260904045804.663799152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Younes Akhouayri <git@younes.io>

commit 7dd6343fc127935425a81a8f1989907996c2868d upstream.

From<bool> turns true into 1. A signed Bounded with N = 1 can hold
only -1 and 0. The current implementation can therefore create a value
that breaks Bounded's invariant. Deref relies on that invariant and
calls unreachable_unchecked() when it is broken, so safe Rust can reach
undefined behavior.

The other primitive conversions require the source and destination to
have the same signedness. Treat bool as an unsigned one-bit value and
allow conversions between bool and Bounded only when the backing integer
type is unsigned.

Fixes: 01e345e82ec3 ("rust: num: add Bounded integer wrapping type")
Closes: https://lore.kernel.org/rust-for-linux/OzuVxu0--J-9@younes.io/
Cc: stable@vger.kernel.org
Suggested-by: Alexandre Courbot <acourbot@nvidia.com>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Younes Akhouayri <git@younes.io>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Link: https://patch.msgid.link/20260822-fix-rust-bounded-from-bool-submit-v4-1-aa780bfe7f30@younes.io
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/num/bounded.rs |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/rust/kernel/num/bounded.rs
+++ b/rust/kernel/num/bounded.rs
@@ -13,7 +13,10 @@ use core::{
 };
 
 use kernel::{
-    num::Integer,
+    num::{
+        Integer,
+        Unsigned, //
+    },
     prelude::*, //
 };
 
@@ -174,13 +177,16 @@ fn fits_within<T: Integer>(value: T, num
 /// // `u8` (regardless of the passed value).
 /// // let _ = Bounded::<u32, 6>::from(10u8);
 ///
-/// // Booleans can be converted into single-bit `Bounded`s.
+/// // Booleans can be converted into unsigned `Bounded`s.
 ///
 /// let v = Bounded::<u64, 1>::from(false);
 /// assert_eq!(v.get(), 0);
 ///
 /// let v = Bounded::<u64, 1>::from(true);
 /// assert_eq!(v.get(), 1);
+///
+/// // This does not build because `i8` is signed.
+/// // let _ = Bounded::<i8, 2>::from(true);
 /// ```
 ///
 /// Infallible conversions from a [`Bounded`] to a primitive integer are also supported, and
@@ -203,12 +209,16 @@ fn fits_within<T: Integer>(value: T, num
 /// let _v = Bounded::<u32, 10>::new::<10>();
 /// // assert_eq!(u8::from(_v), 10);
 ///
-/// // Single-bit `Bounded`s can be converted into a boolean.
+/// // Unsigned single-bit `Bounded`s can be converted into a boolean.
 /// let v = Bounded::<u8, 1>::new::<1>();
 /// assert_eq!(bool::from(v), true);
 ///
 /// let v = Bounded::<u8, 1>::new::<0>();
 /// assert_eq!(bool::from(v), false);
+///
+/// // This does not build because `i8` is signed.
+/// // let v = Bounded::<i8, 1>::new::<-1>();
+/// // let _ = bool::from(v);
 /// ```
 ///
 /// Fallible conversions from any primitive integer to any [`Bounded`] are also supported using the
@@ -1077,31 +1087,33 @@ impl_into_primitive!(
     i8 i16 i32 i64 isize
 );
 
-// Single-bit `Bounded`s can be converted from/to a boolean.
+// Unsigned single-bit `Bounded`s can be converted to a boolean.
 
 impl<T> From<Bounded<T, 1>> for bool
 where
-    T: Integer + Zeroable,
+    T: Integer<Signedness = Unsigned> + Zeroable,
 {
     fn from(value: Bounded<T, 1>) -> Self {
         value.get() != Zeroable::zeroed()
     }
 }
 
+// Booleans can be converted to unsigned `Bounded`s.
+
 impl<T, const N: u32> From<bool> for Bounded<T, N>
 where
-    T: Integer + From<bool>,
+    T: Integer<Signedness = Unsigned> + From<bool>,
 {
     fn from(value: bool) -> Self {
-        // SAFETY: A boolean can be represented using a single bit, and thus fits within any
-        // integer type for any `N` > 0.
+        // SAFETY: A boolean is represented by `0` or `1`, so it fits within any valid unsigned
+        // `Bounded` width.
         unsafe { Self::__new(T::from(value)) }
     }
 }
 
 impl<T> Bounded<T, 1>
 where
-    T: Integer + Zeroable,
+    T: Integer<Signedness = Unsigned> + Zeroable,
 {
     /// Converts this [`Bounded`] into a [`bool`].
     ///


