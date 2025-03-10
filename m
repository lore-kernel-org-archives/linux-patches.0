Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262EC226D0B;
	Mon, 10 Mar 2025 17:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627298; cv=none; b=MDO6KI0AH8gxb5h3Mi+N2XkytexZoaww+8gKmHrEna1OaYtRY043cRlS5VhhfXRoBWWr8TpeL56/sH7eG/QCRpcJiqTYj7F9/3fd5egsRec2xgiuhkT7JVKxcpW31QA5LWLNZcZbndEr851GIt2c8UHSijxrqT9fq90EOnJJ5zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627298; c=relaxed/simple;
	bh=nKuSZ5BQAl+uISvVLfpTJ4Pds3M7KM4eXqAI9+o0DR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDI081qydRi6ow7uKpB3fsmGoYKyhbidTBL5BQK+9mHGR2zwUfSAenYB+LH7AI/yZOk7215lErJW/thdkXuyMKwtmiFedN3ZXZuiykbGr9slBHcmUCuDTHXXyeCl1J+buPOgfLF7YMElKMkQ1QMqz19dsA71B4WAhHstlxQiqmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAH7ysmA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAH7ysmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4C7C4CEE5;
	Mon, 10 Mar 2025 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627298;
	bh=nKuSZ5BQAl+uISvVLfpTJ4Pds3M7KM4eXqAI9+o0DR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HAH7ysmAnWS1CNxquU/JG/MEzKKqozAMAsXN9s4k+qd9IdLVvp020favR2MfuggTE
	 kzYd79YbogTUK+t1eJx0T8IbaaCozkGD/dgz8tmepiVTeOnUr0gZuOm4TBKT20GUuM
	 KHJxnsr9Zwl1Cnq5KyF4MgXtm8ASE/nbZdATruhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 049/269] rust: treewide: switch to the kernel `Vec` type
Date: Mon, 10 Mar 2025 18:03:22 +0100
Message-ID: <20250310170459.679470397@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit 58eff8e872bd04ccb3adcf99aec7334ffad06cfd upstream.

Now that we got the kernel `Vec` in place, convert all existing `Vec`
users to make use of it.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-20-dakr@kernel.org
[ Converted `kasan_test_rust.rs` too, as discussed. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kasan/kasan_test_rust.rs   |    2 +-
 rust/kernel/str.rs            |   12 +++++-------
 rust/kernel/sync/locked_by.rs |    2 +-
 rust/kernel/types.rs          |    2 +-
 rust/kernel/uaccess.rs        |   17 +++++++----------
 rust/macros/lib.rs            |    6 +++---
 samples/rust/rust_minimal.rs  |    4 ++--
 7 files changed, 20 insertions(+), 25 deletions(-)

--- a/mm/kasan/kasan_test_rust.rs
+++ b/mm/kasan/kasan_test_rust.rs
@@ -11,7 +11,7 @@ use kernel::prelude::*;
 /// drop the vector, and touch it.
 #[no_mangle]
 pub extern "C" fn kasan_test_rust_uaf() -> u8 {
-    let mut v: Vec<u8> = Vec::new();
+    let mut v: KVec<u8> = KVec::new();
     for _ in 0..4096 {
         v.push(0x42, GFP_KERNEL).unwrap();
     }
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -2,8 +2,7 @@
 
 //! String representations.
 
-use crate::alloc::{flags::*, vec_ext::VecExt, AllocError};
-use alloc::vec::Vec;
+use crate::alloc::{flags::*, AllocError, KVec};
 use core::fmt::{self, Write};
 use core::ops::{self, Deref, DerefMut, Index};
 
@@ -791,7 +790,7 @@ impl fmt::Write for Formatter {
 /// assert_eq!(s.is_ok(), false);
 /// ```
 pub struct CString {
-    buf: Vec<u8>,
+    buf: KVec<u8>,
 }
 
 impl CString {
@@ -804,7 +803,7 @@ impl CString {
         let size = f.bytes_written();
 
         // Allocate a vector with the required number of bytes, and write to it.
-        let mut buf = <Vec<_> as VecExt<_>>::with_capacity(size, GFP_KERNEL)?;
+        let mut buf = KVec::with_capacity(size, GFP_KERNEL)?;
         // SAFETY: The buffer stored in `buf` is at least of size `size` and is valid for writes.
         let mut f = unsafe { Formatter::from_buffer(buf.as_mut_ptr(), size) };
         f.write_fmt(args)?;
@@ -851,10 +850,9 @@ impl<'a> TryFrom<&'a CStr> for CString {
     type Error = AllocError;
 
     fn try_from(cstr: &'a CStr) -> Result<CString, AllocError> {
-        let mut buf = Vec::new();
+        let mut buf = KVec::new();
 
-        <Vec<_> as VecExt<_>>::extend_from_slice(&mut buf, cstr.as_bytes_with_nul(), GFP_KERNEL)
-            .map_err(|_| AllocError)?;
+        buf.extend_from_slice(cstr.as_bytes_with_nul(), GFP_KERNEL)?;
 
         // INVARIANT: The `CStr` and `CString` types have the same invariants for
         // the string data, and we copied it over without changes.
--- a/rust/kernel/sync/locked_by.rs
+++ b/rust/kernel/sync/locked_by.rs
@@ -43,7 +43,7 @@ use core::{cell::UnsafeCell, mem::size_o
 /// struct InnerDirectory {
 ///     /// The sum of the bytes used by all files.
 ///     bytes_used: u64,
-///     _files: Vec<File>,
+///     _files: KVec<File>,
 /// }
 ///
 /// struct Directory {
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -135,7 +135,7 @@ impl ForeignOwnable for () {
 /// # use kernel::types::ScopeGuard;
 /// fn example3(arg: bool) -> Result {
 ///     let mut vec =
-///         ScopeGuard::new_with_data(Vec::new(), |v| pr_info!("vec had {} elements\n", v.len()));
+///         ScopeGuard::new_with_data(KVec::new(), |v| pr_info!("vec had {} elements\n", v.len()));
 ///
 ///     vec.push(10u8, GFP_KERNEL)?;
 ///     if arg {
--- a/rust/kernel/uaccess.rs
+++ b/rust/kernel/uaccess.rs
@@ -11,7 +11,6 @@ use crate::{
     prelude::*,
     types::{AsBytes, FromBytes},
 };
-use alloc::vec::Vec;
 use core::ffi::{c_ulong, c_void};
 use core::mem::{size_of, MaybeUninit};
 
@@ -46,7 +45,6 @@ pub type UserPtr = usize;
 /// every byte in the region.
 ///
 /// ```no_run
-/// use alloc::vec::Vec;
 /// use core::ffi::c_void;
 /// use kernel::error::Result;
 /// use kernel::uaccess::{UserPtr, UserSlice};
@@ -54,7 +52,7 @@ pub type UserPtr = usize;
 /// fn bytes_add_one(uptr: UserPtr, len: usize) -> Result<()> {
 ///     let (read, mut write) = UserSlice::new(uptr, len).reader_writer();
 ///
-///     let mut buf = Vec::new();
+///     let mut buf = KVec::new();
 ///     read.read_all(&mut buf, GFP_KERNEL)?;
 ///
 ///     for b in &mut buf {
@@ -69,7 +67,6 @@ pub type UserPtr = usize;
 /// Example illustrating a TOCTOU (time-of-check to time-of-use) bug.
 ///
 /// ```no_run
-/// use alloc::vec::Vec;
 /// use core::ffi::c_void;
 /// use kernel::error::{code::EINVAL, Result};
 /// use kernel::uaccess::{UserPtr, UserSlice};
@@ -78,21 +75,21 @@ pub type UserPtr = usize;
 /// fn is_valid(uptr: UserPtr, len: usize) -> Result<bool> {
 ///     let read = UserSlice::new(uptr, len).reader();
 ///
-///     let mut buf = Vec::new();
+///     let mut buf = KVec::new();
 ///     read.read_all(&mut buf, GFP_KERNEL)?;
 ///
 ///     todo!()
 /// }
 ///
 /// /// Returns the bytes behind this user pointer if they are valid.
-/// fn get_bytes_if_valid(uptr: UserPtr, len: usize) -> Result<Vec<u8>> {
+/// fn get_bytes_if_valid(uptr: UserPtr, len: usize) -> Result<KVec<u8>> {
 ///     if !is_valid(uptr, len)? {
 ///         return Err(EINVAL);
 ///     }
 ///
 ///     let read = UserSlice::new(uptr, len).reader();
 ///
-///     let mut buf = Vec::new();
+///     let mut buf = KVec::new();
 ///     read.read_all(&mut buf, GFP_KERNEL)?;
 ///
 ///     // THIS IS A BUG! The bytes could have changed since we checked them.
@@ -130,7 +127,7 @@ impl UserSlice {
     /// Reads the entirety of the user slice, appending it to the end of the provided buffer.
     ///
     /// Fails with [`EFAULT`] if the read happens on a bad address.
-    pub fn read_all(self, buf: &mut Vec<u8>, flags: Flags) -> Result {
+    pub fn read_all(self, buf: &mut KVec<u8>, flags: Flags) -> Result {
         self.reader().read_all(buf, flags)
     }
 
@@ -291,9 +288,9 @@ impl UserSliceReader {
     /// Reads the entirety of the user slice, appending it to the end of the provided buffer.
     ///
     /// Fails with [`EFAULT`] if the read happens on a bad address.
-    pub fn read_all(mut self, buf: &mut Vec<u8>, flags: Flags) -> Result {
+    pub fn read_all(mut self, buf: &mut KVec<u8>, flags: Flags) -> Result {
         let len = self.length;
-        VecExt::<u8>::reserve(buf, len, flags)?;
+        buf.reserve(len, flags)?;
 
         // The call to `try_reserve` was successful, so the spare capacity is at least `len` bytes
         // long.
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -242,7 +242,7 @@ pub fn concat_idents(ts: TokenStream) ->
 /// #[pin_data]
 /// struct DriverData {
 ///     #[pin]
-///     queue: Mutex<Vec<Command>>,
+///     queue: Mutex<KVec<Command>>,
 ///     buf: KBox<[u8; 1024 * 1024]>,
 /// }
 /// ```
@@ -251,7 +251,7 @@ pub fn concat_idents(ts: TokenStream) ->
 /// #[pin_data(PinnedDrop)]
 /// struct DriverData {
 ///     #[pin]
-///     queue: Mutex<Vec<Command>>,
+///     queue: Mutex<KVec<Command>>,
 ///     buf: KBox<[u8; 1024 * 1024]>,
 ///     raw_info: *mut Info,
 /// }
@@ -281,7 +281,7 @@ pub fn pin_data(inner: TokenStream, item
 /// #[pin_data(PinnedDrop)]
 /// struct DriverData {
 ///     #[pin]
-///     queue: Mutex<Vec<Command>>,
+///     queue: Mutex<KVec<Command>>,
 ///     buf: KBox<[u8; 1024 * 1024]>,
 ///     raw_info: *mut Info,
 /// }
--- a/samples/rust/rust_minimal.rs
+++ b/samples/rust/rust_minimal.rs
@@ -13,7 +13,7 @@ module! {
 }
 
 struct RustMinimal {
-    numbers: Vec<i32>,
+    numbers: KVec<i32>,
 }
 
 impl kernel::Module for RustMinimal {
@@ -21,7 +21,7 @@ impl kernel::Module for RustMinimal {
         pr_info!("Rust minimal sample (init)\n");
         pr_info!("Am I built-in? {}\n", !cfg!(MODULE));
 
-        let mut numbers = Vec::new();
+        let mut numbers = KVec::new();
         numbers.push(72, GFP_KERNEL)?;
         numbers.push(108, GFP_KERNEL)?;
         numbers.push(200, GFP_KERNEL)?;


