Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740F83002A9;
	Tue, 31 Mar 2026 17:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976618; cv=none; b=GbGS/gGwUoXflr1ip5LPhnCwd80b1s9ZaxANFlPB2kMDmuWrw6CfJ8BNKi2Vj+aGf/QLC9jmw+RBH5TB0dkfN6NYV34KGihAKzUWZmWxHn+wyMABBA1JeAQX9HZSeKS84iEKPDN6yVax8QQL2YmVYo839tJGM6r1c4DqN00WBfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976618; c=relaxed/simple;
	bh=FJLL2qKuK7G1dS/J3bqGsryNLE+Ayw+m5/UOQqwHD4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQBg2M3WfJ4tpILLNhPab664xco/GnHRuqkiC7yhBf3OHHqItViiEBX+lNcTz6TCXEy+8HBwv7Rmwk+G6Se7cetsmDhj8yuTkN06Fj1WRHQXyrs7F6FSOtMXEzlxoBnhvh8my/XYCYe5kvFNhN4xdeV8uhELeCLQalxu/3Bd/zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gICV1jgK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gICV1jgK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADA8C19423;
	Tue, 31 Mar 2026 17:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976618;
	bh=FJLL2qKuK7G1dS/J3bqGsryNLE+Ayw+m5/UOQqwHD4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gICV1jgK0l0sn5KNR1l9ekWqjicrE145PB3gNrLrOTZZ+qNDE6YDb3h7s6J+GDAJQ
	 4bCyci2NjO0fsJgkXGH5KzNzGhFUzRn0tqyiBJWm+BKtl9xN7CSYY3CXuzBFGvJnxI
	 BfuR1/uv6Y8rUzJkxnvfuCdrvgrqVqzCRoTulkPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/309] rust: regulator: do not assume that regulator_get() returns non-null
Date: Tue, 31 Mar 2026 18:21:04 +0200
Message-ID: <20260331161759.392582626@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 8121353a4bf8e38afee26299419a78ec108e14a6 ]

The Rust `Regulator` abstraction uses `NonNull` to wrap the underlying
`struct regulator` pointer. When `CONFIG_REGULATOR` is disabled, the C
stub for `regulator_get` returns `NULL`. `from_err_ptr` does not treat
`NULL` as an error, so it was passed to `NonNull::new_unchecked`,
causing undefined behavior.

Fix this by using a raw pointer `*mut bindings::regulator` instead of
`NonNull`. This allows `inner` to be `NULL` when `CONFIG_REGULATOR` is
disabled, and leverages the C stubs which are designed to handle `NULL`
or are no-ops.

Fixes: 9b614ceada7c ("rust: regulator: add a bare minimum regulator abstraction")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Closes: https://lore.kernel.org/r/20260322193830.89324-1-ojeda@kernel.org
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Link: https://patch.msgid.link/20260324-regulator-fix-v1-1-a5244afa3c15@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/regulator.rs | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/rust/kernel/regulator.rs b/rust/kernel/regulator.rs
index b55a201e5029f..09c8263043bc7 100644
--- a/rust/kernel/regulator.rs
+++ b/rust/kernel/regulator.rs
@@ -23,7 +23,10 @@ use crate::{
     prelude::*,
 };
 
-use core::{marker::PhantomData, mem::ManuallyDrop, ptr::NonNull};
+use core::{
+    marker::PhantomData,
+    mem::ManuallyDrop, //
+};
 
 mod private {
     pub trait Sealed {}
@@ -230,15 +233,17 @@ pub fn devm_enable_optional(dev: &Device<Bound>, name: &CStr) -> Result {
 ///
 /// # Invariants
 ///
-/// - `inner` is a non-null wrapper over a pointer to a `struct
-///   regulator` obtained from [`regulator_get()`].
+/// - `inner` is a pointer obtained from a successful call to
+///   [`regulator_get()`]. It is treated as an opaque token that may only be
+///   accessed using C API methods (e.g., it may be `NULL` if the C API returns
+///   `NULL`).
 ///
 /// [`regulator_get()`]: https://docs.kernel.org/driver-api/regulator.html#c.regulator_get
 pub struct Regulator<State>
 where
     State: RegulatorState,
 {
-    inner: NonNull<bindings::regulator>,
+    inner: *mut bindings::regulator,
     _phantom: PhantomData<State>,
 }
 
@@ -250,7 +255,7 @@ impl<T: RegulatorState> Regulator<T> {
         // SAFETY: Safe as per the type invariants of `Regulator`.
         to_result(unsafe {
             bindings::regulator_set_voltage(
-                self.inner.as_ptr(),
+                self.inner,
                 min_voltage.as_microvolts(),
                 max_voltage.as_microvolts(),
             )
@@ -260,7 +265,7 @@ impl<T: RegulatorState> Regulator<T> {
     /// Gets the current voltage of the regulator.
     pub fn get_voltage(&self) -> Result<Voltage> {
         // SAFETY: Safe as per the type invariants of `Regulator`.
-        let voltage = unsafe { bindings::regulator_get_voltage(self.inner.as_ptr()) };
+        let voltage = unsafe { bindings::regulator_get_voltage(self.inner) };
 
         to_result(voltage).map(|()| Voltage::from_microvolts(voltage))
     }
@@ -270,10 +275,8 @@ impl<T: RegulatorState> Regulator<T> {
         // received from the C code.
         let inner = from_err_ptr(unsafe { bindings::regulator_get(dev.as_raw(), name.as_ptr()) })?;
 
-        // SAFETY: We can safely trust `inner` to be a pointer to a valid
-        // regulator if `ERR_PTR` was not returned.
-        let inner = unsafe { NonNull::new_unchecked(inner) };
-
+        // INVARIANT: `inner` is a pointer obtained from `regulator_get()`, and
+        // the call was successful.
         Ok(Self {
             inner,
             _phantom: PhantomData,
@@ -282,12 +285,12 @@ impl<T: RegulatorState> Regulator<T> {
 
     fn enable_internal(&self) -> Result {
         // SAFETY: Safe as per the type invariants of `Regulator`.
-        to_result(unsafe { bindings::regulator_enable(self.inner.as_ptr()) })
+        to_result(unsafe { bindings::regulator_enable(self.inner) })
     }
 
     fn disable_internal(&self) -> Result {
         // SAFETY: Safe as per the type invariants of `Regulator`.
-        to_result(unsafe { bindings::regulator_disable(self.inner.as_ptr()) })
+        to_result(unsafe { bindings::regulator_disable(self.inner) })
     }
 }
 
@@ -349,7 +352,7 @@ impl<T: IsEnabled> Regulator<T> {
     /// Checks if the regulator is enabled.
     pub fn is_enabled(&self) -> bool {
         // SAFETY: Safe as per the type invariants of `Regulator`.
-        unsafe { bindings::regulator_is_enabled(self.inner.as_ptr()) != 0 }
+        unsafe { bindings::regulator_is_enabled(self.inner) != 0 }
     }
 }
 
@@ -359,11 +362,11 @@ impl<T: RegulatorState> Drop for Regulator<T> {
             // SAFETY: By the type invariants, we know that `self` owns a
             // reference on the enabled refcount, so it is safe to relinquish it
             // now.
-            unsafe { bindings::regulator_disable(self.inner.as_ptr()) };
+            unsafe { bindings::regulator_disable(self.inner) };
         }
         // SAFETY: By the type invariants, we know that `self` owns a reference,
         // so it is safe to relinquish it now.
-        unsafe { bindings::regulator_put(self.inner.as_ptr()) };
+        unsafe { bindings::regulator_put(self.inner) };
     }
 }
 
-- 
2.53.0



