Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F24B146A63;
	Mon, 24 Feb 2025 14:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408947; cv=none; b=gwQvmWR+hH3+PF0lnn9I3BQbAoyp07Sk3VsyEzqX1yo6a4nh2ZK1G0iyqFH8j/AMwDZH0jBq2g2uygvj3uI3YqGyIpv94b1IJU7WF+qbq8aEpRKpjc5qCbPY1j97oK/wtT4YDkilqc6IzKENF+AwUi7VB+Y2Nf9eRTrva5rDN1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408947; c=relaxed/simple;
	bh=XTJaoq5eI0ui+whTVzO+zWKA9LU/Q6eslEB6P5GExUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itNjRlJZkeq60AXvEzXPVbce/1iwVzTIeKk7HWCXFbdHcO9sdMWd3FIbLxqpOgE78df71nEp3b1ueUVWEIZ+RE9Z/FZchK+rLN5MhZDALBphw5faExJsc0RopUxY29YNtbIoWGqgBjJYcBxz4BAFl74AFHhIEV45zjvPkl157O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBJHa092; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBJHa092"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDF1C4CEE6;
	Mon, 24 Feb 2025 14:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408947;
	bh=XTJaoq5eI0ui+whTVzO+zWKA9LU/Q6eslEB6P5GExUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBJHa0924uFaz974tTa8Y2vVMs2bs7SMYtSLct1Ght6daEwSgg2mFN9o20uaMFj77
	 fqMKKdMMeBRilc8PGvwrfUI/sVhmtjkbDnLaD+sD20DZAIRJeGo73BWkcxhDw1xQ6L
	 SDVwu7gfC8eN9TIcIbZ5GOVdvXD0hlIZaHLNAzoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.13 051/138] rust: cleanup unnecessary casts
Date: Mon, 24 Feb 2025 15:34:41 +0100
Message-ID: <20250224142606.485245521@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

commit 9b98be76855f14bd5180b59c1ac646b5add98f33 upstream.

With `long` mapped to `isize`, `size_t`/`__kernel_size_t` mapped to
`usize` and `char` mapped to `u8`, many of the existing casts are no
longer necessary.

Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240913213041.395655-6-gary@garyguo.net
[ Moved `uaccess` changes to the previous commit, since they were
  irrefutable patterns that Rust >= 1.82.0 warns about. Removed a
  couple casts that now use `c""` literals. Rebased on top of
  `rust-next`. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/print.rs |    4 ++--
 rust/kernel/str.rs   |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -107,7 +107,7 @@ pub unsafe fn call_printk(
     // SAFETY: TODO.
     unsafe {
         bindings::_printk(
-            format_string.as_ptr() as _,
+            format_string.as_ptr(),
             module_name.as_ptr(),
             &args as *const _ as *const c_void,
         );
@@ -128,7 +128,7 @@ pub fn call_printk_cont(args: fmt::Argum
     #[cfg(CONFIG_PRINTK)]
     unsafe {
         bindings::_printk(
-            format_strings::CONT.as_ptr() as _,
+            format_strings::CONT.as_ptr(),
             &args as *const _ as *const c_void,
         );
     }
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -189,7 +189,7 @@ impl CStr {
         // to a `NUL`-terminated C string.
         let len = unsafe { bindings::strlen(ptr) } + 1;
         // SAFETY: Lifetime guaranteed by the safety precondition.
-        let bytes = unsafe { core::slice::from_raw_parts(ptr as _, len as _) };
+        let bytes = unsafe { core::slice::from_raw_parts(ptr as _, len) };
         // SAFETY: As `len` is returned by `strlen`, `bytes` does not contain interior `NUL`.
         // As we have added 1 to `len`, the last byte is known to be `NUL`.
         unsafe { Self::from_bytes_with_nul_unchecked(bytes) }
@@ -248,7 +248,7 @@ impl CStr {
     /// Returns a C pointer to the string.
     #[inline]
     pub const fn as_char_ptr(&self) -> *const crate::ffi::c_char {
-        self.0.as_ptr() as _
+        self.0.as_ptr()
     }
 
     /// Convert the string to a byte slice without the trailing `NUL` byte.
@@ -838,7 +838,7 @@ impl CString {
         // SAFETY: The buffer is valid for read because `f.bytes_written()` is bounded by `size`
         // (which the minimum buffer size) and is non-zero (we wrote at least the `NUL` terminator)
         // so `f.bytes_written() - 1` doesn't underflow.
-        let ptr = unsafe { bindings::memchr(buf.as_ptr().cast(), 0, (f.bytes_written() - 1) as _) };
+        let ptr = unsafe { bindings::memchr(buf.as_ptr().cast(), 0, f.bytes_written() - 1) };
         if !ptr.is_null() {
             return Err(EINVAL);
         }


