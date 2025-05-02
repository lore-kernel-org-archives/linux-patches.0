Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC914238D54;
	Fri,  2 May 2025 14:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746194591; cv=none; b=E104c5Qzu3nohXXWqrwvU5I2nz/MqhMWazqmQDLHuR5CbsfqxPCsPCiBk5U8iPvXO4M8XDfxo0nDLrVqJ5Rpx4wdJwFNiZWd99PACh1lx4IG1Z0LsFznbTHHxNWtSaxVDR5juscDJGq+7bkOirWuOVUa2YGpBD7VQjJW6/r/M1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746194591; c=relaxed/simple;
	bh=7qEfl7i6phNDc2ffZvUO+dFPf0BJE9OWp+T3HFvCE4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OX4+dHr27+Icm277cSiG7eyRwdkmPqeUMQfBkV097ZJuodLWZHBv8NmWUOzD2cE5h+m8TbDhpGKtFXSnhPF00bC2SDDciCdDg1+SxpPdSL4k7idklucCoRWaL9ChQPwxaAV+gZsMbPBybfjfX9Jd9prVug5N0WydUuUN55kmiSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BPWHu7rn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BPWHu7rn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB12BC4CEE4;
	Fri,  2 May 2025 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746194589;
	bh=7qEfl7i6phNDc2ffZvUO+dFPf0BJE9OWp+T3HFvCE4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BPWHu7rngB2GoE8ZwgH0igniUJskEjqy++nPBCLFmLu1bWaapv3hHzFq/0W4+N5LW
	 TvKqEYHNFhPMDI4VFGuGnXvBxWP+gRqJHg1yvX0TSlgJJKwfk/5OJd2naZ6UQYc9xU
	 bJ7QwVGQ8S+UNrRaiJeJ7GR2hTJNFZVd1DqRte2QUk5+TXVrm0BLVqzO3WYiDEGqu4
	 agzKkIez9NO62vNdea+OgIVH5x3mQySCmUE0h9ITyqm07ctvRFSF7whcZ+MaRlJN7/
	 SSq6i85brs1/ZpApBbwMx/3+AOzN8TBpoc7KUxqJAKEyqRi9gNFhT+cMgOOP96Aw75
	 N+rC8BT+TIFtw==
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
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Subject: [PATCH 2/5] rust: clean Rust 1.87.0's `clippy::ptr_eq` lints
Date: Fri,  2 May 2025 16:02:34 +0200
Message-ID: <20250502140237.1659624-3-ojeda@kernel.org>
In-Reply-To: <20250502140237.1659624-1-ojeda@kernel.org>
References: <20250502140237.1659624-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.87.0 (expected 2025-05-15) [1], Clippy may expand
the `ptr_eq` lint, e.g.:

    error: use `core::ptr::eq` when comparing raw pointers
       --> rust/kernel/list.rs:438:12
        |
    438 |         if self.first == item {
        |            ^^^^^^^^^^^^^^^^^^ help: try: `core::ptr::eq(self.first, item)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#ptr_eq
        = note: `-D clippy::ptr-eq` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::ptr_eq)]`

Thus clean the few cases we have.

This patch may not be actually needed by the time Rust 1.87.0 releases
since a PR to relax the lint has been beta nominated [2] due to reports
of being too eager (at least by default) [3].

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust-clippy/pull/14339 [1]
Link: https://github.com/rust-lang/rust-clippy/pull/14526 [2]
Link: https://github.com/rust-lang/rust-clippy/issues/14525 [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/kvec.rs |  2 +-
 rust/kernel/list.rs       | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index ae9d072741ce..cde911551327 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -743,7 +743,7 @@ fn into_raw_parts(self) -> (*mut T, NonNull<T>, usize, usize) {
     pub fn collect(self, flags: Flags) -> Vec<T, A> {
         let old_layout = self.layout;
         let (mut ptr, buf, len, mut cap) = self.into_raw_parts();
-        let has_advanced = ptr != buf.as_ptr();
+        let has_advanced = !core::ptr::eq(ptr, buf.as_ptr());
 
         if has_advanced {
             // Copy the contents we have advanced to at the beginning of the buffer.
diff --git a/rust/kernel/list.rs b/rust/kernel/list.rs
index a335c3b1ff5e..c63cbeee3316 100644
--- a/rust/kernel/list.rs
+++ b/rust/kernel/list.rs
@@ -435,7 +435,7 @@ unsafe fn remove_internal_inner(
         //  * If `item` was the only item in the list, then `prev == item`, and we just set
         //    `item->next` to null, so this correctly sets `first` to null now that the list is
         //    empty.
-        if self.first == item {
+        if core::ptr::eq(self.first, item) {
             // SAFETY: The `prev` pointer is the value that `item->prev` had when it was in this
             // list, so it must be valid. There is no race since `prev` is still in the list and we
             // still have exclusive access to the list.
@@ -556,7 +556,7 @@ fn next(&mut self) -> Option<ArcBorrow<'a, T>> {
         let next = unsafe { (*current).next };
         // INVARIANT: If `current` was the last element of the list, then this updates it to null.
         // Otherwise, we update it to the next element.
-        self.current = if next != self.stop {
+        self.current = if !core::ptr::eq(next, self.stop) {
             next
         } else {
             ptr::null_mut()
@@ -726,7 +726,7 @@ impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> Cursor<'a, T, ID> {
     fn prev_ptr(&self) -> *mut ListLinksFields {
         let mut next = self.next;
         let first = self.list.first;
-        if next == first {
+        if core::ptr::eq(next, first) {
             // We are before the first element.
             return core::ptr::null_mut();
         }
@@ -788,7 +788,7 @@ pub fn move_next(&mut self) -> bool {
         // access the `next` field.
         let mut next = unsafe { (*self.next).next };
 
-        if next == self.list.first {
+        if core::ptr::eq(next, self.list.first) {
             next = core::ptr::null_mut();
         }
 
@@ -802,7 +802,7 @@ pub fn move_next(&mut self) -> bool {
     /// If the cursor is before the first element, then this call does nothing. This call returns
     /// `true` if the cursor's position was changed.
     pub fn move_prev(&mut self) -> bool {
-        if self.next == self.list.first {
+        if core::ptr::eq(self.next, self.list.first) {
             return false;
         }
 
@@ -822,7 +822,7 @@ fn insert_inner(&mut self, item: ListArc<T, ID>) -> *mut ListLinksFields {
         // * `ptr` is an element in the list or null.
         // * if `ptr` is null, then `self.list.first` is null so the list is empty.
         let item = unsafe { self.list.insert_inner(item, ptr) };
-        if self.next == self.list.first {
+        if core::ptr::eq(self.next, self.list.first) {
             // INVARIANT: We just inserted `item`, so it's a member of list.
             self.list.first = item;
         }
-- 
2.49.0

