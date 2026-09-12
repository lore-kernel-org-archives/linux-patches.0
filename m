Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D613A8737;
	Sat, 12 Sep 2026 08:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201952; cv=none; b=W5Kqo/XNpaRxEr/oIYkdWEY03LsvbeaVHAcrOscBjUYncR+ETgYuyfJ1xBlPfhZpSba7hzwp8j/9v7zCVtgPoDwcYFQie/Zp//Ro19/KT1ny40igu57PqfGDWJCbJ+DHaMVEMSoN72EdwJomeSlwzZES9bKaApVui3NrjM26GGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201952; c=relaxed/simple;
	bh=ust34OrJRQubPA1p+H96p0zvSD3qJ020HYAXGmlMcqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHBVorvWs8/MXH7sVibKm01A5QEpED8nLh1dhTjflREa2jpJqPM+gI34ua4/Y4Sba5D0gJx0up8hgGBdnzlw4RcorxwgoIqlThHxizQTOMSALS1TrNkdAQtKartUuMxzeitfzSYCNiAXjspCRryTpN9KsaEMkeH/UrTDPYxTTLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f32m9h0Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f32m9h0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69011F000FF;
	Sat, 12 Sep 2026 08:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201950;
	bh=tzkT36ksygCiT5DFAlf75/j0P1Yp9LxRYHkf3PrImQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f32m9h0QqnxqRQqYui1osZJD/kJgXXRcwN4R9nHKRmcWD6uu4Ixn+/9m4q98FNol+
	 LsDjKtQPwRhXc8hvtenoFU2wLBRNCctDkXW04vOdv/ig2HQdMzqzXU0L9b4Nm1GyTN
	 /OjgsN8P/c4hQbxPSDPAD2X4jOBjC514W+qxnsPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1095/1815] gpu: nova-core: correct FRTS vidmem offset calculation
Date: Sat, 12 Sep 2026 08:47:25 +0200
Message-ID: <20260912065714.727623978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

[ Upstream commit 5c9deba5578db5a3ea05be8a3e4a59ecb08ee76f ]

Currently, the frts vidmem offset is calculated based on the non-wpr
heap size and pmu reservation size, but this is not right. The layout
actually looks like this:

| non-wpr heap | WPR2 .. FRTS | PMU reserved | ... | VGA workspace |

It's just by coincidence + generous alignment that the values happened
to match. Instead, define a per-architecture reserved size at the end of
the framebuffer and use this plus the PMU reserved size to calculate the
frts vidmem offset.

Fixes: d317e4585fa3 ("gpu: nova-core: Hopper/Blackwell: add FSP Chain of Trust boot")
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260804-blackwell-fixes-v4-1-ac858b6a1935@nvidia.com
[acourbot: add comment clarifying reason for testing pmu_reserved_size.]
[acourbot: make fb_end_reserved_size() return u64.]
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/fb/hal/gb100.rs  |  1 +
 drivers/gpu/nova-core/fb/hal/gb202.rs  |  1 +
 drivers/gpu/nova-core/fsp.rs           | 28 ++++++++++++++++++--------
 drivers/gpu/nova-core/fsp/hal.rs       |  4 ++++
 drivers/gpu/nova-core/fsp/hal/gb100.rs |  6 ++++++
 drivers/gpu/nova-core/fsp/hal/gb202.rs |  9 ++++++++-
 drivers/gpu/nova-core/fsp/hal/gh100.rs |  9 ++++++++-
 7 files changed, 48 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/nova-core/fb/hal/gb100.rs b/drivers/gpu/nova-core/fb/hal/gb100.rs
index 6e0eba101ca15..51bd0c0bede69 100644
--- a/drivers/gpu/nova-core/fb/hal/gb100.rs
+++ b/drivers/gpu/nova-core/fb/hal/gb100.rs
@@ -78,6 +78,7 @@ fn write_sysmem_flush_page_gb100(bar: Bar0<'_>, addr: Bounded<u64, 52>) {
     );
 }
 
+// This PMU reservation size is r570-specific.
 pub(super) const fn pmu_reserved_size_gb100() -> u32 {
     usize_into_u32::<{ const_align_up(SZ_8M + SZ_16M + SZ_4K, Alignment::new::<SZ_128K>()).unwrap() }>(
     )
diff --git a/drivers/gpu/nova-core/fb/hal/gb202.rs b/drivers/gpu/nova-core/fb/hal/gb202.rs
index 038d1278c6341..9978a5d2dec1c 100644
--- a/drivers/gpu/nova-core/fb/hal/gb202.rs
+++ b/drivers/gpu/nova-core/fb/hal/gb202.rs
@@ -83,6 +83,7 @@ impl FbHal for Gb202 {
 
     fn non_wpr_heap_size(&self) -> u32 {
         // Non-WPR heap for GB20x (see Open RM: kgspGetNonWprHeapSize, GB202+).
+        // This size is r570-specific.
         u32::SZ_2M + u32::SZ_128K
     }
 
diff --git a/drivers/gpu/nova-core/fsp.rs b/drivers/gpu/nova-core/fsp.rs
index d2141b5450573..04af98d2c1f81 100644
--- a/drivers/gpu/nova-core/fsp.rs
+++ b/drivers/gpu/nova-core/fsp.rs
@@ -126,20 +126,32 @@ struct FspCotMessage {
 }
 
 impl FspCotMessage {
+    /// Computes the FRTS vidmem offset for the Chain-of-Trust message. It is measured backwards
+    /// from the end of the framebuffer.
+    fn frts_vidmem_offset(hal: &dyn hal::FspHal, fb_layout: &FbLayout) -> Result<u64> {
+        let mut offset = hal.fb_end_reserved_size();
+
+        // As per OpenRM's `kfspPrepareBootCommands_GH100`.
+        if fb_layout.pmu_reserved_size != 0 {
+            offset = (offset + u64::from(fb_layout.pmu_reserved_size))
+                // The 2 MiB alignment is r570-specific.
+                .align_up(Alignment::new::<SZ_2M>())
+                .ok_or(EINVAL)?;
+        }
+
+        Ok(offset)
+    }
+
     /// Returns an in-place initializer for [`FspCotMessage`].
     fn new<'a>(
         fb_layout: &FbLayout,
         fsp_fw: &'a FspFirmware,
         args: &'a FmcBootArgs,
     ) -> Result<impl Init<Self> + 'a> {
-        // frts_vidmem_offset is measured from the end of FB, so FRTS sits at
-        // (end of FB) - frts_vidmem_offset.
-        let frts_vidmem_offset = if !args.resume {
-            let frts_reserved_size = fb_layout.heap.len() + u64::from(fb_layout.pmu_reserved_size);
+        let hal = hal::fsp_hal(args.chipset).ok_or(ENOTSUPP)?;
 
-            frts_reserved_size
-                .align_up(Alignment::new::<SZ_2M>())
-                .ok_or(EINVAL)?
+        let frts_vidmem_offset = if !args.resume {
+            Self::frts_vidmem_offset(hal, fb_layout)?
         } else {
             0
         };
@@ -150,7 +162,7 @@ impl FspCotMessage {
             0
         };
 
-        let version = hal::fsp_hal(args.chipset).ok_or(ENOTSUPP)?.cot_version();
+        let version = hal.cot_version();
         let size = num::usize_into_u16::<{ core::mem::size_of::<NvdmPayloadCot>() }>();
 
         Ok(init!(Self {
diff --git a/drivers/gpu/nova-core/fsp/hal.rs b/drivers/gpu/nova-core/fsp/hal.rs
index b6f2624bb13d4..eaf5837ac5a88 100644
--- a/drivers/gpu/nova-core/fsp/hal.rs
+++ b/drivers/gpu/nova-core/fsp/hal.rs
@@ -19,6 +19,10 @@ pub(super) trait FspHal {
 
     /// Returns the FSP Chain of Trust protocol version this chipset advertises.
     fn cot_version(&self) -> u16;
+
+    // TODO: consider moving this into the TLV firmware metadata when ready
+    /// Returns the size reserved at the end of the framebuffer, in bytes.
+    fn fb_end_reserved_size(&self) -> u64;
 }
 
 /// Returns the FSP HAL, or `None` if the architecture doesn't support FSP.
diff --git a/drivers/gpu/nova-core/fsp/hal/gb100.rs b/drivers/gpu/nova-core/fsp/hal/gb100.rs
index 42f5ecfc64004..7cf53aa3d1ff0 100644
--- a/drivers/gpu/nova-core/fsp/hal/gb100.rs
+++ b/drivers/gpu/nova-core/fsp/hal/gb100.rs
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 // SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
+use kernel::sizes::SizeConstants;
+
 use crate::{
     driver::Bar0,
     fsp::hal::FspHal, //
@@ -17,6 +19,10 @@ impl FspHal for Gb100 {
     fn cot_version(&self) -> u16 {
         2
     }
+
+    fn fb_end_reserved_size(&self) -> u64 {
+        u64::SZ_2M + u64::SZ_128K
+    }
 }
 
 const GB100: Gb100 = Gb100;
diff --git a/drivers/gpu/nova-core/fsp/hal/gb202.rs b/drivers/gpu/nova-core/fsp/hal/gb202.rs
index 1091b169a645a..e380bbc5d58d7 100644
--- a/drivers/gpu/nova-core/fsp/hal/gb202.rs
+++ b/drivers/gpu/nova-core/fsp/hal/gb202.rs
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 // SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
-use kernel::io::Io;
+use kernel::{
+    io::Io,
+    sizes::SizeConstants, //
+};
 
 use crate::{
     driver::Bar0,
@@ -21,6 +24,10 @@ impl FspHal for Gb202 {
     fn cot_version(&self) -> u16 {
         2
     }
+
+    fn fb_end_reserved_size(&self) -> u64 {
+        u64::SZ_2M + u64::SZ_128K
+    }
 }
 
 const GB202: Gb202 = Gb202;
diff --git a/drivers/gpu/nova-core/fsp/hal/gh100.rs b/drivers/gpu/nova-core/fsp/hal/gh100.rs
index 291acaf2845a7..9a8563799da85 100644
--- a/drivers/gpu/nova-core/fsp/hal/gh100.rs
+++ b/drivers/gpu/nova-core/fsp/hal/gh100.rs
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
 // SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
 
-use kernel::io::Io;
+use kernel::{
+    io::Io,
+    sizes::SizeConstants, //
+};
 
 use crate::{
     driver::Bar0,
@@ -26,6 +29,10 @@ impl FspHal for Gh100 {
     fn cot_version(&self) -> u16 {
         1
     }
+
+    fn fb_end_reserved_size(&self) -> u64 {
+        u64::SZ_2M
+    }
 }
 
 const GH100: Gh100 = Gh100;
-- 
2.53.0



