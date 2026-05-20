Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC862D879E;
	Wed, 20 May 2026 17:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298211; cv=none; b=gijNMJo5AggiTzQSJPxlfDY756QYPm0KjwjZ2EQn3+DYMXuNvKBLMHWcldLKJTucppm/BouOL9xw32WvJ51XE+CD35CKfD3QQsdTXv8tO3XSW4FU8n6iST7y+tg0c6G/36gQRTPujUbQ4Sxsi0TAqOQfaG0WGi6j0b+wEWBPlFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298211; c=relaxed/simple;
	bh=2HwFGmUYtlAppahqwONl3RLernQGhfRUBL34gqGOjMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJL+hlh2EjAsKLbAtywgtSPVrCctF+Cr0Vg46JjLAMPP2B8GRO8aS3zZ3OvBFUA9caBBbdX53ZNpov6O2zjtYapjjcyr2hdeNb3f+Ewjoetzp2vFCuiXpW+X6b6ktQTEiyfsk/OY1WMU+Ugj8qf1eqq/JI4nuOQOMsrYDLimm84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcMoN4pe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcMoN4pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8075E1F00893;
	Wed, 20 May 2026 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298210;
	bh=turHpInxqSIaQAteiIeDhwT420IWqzZI86Wpe5iOiQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kcMoN4peDvyYdALvfFjlvy7xGXyDgQeRDNBi4C4D0erz0qIv8bVePXBWtmdeJ9oNx
	 qlmaEZKakQp8VM4UCueKNty3pxPGyiCH3KJdtKTfAXpsXdwk1pxZlnbgBLz/ckvFiz
	 /AzuclBpNw7mGRJD5IE68NO9O9EION1HfGN+icGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edwin Peer <epeer@nvidia.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 307/957] gpu: nova-core: register: use field type for Into implementation
Date: Wed, 20 May 2026 18:13:10 +0200
Message-ID: <20260520162141.188935268@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Alexandre Courbot <acourbot@nvidia.com>

[ Upstream commit 3f674dc4ef1b3783f9d8dae33b46bf50eaac7c79 ]

The getter method of a field works with the field type, but its setter
expects the type of the register. This leads to an asymmetry in the
From/Into implementations required for a field with a dedicated type.
For instance, a field declared as

    pub struct ControlReg(u32) {
        3:0 mode as u8 ?=> Mode;
        ...
    }

currently requires the following implementations:

    impl TryFrom<u8> for Mode {
      ...
    }

    impl From<Mode> for u32 {
      ...
    }

Change this so the `From<Mode>` now needs to be implemented for `u8`,
i.e. the primitive type of the field. This is more consistent, and will
become a requirement once we start using the TryFrom/Into derive macros
to implement these automatically.

Reported-by: Edwin Peer <epeer@nvidia.com>
Closes: https://lore.kernel.org/rust-for-linux/F3853912-2C1C-4F9B-89B0-3168689F35B3@nvidia.com/
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Message-ID: <20251016151323.1201196-2-joelagnelf@nvidia.com>
Stable-dep-of: de0aca13509b ("gpu: nova-core: bitfield: fix broken Default implementation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/falcon.rs      | 38 ++++++++++++++++++++--------
 drivers/gpu/nova-core/regs/macros.rs | 10 ++++----
 2 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/nova-core/falcon.rs b/drivers/gpu/nova-core/falcon.rs
index 37e6298195e49..3f505b8706011 100644
--- a/drivers/gpu/nova-core/falcon.rs
+++ b/drivers/gpu/nova-core/falcon.rs
@@ -22,11 +22,11 @@ mod hal;
 pub(crate) mod sec2;
 
 // TODO[FPRI]: Replace with `ToPrimitive`.
-macro_rules! impl_from_enum_to_u32 {
+macro_rules! impl_from_enum_to_u8 {
     ($enum_type:ty) => {
-        impl From<$enum_type> for u32 {
+        impl From<$enum_type> for u8 {
             fn from(value: $enum_type) -> Self {
-                value as u32
+                value as u8
             }
         }
     };
@@ -46,7 +46,7 @@ pub(crate) enum FalconCoreRev {
     Rev6 = 6,
     Rev7 = 7,
 }
-impl_from_enum_to_u32!(FalconCoreRev);
+impl_from_enum_to_u8!(FalconCoreRev);
 
 // TODO[FPRI]: replace with `FromPrimitive`.
 impl TryFrom<u8> for FalconCoreRev {
@@ -81,7 +81,7 @@ pub(crate) enum FalconCoreRevSubversion {
     Subversion2 = 2,
     Subversion3 = 3,
 }
-impl_from_enum_to_u32!(FalconCoreRevSubversion);
+impl_from_enum_to_u8!(FalconCoreRevSubversion);
 
 // TODO[FPRI]: replace with `FromPrimitive`.
 impl TryFrom<u8> for FalconCoreRevSubversion {
@@ -125,7 +125,7 @@ pub(crate) enum FalconSecurityModel {
     /// Also known as High-Secure, Privilege Level 3 or PL3.
     Heavy = 3,
 }
-impl_from_enum_to_u32!(FalconSecurityModel);
+impl_from_enum_to_u8!(FalconSecurityModel);
 
 // TODO[FPRI]: replace with `FromPrimitive`.
 impl TryFrom<u8> for FalconSecurityModel {
@@ -157,7 +157,7 @@ pub(crate) enum FalconModSelAlgo {
     #[default]
     Rsa3k = 1,
 }
-impl_from_enum_to_u32!(FalconModSelAlgo);
+impl_from_enum_to_u8!(FalconModSelAlgo);
 
 // TODO[FPRI]: replace with `FromPrimitive`.
 impl TryFrom<u8> for FalconModSelAlgo {
@@ -179,7 +179,7 @@ pub(crate) enum DmaTrfCmdSize {
     #[default]
     Size256B = 0x6,
 }
-impl_from_enum_to_u32!(DmaTrfCmdSize);
+impl_from_enum_to_u8!(DmaTrfCmdSize);
 
 // TODO[FPRI]: replace with `FromPrimitive`.
 impl TryFrom<u8> for DmaTrfCmdSize {
@@ -202,7 +202,6 @@ pub(crate) enum PeregrineCoreSelect {
     /// RISC-V core is active.
     Riscv = 1,
 }
-impl_from_enum_to_u32!(PeregrineCoreSelect);
 
 impl From<bool> for PeregrineCoreSelect {
     fn from(value: bool) -> Self {
@@ -213,6 +212,15 @@ impl From<bool> for PeregrineCoreSelect {
     }
 }
 
+impl From<PeregrineCoreSelect> for bool {
+    fn from(value: PeregrineCoreSelect) -> Self {
+        match value {
+            PeregrineCoreSelect::Falcon => false,
+            PeregrineCoreSelect::Riscv => true,
+        }
+    }
+}
+
 /// Different types of memory present in a falcon core.
 #[derive(Debug, Clone, Copy, PartialEq, Eq)]
 pub(crate) enum FalconMem {
@@ -236,7 +244,7 @@ pub(crate) enum FalconFbifTarget {
     /// Non-coherent system memory (System DRAM).
     NoncoherentSysmem = 2,
 }
-impl_from_enum_to_u32!(FalconFbifTarget);
+impl_from_enum_to_u8!(FalconFbifTarget);
 
 // TODO[FPRI]: replace with `FromPrimitive`.
 impl TryFrom<u8> for FalconFbifTarget {
@@ -263,7 +271,6 @@ pub(crate) enum FalconFbifMemType {
     /// Physical memory addresses.
     Physical = 1,
 }
-impl_from_enum_to_u32!(FalconFbifMemType);
 
 /// Conversion from a single-bit register field.
 impl From<bool> for FalconFbifMemType {
@@ -275,6 +282,15 @@ impl From<bool> for FalconFbifMemType {
     }
 }
 
+impl From<FalconFbifMemType> for bool {
+    fn from(value: FalconFbifMemType) -> Self {
+        match value {
+            FalconFbifMemType::Virtual => false,
+            FalconFbifMemType::Physical => true,
+        }
+    }
+}
+
 /// Type used to represent the `PFALCON` registers address base for a given falcon engine.
 pub(crate) struct PFalconBase(());
 
diff --git a/drivers/gpu/nova-core/regs/macros.rs b/drivers/gpu/nova-core/regs/macros.rs
index 8058e1696df97..1c54a4533822e 100644
--- a/drivers/gpu/nova-core/regs/macros.rs
+++ b/drivers/gpu/nova-core/regs/macros.rs
@@ -482,7 +482,7 @@ macro_rules! register {
         register!(
             @leaf_accessor $name $hi:$lo $field
             { |f| <$into_type>::from(if f != 0 { true } else { false }) }
-            $into_type => $into_type $(, $comment)?;
+            bool $into_type => $into_type $(, $comment)?;
         );
     };
 
@@ -499,7 +499,7 @@ macro_rules! register {
             $(, $comment:literal)?;
     ) => {
         register!(@leaf_accessor $name $hi:$lo $field
-            { |f| <$try_into_type>::try_from(f as $type) } $try_into_type =>
+            { |f| <$try_into_type>::try_from(f as $type) } $type $try_into_type =>
             ::core::result::Result<
                 $try_into_type,
                 <$try_into_type as ::core::convert::TryFrom<$type>>::Error
@@ -513,7 +513,7 @@ macro_rules! register {
             $(, $comment:literal)?;
     ) => {
         register!(@leaf_accessor $name $hi:$lo $field
-            { |f| <$into_type>::from(f as $type) } $into_type => $into_type $(, $comment)?;);
+            { |f| <$into_type>::from(f as $type) } $type $into_type => $into_type $(, $comment)?;);
     };
 
     // Shortcut for non-boolean fields defined without the `=>` or `?=>` syntax.
@@ -527,7 +527,7 @@ macro_rules! register {
     // Generates the accessor methods for a single field.
     (
         @leaf_accessor $name:ident $hi:tt:$lo:tt $field:ident
-            { $process:expr } $to_type:ty => $res_type:ty $(, $comment:literal)?;
+            { $process:expr } $prim_type:tt $to_type:ty => $res_type:ty $(, $comment:literal)?;
     ) => {
         ::kernel::macros::paste!(
         const [<$field:upper _RANGE>]: ::core::ops::RangeInclusive<u8> = $lo..=$hi;
@@ -559,7 +559,7 @@ macro_rules! register {
         pub(crate) fn [<set_ $field>](mut self, value: $to_type) -> Self {
             const MASK: u32 = $name::[<$field:upper _MASK>];
             const SHIFT: u32 = $name::[<$field:upper _SHIFT>];
-            let value = (u32::from(value) << SHIFT) & MASK;
+            let value = (u32::from($prim_type::from(value)) << SHIFT) & MASK;
             self.0 = (self.0 & !MASK) | value;
 
             self
-- 
2.53.0



