Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA55F284B5B;
	Tue, 26 Aug 2025 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207961; cv=none; b=nX67m7TisPhggpZlgHuHqHoQpSCljQbgG+DN60EFH4mgPphMNVn2PWgz/ARb/12vIsgc6i6+FDrspnjgzIcAH91PHTxMjHMVKf144kqbJyKdxAN8mnMyfgESYrC9pyYRo4ikdMhUg1oHfGlImf/0DWsO5IvKHpfjdiCKhtml7z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207961; c=relaxed/simple;
	bh=LrzRQgcJqYPSmJit+QqQvElPwNAP1vMOt78+P1hFE58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mn4qdM4Qen+ClBJVV+e65xojbqTdeD8rD/hQnB3yZF0+I/LwfaFScIE2e3qyXjHlS1Gec8UQFwEAJhQRFNcZJVXpQrsf74ArQWNF5FVyX7OSejd50k/pQeCmHOJx0VEa/ePJ9r9X9lP1C/lCfp7wOj12zO0OH0NyxC0boKqveGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDRoVqDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDRoVqDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471D1C4CEF1;
	Tue, 26 Aug 2025 11:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207961;
	bh=LrzRQgcJqYPSmJit+QqQvElPwNAP1vMOt78+P1hFE58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDRoVqDe+Jho+A3CBAlmReShINYExPkGZ6rc/o6WR9i98OcK6ykiwPDX01d1VvS9f
	 rc5IS92VMYY+60eU/tU2A5ZI5LMx+4Jiu4KGML7UbdquHpaOBnjg5n6kzYZKeaAnzD
	 i3Zv5nfWEWV5LcIRCZdmjt90owi+bGkv/U+3g3OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 353/457] rust: drm: ensure kmalloc() compatible Layout
Date: Tue, 26 Aug 2025 13:10:37 +0200
Message-ID: <20250826110946.044259742@linuxfoundation.org>
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

[ Upstream commit 22ab0641b939967f630d108e33a3582841ad6846 ]

drm::Device is allocated through __drm_dev_alloc() (which uses
kmalloc()) and the driver private data, <T as drm::Driver>::Data, is
initialized in-place.

Due to the order of fields in drm::Device

  pub struct Device<T: drm::Driver> {
     dev: Opaque<bindings::drm_device>,
     data: T::Data,
  }

even with an arbitrary large alignment requirement of T::Data it can't
happen that the size of Device is smaller than its alignment requirement.

However, let's not rely on this subtle circumstance and create a proper
kmalloc() compatible Layout.

Fixes: 1e4b8896c0f3 ("rust: drm: add device abstraction")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://lore.kernel.org/r/20250731154919.4132-3-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/drm/device.rs | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/drm/device.rs b/rust/kernel/drm/device.rs
index 14c1aa402951..6c1fc33cdc68 100644
--- a/rust/kernel/drm/device.rs
+++ b/rust/kernel/drm/device.rs
@@ -5,6 +5,7 @@
 //! C header: [`include/linux/drm/drm_device.h`](srctree/include/linux/drm/drm_device.h)
 
 use crate::{
+    alloc::allocator::Kmalloc,
     bindings, device, drm,
     drm::driver::AllocImpl,
     error::from_err_ptr,
@@ -12,7 +13,7 @@ use crate::{
     prelude::*,
     types::{ARef, AlwaysRefCounted, Opaque},
 };
-use core::{mem, ops::Deref, ptr, ptr::NonNull};
+use core::{alloc::Layout, mem, ops::Deref, ptr, ptr::NonNull};
 
 #[cfg(CONFIG_DRM_LEGACY)]
 macro_rules! drm_legacy_fields {
@@ -96,6 +97,10 @@ impl<T: drm::Driver> Device<T> {
 
     /// Create a new `drm::Device` for a `drm::Driver`.
     pub fn new(dev: &device::Device, data: impl PinInit<T::Data, Error>) -> Result<ARef<Self>> {
+        // `__drm_dev_alloc` uses `kmalloc()` to allocate memory, hence ensure a `kmalloc()`
+        // compatible `Layout`.
+        let layout = Kmalloc::aligned_layout(Layout::new::<Self>());
+
         // SAFETY:
         // - `VTABLE`, as a `const` is pinned to the read-only section of the compilation,
         // - `dev` is valid by its type invarants,
@@ -103,7 +108,7 @@ impl<T: drm::Driver> Device<T> {
             bindings::__drm_dev_alloc(
                 dev.as_raw(),
                 &Self::VTABLE,
-                mem::size_of::<Self>(),
+                layout.size(),
                 mem::offset_of!(Self, dev),
             )
         }
-- 
2.50.1



