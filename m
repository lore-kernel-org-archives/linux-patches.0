Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231391DD0D5;
	Wed, 19 Mar 2025 14:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394945; cv=none; b=X0KT6x6ZlV/7pPaFa567L5z2ABrTYWrJNDduoKSDArvrcX7Gn4MQwHNMjyji3yBqd89oB6opQAKs8xhfsug8Dc6WPgurOHaKJWCAe1Ka2zKZ4SRVyzzwgXEtV4DrDtWT/9p8l5Pqv8TwBDoAZOiXf/Q/SQfd+oDIjQZnT5bOoqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394945; c=relaxed/simple;
	bh=jkueUicdMhighYEplXf2wX4n83YxoKuMRe0+lkb3Lz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzK7fJGVpZ5QyiM9jKVZrl0xp02jHbhRahCXpSe4KY2HLogr6e6ZnHiTEmnteBgphhioFhEw0W1J7PhTYhxTmPVUZoVFogcVRo+UqHYC0y6+4jhxBLMnJSNV2pqsyMv9IZt+W5JR90uVcKNKXnMCv9gxEUejrr4MViWm+HQr8Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdJks60S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdJks60S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A580C4CEE4;
	Wed, 19 Mar 2025 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394944;
	bh=jkueUicdMhighYEplXf2wX4n83YxoKuMRe0+lkb3Lz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdJks60S2ygXT/NPfeHVhLEQASNf7M5pAHAxrSpusZXWfmq14xRfSGl/rLkKb6H9X
	 M0y5UEt9B0oLVb+9q+TaGctTqkqWKIVW9i40ztGkq9EHSD2Nall8ItibO0TfN1C135
	 v8X8lZcoRhRSZMaJMbho5fCtpwt8Bsu2DjNpdvxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Benno Lossin <benno.lossin@proton.me>
Subject: [PATCH 6.13 167/241] rust: lockdep: Remove support for dynamically allocated LockClassKeys
Date: Wed, 19 Mar 2025 07:30:37 -0700
Message-ID: <20250319143031.857673209@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mitchell Levy <levymitchell0@gmail.com>

commit 966944f3711665db13e214fef6d02982c49bb972 upstream.

Currently, dynamically allocated LockCLassKeys can be used from the Rust
side without having them registered. This is a soundness issue, so
remove them.

Fixes: 6ea5aa08857a ("rust: sync: introduce `LockClassKey`")
Suggested-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Mitchell Levy <levymitchell0@gmail.com>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250307232717.1759087-11-boqun.feng@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync.rs |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

--- a/rust/kernel/sync.rs
+++ b/rust/kernel/sync.rs
@@ -29,28 +29,20 @@ pub struct LockClassKey(Opaque<bindings:
 unsafe impl Sync for LockClassKey {}
 
 impl LockClassKey {
-    /// Creates a new lock class key.
-    pub const fn new() -> Self {
-        Self(Opaque::uninit())
-    }
-
     pub(crate) fn as_ptr(&self) -> *mut bindings::lock_class_key {
         self.0.get()
     }
 }
 
-impl Default for LockClassKey {
-    fn default() -> Self {
-        Self::new()
-    }
-}
-
 /// Defines a new static lock class and returns a pointer to it.
 #[doc(hidden)]
 #[macro_export]
 macro_rules! static_lock_class {
     () => {{
-        static CLASS: $crate::sync::LockClassKey = $crate::sync::LockClassKey::new();
+        static CLASS: $crate::sync::LockClassKey =
+            // SAFETY: lockdep expects uninitialized memory when it's handed a statically allocated
+            // lock_class_key
+            unsafe { ::core::mem::MaybeUninit::uninit().assume_init() };
         &CLASS
     }};
 }


