Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5819122154C;
	Mon, 10 Mar 2025 17:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627292; cv=none; b=OLQ4SB6TRBfAfLGKdGzxMWLtlh9/hqilFFaHM7zbYb+gCMmlT5JfGIPWtSiZt0uSCzNu4GdXgOyuPUMAbLFHEjTHJMjhDUh8VOcSSRdGCTNUHJG8cP00c/Bg7mK+hnz1lMaxS3pJGJTzboR4JPqkInRSpmYqYAU9Sq8cucr6LRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627292; c=relaxed/simple;
	bh=xwyzZpXyiZNKilwOTU2+imPAauOHgP2BcGxiinGsxHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPNRWmRugAkIz2r4wqLL2wHhDbT9K2PSvrvD1MF0Wvit8ZYXrGJhneVyliK5p/nG/M9ilLNILmIIt+6nXBN+dM1oRLQVC361aKcGhuEYinHYED2WSCzp1XfLzmS0LNEbqRkh/FrCUOK12baegi0l+ROYnBlwyduHoOxRiLUom2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krzwLcW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krzwLcW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A59C4CEE5;
	Mon, 10 Mar 2025 17:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627292;
	bh=xwyzZpXyiZNKilwOTU2+imPAauOHgP2BcGxiinGsxHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krzwLcW0yjuan7VdTqM0rMsMHGtkLPKdqhYT8jXIZPzYZ2qtxFI2QrmgQdcGA6scj
	 OImB69yxSMzDMwUTzj88VrEdZVvRL7uGPMfPZI9OpsXNA8rXn2Io8cLcJd2h+jJv2N
	 zFOmrVuK+jtfksaoDURnmMRNm1y75jXmGEgpQq6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 047/269] rust: alloc: implement `IntoIterator` for `Vec`
Date: Mon, 10 Mar 2025 18:03:20 +0100
Message-ID: <20250310170459.598815207@linuxfoundation.org>
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

commit 1d1d223aa3b37c34271aefc2706340d0843bfcb2 upstream.

Implement `IntoIterator` for `Vec`, `Vec`'s `IntoIter` type, as well as
`Iterator` for `IntoIter`.

`Vec::into_iter` disassembles the `Vec` into its raw parts; additionally,
`IntoIter` keeps track of a separate pointer, which is incremented
correspondingly as the iterator advances, while the length, or the count
of elements, is decremented.

This also means that `IntoIter` takes the ownership of the backing
buffer and is responsible to drop the remaining elements and free the
backing buffer, if it's dropped.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-18-dakr@kernel.org
[ Fixed typos. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs      |    1 
 rust/kernel/alloc/kvec.rs |  170 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -20,6 +20,7 @@ pub use self::kbox::KBox;
 pub use self::kbox::KVBox;
 pub use self::kbox::VBox;
 
+pub use self::kvec::IntoIter;
 pub use self::kvec::KVVec;
 pub use self::kvec::KVec;
 pub use self::kvec::VVec;
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -646,3 +646,173 @@ impl_slice_eq! {
     [A: Allocator, const N: usize] Vec<T, A>, [U; N],
     [A: Allocator, const N: usize] Vec<T, A>, &[U; N],
 }
+
+impl<'a, T, A> IntoIterator for &'a Vec<T, A>
+where
+    A: Allocator,
+{
+    type Item = &'a T;
+    type IntoIter = slice::Iter<'a, T>;
+
+    fn into_iter(self) -> Self::IntoIter {
+        self.iter()
+    }
+}
+
+impl<'a, T, A: Allocator> IntoIterator for &'a mut Vec<T, A>
+where
+    A: Allocator,
+{
+    type Item = &'a mut T;
+    type IntoIter = slice::IterMut<'a, T>;
+
+    fn into_iter(self) -> Self::IntoIter {
+        self.iter_mut()
+    }
+}
+
+/// An [`Iterator`] implementation for [`Vec`] that moves elements out of a vector.
+///
+/// This structure is created by the [`Vec::into_iter`] method on [`Vec`] (provided by the
+/// [`IntoIterator`] trait).
+///
+/// # Examples
+///
+/// ```
+/// let v = kernel::kvec![0, 1, 2]?;
+/// let iter = v.into_iter();
+///
+/// # Ok::<(), Error>(())
+/// ```
+pub struct IntoIter<T, A: Allocator> {
+    ptr: *mut T,
+    buf: NonNull<T>,
+    len: usize,
+    layout: ArrayLayout<T>,
+    _p: PhantomData<A>,
+}
+
+impl<T, A> Iterator for IntoIter<T, A>
+where
+    A: Allocator,
+{
+    type Item = T;
+
+    /// # Examples
+    ///
+    /// ```
+    /// let v = kernel::kvec![1, 2, 3]?;
+    /// let mut it = v.into_iter();
+    ///
+    /// assert_eq!(it.next(), Some(1));
+    /// assert_eq!(it.next(), Some(2));
+    /// assert_eq!(it.next(), Some(3));
+    /// assert_eq!(it.next(), None);
+    ///
+    /// # Ok::<(), Error>(())
+    /// ```
+    fn next(&mut self) -> Option<T> {
+        if self.len == 0 {
+            return None;
+        }
+
+        let current = self.ptr;
+
+        // SAFETY: We can't overflow; decreasing `self.len` by one every time we advance `self.ptr`
+        // by one guarantees that.
+        unsafe { self.ptr = self.ptr.add(1) };
+
+        self.len -= 1;
+
+        // SAFETY: `current` is guaranteed to point at a valid element within the buffer.
+        Some(unsafe { current.read() })
+    }
+
+    /// # Examples
+    ///
+    /// ```
+    /// let v: KVec<u32> = kernel::kvec![1, 2, 3]?;
+    /// let mut iter = v.into_iter();
+    /// let size = iter.size_hint().0;
+    ///
+    /// iter.next();
+    /// assert_eq!(iter.size_hint().0, size - 1);
+    ///
+    /// iter.next();
+    /// assert_eq!(iter.size_hint().0, size - 2);
+    ///
+    /// iter.next();
+    /// assert_eq!(iter.size_hint().0, size - 3);
+    ///
+    /// # Ok::<(), Error>(())
+    /// ```
+    fn size_hint(&self) -> (usize, Option<usize>) {
+        (self.len, Some(self.len))
+    }
+}
+
+impl<T, A> Drop for IntoIter<T, A>
+where
+    A: Allocator,
+{
+    fn drop(&mut self) {
+        // SAFETY: `self.ptr` is guaranteed to be valid by the type invariant.
+        unsafe { ptr::drop_in_place(ptr::slice_from_raw_parts_mut(self.ptr, self.len)) };
+
+        // SAFETY:
+        // - `self.buf` was previously allocated with `A`.
+        // - `self.layout` matches the `ArrayLayout` of the preceding allocation.
+        unsafe { A::free(self.buf.cast(), self.layout.into()) };
+    }
+}
+
+impl<T, A> IntoIterator for Vec<T, A>
+where
+    A: Allocator,
+{
+    type Item = T;
+    type IntoIter = IntoIter<T, A>;
+
+    /// Consumes the `Vec<T, A>` and creates an `Iterator`, which moves each value out of the
+    /// vector (from start to end).
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// let v = kernel::kvec![1, 2]?;
+    /// let mut v_iter = v.into_iter();
+    ///
+    /// let first_element: Option<u32> = v_iter.next();
+    ///
+    /// assert_eq!(first_element, Some(1));
+    /// assert_eq!(v_iter.next(), Some(2));
+    /// assert_eq!(v_iter.next(), None);
+    ///
+    /// # Ok::<(), Error>(())
+    /// ```
+    ///
+    /// ```
+    /// let v = kernel::kvec![];
+    /// let mut v_iter = v.into_iter();
+    ///
+    /// let first_element: Option<u32> = v_iter.next();
+    ///
+    /// assert_eq!(first_element, None);
+    ///
+    /// # Ok::<(), Error>(())
+    /// ```
+    #[inline]
+    fn into_iter(self) -> Self::IntoIter {
+        let buf = self.ptr;
+        let layout = self.layout;
+        let (ptr, len, _) = self.into_raw_parts();
+
+        IntoIter {
+            ptr,
+            buf,
+            len,
+            layout,
+            _p: PhantomData::<A>,
+        }
+    }
+}


