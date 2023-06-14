Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A120979E1
	for <patches@lists.linux.dev>; Wed, 14 Jun 2023 11:53:37 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-56d43d49d58so8826967b3.1
        for <patches@lists.linux.dev>; Wed, 14 Jun 2023 04:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686743616; x=1689335616;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iQcKjMXMsnWztaoMR9yA4alqbcESKo/Ty0nyLCc3lHY=;
        b=P/0dT32mEmx5CRm6KyIkY8XYLtJCudbxoZS8fwkFdmZ7FMZ4gNRw1+wgP465gUIN42
         LdIpWmYzaXg3CI1XlaE4maNokY3KosI1rhodoBW1i9esHOuyKU6hAdVgZxmvkeK5ZDe9
         aLJ9E7GES+I4AlHLDcNtJNj4K0AllRunwIQ9tqSlsSCb8yOCdqpgZgtpSsfxZURxkCOW
         +tQPNlr1bkJ2jdG3tZqf0IWPKabg/xWJ0mH6IspxYJyWXft9mOT1ou3m9ewsZ3VAUNwC
         Exrhm9dNNTMrUzhFcy0uEdc+f9CEHHQo3at96Cp0neLyBwDwfv6PJsN0aOxfCVncW+0k
         acsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686743616; x=1689335616;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iQcKjMXMsnWztaoMR9yA4alqbcESKo/Ty0nyLCc3lHY=;
        b=XqiqXrbBQbyd+XRiDKEw3KUpLPVJbZliNvZ8qNIf1giVJDhi0s+aDk95SxEFLc62m3
         F+2ugdlNPkNi7M0zRiYVXJoDPKfENIKLA6HZiWCbrAIQRxAwgMcX6gsb02VvgGzsHsFI
         hENyEh3g13XQoD5uHcdUynepMG7qCfa6bmuBSNu0tCuVdWq0L1NbBcVgqPZY6OV0meJR
         R2h6q3ZXBB66vQn5u8mYRf/tpSp7pyhNX574JO7gEgnCtlwfcJ6B/qcd3kCEhdrEDJUx
         UdWI1RjWUoI+5egRNVkTuTgOLI9/tiRVuVPPnmHSRyNM3uyZ11N6kOrMC8CbNmyZ8XmB
         kl0g==
X-Gm-Message-State: AC+VfDyoWr95vOsYiVJFp7PhHgZhKz++a8/OPgrGIdausWGB2/xIdgjt
	g5CBq/cxv7DIRGiwCMpSWvn+CL/9K5xVlTA=
X-Google-Smtp-Source: ACHHUZ5vDFW8adN4U6HOdgFt8IGTY+hbYJ1tu0Qnb7sRlz1iIvi7knGe30Ax5P9nmQuCndSXtfKh6M7RkJo74RQ=
X-Received: from aliceryhl.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:6c8])
 (user=aliceryhl job=sendgmr) by 2002:a25:d854:0:b0:bc4:8939:e1f5 with SMTP id
 p81-20020a25d854000000b00bc48939e1f5mr909934ybg.4.1686743616324; Wed, 14 Jun
 2023 04:53:36 -0700 (PDT)
Date: Wed, 14 Jun 2023 11:53:28 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230614115328.2825961-1-aliceryhl@google.com>
Subject: [PATCH] rust: make `UnsafeCell` the outer type in `Opaque`
From: Alice Ryhl <aliceryhl@google.com>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Wedson Almeida Filho <wedsonaf@gmail.com>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, 
	"=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <benno.lossin@proton.me>, 
	Alice Ryhl <aliceryhl@google.com>, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

When combining `UnsafeCell` with `MaybeUninit`, it is idiomatic to use
`UnsafeCell` as the outer type. Intuitively, this is because a
`MaybeUninit<T>` might not contain a `T`, but we always want the effect
of the `UnsafeCell`, even if the inner value is uninitialized.

Now, strictly speaking, this doesn't really make a difference. The
compiler will always apply the `UnsafeCell` effect even if the inner
value is uninitialized. But I think we should follow the convention
here.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/types.rs | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 1e5380b16ed5..fb41635f1e1f 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -224,17 +224,17 @@ fn drop(&mut self) {
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
@@ -258,7 +258,7 @@ pub fn ffi_init(init_func: impl FnOnce(*mut T)) -> impl PinInit<Self> {
 
     /// Returns a raw pointer to the opaque data.
     pub fn get(&self) -> *mut T {
-        UnsafeCell::raw_get(self.0.as_ptr())
+        UnsafeCell::get(&self.0).cast::<T>()
     }
 
     /// Gets the value behind `this`.
@@ -266,7 +266,7 @@ pub fn get(&self) -> *mut T {
     /// This function is useful to get access to the value without creating intermediate
     /// references.
     pub const fn raw_get(this: *const Self) -> *mut T {
-        UnsafeCell::raw_get(this.cast::<UnsafeCell<T>>())
+        UnsafeCell::raw_get(this.cast::<UnsafeCell<MaybeUninit<T>>>()).cast::<T>()
     }
 }
 

base-commit: d2e3115d717197cb2bc020dd1f06b06538474ac3
-- 
2.41.0.162.gfafddb0af9-goog

