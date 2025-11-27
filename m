Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A39130F7ED;
	Thu, 27 Nov 2025 21:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764279231; cv=none; b=G1KmEFf4MX8ozs84QBVK9Rb0p94kBHXLPAmRKaT0ONf9PgBf0djo8ZqhyVAIJB+5APbzFLu0PR3tIN/prjAF3Duj1Tw2BzYgHFJ33TyqdGQ0gSPJZq8sy73LAq2Jwri6uXLAZ9o1vKUFpGbGYBOF4pO0kjzcbh1nPUIT4lpmGaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764279231; c=relaxed/simple;
	bh=ziNNElqASz+QcTFfw2S5kiqwjMGYBn1OZi8SCEwPylA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r5hRcd7G8ArSPJvLbmmLvtsF/+zKYy/WcN5a+CGXZES2dj/HCGkdS8G6GHphGcd4YJV/xOwuWv7ha7th594FVNNXBl1C2I8B1ihxmuRr3IGq0I/gmTodxUvAmQLeOoGjpFz7T/2hy2gKD13udMtcrO+E9ptp1xHF6MtRrZJBbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TEbhok1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TEbhok1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57939C4CEF8;
	Thu, 27 Nov 2025 21:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764279229;
	bh=ziNNElqASz+QcTFfw2S5kiqwjMGYBn1OZi8SCEwPylA=;
	h=From:To:Cc:Subject:Date:From;
	b=TEbhok1nY8C0vK8gSovQ9vGyrWtBRMX7opp03IoxHWb9wxoo8cHGrVn5lTq9AFqwz
	 3RgMUs0kMZxdBEpXRio2wULm7Xa/iFc/mdkNB7RBj/+WeT40PujhLRmroG6nCsy0rb
	 tMcMBU+VV/iJKJvxlPZF1NNC+y6nabz4nnm4LV/0RuH+Q27F8OR0+v/0aokcGfadkw
	 zB2R7CQUfhUEi9E29/xkQtafvsQCQMM7Duee+YlXfN5kgPgW9hAFzhfA+mW7Tt2kal
	 WXahjj3PJISurcxdMzQTZ+7JdecoHlDsD1M1R8mr2ACcjT08NKrD1ovX5BIPNW0hM7
	 q7v6d2Wt/H0qA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>,
	Burak Emir <bqe@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Yury Norov <yury.norov@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: id_pool: fix broken intra-doc link
Date: Thu, 27 Nov 2025 22:33:40 +0100
Message-ID: <20251127213340.180090-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`rustdoc` detects a broken intra-doc link:

    error: unresolved link to `BitmapVec::NO_ALLOC_MAX_LEN`
       --> rust/kernel/id_pool.rs:100:31
        |
    100 |     /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
        |                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^ the struct `BitmapVec` has no field or associated item named `NO_ALLOC_MAX_LEN`
        |
        = note: `-D rustdoc::broken-intra-doc-links` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(rustdoc::broken_intra_doc_links)]`

Thus fix it.

It was a missed rename in v5 of the patch series adding this [1].

Fixes: feb3fdf1239a ("rust: id_pool: do not supply starting capacity")
Link: https://lore.kernel.org/all/20251112-binder-bitmap-v5-0-8b9d7c7eca82@google.com/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I saw this in next-20251127.

I think using [`BitmapVec::MAX_INLINE_LEN`] is clearer in general,
especially for things in other modules, but I kept the same style as
other links in the file.

 rust/kernel/id_pool.rs | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/id_pool.rs b/rust/kernel/id_pool.rs
index a4c37d6a0971..73a952d7dd83 100644
--- a/rust/kernel/id_pool.rs
+++ b/rust/kernel/id_pool.rs
@@ -95,9 +95,9 @@ pub fn realloc(&self, flags: Flags) -> Result<PoolResizer, AllocError> {
 impl IdPool {
     /// Constructs a new [`IdPool`].
     ///
-    /// The pool will have a capacity of [`NO_ALLOC_MAX_LEN`].
+    /// The pool will have a capacity of [`MAX_INLINE_LEN`].
     ///
-    /// [`NO_ALLOC_MAX_LEN`]: BitmapVec::NO_ALLOC_MAX_LEN
+    /// [`MAX_INLINE_LEN`]: BitmapVec::MAX_INLINE_LEN
     #[inline]
     pub fn new() -> Self {
         Self {

base-commit: a322638c15a678168aeb8dc11c8760f8a053124d
--
2.52.0
