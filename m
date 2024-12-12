Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC07221578A;
	Thu, 12 Dec 2024 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016483; cv=none; b=mPuwj/gFn3BfbXTTkx6IXnCmXF3RYUrp52TxYBfDWgWh5nBf/4rhTXW8B1ESB7Mjxk7lfJHHfIyKhW+2aX8g6nLn1SuIgPGHBvcMyaG26twvspUTD5pF7A2jO98k0NN7KG/aC0HBdC1tdoHUzy/2GO2gvjf54WW756o0k/1soqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016483; c=relaxed/simple;
	bh=rHOmSHKtj7Fhf6ocDBQFZyzwf7NQ+HJxWafr2ha9S0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLvPOq1POnUER8qqQ0QsFdkq/bY+BwFoOrlz9iWiJ4orGAI7602BX9NJOC/WIMjfHOA5alwfqi0luJczOxKxMrT/GNGtXQWMtG/UAH4NrpnkBJ1ZW67qqWx7z74jwPYRDU6CUq978ZSLkOnzD4BCRoE7OnAi6TNkk2ffhSsQIXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=manFJElg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="manFJElg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17BECC4CECE;
	Thu, 12 Dec 2024 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016483;
	bh=rHOmSHKtj7Fhf6ocDBQFZyzwf7NQ+HJxWafr2ha9S0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=manFJElg4zS2FsUVQW/tBWJPusTC7KEtt88co9eQfyD/xEiYyyu9ICV7BqQndblA9
	 QOqqOXBT/uMxnnNsAM3wlL9ym74C8xxrY8QOP5r3PYwNkWQtE0VzoKMT9+UZ5hj6By
	 3dfutRHx2ZO0ZYiajRW5MBOI/i1+OB9mhl8RJ4IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Taylor <ade@hohum.me.uk>,
	Gary Guo <gary@garyguo.net>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 211/466] rust: enable arbitrary_self_types and remove `Receiver`
Date: Thu, 12 Dec 2024 15:56:20 +0100
Message-ID: <20241212144315.125422372@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

commit c95bbb59a9b22f9b838b15d28319185c1c884329 upstream.

The term "receiver" means that a type can be used as the type of `self`,
and thus enables method call syntax `foo.bar()` instead of
`Foo::bar(foo)`. Stable Rust as of today (1.81) enables a limited
selection of types (primitives and types in std, e.g. `Box` and `Arc`)
to be used as receivers, while custom types cannot.

We want the kernel `Arc` type to have the same functionality as the Rust
std `Arc`, so we use the `Receiver` trait (gated behind `receiver_trait`
unstable feature) to gain the functionality.

The `arbitrary_self_types` RFC [1] (tracking issue [2]) is accepted and
it will allow all types that implement a new `Receiver` trait (different
from today's unstable trait) to be used as receivers. This trait will be
automatically implemented for all `Deref` types, which include our `Arc`
type, so we no longer have to opt-in to be used as receiver. To prepare
us for the change, remove the `Receiver` implementation and the
associated feature. To still allow `Arc` and others to be used as method
receivers, turn on `arbitrary_self_types` feature instead.

This feature gate is introduced in 1.23.0. It used to enable both
`Deref` types and raw pointer types to be used as receivers, but the
latter is now split into a different feature gate in Rust 1.83 nightly.
We do not need receivers on raw pointers so this change would not affect
us and usage of `arbitrary_self_types` feature would work for all Rust
versions that we support (>=1.78).

Cc: Adrian Taylor <ade@hohum.me.uk>
Link: https://github.com/rust-lang/rfcs/pull/3519 [1]
Link: https://github.com/rust-lang/rust/issues/44874 [2]
Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20240915132734.1653004-1-gary@garyguo.net
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/lib.rs      |    2 +-
 rust/kernel/list/arc.rs |    3 ---
 rust/kernel/sync/arc.rs |    6 ------
 scripts/Makefile.build  |    2 +-
 4 files changed, 2 insertions(+), 11 deletions(-)

--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -12,10 +12,10 @@
 //! do so first instead of bypassing this crate.
 
 #![no_std]
+#![feature(arbitrary_self_types)]
 #![feature(coerce_unsized)]
 #![feature(dispatch_from_dyn)]
 #![feature(new_uninit)]
-#![feature(receiver_trait)]
 #![feature(unsize)]
 
 // Ensure conditional compilation based on the kernel configuration works;
--- a/rust/kernel/list/arc.rs
+++ b/rust/kernel/list/arc.rs
@@ -441,9 +441,6 @@ where
     }
 }
 
-// This is to allow [`ListArc`] (and variants) to be used as the type of `self`.
-impl<T, const ID: u64> core::ops::Receiver for ListArc<T, ID> where T: ListArcSafe<ID> + ?Sized {}
-
 // This is to allow coercion from `ListArc<T>` to `ListArc<U>` if `T` can be converted to the
 // dynamically-sized type (DST) `U`.
 impl<T, U, const ID: u64> core::ops::CoerceUnsized<ListArc<U, ID>> for ListArc<T, ID>
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -171,9 +171,6 @@ impl<T: ?Sized> ArcInner<T> {
     }
 }
 
-// This is to allow [`Arc`] (and variants) to be used as the type of `self`.
-impl<T: ?Sized> core::ops::Receiver for Arc<T> {}
-
 // This is to allow coercion from `Arc<T>` to `Arc<U>` if `T` can be converted to the
 // dynamically-sized type (DST) `U`.
 impl<T: ?Sized + Unsize<U>, U: ?Sized> core::ops::CoerceUnsized<Arc<U>> for Arc<T> {}
@@ -480,9 +477,6 @@ pub struct ArcBorrow<'a, T: ?Sized + 'a>
     _p: PhantomData<&'a ()>,
 }
 
-// This is to allow [`ArcBorrow`] (and variants) to be used as the type of `self`.
-impl<T: ?Sized> core::ops::Receiver for ArcBorrow<'_, T> {}
-
 // This is to allow `ArcBorrow<U>` to be dispatched on when `ArcBorrow<T>` can be coerced into
 // `ArcBorrow<U>`.
 impl<T: ?Sized + Unsize<U>, U: ?Sized> core::ops::DispatchFromDyn<ArcBorrow<'_, U>>
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -248,7 +248,7 @@ $(obj)/%.lst: $(obj)/%.c FORCE
 # Compile Rust sources (.rs)
 # ---------------------------------------------------------------------------
 
-rust_allowed_features := new_uninit
+rust_allowed_features := arbitrary_self_types,new_uninit
 
 # `--out-dir` is required to avoid temporaries being created by `rustc` in the
 # current working directory, which may be not accessible in the out-of-tree


