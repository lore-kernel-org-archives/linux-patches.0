Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC9A226D0B;
	Mon, 10 Mar 2025 17:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627295; cv=none; b=k1mvBFxhXXXzXFg1QijxaNGozwR92OasrNvjarRSnY4efeg4fQamQbTbVOR6hW5W2i42jyXy9JideyuCPiigUtkhMEasx8LAwYOA+5wRJfrgZhndj+z/Lph5t+7ww/ukp35PTR9CkojJ8c+hLgi8qOxpPKLsqdE8ytRrpg6XMUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627295; c=relaxed/simple;
	bh=HQZJtU9NJ/i09jXuopgpOMszbyGbCaVhyiPdu3/YsE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3+z1bSkRgHFBj8D7Zz3McblugcIYScj02RSX5pXBpMO1JXtyLjqro+AzaoUNxeF2nudrEZI26zrIvxe2TBqbgBCauEDfRby/gAXrNkBexVS2jdYlNHvXVwNylNpOEApFg8V0N/MRcZgSTX1+EZFGSSdhAGq0D6jaWM5Y2FJRi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O7H1+6hz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O7H1+6hz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6D5C4CEE5;
	Mon, 10 Mar 2025 17:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627295;
	bh=HQZJtU9NJ/i09jXuopgpOMszbyGbCaVhyiPdu3/YsE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O7H1+6hzJWFoRw/3bM7pE9HhNpJF1L7iLc28B4+9TndtEyAc2Qy7cusamf0BgOU9q
	 B+WDZf68jqGTeHLO4blpqNT1w4pT4l0mNZz490AbH1XWskMK5l5jkBC6BGTf4rqflu
	 vHK4IezgkHUDubBabTLAfKl6+Rat/n/3XrNDfeL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 048/269] rust: alloc: implement `collect` for `IntoIter`
Date: Mon, 10 Mar 2025 18:03:21 +0100
Message-ID: <20250310170459.639354920@linuxfoundation.org>
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

commit 93e602310f87b7b515b86a8f919cc0799387e5c3 upstream.

Currently, we can't implement `FromIterator`. There are a couple of
issues with this trait in the kernel, namely:

  - Rust's specialization feature is unstable. This prevents us to
    optimize for the special case where `I::IntoIter` equals `Vec`'s
    `IntoIter` type.
  - We also can't use `I::IntoIter`'s type ID either to work around this,
    since `FromIterator` doesn't require this type to be `'static`.
  - `FromIterator::from_iter` does return `Self` instead of
    `Result<Self, AllocError>`, hence we can't properly handle allocation
    failures.
  - Neither `Iterator::collect` nor `FromIterator::from_iter` can handle
    additional allocation flags.

Instead, provide `IntoIter::collect`, such that we can at least convert
`IntoIter` into a `Vec` again.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-19-dakr@kernel.org
[ Added newline in documentation, changed case of section to be
  consistent with an existing one, fixed typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/kvec.rs |   95 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -692,6 +692,101 @@ pub struct IntoIter<T, A: Allocator> {
     _p: PhantomData<A>,
 }
 
+impl<T, A> IntoIter<T, A>
+where
+    A: Allocator,
+{
+    fn into_raw_parts(self) -> (*mut T, NonNull<T>, usize, usize) {
+        let me = ManuallyDrop::new(self);
+        let ptr = me.ptr;
+        let buf = me.buf;
+        let len = me.len;
+        let cap = me.layout.len();
+        (ptr, buf, len, cap)
+    }
+
+    /// Same as `Iterator::collect` but specialized for `Vec`'s `IntoIter`.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// let v = kernel::kvec![1, 2, 3]?;
+    /// let mut it = v.into_iter();
+    ///
+    /// assert_eq!(it.next(), Some(1));
+    ///
+    /// let v = it.collect(GFP_KERNEL);
+    /// assert_eq!(v, [2, 3]);
+    ///
+    /// # Ok::<(), Error>(())
+    /// ```
+    ///
+    /// # Implementation details
+    ///
+    /// Currently, we can't implement `FromIterator`. There are a couple of issues with this trait
+    /// in the kernel, namely:
+    ///
+    /// - Rust's specialization feature is unstable. This prevents us to optimize for the special
+    ///   case where `I::IntoIter` equals `Vec`'s `IntoIter` type.
+    /// - We also can't use `I::IntoIter`'s type ID either to work around this, since `FromIterator`
+    ///   doesn't require this type to be `'static`.
+    /// - `FromIterator::from_iter` does return `Self` instead of `Result<Self, AllocError>`, hence
+    ///   we can't properly handle allocation failures.
+    /// - Neither `Iterator::collect` nor `FromIterator::from_iter` can handle additional allocation
+    ///   flags.
+    ///
+    /// Instead, provide `IntoIter::collect`, such that we can at least convert a `IntoIter` into a
+    /// `Vec` again.
+    ///
+    /// Note that `IntoIter::collect` doesn't require `Flags`, since it re-uses the existing backing
+    /// buffer. However, this backing buffer may be shrunk to the actual count of elements.
+    pub fn collect(self, flags: Flags) -> Vec<T, A> {
+        let old_layout = self.layout;
+        let (mut ptr, buf, len, mut cap) = self.into_raw_parts();
+        let has_advanced = ptr != buf.as_ptr();
+
+        if has_advanced {
+            // Copy the contents we have advanced to at the beginning of the buffer.
+            //
+            // SAFETY:
+            // - `ptr` is valid for reads of `len * size_of::<T>()` bytes,
+            // - `buf.as_ptr()` is valid for writes of `len * size_of::<T>()` bytes,
+            // - `ptr` and `buf.as_ptr()` are not be subject to aliasing restrictions relative to
+            //   each other,
+            // - both `ptr` and `buf.ptr()` are properly aligned.
+            unsafe { ptr::copy(ptr, buf.as_ptr(), len) };
+            ptr = buf.as_ptr();
+
+            // SAFETY: `len` is guaranteed to be smaller than `self.layout.len()`.
+            let layout = unsafe { ArrayLayout::<T>::new_unchecked(len) };
+
+            // SAFETY: `buf` points to the start of the backing buffer and `len` is guaranteed to be
+            // smaller than `cap`. Depending on `alloc` this operation may shrink the buffer or leaves
+            // it as it is.
+            ptr = match unsafe {
+                A::realloc(Some(buf.cast()), layout.into(), old_layout.into(), flags)
+            } {
+                // If we fail to shrink, which likely can't even happen, continue with the existing
+                // buffer.
+                Err(_) => ptr,
+                Ok(ptr) => {
+                    cap = len;
+                    ptr.as_ptr().cast()
+                }
+            };
+        }
+
+        // SAFETY: If the iterator has been advanced, the advanced elements have been copied to
+        // the beginning of the buffer and `len` has been adjusted accordingly.
+        //
+        // - `ptr` is guaranteed to point to the start of the backing buffer.
+        // - `cap` is either the original capacity or, after shrinking the buffer, equal to `len`.
+        // - `alloc` is guaranteed to be unchanged since `into_iter` has been called on the original
+        //   `Vec`.
+        unsafe { Vec::from_raw_parts(ptr, len, cap) }
+    }
+}
+
 impl<T, A> Iterator for IntoIter<T, A>
 where
     A: Allocator,


