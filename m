Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20238284B5B;
	Tue, 26 Aug 2025 11:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207967; cv=none; b=NEIHTWkhGtl6a6SdnIiaf3uX2lF0mINEuLJa48Mtc1FV7gLPuBU4a4w7TRoowzQBvo1QEMqoD5fTlHz3VZGMULAO6ihv71J1HJILGfWWuPw/jimaW8m4LbYqYXBuOtnt1uAWDBnwJWO42xiAyvy9C08yw+aHV1Q5ssn/KJcpyko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207967; c=relaxed/simple;
	bh=eMoDdcx8K1J4qftOqdXoEgIoXaS0veK7DX3Mqyu/7Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GHHI6g8ompLDSX9Ew84egnIgxp6aUalST6Uk4HXTLYID0pIIJy9FgsV1Ue062cFiq7pWspRuOdvNr0y6qtDtsD8u/pCvikqt7OC1Lvbc2X4ge2ASqo0rtjRrwGLcn9HbkqARaupQ3ALqPNo9emODh3V5rlJQB4MerT5bv3Ac8ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziAFDUSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziAFDUSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD39C4CEF1;
	Tue, 26 Aug 2025 11:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207967;
	bh=eMoDdcx8K1J4qftOqdXoEgIoXaS0veK7DX3Mqyu/7Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziAFDUSrPvPTXT3bAp6D+AiDlCWBRS9cTiecfhnWYHTuNHtF3DFj4DudskIj7btW3
	 pRBvrHKHPyV/GKxO+JJxTuK9A+rlcemhzlY7rmyvKzb/d4wubUhDpflRZ5fNtfJkB6
	 0d61UKFOujICaRx9I5NAg7hl2A3jFZjcvp3rLQVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 355/457] rust: drm: dont pass the address of drm::Device to drm_dev_put()
Date: Tue, 26 Aug 2025 13:10:39 +0200
Message-ID: <20250826110946.091541320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 360077278ba62e81310080f075a1a3028e778ef9 ]

In drm_dev_put() call in AlwaysRefCounted::dec_ref() we rely on struct
drm_device to be the first field in drm::Device, whereas everywhere
else we correctly obtain the address of the actual struct drm_device.

Analogous to the from_drm_device() helper, provide the
into_drm_device() helper in order to address this.

Fixes: 1e4b8896c0f3 ("rust: drm: add device abstraction")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250731154919.4132-5-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/drm/device.rs | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/drm/device.rs b/rust/kernel/drm/device.rs
index cb6bbd024a1e..3832779f439f 100644
--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -120,9 +120,13 @@ impl<T: drm::Driver> Device<T> {
         // - `raw_data` is a valid pointer to uninitialized memory.
         // - `raw_data` will not move until it is dropped.
         unsafe { data.__pinned_init(raw_data) }.inspect_err(|_| {
-            // SAFETY: `__drm_dev_alloc()` was successful, hence `raw_drm` must be valid and the
+            // SAFETY: `raw_drm` is a valid pointer to `Self`, given that `__drm_dev_alloc` was
+            // successful.
+            let drm_dev = unsafe { Self::into_drm_device(raw_drm) };
+
+            // SAFETY: `__drm_dev_alloc()` was successful, hence `drm_dev` must be valid and the
             // refcount must be non-zero.
-            unsafe { bindings::drm_dev_put(ptr::addr_of_mut!((*raw_drm.as_ptr()).dev).cast()) };
+            unsafe { bindings::drm_dev_put(drm_dev) };
         })?;
 
         // SAFETY: The reference count is one, and now we take ownership of that reference as a
@@ -145,6 +149,14 @@ impl<T: drm::Driver> Device<T> {
         unsafe { crate::container_of!(ptr, Self, dev) }.cast_mut()
     }
 
+    /// # Safety
+    ///
+    /// `ptr` must be a valid pointer to `Self`.
+    unsafe fn into_drm_device(ptr: NonNull<Self>) -> *mut bindings::drm_device {
+        // SAFETY: By the safety requirements of this function, `ptr` is a valid pointer to `Self`.
+        unsafe { &raw mut (*ptr.as_ptr()).dev }.cast()
+    }
+
     /// Not intended to be called externally, except via declare_drm_ioctls!()
     ///
     /// # Safety
@@ -194,8 +206,11 @@ unsafe impl<T: drm::Driver> AlwaysRefCounted for Device<T> {
     }
 
     unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: `obj` is a valid pointer to `Self`.
+        let drm_dev = unsafe { Self::into_drm_device(obj) };
+
         // SAFETY: The safety requirements guarantee that the refcount is non-zero.
-        unsafe { bindings::drm_dev_put(obj.cast().as_ptr()) };
+        unsafe { bindings::drm_dev_put(drm_dev) };
     }
 }
 
-- 
2.50.1



