Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C6D14A617;
	Wed,  4 Sep 2024 20:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482700; cv=none; b=opywEbYQ/iNAzPaANV5DQxd2af1JqS/o0ykekWRrDvKscY1qJKDCtnupBkp+4AHd7uygWbvML2s+s5gc6gZ7WBv+bvwJCr8drp4TK3BdC90dDsfl+pumwrt5G+MuF1+7LrOG2pD1WO7dix3+ejkLgw+yxIOOerIwT2yl9uYBXUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482700; c=relaxed/simple;
	bh=ScGZgrKvu1t/7yMx+LbTEU/fmoPyoLxUOZaQ8KvNmP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V4W5k1i/bHtgrg5yaAu2A8FydTKdWV/9oyaqfD+mKpGIXbhLvx+x2qpJx5W8sqVvNpz9xHEcxjbjigB01a4oxC2MFqVL47eV8rQ3l2yB6/IQ0LXl7Y44dCsQc0Q1uBe8ZNUB/d3tO+uLuWFyijGRV7UjObrH+22Lr8ifOyFGCRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NKagXVE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKagXVE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ACDBC4CEC8;
	Wed,  4 Sep 2024 20:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482700;
	bh=ScGZgrKvu1t/7yMx+LbTEU/fmoPyoLxUOZaQ8KvNmP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKagXVE6AImx1gmkJDP7U3fT9eXUG4lfdbOL/Fc5J5gDilVVgAYpOO+J2M26/txJh
	 wW0g5brE25mbzl5gzzFasZI7corU93P99oeWHto1ARmgC5UCYXmC6I72oRVnDeXpGp
	 zBd7eSp4xxPf3j0UzukVXSh/pZ7eNEUsLdWICyw9VaPRgpm6qGoDeOHtcv0ONg5XLf
	 F0L+XhtgfAQb8ta/gTKY5jEy8eZe9qYGB11ZT2StUF91LwyiajGNiBOfsPIRpotc0w
	 yH2h4fAsVNH5dpu+dOr1hhmAd3mzSYKVuqAtlt2xCwA8O0yamEwR+Wvn2i/KFBf5Yd
	 Wn79Cn46Q8YTw==
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
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 05/19] rust: enable `clippy::unnecessary_safety_comment` lint
Date: Wed,  4 Sep 2024 22:43:33 +0200
Message-ID: <20240904204347.168520-6-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Rust 1.67.0, Clippy added the `unnecessary_safety_comment` lint [1],
which is the "inverse" of `undocumented_unsafe_blocks`: it finds places
where safe code has a `// SAFETY` comment attached.

The lint currently finds 3 places where we had such mistakes, thus it
seems already quite useful.

Thus clean those and enable it.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecessary_safety_comment [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile                 | 1 +
 rust/kernel/sync/arc.rs  | 2 +-
 rust/kernel/workqueue.rs | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index c7a4f313728d..85f37ac9fef8 100644
--- a/Makefile
+++ b/Makefile
@@ -457,6 +457,7 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::needless_continue \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
+			    -Wclippy::unnecessary_safety_comment \
 			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 3021f30fd822..84c7cbfb096d 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -341,7 +341,7 @@ fn into_foreign(self) -> *const core::ffi::c_void {
     }
 
     unsafe fn borrow<'a>(ptr: *const core::ffi::c_void) -> ArcBorrow<'a, T> {
-        // SAFETY: By the safety requirement of this function, we know that `ptr` came from
+        // By the safety requirement of this function, we know that `ptr` came from
         // a previous call to `Arc::into_foreign`.
         let inner = NonNull::new(ptr as *mut ArcInner<T>).unwrap();
 
diff --git a/rust/kernel/workqueue.rs b/rust/kernel/workqueue.rs
index 3b3f1dbe8192..10d2bc62e2cf 100644
--- a/rust/kernel/workqueue.rs
+++ b/rust/kernel/workqueue.rs
@@ -526,7 +526,7 @@ unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Arc<T>
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };
@@ -573,7 +573,7 @@ unsafe impl<T, const ID: u64> WorkItemPointer<ID> for Pin<Box<T>>
     T: HasWork<T, ID>,
 {
     unsafe extern "C" fn run(ptr: *mut bindings::work_struct) {
-        // SAFETY: The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
+        // The `__enqueue` method always uses a `work_struct` stored in a `Work<T, ID>`.
         let ptr = ptr as *mut Work<T, ID>;
         // SAFETY: This computes the pointer that `__enqueue` got from `Arc::into_raw`.
         let ptr = unsafe { T::work_container_of(ptr) };
-- 
2.46.0

