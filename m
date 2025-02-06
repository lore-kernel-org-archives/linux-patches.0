Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F462417E2;
	Thu,  6 Feb 2025 23:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738884041; cv=none; b=O+ayjn3DV8anUexpSWFWP2vfiAzUaTyrET/1mVnTmF/kdGVjTALfSfHHg+/8vttkCPlpP9QpnPM+oNV5rDtSaaxPN5lUDrccx9e2DmL8BTVfPizxwIpUtoSmp43b9YbcRDWvmNuMO+L9xN+NZUNFj62MLd8kcmL88qQ6pOBBqQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738884041; c=relaxed/simple;
	bh=hVCqKIDkPNn9wFCajGktnwPggu83Hd0xI4FypnD5poU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HAtZ9h9k+Z1/bGpOI92/T9S2tP5OfRHqCv+28+gCcm1RzrFutLav1s9AJ0LFE8d2zRK2fwydYrYbqxfq+kpQje63zblNCY5qIbY9qOcNYeUs/CR1n7RghXCeoxRvKnxA82VVlV38m3D0DswnCAIFyeM3GXbOrFZBqG1WDjiSGiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uuYZuu0B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uuYZuu0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDDCC4CEDF;
	Thu,  6 Feb 2025 23:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738884039;
	bh=hVCqKIDkPNn9wFCajGktnwPggu83Hd0xI4FypnD5poU=;
	h=From:To:Cc:Subject:Date:From;
	b=uuYZuu0Bjb+THpnDG4ki+arsS5mqxWemPkD4j5kYtNoExQUYkqwbL7bTTCrE9wcUa
	 fniOZYvdGyl8uh3OSHFzDkt/UVJYFPe0WxModo68/+6eBhYIOyVB3xeKRNEmQg5dK8
	 qhfe+wEarulaIayG3A4KV0yMNHQHJxy2U2PodOmoNJkouS0Qxgja8+VdGENcaYz4sQ
	 cewRRmQ3f+bfSBlCVC8l5oZkfPMtCb+28BQNXnr9QRV1NxO1k9rbK6azjFCkEjBk+k
	 tb1wBGn57d+N/l+SyC2mN4OSiMb7MmV558uMsmF1FYV+57tHZTNSERVNWHUuXlIBdz
	 M5SdeRa8+FpoA==
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
	Yutaro Ohno <yutaro.ono.418@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] rust: rbtree: fix overindented list item
Date: Fri,  7 Feb 2025 00:20:22 +0100
Message-ID: <20250206232022.599998-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.86.0 (to be released 2025-04-03), Clippy will have
a new lint, `doc_overindented_list_items` [1], which catches cases of
overindented list items.

The lint has been added by Yutaro Ohno, based on feedback from the kernel
[2] on a patch that fixed a similar case -- commit 0c5928deada1 ("rust:
block: fix formatting in GenDisk doc").

Clippy reports a single case in the kernel, apart from the one already
fixed in the commit above:

    error: doc list item overindented
        --> rust/kernel/rbtree.rs:1152:5
         |
    1152 | ///     null, it is a pointer to the root of the [`RBTree`].
         |     ^^^^ help: try using `  ` (2 spaces)
         |
         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_overindented_list_items
         = note: `-D clippy::doc-overindented-list-items` implied by `-D warnings`
         = help: to override `-D warnings` add `#[allow(clippy::doc_overindented_list_items)]`

Thus clean it up.

Cc: Yutaro Ohno <yutaro.ono.418@gmail.com>
Cc: <stable@vger.kernel.org> # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Fixes: a335e9591404 ("rust: rbtree: add `RBTree::entry`")
Link: https://github.com/rust-lang/rust-clippy/pull/13711 [1]
Link: https://github.com/rust-lang/rust-clippy/issues/13601 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/rbtree.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/rbtree.rs b/rust/kernel/rbtree.rs
index ee2731dad72d..0d1e75810664 100644
--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -1149,7 +1149,7 @@ pub struct VacantEntry<'a, K, V> {
 /// # Invariants
 /// - `parent` may be null if the new node becomes the root.
 /// - `child_field_of_parent` is a valid pointer to the left-child or right-child of `parent`. If `parent` is
-///     null, it is a pointer to the root of the [`RBTree`].
+///   null, it is a pointer to the root of the [`RBTree`].
 struct RawVacantEntry<'a, K, V> {
     rbtree: *mut RBTree<K, V>,
     /// The node that will become the parent of the new node if we insert one.
-- 
2.48.1

