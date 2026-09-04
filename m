Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7823876B3;
	Fri,  4 Sep 2026 05:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498345; cv=none; b=UCKSRF7dtwRd/iDBIsCaheKJ1NMWeH0QuTsGcgMeVxuVUBLkNTokbp0sYlvdRT8jasO6AWExpaXBAh3tHGA2qWbcXI6K/ODfKgENIJ39UMYs3yZKy4fy3Iz4CbnvVZRzex29thJd5zy74x0MD2JATgw1OW0cVYfUaiCt1R5J3iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498345; c=relaxed/simple;
	bh=IqFcNkk/eWfV83bvzyHLQ+ngSgyGsdCDbi5rI98qquc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKTxfPZ7DGj50dsY6q4yPS4QWsdQ5LUeXeOcy7c3XNzdPltItWxu6HSVUvwGMUoy0v+zHTbSVdyBAGW82AbE8/bfPrrFbTt45Ak0jvRBd9TV7EirSMbmzYO1EVabUrs5C5ROhPSOx76MVLJkpv/TyFyeeI8O8C74GdVF0oAWG8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gftZCniF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gftZCniF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460051F00A3D;
	Fri,  4 Sep 2026 05:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498343;
	bh=PnpaWrIFr4ZNZpsNO2A4hqIiwWfChTt5TcLmXfkXurM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gftZCniFFlwMFSuOKsxlBurQSz3b+yRJRawdc1R9w140p9dMuZvVgmqDyHEJfe0gQ
	 62arb2iUXcDJTJJ8OyDLWJXbw7+023BgsqooRIGQui5Fu7vhxkQepw+dbQq1EglCte
	 YdGdG16ssF3vf/CaU4un9SQFV2bNkaZ+rHMLToLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 029/713] rust: bug: prevent dead_code warning from warn_on!s flags constant
Date: Fri,  4 Sep 2026 06:49:57 +0200
Message-ID: <20260904045804.484118353@linuxfoundation.org>
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

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit e66cfc29e0d06fec34c06bb40d4d281f595677b1 upstream.

Fix the following dead_code warning on some configurations in an
atomic development branch:

warning: constant `WARN_ON_FLAGS` is never used
   --> linux/rust/kernel/bug.rs:126:19
    |
126 |               const WARN_ON_FLAGS: u32 = $crate::bug::bugflag_taint($crate::bindings::TAINT_WARN);
    |                     ^^^^^^^^^^^^^
    |
   ::: linux/rust/kernel/sync/srcu.rs:106:12
    |
106 |           if crate::warn_on!(
    |  ____________-
107 | |             // SAFETY: By the type invariants, `self` contains a valid and pinned `struct srcu_struct`
108 | |             // and `srcu_readers_active()` only checks the active reader count.
109 | |             unsafe { bindings::srcu_readers_active(ptr) }
110 | |         ) {
    | |_________- in this macro invocation
    |
    = note: `#[warn(dead_code)]` (part of `#[warn(unused)]`) on by default
    = note: this warning originates in the macro `crate::warn_on` (in Nightly builds, run with -Z macro-backtrace for more info)

The warn_on! macro always defines a WARN_ON_FLAGS constant and hands it
to warn_flags!. On configurations where warn_flags! does not reference
its flags argument (the LOONGARCH/ARM variant, which only calls
WARN_ON(), and the !CONFIG_BUG no-op variant), the constant is left
unused and triggers a dead_code warning.

warn_flags! is the macro that accepts (and here discards) the flags
argument, so make it responsible for the argument it drops.

Also rename `_COND_STR` to `COND_STR` and consume `$file` for consistency.

Fixes: dff64b072708 ("rust: Add warn_on macro")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260801024841.786664-1-tomo@flapping.org
[ Added newlines. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/bug.rs |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

--- a/rust/kernel/bug.rs
+++ b/rust/kernel/bug.rs
@@ -55,6 +55,10 @@ macro_rules! warn_flags {
     ($file:expr, $flags:expr) => {
         const FLAGS: u32 = $crate::bindings::BUGFLAG_WARNING | $flags;
 
+        if false {
+            _ = $file;
+        }
+
         // SAFETY:
         // - `flags` and `size` are all compile-time constants, preventing
         // any invalid memory access.
@@ -79,6 +83,10 @@ macro_rules! warn_flags {
 #[cfg(all(CONFIG_BUG, CONFIG_UML))]
 macro_rules! warn_flags {
     ($file:expr, $flags:expr) => {
+        if false {
+            _ = $file;
+        }
+
         // SAFETY: It is always safe to call `warn_slowpath_fmt()`
         // with a valid null-terminated string.
         unsafe {
@@ -98,6 +106,11 @@ macro_rules! warn_flags {
 #[cfg(all(CONFIG_BUG, any(CONFIG_LOONGARCH, CONFIG_ARM)))]
 macro_rules! warn_flags {
     ($file:expr, $flags:expr) => {
+        if false {
+            _ = $file;
+            _ = $flags;
+        }
+
         // SAFETY: It is always safe to call `WARN_ON()`.
         unsafe { $crate::bindings::WARN_ON(true) }
     };
@@ -107,7 +120,12 @@ macro_rules! warn_flags {
 #[doc(hidden)]
 #[cfg(any(testlib, not(CONFIG_BUG)))]
 macro_rules! warn_flags {
-    ($file:expr, $flags:expr) => {};
+    ($file:expr, $flags:expr) => {
+        if false {
+            _ = $file;
+            _ = $flags;
+        }
+    };
 }
 
 #[doc(hidden)]
@@ -122,14 +140,14 @@ macro_rules! warn_on {
         let cond = $cond;
 
         #[cfg(CONFIG_DEBUG_BUGVERBOSE_DETAILED)]
-        const _COND_STR: &str = concat!("[", stringify!($cond), "] ", file!());
+        const COND_STR: &str = concat!("[", stringify!($cond), "] ", file!());
         #[cfg(not(CONFIG_DEBUG_BUGVERBOSE_DETAILED))]
-        const _COND_STR: &str = file!();
+        const COND_STR: &str = file!();
 
         if cond {
             const WARN_ON_FLAGS: u32 = $crate::bug::bugflag_taint($crate::bindings::TAINT_WARN);
 
-            $crate::warn_flags!(_COND_STR, WARN_ON_FLAGS);
+            $crate::warn_flags!(COND_STR, WARN_ON_FLAGS);
         }
         cond
     }};


