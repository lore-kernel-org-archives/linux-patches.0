Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC61013D29A;
	Sat, 12 Oct 2024 23:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728774796; cv=none; b=LXChQpFkTu8kiy9DBsgfJErhDkjMzk2tM8zvQneT3G7vacpHGQucaJXwgRurckqEGK89/6KFvrmbPCgInUkPiXF4Te7pWc4q+hpxC4qk/X1zCI1PmOJgsfCbFPx/w8a/O19lKhO3mfPHC74CZHO0cY6H4RaxnL9vyLXRJZndWDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728774796; c=relaxed/simple;
	bh=AzeLI7/qmt92QUnf/gSnV2p9Yej95L5XnCrB93d6HHw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Fv/gG2AcphLgeWbOrU9JcDCQWUG5xL2fVkJ0o8XYiyx7YMjgtUCw3JYv+hfA27KPzwT4cHnQpKvZRrXSz8eSS+qyOurQfKPYhFA+oRL+6oaDjieQygWhBfWS1TOSbO+dMC9qNk6NcndJ2gt54KCLvrDhGLAAwHl9ZBbhL9G6uQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ij6iD3Ae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ij6iD3Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE91C4CEC6;
	Sat, 12 Oct 2024 23:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728774796;
	bh=AzeLI7/qmt92QUnf/gSnV2p9Yej95L5XnCrB93d6HHw=;
	h=From:To:Cc:Subject:Date:From;
	b=Ij6iD3Ae2X0np//wdjkNu8Ffx1HFTa9RaD6+2ZjJEigh9yjk6l6hddthkpYAETzCQ
	 /WLKWOGF+7PTfmqIFUdE0mDhRGgjy3nSxqMhgTXx/k3U9z1sfI5qzhsIyptfACUXMt
	 hHSu2qxWmA01Wb4ascaBcPltGf6RV8kAb5idS4x8jCQXgjlrWm4MyITCR0uxg0Mzym
	 3yInJBE+0lrUfZkWhZBMhq1fEPCXFTigZw8ioQv5VF9Vy3JD58a/YU/s1lH9Bg5TNW
	 ZN0pc+AfKo6YQMcTUCrRKzi1CmNiVtM4bkrD+Ig5kaIzRTOjhnTbN9boVh38UTeLuT
	 Zn0psdwiSJSIQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH] rust: kernel: clean explicit lifetimes that can be elided
Date: Sun, 13 Oct 2024 01:13:00 +0200
Message-ID: <20241012231300.397010-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In nightly Clippy (i.e. Rust 1.83.0), the `needless_lifetimes` lint has
been extended [1] to suggest eliding `impl` lifetimes, e.g.

    error: the following explicit lifetimes could be elided: 'a
    --> rust/kernel/list.rs:647:6
        |
    647 | impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
        |      ^^                                                                  ^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_lifetimes
        = note: `-D clippy::needless-lifetimes` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::needless_lifetimes)]`
    help: elide the lifetimes
        |
    647 - impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
    647 + impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'_, T, ID> {}

Thus clean them.

Link: https://github.com/rust-lang/rust-clippy/pull/13286 [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Do we want this in general, or just in some cases? There is an issue about this
where we may want to leave some feedback:

    https://github.com/rust-lang/rust-clippy/issues/13514

 rust/kernel/list.rs   |  2 +-
 rust/kernel/rbtree.rs | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/rust/kernel/list.rs b/rust/kernel/list.rs
index 5b4aec29eb67..cbccd932fa43 100644
--- a/rust/kernel/list.rs
+++ b/rust/kernel/list.rs
@@ -644,7 +644,7 @@ pub fn remove(self) -> ListArc<T, ID> {
     }
 }

-impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
+impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'_, T, ID> {}

 impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> IntoIterator for &'a List<T, ID> {
     type IntoIter = Iter<'a, T, ID>;
diff --git a/rust/kernel/rbtree.rs b/rust/kernel/rbtree.rs
index 25eb36fd1cdc..232a5eefa6f9 100644
--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -729,13 +729,13 @@ pub struct Cursor<'a, K, V> {
 // SAFETY: The [`Cursor`] has exclusive access to both `K` and `V`, so it is sufficient to require them to be `Send`.
 // The cursor only gives out immutable references to the keys, but since it has excusive access to those same
 // keys, `Send` is sufficient. `Sync` would be okay, but it is more restrictive to the user.
-unsafe impl<'a, K: Send, V: Send> Send for Cursor<'a, K, V> {}
+unsafe impl<K: Send, V: Send> Send for Cursor<'_, K, V> {}

 // SAFETY: The [`Cursor`] gives out immutable references to K and mutable references to V,
 // so it has the same thread safety requirements as mutable references.
-unsafe impl<'a, K: Sync, V: Sync> Sync for Cursor<'a, K, V> {}
+unsafe impl<K: Sync, V: Sync> Sync for Cursor<'_, K, V> {}

-impl<'a, K, V> Cursor<'a, K, V> {
+impl<K, V> Cursor<'_, K, V> {
     /// The current node
     pub fn current(&self) -> (&K, &V) {
         // SAFETY:
@@ -948,11 +948,11 @@ pub struct Iter<'a, K, V> {

 // SAFETY: The [`Iter`] gives out immutable references to K and V, so it has the same
 // thread safety requirements as immutable references.
-unsafe impl<'a, K: Sync, V: Sync> Send for Iter<'a, K, V> {}
+unsafe impl<K: Sync, V: Sync> Send for Iter<'_, K, V> {}

 // SAFETY: The [`Iter`] gives out immutable references to K and V, so it has the same
 // thread safety requirements as immutable references.
-unsafe impl<'a, K: Sync, V: Sync> Sync for Iter<'a, K, V> {}
+unsafe impl<K: Sync, V: Sync> Sync for Iter<'_, K, V> {}

 impl<'a, K, V> Iterator for Iter<'a, K, V> {
     type Item = (&'a K, &'a V);
@@ -983,11 +983,11 @@ pub struct IterMut<'a, K, V> {
 // SAFETY: The [`IterMut`] has exclusive access to both `K` and `V`, so it is sufficient to require them to be `Send`.
 // The iterator only gives out immutable references to the keys, but since the iterator has excusive access to those same
 // keys, `Send` is sufficient. `Sync` would be okay, but it is more restrictive to the user.
-unsafe impl<'a, K: Send, V: Send> Send for IterMut<'a, K, V> {}
+unsafe impl<K: Send, V: Send> Send for IterMut<'_, K, V> {}

 // SAFETY: The [`IterMut`] gives out immutable references to K and mutable references to V, so it has the same
 // thread safety requirements as mutable references.
-unsafe impl<'a, K: Sync, V: Sync> Sync for IterMut<'a, K, V> {}
+unsafe impl<K: Sync, V: Sync> Sync for IterMut<'_, K, V> {}

 impl<'a, K, V> Iterator for IterMut<'a, K, V> {
     type Item = (&'a K, &'a mut V);

base-commit: 8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
--
2.47.0
