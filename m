Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D70E37475C;
	Thu, 30 Jul 2026 14:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422811; cv=none; b=jmRguFn+9DSkkPKCTfcMWccWS7L1FiPhXGnRy76MibgQQeqiuSvNxVoD8XHnVGnFx4459aQ+bLWq8zb9P+DzLTYtqn+NiURWWI48mVMn6DOduFahWx1zcvnGjCaeB3Q7lSofKsgaeOhZYe5+jcbCn7gJbpv+QZZHcCb9uPQAK4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422811; c=relaxed/simple;
	bh=pvMaPkpzNvmrhE9GmlS5+KtFd0khGGuKSTfUJY+XCT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FTZ33Ttbua2V70r4VfnYv1tj99I0/Zz2khnBtxjtL1g0iTDT6JAnCaBr16YTHRl+sKQQZWICZuhFSz7MH1aKQxuPz73VUogtnokhkHlOKziePobebK5qPBDss/wCtLnlYuD9Ww+VRUkrvA+k0NbIPlu1qQLF1FwYClUs+tE6WZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIUprlRW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIUprlRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BB81F000E9;
	Thu, 30 Jul 2026 14:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422810;
	bh=ZgQaq7lV1Z9LJTMYE1fFSM7gMpYa9ytIVOuHMOZ8YhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIUprlRWqkojbcfly4ejQEY8aAX/M7XVG0Vw4r54mEBf38zzmDhM+gBIsQNSGFpr6
	 U6Hjf1DI+LX04GLUachQveIY+9/Bu5sTGRDQDZRX1zohOinHk0OxyDjsBnnUvef1OT
	 lnL0tcc5qwm9UohBlSx1bFPfwzZdmrSONN9Yjbyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.1 565/744] rust: device: avoid trailing ; in printing macros
Date: Thu, 30 Jul 2026 16:13:58 +0200
Message-ID: <20260730141456.294389386@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit a19bda861b3a79e25417462539df8b0d77c6b322 upstream.

These macros are used like expressions, so they should not emit a
semicolon. This is being turned into a hard error in a future release of
Rust.

    error: trailing semicolon in macro used in expression position
      --> drivers/gpu/nova-core/firmware/fsp.rs:79:34
       |
    79 |                 .inspect_err(|_| dev_err!(dev, "FMC firmware missing '{}' section\n", name))
       |                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
       |
       = warning: this was previously accepted by the compiler but is being phased out; it will become a hard error in a future release!
       = note: for more information, see issue #79813 <https://github.com/rust-lang/rust/issues/79813>
       = note: this error originates in the macro `dev_err` (in Nightly builds, run with -Z macro-backtrace for more info)

[ I was doubly surprised since upstream made it a deny-by-default lint
  a year ago for Rust 1.91.0, and yet we didn't see it; plus I hadn't
  seen this in my CI even yesterday.

  It turns out this just landed into today's nightly (nightly-2026-07-16,
  using upstream commit d0babd8b6):

    Link: https://github.com/rust-lang/rust/pull/159222

  which says:

    "The `semicolon_in_expressions_from_macros` lint previously
     suppressed warnings about non-local macros. This masks
     a lint that will subsequently become a hard error."

  So that explains it. And this is the PR that will make it a hard error
  at some point in the future:

    Link: https://github.com/rust-lang/rust/pull/159218

  Thus starting with Rust 1.99.0 (expected 2026-10-01), we will be
  seeing the deny-by-default lint above, so clean it up already.

    - Miguel ]

Cc: stable@vger.kernel.org # Needed in 6.18.y and later.
Link: https://github.com/rust-lang/rust/issues/79813
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Danilo Krummrich <dakr@kernel.org>
Link: https://github.com/rust-lang/rust/pull/159218
Link: https://github.com/rust-lang/rust/pull/159222
Link: https://patch.msgid.link/20260716-device-trail-semicolon-v1-1-f48e9dcfae15@google.com
[ Fixed typo. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/device.rs |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -737,9 +737,7 @@ macro_rules! impl_device_context_into_ar
 #[macro_export]
 macro_rules! dev_printk {
     ($method:ident, $dev:expr, $($f:tt)*) => {
-        {
-            $crate::device::Device::$method($dev.as_ref(), $crate::prelude::fmt!($($f)*))
-        }
+        $crate::device::Device::$method($dev.as_ref(), $crate::prelude::fmt!($($f)*))
     }
 }
 
@@ -766,7 +764,7 @@ macro_rules! dev_printk {
 /// ```
 #[macro_export]
 macro_rules! dev_emerg {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_emerg, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_emerg, $($f)*) }
 }
 
 /// Prints an alert-level message (level 1) prefixed with device information.
@@ -792,7 +790,7 @@ macro_rules! dev_emerg {
 /// ```
 #[macro_export]
 macro_rules! dev_alert {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_alert, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_alert, $($f)*) }
 }
 
 /// Prints a critical-level message (level 2) prefixed with device information.
@@ -818,7 +816,7 @@ macro_rules! dev_alert {
 /// ```
 #[macro_export]
 macro_rules! dev_crit {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_crit, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_crit, $($f)*) }
 }
 
 /// Prints an error-level message (level 3) prefixed with device information.
@@ -844,7 +842,7 @@ macro_rules! dev_crit {
 /// ```
 #[macro_export]
 macro_rules! dev_err {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_err, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_err, $($f)*) }
 }
 
 /// Prints a warning-level message (level 4) prefixed with device information.
@@ -870,7 +868,7 @@ macro_rules! dev_err {
 /// ```
 #[macro_export]
 macro_rules! dev_warn {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_warn, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_warn, $($f)*) }
 }
 
 /// Prints a notice-level message (level 5) prefixed with device information.
@@ -896,7 +894,7 @@ macro_rules! dev_warn {
 /// ```
 #[macro_export]
 macro_rules! dev_notice {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_notice, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_notice, $($f)*) }
 }
 
 /// Prints an info-level message (level 6) prefixed with device information.
@@ -922,7 +920,7 @@ macro_rules! dev_notice {
 /// ```
 #[macro_export]
 macro_rules! dev_info {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_info, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_info, $($f)*) }
 }
 
 /// Prints a debug-level message (level 7) prefixed with device information.
@@ -948,5 +946,5 @@ macro_rules! dev_info {
 /// ```
 #[macro_export]
 macro_rules! dev_dbg {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_dbg, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_dbg, $($f)*) }
 }


