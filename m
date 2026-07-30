Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335C242F712;
	Thu, 30 Jul 2026 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425235; cv=none; b=dR0yjeNWhB4wKIoojIZ84Gh02V9Wg9XNbrGRTS2q/iExOD8ieKs18G+u5hRJSEAnaUNQD1CugSRlrsTe8YpWtTwdjFHviYTXJ7XqsJnZN8Bvlb5R3x8WSEjqKgsjDVvgizmys9e4oisGyP5wrc17kEXTwOfOvHvogWNmUQbZvUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425235; c=relaxed/simple;
	bh=gxjOWlOvI8GTKLf6eWOh7ZbVrpyWaSFdlJcQ6U4YZMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibQTCnygPVbumLJGQFOA2gQ8PWxnlsmTWF7jd7Ir/oBXocfLNVv8tDYVBF+QZJGL6v/UMSM65UCz6pH/azaToYoquD8ZxvMuoD/SRnnZv6HPLITyvfnPwMaaSzvQlZClmFe80eWmZi/nZYBof4m91/jl4UBzw8CCQ28d/hdRibk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+maSbhp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+maSbhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830FF1F000E9;
	Thu, 30 Jul 2026 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425234;
	bh=kqjWevw0CHpGpjWe+ff+J8sLI0G7SuX8VfYkUZ5b+14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u+maSbhpicFsHhL+M5hp5D6L4NGoSVsnmd7IA17iWH5mUTvleW01v7OqBcP4nXRGN
	 /DGrPGNV8nPYvGfl+KNi6QFzDg061xKkcVi9zV6zOJC3STe6tiqV0DfsKoaDPCP3ik
	 ZjMynEY3MOR2lQ9ks9uQ/hx0TrvKVBDca9mDLndk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 670/675] rust: device: avoid trailing ; in printing macros
Date: Thu, 30 Jul 2026 16:16:40 +0200
Message-ID: <20260730141459.402367394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
[ Resolved conflict on `dev_printk` by not performing a similar cleanup
  since it is not strictly needed. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/device.rs |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -625,7 +625,7 @@ macro_rules! dev_printk {
 /// ```
 #[macro_export]
 macro_rules! dev_emerg {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_emerg, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_emerg, $($f)*) }
 }
 
 /// Prints an alert-level message (level 1) prefixed with device information.
@@ -651,7 +651,7 @@ macro_rules! dev_emerg {
 /// ```
 #[macro_export]
 macro_rules! dev_alert {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_alert, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_alert, $($f)*) }
 }
 
 /// Prints a critical-level message (level 2) prefixed with device information.
@@ -677,7 +677,7 @@ macro_rules! dev_alert {
 /// ```
 #[macro_export]
 macro_rules! dev_crit {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_crit, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_crit, $($f)*) }
 }
 
 /// Prints an error-level message (level 3) prefixed with device information.
@@ -703,7 +703,7 @@ macro_rules! dev_crit {
 /// ```
 #[macro_export]
 macro_rules! dev_err {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_err, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_err, $($f)*) }
 }
 
 /// Prints a warning-level message (level 4) prefixed with device information.
@@ -729,7 +729,7 @@ macro_rules! dev_err {
 /// ```
 #[macro_export]
 macro_rules! dev_warn {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_warn, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_warn, $($f)*) }
 }
 
 /// Prints a notice-level message (level 5) prefixed with device information.
@@ -755,7 +755,7 @@ macro_rules! dev_warn {
 /// ```
 #[macro_export]
 macro_rules! dev_notice {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_notice, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_notice, $($f)*) }
 }
 
 /// Prints an info-level message (level 6) prefixed with device information.
@@ -781,7 +781,7 @@ macro_rules! dev_notice {
 /// ```
 #[macro_export]
 macro_rules! dev_info {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_info, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_info, $($f)*) }
 }
 
 /// Prints a debug-level message (level 7) prefixed with device information.
@@ -807,5 +807,5 @@ macro_rules! dev_info {
 /// ```
 #[macro_export]
 macro_rules! dev_dbg {
-    ($($f:tt)*) => { $crate::dev_printk!(pr_dbg, $($f)*); }
+    ($($f:tt)*) => { $crate::dev_printk!(pr_dbg, $($f)*) }
 }


