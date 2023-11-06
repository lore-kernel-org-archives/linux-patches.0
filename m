Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB9F208BD
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1IkWI6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298ABC433C7;
	Mon,  6 Nov 2023 13:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276676;
	bh=ouQ81jf53pzZ/8j8aUQKo7eMhB9ldbVs9GGjkb13kng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t1IkWI6SfCcnubNCEJjd/tG2Jp2QR0YAzKo6aK1YNr+IRhWp642XIEQZ7JfqdJKcx
	 XJ3OdYIuj+baAq4z70nu3K3nXngjYYQrPjuCD7LNOfREtSU7T96wah0h4DXCoTm+1g
	 PeaK3E56cCngSZsu7os6nJaOYqn2ycSLfGs/6t3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 61/88] rust: make `UnsafeCell` the outer type in `Opaque`
Date: Mon,  6 Nov 2023 14:03:55 +0100
Message-ID: <20231106130308.041864552@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
References: <20231106130305.772449722@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

[ Upstream commit 35cad617df2eeef8440a38e82bb2d81ae32ca50d ]

When combining `UnsafeCell` with `MaybeUninit`, it is idiomatic to use
`UnsafeCell` as the outer type. Intuitively, this is because a
`MaybeUninit<T>` might not contain a `T`, but we always want the effect
of the `UnsafeCell`, even if the inner value is uninitialized.

Now, strictly speaking, this doesn't really make a difference. The
compiler will always apply the `UnsafeCell` effect even if the inner
value is uninitialized. But I think we should follow the convention
here.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Link: https://lore.kernel.org/r/20230614115328.2825961-1-aliceryhl@google.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Stable-dep-of: 0b4e3b6f6b79 ("rust: types: make `Opaque` be `!Unpin`")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/types.rs | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index d479f8da8f381..c0b8bb1a75393 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -206,17 +206,17 @@ fn drop(&mut self) {
 ///
 /// This is meant to be used with FFI objects that are never interpreted by Rust code.
 #[repr(transparent)]
-pub struct Opaque<T>(MaybeUninit<UnsafeCell<T>>);
+pub struct Opaque<T>(UnsafeCell<MaybeUninit<T>>);
 
 impl<T> Opaque<T> {
     /// Creates a new opaque value.
     pub const fn new(value: T) -> Self {
-        Self(MaybeUninit::new(UnsafeCell::new(value)))
+        Self(UnsafeCell::new(MaybeUninit::new(value)))
     }
 
     /// Creates an uninitialised value.
     pub const fn uninit() -> Self {
-        Self(MaybeUninit::uninit())
+        Self(UnsafeCell::new(MaybeUninit::uninit()))
     }
 
     /// Creates a pin-initializer from the given initializer closure.
@@ -240,7 +240,7 @@ pub fn ffi_init(init_func: impl FnOnce(*mut T)) -> impl PinInit<Self> {
 
     /// Returns a raw pointer to the opaque data.
     pub fn get(&self) -> *mut T {
-        UnsafeCell::raw_get(self.0.as_ptr())
+        UnsafeCell::get(&self.0).cast::<T>()
     }
 
     /// Gets the value behind `this`.
@@ -248,7 +248,7 @@ pub fn get(&self) -> *mut T {
     /// This function is useful to get access to the value without creating intermediate
     /// references.
     pub const fn raw_get(this: *const Self) -> *mut T {
-        UnsafeCell::raw_get(this.cast::<UnsafeCell<T>>())
+        UnsafeCell::raw_get(this.cast::<UnsafeCell<MaybeUninit<T>>>()).cast::<T>()
     }
 }
 
-- 
2.42.0



