Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A4C12C47A;
	Tue, 30 Apr 2024 10:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474376; cv=none; b=HrhBY8MmG9aZ+rF3rpudmVZRqHwRHIBNKc4QyRhr1VYIlWnhFemW3tOlc7+mISFcxz+kyZXn/5ESnivE91SpyqtNh8zgME50EFn9SWm6p01KOFJfFC2a3+fHxZw2HC1JSZqQ0asxaQIsqHVR4QJpDfAyUPt/wHoAi8zkD9bhogM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474376; c=relaxed/simple;
	bh=uTicIQkuAoanNIgtmhGlwIIiozMqRQ7/SVcwoFfcM5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTUIsjZ1nYAad9HdQGy2Rd2mtf/EpruQcUw7DgoJBksn3J4V3bawms4MIYtJOrnqhi0VxsaYFXX2aF+vQLRfZ7GidVk1WRp/2BuNUuF0flnlRCJ8gIKBOCHwi1CezXjb/64F3E0nYqLZ0a3iAs7sE+2ljYgj8rihkyz0sEZsB1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM1dD4Fe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM1dD4Fe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81865C2BBFC;
	Tue, 30 Apr 2024 10:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474375;
	bh=uTicIQkuAoanNIgtmhGlwIIiozMqRQ7/SVcwoFfcM5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jM1dD4FegzKc+LLsAnwnpXer2LOz3UMRsbBmXr5OZ2m+2XKAWWdP6yEaff6T+NSX8
	 IaPEM2H8BoKAwMKRmhdgzXjwd5HB0eky7HA4KAtnVLJJeaO/+CzsqOktWTkLI32weH
	 fcc4uColrjyZ+aF4ZRmGB+kGUx0pGM1twDj9UvnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laine Taffin Altman <alexanderaltman@me.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.8 137/228] rust: init: remove impl Zeroable for Infallible
Date: Tue, 30 Apr 2024 12:38:35 +0200
Message-ID: <20240430103107.754646328@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laine Taffin Altman <alexanderaltman@me.com>

commit 49ceae68a0df9a92617a61e9ce8a0efcf6419585 upstream.

In Rust, producing an invalid value of any type is immediate undefined
behavior (UB); this includes via zeroing memory.  Therefore, since an
uninhabited type has no valid values, producing any values at all for it is
UB.

The Rust standard library type `core::convert::Infallible` is uninhabited,
by virtue of having been declared as an enum with no cases, which always
produces uninhabited types in Rust.

The current kernel code allows this UB to be triggered, for example by code
like `Box::<core::convert::Infallible>::init(kernel::init::zeroed())`.

Thus, remove the implementation of `Zeroable` for `Infallible`, thereby
avoiding the unsoundness (potential for future UB).

Cc: stable@vger.kernel.org
Fixes: 38cde0bd7b67 ("rust: init: add `Zeroable` trait and `init::zeroed` function")
Closes: https://github.com/Rust-for-Linux/pinned-init/pull/13
Signed-off-by: Laine Taffin Altman <alexanderaltman@me.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Link: https://lore.kernel.org/r/CA160A4E-561E-4918-837E-3DCEBA74F808@me.com
[ Reformatted the comment slightly. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/init.rs |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -1292,8 +1292,15 @@ impl_zeroable! {
     i8, i16, i32, i64, i128, isize,
     f32, f64,
 
-    // SAFETY: These are ZSTs, there is nothing to zero.
-    {<T: ?Sized>} PhantomData<T>, core::marker::PhantomPinned, Infallible, (),
+    // Note: do not add uninhabited types (such as `!` or `core::convert::Infallible`) to this list;
+    // creating an instance of an uninhabited type is immediate undefined behavior. For more on
+    // uninhabited/empty types, consult The Rustonomicon:
+    // <https://doc.rust-lang.org/stable/nomicon/exotic-sizes.html#empty-types>. The Rust Reference
+    // also has information on undefined behavior:
+    // <https://doc.rust-lang.org/stable/reference/behavior-considered-undefined.html>.
+    //
+    // SAFETY: These are inhabited ZSTs; there is nothing to zero and a valid value exists.
+    {<T: ?Sized>} PhantomData<T>, core::marker::PhantomPinned, (),
 
     // SAFETY: Type is allowed to take any value, including all zeros.
     {<T>} MaybeUninit<T>,


