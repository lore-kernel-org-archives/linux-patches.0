Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23E85C96;
	Wed,  4 Sep 2024 14:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725461003; cv=none; b=Nvgl3aSAfz4YnqgBo7sHuI4xScw1ZW12463qUon14u9PGf3NO6IqYt7WMQfOZA0hSs7z5fgrlIBDgKub17JQIi6Z52hxVLFt2tmM6lIRSJOMJFylnplTRd4J2sCc38nNb5/OrFCuMhi6G+HCS/pSk+yfjsmu3j3LJeOyUYNo9Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725461003; c=relaxed/simple;
	bh=ysrIaa54LXGyRQ0SCJqaqPXG/wL/56b1svoQ9zTZvwI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Tf6c76OyKWpCEJO25W67Y3Xrl7A7OZtmFSYjAP/ViGy02+l2zb0uElulBoMXFHfHH6qawj2DlL9cc20U8ybzq9+UBDIY8IYHl3ns+TvOtBY/7/TxwROeG4auutzrbgHaXrmqKCmmkMuwSRjObqh+tinHplpODt9Muf6ild2t62I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=og6Bu/9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="og6Bu/9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5841C4CEC2;
	Wed,  4 Sep 2024 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725461002;
	bh=ysrIaa54LXGyRQ0SCJqaqPXG/wL/56b1svoQ9zTZvwI=;
	h=From:To:Cc:Subject:Date:From;
	b=og6Bu/9QOcl2W3bniJfApqUSTx6DFe/oZoANDXrHF9Xd2/5tdinWY0pa2C/GWx4cj
	 xBbaTHrDpDcvV3uKakxsSbcR8g9VN3JIKNSU92Uwnr/7depEttC94p7Ig8Lm3WAG8q
	 6RmqVZXY1qKuziPnTB1qa5w+6OPMlGTzvO9sF1hkTmaVr7KYRo097faW7TPq9a5Rxb
	 1Qmawq+a6s0n3+C6oDt8Ey/L1hEr9KOE3sWfOgusTfGONnLTAgxRVs3WkZSYTvN8y5
	 jLMrT6gPPehqUF7gzzt9aAVFdujAZGT+CWU3Ah9VC26Ht9DOg8nmkgGdm/uqGCbAI0
	 4cq9Vsm3fD7VA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Matt Gilbride <mattgilbride@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: avoid `box_uninit_write` feature
Date: Wed,  4 Sep 2024 16:42:29 +0200
Message-ID: <20240904144229.18592-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like commit 0903b9e2a46c ("rust: alloc: eschew
`Box<MaybeUninit<T>>::write`"), but for the new `rbtree` and `alloc` code.

That is, `feature(new_uninit)` [1] got partially stabilized [2]
for Rust 1.82.0 (expected to be released on 2024-10-17), but it
did not include `Box<MaybeUninit<T>>::write`, which got split into
`feature(box_uninit_write)` [3].

To avoid relying on a new unstable feature, rewrite the `write` +
`assume_init` pair manually.

Link: https://github.com/rust-lang/rust/issues/63291 [1]
Link: https://github.com/rust-lang/rust/pull/129401 [2]
Link: https://github.com/rust-lang/rust/issues/129397 [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/box_ext.rs |  6 ++++--
 rust/kernel/rbtree.rs        | 17 ++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/rust/kernel/alloc/box_ext.rs b/rust/kernel/alloc/box_ext.rs
index b68ade26a42d..5b1550d620fd 100644
--- a/rust/kernel/alloc/box_ext.rs
+++ b/rust/kernel/alloc/box_ext.rs
@@ -26,9 +26,11 @@ pub trait BoxExt<T>: Sized {
     /// use kernel::alloc::{flags, box_ext::BoxExt};
     /// let value = Box::new([0; 32], flags::GFP_KERNEL)?;
     /// assert_eq!(*value, [0; 32]);
-    /// let value = Box::drop_contents(value);
+    /// let mut value = Box::drop_contents(value);
     /// // Now we can re-use `value`:
-    /// let value = Box::write(value, [1; 32]);
+    /// value.write([1; 32]);
+    /// // SAFETY: We just wrote to it.
+    /// let value = unsafe { value.assume_init() };
     /// assert_eq!(*value, [1; 32]);
     /// # Ok::<(), Error>(())
     /// ```
diff --git a/rust/kernel/rbtree.rs b/rust/kernel/rbtree.rs
index 48ceb9560bf5..25eb36fd1cdc 100644
--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -1059,15 +1059,14 @@ impl<K, V> RBTreeNodeReservation<K, V> {
     /// Initialises a node reservation.
     ///
     /// It then becomes an [`RBTreeNode`] that can be inserted into a tree.
-    pub fn into_node(self, key: K, value: V) -> RBTreeNode<K, V> {
-        let node = Box::write(
-            self.node,
-            Node {
-                key,
-                value,
-                links: bindings::rb_node::default(),
-            },
-        );
+    pub fn into_node(mut self, key: K, value: V) -> RBTreeNode<K, V> {
+        self.node.write(Node {
+            key,
+            value,
+            links: bindings::rb_node::default(),
+        });
+        // SAFETY: We just wrote to it.
+        let node = unsafe { self.node.assume_init() };
         RBTreeNode { node }
     }
 }

base-commit: 68d3b6aa08708bb3907c2c13eaf4b3ccf4805160
-- 
2.46.0

