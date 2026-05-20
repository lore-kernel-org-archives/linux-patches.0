Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1F136A352;
	Wed, 20 May 2026 16:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295131; cv=none; b=N/gWU+mznDR9aBjVx0cheAbp0VbgTklN3ps2NA5zPJzKj6bFk5H9NVPd7W6DpdalMCfGP9Q25E6YD/BfNyuNPeNFkpnicJ8yYGIP4Iqq17X2XG6z4soMVdqcM7bBAHzxD7Y8ZxKj5sf891/GB1mrbjHf7ih2nEHM+lENItJFO6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295131; c=relaxed/simple;
	bh=l63ICDmQ7tP3iulwWDdX9xz7YJfc5pBNvYe1D2J+wLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhrR1G5iprej2KWiA9jwsojlW+RtIcrazBBjjzGO6w0TRLV4/3m3ZWFcioDBZec6pra4c10RxwSAZRqnoHg0c8lkjvb6uFbV31ZdzuLNjuPWxS9oGGhmfTFH3Oga1Ofga69+w7giVHG2rrqWZ8rG4G8J99F9EkX1Gz3K52A3d7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NenAmxyx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NenAmxyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF241F000E9;
	Wed, 20 May 2026 16:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295129;
	bh=5FRXZbGxM9USXhQ5WxZoK/Ed9O+EV/PGFBJZqgc5f7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NenAmxyxHP2E5QYjEIXNREQmtETd2V64JqzLkvjAj4TT84evuuAkK1YMoXJDzYECc
	 wmNXLb3wfgkPcJ/5sXcip2b0ocOo39DFMJDTyBnkWOUatZkG/C7r6+b+2pxxlDmoUj
	 kLlg0K1DwLKMdeSn5sqf4qfBvMcSGtluTdzWBtII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Gary Guo <gary@garyguo.net>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0261/1146] gpu: nova-core: use checked arithmetic in FWSEC firmware parsing
Date: Wed, 20 May 2026 18:08:31 +0200
Message-ID: <20260520162154.135950357@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Fernandes <joelagnelf@nvidia.com>

[ Upstream commit 0568b376a0b13da6582bce1f2e2bbb2eae7fc266 ]

Use checked_add() and checked_mul() when computing offsets from

firmware-provided values in new_fwsec().
Without checked arithmetic, corrupt firmware could cause integer
overflow. The danger is not just wrapping to a huge value, but
potentially wrapping to a small plausible offset that passes validation
yet accesses entirely wrong data, causing silent corruption or security
issues.

Reviewed-by: Zhi Wang <zhiw@nvidia.com>
Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260126202305.2526618-2-joelagnelf@nvidia.com
[acourbot@nvidia.com: rewrap commit message to make checkpatch happy.]
[acourbot@nvidia.com: add missing empty lines after new code blocks.]
[acourbot@nvidia.com: move SAFETY comments to the unsafe statement they
 describe.]
[acourbot@nvidia.com: remove obvious computation comments and use
`CALC:` for the remaining ones.]
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Stable-dep-of: 17d7c97f73c7 ("gpu: nova-core: firmware: fix and explain v2 header offsets computations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/firmware/fwsec.rs | 64 ++++++++++++++-----------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/nova-core/firmware/fwsec.rs b/drivers/gpu/nova-core/firmware/fwsec.rs
index bfb7b06b13d15..df3d8de14ca14 100644
--- a/drivers/gpu/nova-core/firmware/fwsec.rs
+++ b/drivers/gpu/nova-core/firmware/fwsec.rs
@@ -45,10 +45,7 @@ use crate::{
         Signed,
         Unsigned, //
     },
-    num::{
-        FromSafeCast,
-        IntoSafeCast, //
-    },
+    num::FromSafeCast,
     vbios::Vbios,
 };
 
@@ -266,7 +263,12 @@ impl FirmwareDmaObject<FwsecFirmware, Unsigned> {
         let ucode = bios.fwsec_image().ucode(&desc)?;
         let mut dma_object = DmaObject::from_data(dev, ucode)?;
 
-        let hdr_offset = usize::from_safe_cast(desc.imem_load_size() + desc.interface_offset());
+        let hdr_offset = desc
+            .imem_load_size()
+            .checked_add(desc.interface_offset())
+            .map(usize::from_safe_cast)
+            .ok_or(EINVAL)?;
+
         // SAFETY: we have exclusive access to `dma_object`.
         let hdr: &FalconAppifHdrV1 = unsafe { transmute(&dma_object, hdr_offset) }?;
 
@@ -276,26 +278,29 @@ impl FirmwareDmaObject<FwsecFirmware, Unsigned> {
 
         // Find the DMEM mapper section in the firmware.
         for i in 0..usize::from(hdr.entry_count) {
+            // CALC: hdr_offset + header_size + i * entry_size.
+            let entry_offset = hdr_offset
+                .checked_add(usize::from(hdr.header_size))
+                .and_then(|o| o.checked_add(i.checked_mul(usize::from(hdr.entry_size))?))
+                .ok_or(EINVAL)?;
+
             // SAFETY: we have exclusive access to `dma_object`.
-            let app: &FalconAppifV1 = unsafe {
-                transmute(
-                    &dma_object,
-                    hdr_offset + usize::from(hdr.header_size) + i * usize::from(hdr.entry_size),
-                )
-            }?;
+            let app: &FalconAppifV1 = unsafe { transmute(&dma_object, entry_offset) }?;
 
             if app.id != NVFW_FALCON_APPIF_ID_DMEMMAPPER {
                 continue;
             }
             let dmem_base = app.dmem_base;
 
-            // SAFETY: we have exclusive access to `dma_object`.
-            let dmem_mapper: &mut FalconAppifDmemmapperV3 = unsafe {
-                transmute_mut(
-                    &mut dma_object,
-                    (desc.imem_load_size() + dmem_base).into_safe_cast(),
-                )
-            }?;
+            let dmem_mapper_offset = desc
+                .imem_load_size()
+                .checked_add(dmem_base)
+                .map(usize::from_safe_cast)
+                .ok_or(EINVAL)?;
+
+            let dmem_mapper: &mut FalconAppifDmemmapperV3 =
+                // SAFETY: we have exclusive access to `dma_object`.
+                unsafe { transmute_mut(&mut dma_object, dmem_mapper_offset) }?;
 
             dmem_mapper.init_cmd = match cmd {
                 FwsecCommand::Frts { .. } => NVFW_FALCON_APPIF_DMEMMAPPER_CMD_FRTS,
@@ -303,13 +308,15 @@ impl FirmwareDmaObject<FwsecFirmware, Unsigned> {
             };
             let cmd_in_buffer_offset = dmem_mapper.cmd_in_buffer_offset;
 
-            // SAFETY: we have exclusive access to `dma_object`.
-            let frts_cmd: &mut FrtsCmd = unsafe {
-                transmute_mut(
-                    &mut dma_object,
-                    (desc.imem_load_size() + cmd_in_buffer_offset).into_safe_cast(),
-                )
-            }?;
+            let frts_cmd_offset = desc
+                .imem_load_size()
+                .checked_add(cmd_in_buffer_offset)
+                .map(usize::from_safe_cast)
+                .ok_or(EINVAL)?;
+
+            let frts_cmd: &mut FrtsCmd =
+                // SAFETY: we have exclusive access to `dma_object`.
+                unsafe { transmute_mut(&mut dma_object, frts_cmd_offset) }?;
 
             frts_cmd.read_vbios = ReadVbios {
                 ver: 1,
@@ -355,8 +362,11 @@ impl FwsecFirmware {
         // Patch signature if needed.
         let desc = bios.fwsec_image().header()?;
         let ucode_signed = if desc.signature_count() != 0 {
-            let sig_base_img =
-                usize::from_safe_cast(desc.imem_load_size() + desc.pkc_data_offset());
+            let sig_base_img = desc
+                .imem_load_size()
+                .checked_add(desc.pkc_data_offset())
+                .map(usize::from_safe_cast)
+                .ok_or(EINVAL)?;
             let desc_sig_versions = u32::from(desc.signature_versions());
             let reg_fuse_version =
                 falcon.signature_reg_fuse_version(bar, desc.engine_id_mask(), desc.ucode_id())?;
-- 
2.53.0



