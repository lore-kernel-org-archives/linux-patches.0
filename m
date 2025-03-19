Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6551E5B8D;
	Wed, 19 Mar 2025 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395108; cv=none; b=SG2vAstlbaYpD290bDVgiRyZxNbZDReqVH6nnIFVqKMm/w6utVXF8xgV5AkH2iQT/Bsa9z9hA6oblTz7O0Qj4y5ZGRgeAMCV/6/sotDieQPqQmn1qHcCKXb/O65ofJ9lp2uQOIW8sleHspWg2s2Erck8Uv9hvT9h5WHFEbQ4zeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395108; c=relaxed/simple;
	bh=MzO105wdm3+feqLmFjX1vRJUwKcHBK4/PDf3sTBhaZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUqABfKNvR8bbkZ8BLQ7WOYapBQXdor6e1wXjSqrZ3jeVdhs2/3GX8F1PTpzHzA+cFM68xPV50L40ciba0729QBN5CzUUDz+vEUo8gkW8eOLLsFFXSkEcqQAmMMGl5DIlMVgJ/I1kXzqls/1cdAUM2O/7Sj4Dc4mUreDjbrNiPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgd86IFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgd86IFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D9BC4CEE4;
	Wed, 19 Mar 2025 14:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395108;
	bh=MzO105wdm3+feqLmFjX1vRJUwKcHBK4/PDf3sTBhaZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgd86IFCHz/I/rvMj/r2LSR7NLwsCY9VHXU7NeNmtpTHYNg93mkKiAFzHVoIMDWRT
	 65oK8sugG0pFB4/hiMwA4IhgOUhWnDg9JoQ1RRm9cpkSxBZUdeh2bG0NH41yZRmi3/
	 LulTQXv/rD8ToijoSTcsDvNc8wPPhlcKr/b4R5/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Benno Lossin <benno.lossin@proton.me>
Subject: [PATCH 6.12 162/231] rust: lockdep: Remove support for dynamically allocated LockClassKeys
Date: Wed, 19 Mar 2025 07:30:55 -0700
Message-ID: <20250319143030.842866991@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -27,28 +27,20 @@ pub struct LockClassKey(Opaque<bindings:
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


