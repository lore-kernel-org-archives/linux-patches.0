Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7816EB70;
	Mon,  1 Jul 2024 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859015; cv=none; b=jpuZ/ldu5clbku9Ka3XEE8JTkKlRmBAfPKgHntMdKNh8tagnhA6GOKQcceWvwR+tzyK+W1tNLCOpqJAs7v86H682n0ILDxf7iUfTLKLsTfbs7L9MIxiv5qfViWVOG7QcWIoaiC5LVSTk0jsWppAki9zH6jZiTyBYXXOs1VTkjgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859015; c=relaxed/simple;
	bh=PvREQnxwsEdit5kOrHUwIps8b0ZBIllpQYHuS2aVQXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr+WB5qPpnTtt3XjDbjTmYNYm6JxYOFfqT1/LBycDVMeizvsLpt/zigVvOEPT7M1hQalu5UD+oq2RVgJ/+FxFWNa9s/zNBdodUKn2OBQTIj2TC6YF//5Tqc+GBir3t+QO5jwRgfnUDA+l5VdChfavIdruxxbGUqCZ0HOodSzKxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=el/BWU4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="el/BWU4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38114C116B1;
	Mon,  1 Jul 2024 18:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859015;
	bh=PvREQnxwsEdit5kOrHUwIps8b0ZBIllpQYHuS2aVQXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=el/BWU4fixCo0+/Leys6OQjnzW+dVQBfCWRbrSX2+xeuGUKUr+Ff7eBBbZpEd+u6U
	 WTP77gu2hgetW8Q5O74u6sWzibaioHnkH/sG4YoN8Kh1O92W4IIjpqu7mSDXjWWNN4
	 tzFAy1xREuZluiZqAj3sj/hqvEZ8MuAX3KyrL/muHFb58Ty0yF3Xj7f38N/KMueHMR
	 Fq7J4uAQ1OrBlU/bt0i0KeSb6qgvbFxYeIp4JP+XiPJVgNhHBqOdg1/WcG+GTqv/AZ
	 ziqBiYwkO7Nw0lBygUTOwCjDDXPMGrBXF31qybOdNUB+A0+wcpuRYlmUYjhiX9+FnH
	 +WQnazzDixvYA==
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
Subject: [PATCH 02/13] rust: init: simplify from `map_err` to `inspect_err`
Date: Mon,  1 Jul 2024 20:36:12 +0200
Message-ID: <20240701183625.665574-3-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
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
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/init.rs | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/rust/kernel/init.rs b/rust/kernel/init.rs
index 68605b633e73..07bacf134c19 100644
--- a/rust/kernel/init.rs
+++ b/rust/kernel/init.rs
@@ -843,11 +843,9 @@ unsafe fn __pinned_init(self, slot: *mut T) -> Result<(), E> {
         let val = unsafe { &mut *slot };
         // SAFETY: `slot` is considered pinned.
         let val = unsafe { Pin::new_unchecked(val) };
-        (self.1)(val).map_err(|e| {
+        (self.1)(val).inspect_err(|_|
             // SAFETY: `slot` was initialized above.
-            unsafe { core::ptr::drop_in_place(slot) };
-            e
-        })
+            unsafe { core::ptr::drop_in_place(slot) })
     }
 }
 
@@ -941,11 +939,9 @@ unsafe fn __init(self, slot: *mut T) -> Result<(), E> {
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

