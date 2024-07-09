Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57EC19E7C8;
	Tue,  9 Jul 2024 16:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541193; cv=none; b=VvbrMxDmpXCHjlGSwemNLUBqFetd9fDBYMTYEiSDfHeWeCCJ67CZOly/iNKWRD47xy/3Ge6nP2wHWAAxmLsdFmXYEEZlVOhgM635xflYG5u6+aiWeNV7s7wd2cCbph7yUJV91uN66cQHfGGj27wkQQEjl12dxGtMVR4rQj0qyy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541193; c=relaxed/simple;
	bh=ou4VeEjvDRaTQ69nADfEa6rEkq7aBSGnOgksPl4kF8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DDSgbqhQ2nmxEGkHZHMoQ0rYJHL/n8ZgBj01C8yXmgwYcyOAZhPb7OlZqiHV3wgD/Im5B5s6HrHH34Zp8uLe4bxrQX7oPuPHfi4jNi8iv5YbLbnInr4wcsR5El0/pvkON6ZL7E+cM/ppKqTVapeXFmEaI9oN4AoQFUwk6KjxcMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSs7rzS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSs7rzS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444C1C32782;
	Tue,  9 Jul 2024 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541193;
	bh=ou4VeEjvDRaTQ69nADfEa6rEkq7aBSGnOgksPl4kF8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSs7rzS9iG5h1vNyQaQ99nsBkU7Q1+MJ8beHF59omw0nERSXALN71w7rb2d0t1nKZ
	 lBcbb3L4b0ozzeOiNqzLiFDbgofJ0i715UAWLX5bza5TTPeW343TRZHSm/FC7WIusL
	 TV7BD+CftUG/8rsMIIgY8yo/SbJL2TVEI3bL8SyDET3jVrK5G6oRFa33B+bVPIJEZs
	 WHH4JLw6c+fuaSQv48WtD+xCjSMGm+3lXpzm3bCpyNm2vXxb1GC/QAAcxKXGx8qPn8
	 zpSl4IvwOU4nlt0BaK94jkZmz/8VmXZ/tCOdy4t/gLJbs1IheFOOAVUY6bD7aqYpfm
	 IlovjQ5PJuvgA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 02/13] rust: init: simplify from `map_err` to `inspect_err`
Date: Tue,  9 Jul 2024 18:05:57 +0200
Message-ID: <20240709160615.998336-3-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

A new complexity lint, `manual_inspect` [1], has been introduced in
the upcoming Rust 1.81 (currently in nightly), which checks for uses of
`map*` which return the original item:

    error:
    --> rust/kernel/init.rs:846:23
        |
    846 |         (self.1)(val).map_err(|e| {
        |                       ^^^^^^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#manual_inspect
        = note: `-D clippy::manual-inspect` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::manual_inspect)]`
    help: try
        |
    846 ~         (self.1)(val).inspect_err(|e| {
    847 |             // SAFETY: `slot` was initialized above.
    848 ~             unsafe { core::ptr::drop_in_place(slot) };
        |

Thus clean them up.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/manual_inspect [1]
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
v2:
  - Moved `SAFETY` comment out of the closure, in one of the instances
    only. In the other, it would mean putting two `SAFETY` comments in
    a row, which is even more confusing. Open coding it may be clearer,
    though -- happy to get a patch for that later on (with some docs
    about guidelines for using or avoiding `inspect_*`). (Björn, Benno,
    Alice)

 rust/kernel/init.rs | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 68605b633e73..495c09ebe3a3 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -843,11 +843,8 @@ unsafe fn __pinned_init(self, slot: *mut T) -> Result<(), E> {
         let val = unsafe { &mut *slot };
         // SAFETY: `slot` is considered pinned.
         let val = unsafe { Pin::new_unchecked(val) };
-        (self.1)(val).map_err(|e| {
-            // SAFETY: `slot` was initialized above.
-            unsafe { core::ptr::drop_in_place(slot) };
-            e
-        })
+        // SAFETY: `slot` was initialized above.
+        (self.1)(val).inspect_err(|_| unsafe { core::ptr::drop_in_place(slot) })
     }
 }

@@ -941,11 +938,9 @@ unsafe fn __init(self, slot: *mut T) -> Result<(), E> {
         // SAFETY: All requirements fulfilled since this function is `__init`.
         unsafe { self.0.__pinned_init(slot)? };
         // SAFETY: The above call initialized `slot` and we still have unique access.
-        (self.1)(unsafe { &mut *slot }).map_err(|e| {
+        (self.1)(unsafe { &mut *slot }).inspect_err(|_|
             // SAFETY: `slot` was initialized above.
-            unsafe { core::ptr::drop_in_place(slot) };
-            e
-        })
+            unsafe { core::ptr::drop_in_place(slot) })
     }
 }

--
2.45.2
