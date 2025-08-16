Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349D71DE4CA;
	Sat, 16 Aug 2025 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755376946; cv=none; b=JkzOljZ6b3AoemD8KMMqrQBnbxlOxOMIpKT3N+d9E/0BQwcE9K9B7oxaP88jTHJP+ZE6JvwzbXBH7j5YYyE3MhJubkYvJ0rgL0Ka2nUPUlCBmCXThb8Rl826bkYAHVMoRMfg42DyteY42fpBpETnkDhf5aifzW7x/v0FAgmZA8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755376946; c=relaxed/simple;
	bh=C0cmruSQBBjqCamTnSvZt6Z6H4u/o6gYc+QMxN0dUNk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PZ7g3VEP5XmjWzcj76f6UYJHELUDp0Fy35PQ5AMULtxD2xPT1FzgxcVbNJOVufZ14Nj+eYNGay5jWgVmKeoi3gdakNm7g6mp1+yjxzvnNPjsFfrn+tLdUza0I69H8f3TzkVAf/Mgjib1LEawq99RUsFGI2C3I+nbTNg9xi6C14o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lko3moo/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lko3moo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77BEAC4CEEF;
	Sat, 16 Aug 2025 20:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755376945;
	bh=C0cmruSQBBjqCamTnSvZt6Z6H4u/o6gYc+QMxN0dUNk=;
	h=From:To:Cc:Subject:Date:From;
	b=lko3moo/xtF64BMLgObhQ9pTtT8+94yyOMpKyfWY/CL9Jj7TX0kg4KyDDn7XbC8F+
	 038Gw0mj1fT9nd7+uF0+33H8tSqMoa97lD25ath488K9gccVxYeMIlDm5mCyqOKJG8
	 4jN6BOkymI/pTpcThhA2akT3UmgD5ikkv/6+3eSAmhiuDYsvWFzw/D0qzJxw5K81MG
	 qbWjr7tNJJATQ030RnAan4C6z20cM0J5P3dS1tozu53jQxHEt8XQAcizLqcPRMPIof
	 XodD3BktX4yJgtM5OvW8xXw5UWOXruFEVLUyHLtv3NMo8hAiTNcPOj+xcrCuArrMQH
	 NmJkkb66fmniQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	rust-for-linux@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: alloc: fix `rusttest` by providing `Cmalloc::aligned_layout` too
Date: Sat, 16 Aug 2025 22:42:15 +0200
Message-ID: <20250816204215.2719559-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit fde578c86281 ("rust: alloc: replace aligned_size() with
Kmalloc::aligned_layout()") provides a public `aligned_layout` function
in `Kamlloc`, but not in `Cmalloc`, and thus uses of it will trigger an
error in `rusttest`.

Such a user appeared in the following commit 22ab0641b939 ("rust: drm:
ensure kmalloc() compatible Layout"):

    error[E0599]: no function or associated item named `aligned_layout` found for struct `alloc::allocator_test::Cmalloc` in the current scope
       --> rust/kernel/drm/device.rs:100:31
        |
    100 |         let layout = Kmalloc::aligned_layout(Layout::new::<Self>());
        |                               ^^^^^^^^^^^^^^ function or associated item not found in `Cmalloc`
        |
       ::: rust/kernel/alloc/allocator_test.rs:19:1
        |
    19  | pub struct Cmalloc;
        | ------------------ function or associated item `aligned_layout` not found for this struct

Thus add an equivalent one for `Cmalloc`.

Fixes: fde578c86281 ("rust: alloc: replace aligned_size() with Kmalloc::aligned_layout()")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
Danilo, as usual, please feel free to rebase if that is better.

Here I just copied the function, including comments, as-is, which maybe we want
to tweak. However, we may want to remove `allocator_test` soon anyway (this adds
to the justification for doing that, so that is good news :).

I am sending that one in parallel -- hopefully we can land that removal too in
this cycle, but meanwhile, we can put something like this in your branch.

 rust/kernel/alloc/allocator_test.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index a3074480bd8d..90dd987d40e4 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -22,6 +22,17 @@
 pub type Vmalloc = Kmalloc;
 pub type KVmalloc = Kmalloc;

+impl Cmalloc {
+    /// Returns a [`Layout`] that makes [`Kmalloc`] fulfill the requested size and alignment of
+    /// `layout`.
+    pub fn aligned_layout(layout: Layout) -> Layout {
+        // Note that `layout.size()` (after padding) is guaranteed to be a multiple of
+        // `layout.align()` which together with the slab guarantees means that `Kmalloc` will return
+        // a properly aligned object (see comments in `kmalloc()` for more information).
+        layout.pad_to_align()
+    }
+}
+
 extern "C" {
     #[link_name = "aligned_alloc"]
     fn libc_aligned_alloc(align: usize, size: usize) -> *mut crate::ffi::c_void;
--
2.50.1
