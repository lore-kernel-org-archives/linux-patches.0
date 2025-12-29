Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC7032ED57;
	Mon, 29 Dec 2025 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025475; cv=none; b=H1A/s+OBGPnvxVMa5M2n9unkIJZOGL9/LKMO80z+WCKZ6Gw/nWQM3E2PRctzzIicYM7CGKZmwHutyWUo3TqmjFXX2DNICQ5kGFNOwpGFtOo9t0/qmUaKPa7N74G9wBi2x/I9lCcQsX0c4H9WNoyMugN57meRudpq51TawZ1auvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025475; c=relaxed/simple;
	bh=9bOnU65O4UJUH3PQ4WA0OCLkKAg5Nra7rOPIpPYLrw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DB/u76MuN4CcSgq3/sRzrEAvJG7Py6DMjnLGF1uYpqiSG5XYwIR3njzxFX6hWJSj0Y4I94E45VRl5qG3GjL/Cr158CcPmnqh3RWtOUyRgtaYqfRAKGv1HXvTj39+ORM7Kpmq/nNRZo3wN7RW/D9J0RyW6xgq/gDy/qezAQUxB1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yc9hO7DR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yc9hO7DR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF33C4CEF7;
	Mon, 29 Dec 2025 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025474;
	bh=9bOnU65O4UJUH3PQ4WA0OCLkKAg5Nra7rOPIpPYLrw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yc9hO7DRWdmCqIWvKfGza7QtHEVn+Wp2zV9GPyFXWGnGHjRDaOl1JZHXe+LFPahwn
	 fKa5T5a0EQ3DBwFWsRr796bP6PMyULuaAIlGsAlgWjOfP3Kp9zr+ZOlWDU+qD3hqsW
	 6nmPUxP0MInNS9/0T6vTFJO6qH4OTJwCwdvybm4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 226/430] rust: io: add typedef for phys_addr_t
Date: Mon, 29 Dec 2025 17:10:28 +0100
Message-ID: <20251229160732.669779153@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit dd6ff5cf56fb183fce605ca6a5bfce228cd8888b upstream.

The C typedef phys_addr_t is missing an analogue in Rust, meaning that
we end up using bindings::phys_addr_t or ResourceSize as a replacement
in various places throughout the kernel. Fix that by introducing a new
typedef on the Rust side. Place it next to the existing ResourceSize
typedef since they're quite related to each other.

Cc: stable@vger.kernel.org # for v6.18 [1]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20251112-resource-phys-typedefs-v2-4-538307384f82@google.com
Link: https://lore.kernel.org/all/20251112-resource-phys-typedefs-v2-0-538307384f82@google.com/ [1]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs      |   18 +++++++++++++++---
 rust/kernel/io.rs          |   20 +++++++++++++++++---
 rust/kernel/io/resource.rs |    9 ++++++---
 3 files changed, 38 insertions(+), 9 deletions(-)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -52,8 +52,20 @@ struct Inner<T: Send> {
 /// # Examples
 ///
 /// ```no_run
-/// # use kernel::{bindings, device::{Bound, Device}, devres::Devres, io::{Io, IoRaw}};
-/// # use core::ops::Deref;
+/// use kernel::{
+///     bindings,
+///     device::{
+///         Bound,
+///         Device,
+///     },
+///     devres::Devres,
+///     io::{
+///         Io,
+///         IoRaw,
+///         PhysAddr,
+///     },
+/// };
+/// use core::ops::Deref;
 ///
 /// // See also [`pci::Bar`] for a real example.
 /// struct IoMem<const SIZE: usize>(IoRaw<SIZE>);
@@ -66,7 +78,7 @@ struct Inner<T: Send> {
 ///     unsafe fn new(paddr: usize) -> Result<Self>{
 ///         // SAFETY: By the safety requirements of this function [`paddr`, `paddr` + `SIZE`) is
 ///         // valid for `ioremap`.
-///         let addr = unsafe { bindings::ioremap(paddr as bindings::phys_addr_t, SIZE) };
+///         let addr = unsafe { bindings::ioremap(paddr as PhysAddr, SIZE) };
 ///         if addr.is_null() {
 ///             return Err(ENOMEM);
 ///         }
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -13,6 +13,12 @@ pub mod resource;
 
 pub use resource::Resource;
 
+/// Physical address type.
+///
+/// This is a type alias to either `u32` or `u64` depending on the config option
+/// `CONFIG_PHYS_ADDR_T_64BIT`, and it can be a u64 even on 32-bit architectures.
+pub type PhysAddr = bindings::phys_addr_t;
+
 /// Resource Size type.
 ///
 /// This is a type alias to either `u32` or `u64` depending on the config option
@@ -68,8 +74,16 @@ impl<const SIZE: usize> IoRaw<SIZE> {
 /// # Examples
 ///
 /// ```no_run
-/// # use kernel::{bindings, ffi::c_void, io::{Io, IoRaw}};
-/// # use core::ops::Deref;
+/// use kernel::{
+///     bindings,
+///     ffi::c_void,
+///     io::{
+///         Io,
+///         IoRaw,
+///         PhysAddr,
+///     },
+/// };
+/// use core::ops::Deref;
 ///
 /// // See also [`pci::Bar`] for a real example.
 /// struct IoMem<const SIZE: usize>(IoRaw<SIZE>);
@@ -82,7 +96,7 @@ impl<const SIZE: usize> IoRaw<SIZE> {
 ///     unsafe fn new(paddr: usize) -> Result<Self>{
 ///         // SAFETY: By the safety requirements of this function [`paddr`, `paddr` + `SIZE`) is
 ///         // valid for `ioremap`.
-///         let addr = unsafe { bindings::ioremap(paddr as bindings::phys_addr_t, SIZE) };
+///         let addr = unsafe { bindings::ioremap(paddr as PhysAddr, SIZE) };
 ///         if addr.is_null() {
 ///             return Err(ENOMEM);
 ///         }
--- a/rust/kernel/io/resource.rs
+++ b/rust/kernel/io/resource.rs
@@ -12,7 +12,10 @@ use crate::prelude::*;
 use crate::str::{CStr, CString};
 use crate::types::Opaque;
 
-pub use super::ResourceSize;
+pub use super::{
+    PhysAddr,
+    ResourceSize, //
+};
 
 /// A region allocated from a parent [`Resource`].
 ///
@@ -93,7 +96,7 @@ impl Resource {
     /// the region, or a part of it, is already in use.
     pub fn request_region(
         &self,
-        start: ResourceSize,
+        start: PhysAddr,
         size: ResourceSize,
         name: CString,
         flags: Flags,
@@ -127,7 +130,7 @@ impl Resource {
     }
 
     /// Returns the start address of the resource.
-    pub fn start(&self) -> ResourceSize {
+    pub fn start(&self) -> PhysAddr {
         let inner = self.0.get();
         // SAFETY: Safe as per the invariants of `Resource`.
         unsafe { (*inner).start }


