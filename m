Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D57263899;
	Tue,  8 Apr 2025 11:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111727; cv=none; b=o+n+veI3bKxZ7bVVyWRMCtr5EyuMf4t90lcBTDyHKkRAnUQsOu38fqt8KKpMwRcxFpkEVMXKfO8E2XbtTvIsawRhfMwdlqfpBp5hvlne8p+DGth9cdcLc3waFC1H/JupxIZCS/waEtKTWdMRqLg+GEKDSea/hBlP2bFHcznrVPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111727; c=relaxed/simple;
	bh=LesinF9C1k7UeJZenDinspkwY0z7TLB6N2VDsnIwji4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czX05EBW3zKdaNEgwe1F40NLB5ia/VY88+P7ISqaxl0Jlw1TEFNCUX50FP0/m2Lnb3zXFqPztotxZvEVYxjOUNizfM+r2/5iK7rnQtagAPfbvKe+eRH0eQZSRV04gYcXO3YyoaSYwEa0WdpZ7AQpYd0LWmwMIdtozNRIGKZCfD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asyx3+8o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asyx3+8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EC7C4CEE5;
	Tue,  8 Apr 2025 11:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111727;
	bh=LesinF9C1k7UeJZenDinspkwY0z7TLB6N2VDsnIwji4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asyx3+8o8tFwJ4IFUnYeZA9wy776r38Iki/yKgozK10bKiDybZvi6nxMqcPH5o62g
	 nfYW/52RQXQhfj0k6RFDB5N8jU84L1HqBRKHc7mlw6A2E/8xm1WHGS9X5Xnacm0IJQ
	 XOKZvpO1sX2u7ot/QHrmPxJWSAqZWiW/GCOZLWLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Danilo Krummrich <dakr@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 510/731] rust: platform: fix unrestricted &mut platform::Device
Date: Tue,  8 Apr 2025 12:46:47 +0200
Message-ID: <20250408104926.139328562@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 4d320e30ee04c25c660eca2bb33e846ebb71a79a ]

As by now, platform::Device is implemented as:

	#[derive(Clone)]
	pub struct Device(ARef<device::Device>);

This may be convenient, but has the implication that drivers can call
device methods that require a mutable reference concurrently at any
point of time.

Instead define platform::Device as

	pub struct Device<Ctx: DeviceContext = Normal>(
		Opaque<bindings::platform_dev>,
		PhantomData<Ctx>,
	);

and manually implement the AlwaysRefCounted trait.

With this we can implement methods that should only be called from
bus callbacks (such as probe()) for platform::Device<Core>. Consequently,
we make this type accessible in bus callbacks only.

Arbitrary references taken by the driver are still of type
ARef<platform::Device> and hence don't provide access to methods that are
reserved for bus callbacks.

Fixes: 683a63befc73 ("rust: platform: add basic platform device / driver abstractions")
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20250314160932.100165-5-dakr@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/platform.rs              | 95 +++++++++++++++++++---------
 samples/rust/rust_driver_platform.rs | 11 ++--
 2 files changed, 72 insertions(+), 34 deletions(-)

diff --git a/rust/kernel/platform.rs b/rust/kernel/platform.rs
index 50e6b04218132..c77c9f2e9aea1 100644
--- a/rust/kernel/platform.rs
+++ b/rust/kernel/platform.rs
@@ -5,7 +5,7 @@
 //! C header: [`include/linux/platform_device.h`](srctree/include/linux/platform_device.h)
 
 use crate::{
-    bindings, container_of, device, driver,
+    bindings, device, driver,
     error::{to_result, Result},
     of,
     prelude::*,
@@ -14,7 +14,11 @@ use crate::{
     ThisModule,
 };
 
-use core::ptr::addr_of_mut;
+use core::{
+    marker::PhantomData,
+    ops::Deref,
+    ptr::{addr_of_mut, NonNull},
+};
 
 /// An adapter for the registration of platform drivers.
 pub struct Adapter<T: Driver>(T);
@@ -54,14 +58,14 @@ unsafe impl<T: Driver + 'static> driver::RegistrationOps for Adapter<T> {
 
 impl<T: Driver + 'static> Adapter<T> {
     extern "C" fn probe_callback(pdev: *mut bindings::platform_device) -> kernel::ffi::c_int {
-        // SAFETY: The platform bus only ever calls the probe callback with a valid `pdev`.
-        let dev = unsafe { device::Device::get_device(addr_of_mut!((*pdev).dev)) };
-        // SAFETY: `dev` is guaranteed to be embedded in a valid `struct platform_device` by the
-        // call above.
-        let mut pdev = unsafe { Device::from_dev(dev) };
+        // SAFETY: The platform bus only ever calls the probe callback with a valid pointer to a
+        // `struct platform_device`.
+        //
+        // INVARIANT: `pdev` is valid for the duration of `probe_callback()`.
+        let pdev = unsafe { &*pdev.cast::<Device<device::Core>>() };
 
         let info = <Self as driver::Adapter>::id_info(pdev.as_ref());
-        match T::probe(&mut pdev, info) {
+        match T::probe(pdev, info) {
             Ok(data) => {
                 // Let the `struct platform_device` own a reference of the driver's private data.
                 // SAFETY: By the type invariant `pdev.as_raw` returns a valid pointer to a
@@ -120,7 +124,7 @@ macro_rules! module_platform_driver {
 /// # Example
 ///
 ///```
-/// # use kernel::{bindings, c_str, of, platform};
+/// # use kernel::{bindings, c_str, device::Core, of, platform};
 ///
 /// struct MyDriver;
 ///
@@ -138,7 +142,7 @@ macro_rules! module_platform_driver {
 ///     const OF_ID_TABLE: Option<of::IdTable<Self::IdInfo>> = Some(&OF_TABLE);
 ///
 ///     fn probe(
-///         _pdev: &mut platform::Device,
+///         _pdev: &platform::Device<Core>,
 ///         _id_info: Option<&Self::IdInfo>,
 ///     ) -> Result<Pin<KBox<Self>>> {
 ///         Err(ENODEV)
@@ -160,41 +164,72 @@ pub trait Driver {
     ///
     /// Called when a new platform device is added or discovered.
     /// Implementers should attempt to initialize the device here.
-    fn probe(dev: &mut Device, id_info: Option<&Self::IdInfo>) -> Result<Pin<KBox<Self>>>;
+    fn probe(dev: &Device<device::Core>, id_info: Option<&Self::IdInfo>)
+        -> Result<Pin<KBox<Self>>>;
 }
 
 /// The platform device representation.
 ///
-/// A platform device is based on an always reference counted `device:Device` instance. Cloning a
-/// platform device, hence, also increments the base device' reference count.
+/// This structure represents the Rust abstraction for a C `struct platform_device`. The
+/// implementation abstracts the usage of an already existing C `struct platform_device` within Rust
+/// code that we get passed from the C side.
 ///
 /// # Invariants
 ///
-/// `Device` holds a valid reference of `ARef<device::Device>` whose underlying `struct device` is a
-/// member of a `struct platform_device`.
-#[derive(Clone)]
-pub struct Device(ARef<device::Device>);
+/// A [`Device`] instance represents a valid `struct platform_device` created by the C portion of
+/// the kernel.
+#[repr(transparent)]
+pub struct Device<Ctx: device::DeviceContext = device::Normal>(
+    Opaque<bindings::platform_device>,
+    PhantomData<Ctx>,
+);
 
 impl Device {
-    /// Convert a raw kernel device into a `Device`
-    ///
-    /// # Safety
-    ///
-    /// `dev` must be an `Aref<device::Device>` whose underlying `bindings::device` is a member of a
-    /// `bindings::platform_device`.
-    unsafe fn from_dev(dev: ARef<device::Device>) -> Self {
-        Self(dev)
+    fn as_raw(&self) -> *mut bindings::platform_device {
+        self.0.get()
     }
+}
 
-    fn as_raw(&self) -> *mut bindings::platform_device {
-        // SAFETY: By the type invariant `self.0.as_raw` is a pointer to the `struct device`
-        // embedded in `struct platform_device`.
-        unsafe { container_of!(self.0.as_raw(), bindings::platform_device, dev) }.cast_mut()
+impl Deref for Device<device::Core> {
+    type Target = Device;
+
+    fn deref(&self) -> &Self::Target {
+        let ptr: *const Self = self;
+
+        // CAST: `Device<Ctx>` is a transparent wrapper of `Opaque<bindings::platform_device>`.
+        let ptr = ptr.cast::<Device>();
+
+        // SAFETY: `ptr` was derived from `&self`.
+        unsafe { &*ptr }
+    }
+}
+
+impl From<&Device<device::Core>> for ARef<Device> {
+    fn from(dev: &Device<device::Core>) -> Self {
+        (&**dev).into()
+    }
+}
+
+// SAFETY: Instances of `Device` are always reference-counted.
+unsafe impl crate::types::AlwaysRefCounted for Device {
+    fn inc_ref(&self) {
+        // SAFETY: The existence of a shared reference guarantees that the refcount is non-zero.
+        unsafe { bindings::get_device(self.as_ref().as_raw()) };
+    }
+
+    unsafe fn dec_ref(obj: NonNull<Self>) {
+        // SAFETY: The safety requirements guarantee that the refcount is non-zero.
+        unsafe { bindings::platform_device_put(obj.cast().as_ptr()) }
     }
 }
 
 impl AsRef<device::Device> for Device {
     fn as_ref(&self) -> &device::Device {
-        &self.0
+        // SAFETY: By the type invariant of `Self`, `self.as_raw()` is a pointer to a valid
+        // `struct platform_device`.
+        let dev = unsafe { addr_of_mut!((*self.as_raw()).dev) };
+
+        // SAFETY: `dev` points to a valid `struct device`.
+        unsafe { device::Device::as_ref(dev) }
     }
 }
diff --git a/samples/rust/rust_driver_platform.rs b/samples/rust/rust_driver_platform.rs
index 8120609e29402..9bb66db0a4f43 100644
--- a/samples/rust/rust_driver_platform.rs
+++ b/samples/rust/rust_driver_platform.rs
@@ -2,10 +2,10 @@
 
 //! Rust Platform driver sample.
 
-use kernel::{c_str, of, platform, prelude::*};
+use kernel::{c_str, device::Core, of, platform, prelude::*, types::ARef};
 
 struct SampleDriver {
-    pdev: platform::Device,
+    pdev: ARef<platform::Device>,
 }
 
 struct Info(u32);
@@ -21,14 +21,17 @@ impl platform::Driver for SampleDriver {
     type IdInfo = Info;
     const OF_ID_TABLE: Option<of::IdTable<Self::IdInfo>> = Some(&OF_TABLE);
 
-    fn probe(pdev: &mut platform::Device, info: Option<&Self::IdInfo>) -> Result<Pin<KBox<Self>>> {
+    fn probe(
+        pdev: &platform::Device<Core>,
+        info: Option<&Self::IdInfo>,
+    ) -> Result<Pin<KBox<Self>>> {
         dev_dbg!(pdev.as_ref(), "Probe Rust Platform driver sample.\n");
 
         if let Some(info) = info {
             dev_info!(pdev.as_ref(), "Probed with info: '{}'.\n", info.0);
         }
 
-        let drvdata = KBox::new(Self { pdev: pdev.clone() }, GFP_KERNEL)?;
+        let drvdata = KBox::new(Self { pdev: pdev.into() }, GFP_KERNEL)?;
 
         Ok(drvdata.into())
     }
-- 
2.39.5



