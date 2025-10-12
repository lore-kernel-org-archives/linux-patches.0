Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655C6BE49;
	Sun, 12 Oct 2025 21:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760304762; cv=none; b=Y8HpR12XuOVZ18D5xmtZgmX8IqyyIrJz8ZL6RG44Y6ZkD5S+lGsu0ZX5zNFfBZmvwDew51Uw+dw9Z35TKvkMHAAfV4vXvRDNTXPMMfTOj/jaNZIqnsfUh8vZLC1AJyp6GQ4gKK4Is/QVB5pjvVV9IJ4ri2PhhK2CIW44UVYMSVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760304762; c=relaxed/simple;
	bh=vZ/jGHMNdvuCwaAUoyyIPpQwHwlXk1nejjZpkhEcaAo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pA+0GwdZd3xDKC04KaXZBJUmqVTxRHC8Rv4fohRxsF8xPUCVH/P5mcowcSxrxDX+/jDyWZStXIVRi7oMAhmWoIPWaxlK0Uyz3RPkwwnOLIZF8ozznfjIVjDwYHP1jEMvjVHd8VhJ0jwbBWS4sMxGmZv4bN7xBUAK5hAMX4VIBlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CAwiNVTo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CAwiNVTo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F442C4CEE7;
	Sun, 12 Oct 2025 21:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760304762;
	bh=vZ/jGHMNdvuCwaAUoyyIPpQwHwlXk1nejjZpkhEcaAo=;
	h=From:To:Cc:Subject:Date:From;
	b=CAwiNVToAPclQUZgcNzwpVdbE2GIKreM++X3r7VPCZOG5FAF1lBa89svYrdNOm6JS
	 9qW279yhqY0EAIsovcok6HsnBnzJcFdDzWRdKd2YcenseMNeNSVlsynJ1KXtNSuIIz
	 68xtkgj9LLN/2g+/cPHQmmLLs0mX3Y+eh6sVqn5V2wmPLmM3unycBE90pJqXCC7GPQ
	 aiu7xqgAkQqlT2Ur+CYlftkkS5pDRUQ7eihiGJebUsTN2+KeVsMf6lRRdgCPvORWv2
	 WJOuFBugNzqJR/jJoPUnPjGwGRazyY/jg3Om3FaeRI+I6CxEi7dVIOK638dXJ9xPfk
	 RykaZD1fe2Y2g==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Martijn Coenen <maco@android.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Christian Brauner <christian@brauner.io>,
	Carlos Llamas <cmllamas@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust_binder: clean Clippy `mem-replace-with-default` warning
Date: Sun, 12 Oct 2025 23:32:30 +0200
Message-ID: <20251012213230.1139674-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.87.0, Clippy reports:

      CLIPPY     drivers/android/binder/rust_binder_main.o
    error: replacing a value of type `T` with `T::default()` is better expressed using `core::mem::take`
       --> drivers/android/binder/node.rs:690:32
        |
    690 |             _unused_capacity = mem::replace(&mut inner.freeze_list, KVVec::new());
        |                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: consider using: `core::mem::take(&mut inner.freeze_list)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#mem_replace_with_default
        = note: `-D clippy::mem-replace-with-default` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::mem_replace_with_default)]`

Thus clean it up as suggested.

Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 drivers/android/binder/node.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder/node.rs b/drivers/android/binder/node.rs
index ade895ef791e..08d362deaf61 100644
--- a/drivers/android/binder/node.rs
+++ b/drivers/android/binder/node.rs
@@ -687,7 +687,7 @@ pub(crate) fn remove_freeze_listener(&self, p: &Arc<Process>) {
             );
         }
         if inner.freeze_list.is_empty() {
-            _unused_capacity = mem::replace(&mut inner.freeze_list, KVVec::new());
+            _unused_capacity = mem::take(&mut inner.freeze_list);
         }
     }
 

base-commit: 8765f467912ff0d4832eeaf26ae573792da877e7
-- 
2.51.0

