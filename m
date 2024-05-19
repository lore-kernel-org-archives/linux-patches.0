Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0164D26AEC;
	Sun, 19 May 2024 21:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716152870; cv=none; b=OA91khVxx2iPgud07Yr7lEzh50zKWrGYbx08qWHihroYBHw3Nnsrw3o3aCzjfj60a/5yq+6reqBQ7bk/P3LIdkBUhcZa/ybBvbHc8sANsQsUdbtjooonShl/R2DXvoKNFzo/bA4OWiCeNEkMnSbcOGRq148lZwGM4ETCkdDh4MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716152870; c=relaxed/simple;
	bh=H6awbG9maNnvIwZjWXp+MfoENhflzFD1z6syx90vt8w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q7l2UdMu39nWvu9yikfDPoPHQn6VVZGeKxFET11MJLwbO7xb7a0OAwnYaTEPk4rcFotLAaiU4qk7C1FDWQXUOwdByhN8Jui+2AWbWe0nK4r7M2HyOBzcHQUUL57y4nBckyBV693WLmpEhbQu6zl/GLuqkDceTG6OdAUJrS/evCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qaOy4dM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qaOy4dM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6337EC32781;
	Sun, 19 May 2024 21:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716152869;
	bh=H6awbG9maNnvIwZjWXp+MfoENhflzFD1z6syx90vt8w=;
	h=From:To:Cc:Subject:Date:From;
	b=qaOy4dM7+RG6NzPTly9gDrivijI3h0waUvmosPNvNuSdulFOz1xGW0pqAraNLq4Hh
	 my7NuhTeOUrobIr8/Qq2elov23GnsoRTnSE9gDsR0FJ7KdwDD1Nm5m9A2SOLJ0WPEi
	 6W/0clmDW3ClOolRUmQ8kypF7MUWH2vjUj0Ch/xHz1CpUMaYvAEz2BF1Isw1otp2CF
	 HjF0dpgYySEzVVHaurEOOs88nYPkh3NeGE0zFuOMyd3neD5NyQjz39o7CCn9MtOGiW
	 AYTCznAIxHHyJsitG7gv0BoOJpPlE4lgr4QJiXvCnv3wGckErPfuM0iXADtyC1mB0o
	 RIYq4zzdeBd/A==
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
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@redhat.com>
Subject: [PATCH] rust: avoid unused import warning in `rusttest`
Date: Sun, 19 May 2024 23:07:35 +0200
Message-ID: <20240519210735.587323-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When compiling for the `rusttest` target, the `core::ptr` import is
unused since its only use happens in the `reserve()` method which is
not compiled in that target:

    warning: unused import: `core::ptr`
    --> rust/kernel/alloc/vec_ext.rs:7:5
      |
    7 | use core::ptr;
      |     ^^^^^^^^^
      |
      = note: `#[warn(unused_imports)]` on by default

Thus clean it.

Fixes: 97ab3e8eec0c ("rust: alloc: fix dangling pointer in VecExt<T>::reserve()")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/vec_ext.rs | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/alloc/vec_ext.rs b/rust/kernel/alloc/vec_ext.rs
index e9a81052728a..1297a4be32e8 100644
--- a/rust/kernel/alloc/vec_ext.rs
+++ b/rust/kernel/alloc/vec_ext.rs
@@ -4,7 +4,6 @@
 
 use super::{AllocError, Flags};
 use alloc::vec::Vec;
-use core::ptr;
 
 /// Extensions to [`Vec`].
 pub trait VecExt<T>: Sized {
@@ -141,7 +140,11 @@ fn reserve(&mut self, additional: usize, flags: Flags) -> Result<(), AllocError>
         // `krealloc_aligned`. A `Vec<T>`'s `ptr` value is not guaranteed to be NULL and might be
         // dangling after being created with `Vec::new`. Instead, we can rely on `Vec<T>`'s capacity
         // to be zero if no memory has been allocated yet.
-        let ptr = if cap == 0 { ptr::null_mut() } else { old_ptr };
+        let ptr = if cap == 0 {
+            core::ptr::null_mut()
+        } else {
+            old_ptr
+        };
 
         // SAFETY: `ptr` is valid because it's either NULL or comes from a previous call to
         // `krealloc_aligned`. We also verified that the type is not a ZST.

base-commit: 97ab3e8eec0ce79d9e265e6c9e4c480492180409
-- 
2.45.1

