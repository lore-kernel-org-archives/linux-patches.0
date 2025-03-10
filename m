Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB1322154C;
	Mon, 10 Mar 2025 17:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627303; cv=none; b=WOrOpovqsT+br2DIMCxIekfCwS4+X3m933/BUIH1BbAM0Biie4XjLAkrDc+HJ17TmV1fvgUHmTjBqO5KO9ax3o5OmoCW1JtQkCY7giE46+6mG02ThEkXUoaZscJF1TJk8kJZNRM2ZA0+8t9bJLvFZXtDo7qC6RxUnN6b70kyvLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627303; c=relaxed/simple;
	bh=hyrFaWXt4Ir9jBMrgCvqiXSsjq1AvucjQv/etFeIRCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hdLpf/SDBkgNw+KdxnisegwZWv9CApiPIdDLl6eLaxS/Ye0NVp4QPNYtIH/rWdomDVq7kT1GsYoNm9xzADNh+qiar6ENhkR7IdXH8ZAOAPSaQjWZjBA6+zPHGcN5M7Y9w3UAhdR51G27O/qw+oNTe/sUws1ls3dhLAHJ2HZC0eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdY87ZuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdY87ZuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560CAC4CEE5;
	Mon, 10 Mar 2025 17:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627303;
	bh=hyrFaWXt4Ir9jBMrgCvqiXSsjq1AvucjQv/etFeIRCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdY87ZuStR0j6MMZ0ztn2S9imhNVGglnTJC0EM/BuscyauSRNOMONldH0Q5P8BO3x
	 4xjewWXG4lGrMOXHnNfCdeTU/FIPNz+8ZgK5YKrQU3qV8xuEBzG22iSWPecGKGbEkk
	 afGA7Uexf2up4MAyNDoH6fMhRPvOdqh06kRDK8L8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 041/269] rust: alloc: implement kernel `Box`
Date: Mon, 10 Mar 2025 18:03:14 +0100
Message-ID: <20250310170459.358709113@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

commit c8cfa8d0c0b10be216861fe904ea68978b1dcc97 upstream.

`Box` provides the simplest way to allocate memory for a generic type
with one of the kernel's allocators, e.g. `Kmalloc`, `Vmalloc` or
`KVmalloc`.

In contrast to Rust's `Box` type, the kernel `Box` type considers the
kernel's GFP flags for all appropriate functions, always reports
allocation failures through `Result<_, AllocError>` and remains
independent from unstable features.

Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-12-dakr@kernel.org
[ Added backticks, fixed typos. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs      |    6 
 rust/kernel/alloc/kbox.rs |  456 ++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/prelude.rs    |    2 
 3 files changed, 463 insertions(+), 1 deletion(-)
 create mode 100644 rust/kernel/alloc/kbox.rs

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -5,6 +5,7 @@
 #[cfg(not(any(test, testlib)))]
 pub mod allocator;
 pub mod box_ext;
+pub mod kbox;
 pub mod vec_ext;
 
 #[cfg(any(test, testlib))]
@@ -13,6 +14,11 @@ pub mod allocator_test;
 #[cfg(any(test, testlib))]
 pub use self::allocator_test as allocator;
 
+pub use self::kbox::Box;
+pub use self::kbox::KBox;
+pub use self::kbox::KVBox;
+pub use self::kbox::VBox;
+
 /// Indicates an allocation error.
 #[derive(Copy, Clone, PartialEq, Eq, Debug)]
 pub struct AllocError;
--- /dev/null
+++ b/rust/kernel/alloc/kbox.rs
@@ -0,0 +1,456 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Implementation of [`Box`].
+
+#[allow(unused_imports)] // Used in doc comments.
+use super::allocator::{KVmalloc, Kmalloc, Vmalloc};
+use super::{AllocError, Allocator, Flags};
+use core::alloc::Layout;
+use core::fmt;
+use core::marker::PhantomData;
+use core::mem::ManuallyDrop;
+use core::mem::MaybeUninit;
+use core::ops::{Deref, DerefMut};
+use core::pin::Pin;
+use core::ptr::NonNull;
+use core::result::Result;
+
+use crate::init::{InPlaceInit, InPlaceWrite, Init, PinInit};
+use crate::types::ForeignOwnable;
+
+/// The kernel's [`Box`] type -- a heap allocation for a single value of type `T`.
+///
+/// This is the kernel's version of the Rust stdlib's `Box`. There are several differences,
+/// for example no `noalias` attribute is emitted and partially moving out of a `Box` is not
+/// supported. There are also several API differences, e.g. `Box` always requires an [`Allocator`]
+/// implementation to be passed as generic, page [`Flags`] when allocating memory and all functions
+/// that may allocate memory are fallible.
+///
+/// `Box` works with any of the kernel's allocators, e.g. [`Kmalloc`], [`Vmalloc`] or [`KVmalloc`].
+/// There are aliases for `Box` with these allocators ([`KBox`], [`VBox`], [`KVBox`]).
+///
+/// When dropping a [`Box`], the value is also dropped and the heap memory is automatically freed.
+///
+/// # Examples
+///
+/// ```
+/// let b = KBox::<u64>::new(24_u64, GFP_KERNEL)?;
+///
+/// assert_eq!(*b, 24_u64);
+/// # Ok::<(), Error>(())
+/// ```
+///
+/// ```
+/// # use kernel::bindings;
+/// const SIZE: usize = bindings::KMALLOC_MAX_SIZE as usize + 1;
+/// struct Huge([u8; SIZE]);
+///
+/// assert!(KBox::<Huge>::new_uninit(GFP_KERNEL | __GFP_NOWARN).is_err());
+/// ```
+///
+/// ```
+/// # use kernel::bindings;
+/// const SIZE: usize = bindings::KMALLOC_MAX_SIZE as usize + 1;
+/// struct Huge([u8; SIZE]);
+///
+/// assert!(KVBox::<Huge>::new_uninit(GFP_KERNEL).is_ok());
+/// ```
+///
+/// # Invariants
+///
+/// `self.0` is always properly aligned and either points to memory allocated with `A` or, for
+/// zero-sized types, is a dangling, well aligned pointer.
+#[repr(transparent)]
+pub struct Box<T: ?Sized, A: Allocator>(NonNull<T>, PhantomData<A>);
+
+/// Type alias for [`Box`] with a [`Kmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// let b = KBox::new(24_u64, GFP_KERNEL)?;
+///
+/// assert_eq!(*b, 24_u64);
+/// # Ok::<(), Error>(())
+/// ```
+pub type KBox<T> = Box<T, super::allocator::Kmalloc>;
+
+/// Type alias for [`Box`] with a [`Vmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// let b = VBox::new(24_u64, GFP_KERNEL)?;
+///
+/// assert_eq!(*b, 24_u64);
+/// # Ok::<(), Error>(())
+/// ```
+pub type VBox<T> = Box<T, super::allocator::Vmalloc>;
+
+/// Type alias for [`Box`] with a [`KVmalloc`] allocator.
+///
+/// # Examples
+///
+/// ```
+/// let b = KVBox::new(24_u64, GFP_KERNEL)?;
+///
+/// assert_eq!(*b, 24_u64);
+/// # Ok::<(), Error>(())
+/// ```
+pub type KVBox<T> = Box<T, super::allocator::KVmalloc>;
+
+// SAFETY: `Box` is `Send` if `T` is `Send` because the `Box` owns a `T`.
+unsafe impl<T, A> Send for Box<T, A>
+where
+    T: Send + ?Sized,
+    A: Allocator,
+{
+}
+
+// SAFETY: `Box` is `Sync` if `T` is `Sync` because the `Box` owns a `T`.
+unsafe impl<T, A> Sync for Box<T, A>
+where
+    T: Sync + ?Sized,
+    A: Allocator,
+{
+}
+
+impl<T, A> Box<T, A>
+where
+    T: ?Sized,
+    A: Allocator,
+{
+    /// Creates a new `Box<T, A>` from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// For non-ZSTs, `raw` must point at an allocation allocated with `A` that is sufficiently
+    /// aligned for and holds a valid `T`. The caller passes ownership of the allocation to the
+    /// `Box`.
+    ///
+    /// For ZSTs, `raw` must be a dangling, well aligned pointer.
+    #[inline]
+    pub const unsafe fn from_raw(raw: *mut T) -> Self {
+        // INVARIANT: Validity of `raw` is guaranteed by the safety preconditions of this function.
+        // SAFETY: By the safety preconditions of this function, `raw` is not a NULL pointer.
+        Self(unsafe { NonNull::new_unchecked(raw) }, PhantomData)
+    }
+
+    /// Consumes the `Box<T, A>` and returns a raw pointer.
+    ///
+    /// This will not run the destructor of `T` and for non-ZSTs the allocation will stay alive
+    /// indefinitely. Use [`Box::from_raw`] to recover the [`Box`], drop the value and free the
+    /// allocation, if any.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// let x = KBox::new(24, GFP_KERNEL)?;
+    /// let ptr = KBox::into_raw(x);
+    /// // SAFETY: `ptr` comes from a previous call to `KBox::into_raw`.
+    /// let x = unsafe { KBox::from_raw(ptr) };
+    ///
+    /// assert_eq!(*x, 24);
+    /// # Ok::<(), Error>(())
+    /// ```
+    #[inline]
+    pub fn into_raw(b: Self) -> *mut T {
+        ManuallyDrop::new(b).0.as_ptr()
+    }
+
+    /// Consumes and leaks the `Box<T, A>` and returns a mutable reference.
+    ///
+    /// See [`Box::into_raw`] for more details.
+    #[inline]
+    pub fn leak<'a>(b: Self) -> &'a mut T {
+        // SAFETY: `Box::into_raw` always returns a properly aligned and dereferenceable pointer
+        // which points to an initialized instance of `T`.
+        unsafe { &mut *Box::into_raw(b) }
+    }
+}
+
+impl<T, A> Box<MaybeUninit<T>, A>
+where
+    A: Allocator,
+{
+    /// Converts a `Box<MaybeUninit<T>, A>` to a `Box<T, A>`.
+    ///
+    /// It is undefined behavior to call this function while the value inside of `b` is not yet
+    /// fully initialized.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that the value inside of `b` is in an initialized state.
+    pub unsafe fn assume_init(self) -> Box<T, A> {
+        let raw = Self::into_raw(self);
+
+        // SAFETY: `raw` comes from a previous call to `Box::into_raw`. By the safety requirements
+        // of this function, the value inside the `Box` is in an initialized state. Hence, it is
+        // safe to reconstruct the `Box` as `Box<T, A>`.
+        unsafe { Box::from_raw(raw.cast()) }
+    }
+
+    /// Writes the value and converts to `Box<T, A>`.
+    pub fn write(mut self, value: T) -> Box<T, A> {
+        (*self).write(value);
+
+        // SAFETY: We've just initialized `b`'s value.
+        unsafe { self.assume_init() }
+    }
+}
+
+impl<T, A> Box<T, A>
+where
+    A: Allocator,
+{
+    /// Creates a new `Box<T, A>` and initializes its contents with `x`.
+    ///
+    /// New memory is allocated with `A`. The allocation may fail, in which case an error is
+    /// returned. For ZSTs no memory is allocated.
+    pub fn new(x: T, flags: Flags) -> Result<Self, AllocError> {
+        let b = Self::new_uninit(flags)?;
+        Ok(Box::write(b, x))
+    }
+
+    /// Creates a new `Box<T, A>` with uninitialized contents.
+    ///
+    /// New memory is allocated with `A`. The allocation may fail, in which case an error is
+    /// returned. For ZSTs no memory is allocated.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// let b = KBox::<u64>::new_uninit(GFP_KERNEL)?;
+    /// let b = KBox::write(b, 24);
+    ///
+    /// assert_eq!(*b, 24_u64);
+    /// # Ok::<(), Error>(())
+    /// ```
+    pub fn new_uninit(flags: Flags) -> Result<Box<MaybeUninit<T>, A>, AllocError> {
+        let layout = Layout::new::<MaybeUninit<T>>();
+        let ptr = A::alloc(layout, flags)?;
+
+        // INVARIANT: `ptr` is either a dangling pointer or points to memory allocated with `A`,
+        // which is sufficient in size and alignment for storing a `T`.
+        Ok(Box(ptr.cast(), PhantomData))
+    }
+
+    /// Constructs a new `Pin<Box<T, A>>`. If `T` does not implement [`Unpin`], then `x` will be
+    /// pinned in memory and can't be moved.
+    #[inline]
+    pub fn pin(x: T, flags: Flags) -> Result<Pin<Box<T, A>>, AllocError>
+    where
+        A: 'static,
+    {
+        Ok(Self::new(x, flags)?.into())
+    }
+
+    /// Forgets the contents (does not run the destructor), but keeps the allocation.
+    fn forget_contents(this: Self) -> Box<MaybeUninit<T>, A> {
+        let ptr = Self::into_raw(this);
+
+        // SAFETY: `ptr` is valid, because it came from `Box::into_raw`.
+        unsafe { Box::from_raw(ptr.cast()) }
+    }
+
+    /// Drops the contents, but keeps the allocation.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// let value = KBox::new([0; 32], GFP_KERNEL)?;
+    /// assert_eq!(*value, [0; 32]);
+    /// let value = KBox::drop_contents(value);
+    /// // Now we can re-use `value`:
+    /// let value = KBox::write(value, [1; 32]);
+    /// assert_eq!(*value, [1; 32]);
+    /// # Ok::<(), Error>(())
+    /// ```
+    pub fn drop_contents(this: Self) -> Box<MaybeUninit<T>, A> {
+        let ptr = this.0.as_ptr();
+
+        // SAFETY: `ptr` is valid, because it came from `this`. After this call we never access the
+        // value stored in `this` again.
+        unsafe { core::ptr::drop_in_place(ptr) };
+
+        Self::forget_contents(this)
+    }
+
+    /// Moves the `Box`'s value out of the `Box` and consumes the `Box`.
+    pub fn into_inner(b: Self) -> T {
+        // SAFETY: By the type invariant `&*b` is valid for `read`.
+        let value = unsafe { core::ptr::read(&*b) };
+        let _ = Self::forget_contents(b);
+        value
+    }
+}
+
+impl<T, A> From<Box<T, A>> for Pin<Box<T, A>>
+where
+    T: ?Sized,
+    A: Allocator,
+{
+    /// Converts a `Box<T, A>` into a `Pin<Box<T, A>>`. If `T` does not implement [`Unpin`], then
+    /// `*b` will be pinned in memory and can't be moved.
+    ///
+    /// This moves `b` into `Pin` without moving `*b` or allocating and copying any memory.
+    fn from(b: Box<T, A>) -> Self {
+        // SAFETY: The value wrapped inside a `Pin<Box<T, A>>` cannot be moved or replaced as long
+        // as `T` does not implement `Unpin`.
+        unsafe { Pin::new_unchecked(b) }
+    }
+}
+
+impl<T, A> InPlaceWrite<T> for Box<MaybeUninit<T>, A>
+where
+    A: Allocator + 'static,
+{
+    type Initialized = Box<T, A>;
+
+    fn write_init<E>(mut self, init: impl Init<T, E>) -> Result<Self::Initialized, E> {
+        let slot = self.as_mut_ptr();
+        // SAFETY: When init errors/panics, slot will get deallocated but not dropped,
+        // slot is valid.
+        unsafe { init.__init(slot)? };
+        // SAFETY: All fields have been initialized.
+        Ok(unsafe { Box::assume_init(self) })
+    }
+
+    fn write_pin_init<E>(mut self, init: impl PinInit<T, E>) -> Result<Pin<Self::Initialized>, E> {
+        let slot = self.as_mut_ptr();
+        // SAFETY: When init errors/panics, slot will get deallocated but not dropped,
+        // slot is valid and will not be moved, because we pin it later.
+        unsafe { init.__pinned_init(slot)? };
+        // SAFETY: All fields have been initialized.
+        Ok(unsafe { Box::assume_init(self) }.into())
+    }
+}
+
+impl<T, A> InPlaceInit<T> for Box<T, A>
+where
+    A: Allocator + 'static,
+{
+    type PinnedSelf = Pin<Self>;
+
+    #[inline]
+    fn try_pin_init<E>(init: impl PinInit<T, E>, flags: Flags) -> Result<Pin<Self>, E>
+    where
+        E: From<AllocError>,
+    {
+        Box::<_, A>::new_uninit(flags)?.write_pin_init(init)
+    }
+
+    #[inline]
+    fn try_init<E>(init: impl Init<T, E>, flags: Flags) -> Result<Self, E>
+    where
+        E: From<AllocError>,
+    {
+        Box::<_, A>::new_uninit(flags)?.write_init(init)
+    }
+}
+
+impl<T: 'static, A> ForeignOwnable for Box<T, A>
+where
+    A: Allocator,
+{
+    type Borrowed<'a> = &'a T;
+
+    fn into_foreign(self) -> *const core::ffi::c_void {
+        Box::into_raw(self) as _
+    }
+
+    unsafe fn from_foreign(ptr: *const core::ffi::c_void) -> Self {
+        // SAFETY: The safety requirements of this function ensure that `ptr` comes from a previous
+        // call to `Self::into_foreign`.
+        unsafe { Box::from_raw(ptr as _) }
+    }
+
+    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> &'a T {
+        // SAFETY: The safety requirements of this method ensure that the object remains alive and
+        // immutable for the duration of 'a.
+        unsafe { &*ptr.cast() }
+    }
+}
+
+impl<T: 'static, A> ForeignOwnable for Pin<Box<T, A>>
+where
+    A: Allocator,
+{
+    type Borrowed<'a> = Pin<&'a T>;
+
+    fn into_foreign(self) -> *const core::ffi::c_void {
+        // SAFETY: We are still treating the box as pinned.
+        Box::into_raw(unsafe { Pin::into_inner_unchecked(self) }) as _
+    }
+
+    unsafe fn from_foreign(ptr: *const core::ffi::c_void) -> Self {
+        // SAFETY: The safety requirements of this function ensure that `ptr` comes from a previous
+        // call to `Self::into_foreign`.
+        unsafe { Pin::new_unchecked(Box::from_raw(ptr as _)) }
+    }
+
+    unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> Pin<&'a T> {
+        // SAFETY: The safety requirements for this function ensure that the object is still alive,
+        // so it is safe to dereference the raw pointer.
+        // The safety requirements of `from_foreign` also ensure that the object remains alive for
+        // the lifetime of the returned value.
+        let r = unsafe { &*ptr.cast() };
+
+        // SAFETY: This pointer originates from a `Pin<Box<T>>`.
+        unsafe { Pin::new_unchecked(r) }
+    }
+}
+
+impl<T, A> Deref for Box<T, A>
+where
+    T: ?Sized,
+    A: Allocator,
+{
+    type Target = T;
+
+    fn deref(&self) -> &T {
+        // SAFETY: `self.0` is always properly aligned, dereferenceable and points to an initialized
+        // instance of `T`.
+        unsafe { self.0.as_ref() }
+    }
+}
+
+impl<T, A> DerefMut for Box<T, A>
+where
+    T: ?Sized,
+    A: Allocator,
+{
+    fn deref_mut(&mut self) -> &mut T {
+        // SAFETY: `self.0` is always properly aligned, dereferenceable and points to an initialized
+        // instance of `T`.
+        unsafe { self.0.as_mut() }
+    }
+}
+
+impl<T, A> fmt::Debug for Box<T, A>
+where
+    T: ?Sized + fmt::Debug,
+    A: Allocator,
+{
+    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
+        fmt::Debug::fmt(&**self, f)
+    }
+}
+
+impl<T, A> Drop for Box<T, A>
+where
+    T: ?Sized,
+    A: Allocator,
+{
+    fn drop(&mut self) {
+        let layout = Layout::for_value::<T>(self);
+
+        // SAFETY: The pointer in `self.0` is guaranteed to be valid by the type invariant.
+        unsafe { core::ptr::drop_in_place::<T>(self.deref_mut()) };
+
+        // SAFETY:
+        // - `self.0` was previously allocated with `A`.
+        // - `layout` is equal to the `Layout´ `self.0` was allocated with.
+        unsafe { A::free(self.0.cast(), layout) };
+    }
+}
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -14,7 +14,7 @@
 #[doc(no_inline)]
 pub use core::pin::Pin;
 
-pub use crate::alloc::{box_ext::BoxExt, flags::*, vec_ext::VecExt};
+pub use crate::alloc::{box_ext::BoxExt, flags::*, vec_ext::VecExt, KBox, KVBox, VBox};
 
 #[doc(no_inline)]
 pub use alloc::{boxed::Box, vec::Vec};


