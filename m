Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619E01DF73E;
	Wed, 19 Mar 2025 14:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395277; cv=none; b=mDT2OnVu5dwlG3XQA9PJLtppE7iUw7S3hNGy8lrW81QZbu/+dE8goVrblIa/6FVQxJ1eDsc0PBiB9U3r/g7POkXkdaIm1p0UKDHWbJIcLI7cG4ukolIacssi3ZhsZ5qq/vdY03eZ/FFUpPRcLo1E2VgUmnBryQHcPF4ddeehJcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395277; c=relaxed/simple;
	bh=ZeUdUmOff5Vcb+Hz7zaHlnaigTrijcuPc4Ml2OBQ4fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRlmAzo3zttWouN8bptTVyS6JfG/iGxouFb+IFF9pMTJpIwO/UeshWJohkLrGn8tnL2HUyhUCQPYfAGLxzq+W0kzI+VzWaXg6/AkFJlSWGAqQOvVybybFFx6Wmbf6MzgeM8/uCinn2G36Bd+s6sOdiIkWAm53VwhTIOl6mS18r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mI0mPTps; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI0mPTps"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EF4C4CEE4;
	Wed, 19 Mar 2025 14:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395277;
	bh=ZeUdUmOff5Vcb+Hz7zaHlnaigTrijcuPc4Ml2OBQ4fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mI0mPTpshhVGbKN+tIugMRNY7ReYwOO9WoHbeye5qh3UZDU9QyXGkA5BC/XDP/XMQ
	 rbqYmQ1PGNTxNV42cClOynppvYwhNED42ZAiEKjZEeDO9MW9QIR87GonKkvmXA4HWT
	 AO40St/nII/x+tkV/VuRRJOf+V4ogMvp3hGLPCZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Benno Lossin <benno.lossin@proton.me>
Subject: [PATCH 6.6 163/166] rust: lockdep: Remove support for dynamically allocated LockClassKeys
Date: Wed, 19 Mar 2025 07:32:14 -0700
Message-ID: <20250319143024.442659502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync.rs |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/rust/kernel/sync.rs
+++ b/rust/kernel/sync.rs
@@ -26,11 +26,6 @@ pub struct LockClassKey(Opaque<bindings:
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
@@ -41,7 +36,10 @@ impl LockClassKey {
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


