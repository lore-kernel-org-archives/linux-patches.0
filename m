Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F369C46F4AB;
	Tue, 21 Jul 2026 17:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655977; cv=none; b=mCylS0LQB/cRre0a8YseElNZCUKlVPBaENSN6tJK8Ots9U2pfKzryZHpyj0BguV6gCLOgqagVITwsMSjentfXblsBSz4/PPegkWVTm2oION4QmV/1cNrlLU4+AMtvp7KUCup03OAHIvJC/x4Dg+BjdXax8fnmWyOaRK5ddqaI+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655977; c=relaxed/simple;
	bh=tvsAfrAPMJrAdJGmZwKkZ2OPbeQuVdLt2rlNnDSBb3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HU1Jxd3fAihkOejQ4CSr6osiqp7+ty685B/KlDgUN9UweKwqG8r0pgEdjCVAzoYwgqHH7YLHi71B2XhsJogFgX6Peh3XJ/j1AE9ZnmMKWvTYGMBSghtCn5S07tLkYKrROPe35wYgjLOjgm0WDhr0gFORRGO5kS4BYdg3En6s2Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECb9gujN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECb9gujN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CEB1F000E9;
	Tue, 21 Jul 2026 17:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655974;
	bh=ZIX6moy9zr5HusL59wmhBlHpZ/kWVFJW8ojE6aMCPHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECb9gujNexCTU/vdTIp1We0JAKRoMYolpgJQygO6qk6VVlZCEGSQsyR2rzITSw6P8
	 J7yMj/TUec8ZgdCTreWRxHWPFeCW5DaMhI3t2XQSfg4sVpCCWoNPClqXkHNSuceUgG
	 uN+G88aHWARbsPjGM1C5SPibxLNoTYZ/PUckQbRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0212/1611] gpu: nova-core: replace `as` with `from` conversions where possible
Date: Tue, 21 Jul 2026 17:05:28 +0200
Message-ID: <20260721152519.743741378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit 9a3c2f8a4f84960a48c056d0da88de3d09e6d622 ]

The `as` operator is best avoided as it silently drops bits if the
destination type is smaller that the source.

For data types where this is clearly not the case, use `from` to
unambiguously signal that these conversions are lossless.

Acked-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Message-ID: <20251029-nova-as-v3-1-6a30c7333ad9@nvidia.com>
Stable-dep-of: 237c252be0db ("gpu: nova-core: vbios: read BitToken using FromBytes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/falcon/hal/ga102.rs |  6 ++--
 drivers/gpu/nova-core/firmware/fwsec.rs   |  4 +--
 drivers/gpu/nova-core/vbios.rs            | 42 +++++++++++------------
 3 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/nova-core/falcon/hal/ga102.rs b/drivers/gpu/nova-core/falcon/hal/ga102.rs
index 0b1cbe7853b3e8..9db112736f354f 100644
--- a/drivers/gpu/nova-core/falcon/hal/ga102.rs
+++ b/drivers/gpu/nova-core/falcon/hal/ga102.rs
@@ -42,11 +42,9 @@ fn signature_reg_fuse_version_ga102(
     engine_id_mask: u16,
     ucode_id: u8,
 ) -> Result<u32> {
-    const NV_FUSE_OPT_FPF_SIZE: u8 = regs::NV_FUSE_OPT_FPF_SIZE as u8;
-
     // Each engine has 16 ucode version registers numbered from 1 to 16.
-    let ucode_idx = match ucode_id {
-        1..=NV_FUSE_OPT_FPF_SIZE => (ucode_id - 1) as usize,
+    let ucode_idx = match usize::from(ucode_id) {
+        ucode_id @ 1..=regs::NV_FUSE_OPT_FPF_SIZE => ucode_id - 1,
         _ => {
             dev_err!(dev, "invalid ucode id {:#x}", ucode_id);
             return Err(EINVAL);
diff --git a/drivers/gpu/nova-core/firmware/fwsec.rs b/drivers/gpu/nova-core/firmware/fwsec.rs
index 8edbb5c0572c9d..dd3420aaa2bf29 100644
--- a/drivers/gpu/nova-core/firmware/fwsec.rs
+++ b/drivers/gpu/nova-core/firmware/fwsec.rs
@@ -259,13 +259,13 @@ impl FirmwareDmaObject<FwsecFirmware, Unsigned> {
         }
 
         // Find the DMEM mapper section in the firmware.
-        for i in 0..hdr.entry_count as usize {
+        for i in 0..usize::from(hdr.entry_count) {
             let app: &FalconAppifV1 =
             // SAFETY: we have exclusive access to `dma_object`.
             unsafe {
                 transmute(
                     &dma_object,
-                    hdr_offset + hdr.header_size as usize + i * hdr.entry_size as usize
+                    hdr_offset + usize::from(hdr.header_size) + i * usize::from(hdr.entry_size)
                 )
             }?;
 
diff --git a/drivers/gpu/nova-core/vbios.rs b/drivers/gpu/nova-core/vbios.rs
index 46e67f0c6901c0..8bbee9a53b38df 100644
--- a/drivers/gpu/nova-core/vbios.rs
+++ b/drivers/gpu/nova-core/vbios.rs
@@ -325,7 +325,7 @@ impl PcirStruct {
 
     /// Calculate image size in bytes from 512-byte blocks.
     fn image_size_bytes(&self) -> usize {
-        self.image_len as usize * 512
+        usize::from(self.image_len) * 512
     }
 }
 
@@ -403,13 +403,13 @@ impl BitToken {
         let header = &image.bit_header;
 
         // Offset to the first token entry
-        let tokens_start = image.bit_offset + header.header_size as usize;
+        let tokens_start = image.bit_offset + usize::from(header.header_size);
 
-        for i in 0..header.token_entries as usize {
-            let entry_offset = tokens_start + (i * header.token_size as usize);
+        for i in 0..usize::from(header.token_entries) {
+            let entry_offset = tokens_start + (i * usize::from(header.token_size));
 
             // Make sure we don't go out of bounds
-            if entry_offset + header.token_size as usize > image.base.data.len() {
+            if entry_offset + usize::from(header.token_size) > image.base.data.len() {
                 return Err(EINVAL);
             }
 
@@ -565,7 +565,7 @@ impl NpdeStruct {
 
     /// Calculate image size in bytes from 512-byte blocks.
     fn image_size_bytes(&self) -> usize {
-        self.subimage_len as usize * 512
+        usize::from(self.subimage_len) * 512
     }
 
     /// Try to find NPDE in the data, the NPDE is right after the PCIR.
@@ -577,8 +577,8 @@ impl NpdeStruct {
     ) -> Option<Self> {
         // Calculate the offset where NPDE might be located
         // NPDE should be right after the PCIR structure, aligned to 16 bytes
-        let pcir_offset = rom_header.pci_data_struct_offset as usize;
-        let npde_start = (pcir_offset + pcir.pci_data_struct_len as usize + 0x0F) & !0x0F;
+        let pcir_offset = usize::from(rom_header.pci_data_struct_offset);
+        let npde_start = (pcir_offset + usize::from(pcir.pci_data_struct_len) + 0x0F) & !0x0F;
 
         // Check if we have enough data
         if npde_start + core::mem::size_of::<Self>() > data.len() {
@@ -772,7 +772,7 @@ impl BiosImageBase {
             .inspect_err(|e| dev_err!(dev, "Failed to create PciRomHeader: {:?}\n", e))?;
 
         // Get the PCI Data Structure using the pointer from the ROM header.
-        let pcir_offset = rom_header.pci_data_struct_offset as usize;
+        let pcir_offset = usize::from(rom_header.pci_data_struct_offset);
         let pcir_data = data
             .get(pcir_offset..pcir_offset + core::mem::size_of::<PcirStruct>())
             .ok_or(EINVAL)
@@ -840,12 +840,12 @@ impl PciAtBiosImage {
         let token = self.get_bit_token(BIT_TOKEN_ID_FALCON_DATA)?;
 
         // Make sure we don't go out of bounds
-        if token.data_offset as usize + 4 > self.base.data.len() {
+        if usize::from(token.data_offset) + 4 > self.base.data.len() {
             return Err(EINVAL);
         }
 
         // read the 4 bytes at the offset specified in the token
-        let offset = token.data_offset as usize;
+        let offset = usize::from(token.data_offset);
         let bytes: [u8; 4] = self.base.data[offset..offset + 4].try_into().map_err(|_| {
             dev_err!(self.base.dev, "Failed to convert data slice to array");
             EINVAL
@@ -921,9 +921,9 @@ impl PmuLookupTable {
             return Err(EINVAL);
         }
 
-        let header_len = data[1] as usize;
-        let entry_len = data[2] as usize;
-        let entry_count = data[3] as usize;
+        let header_len = usize::from(data[1]);
+        let entry_len = usize::from(data[2]);
+        let entry_count = usize::from(data[3]);
 
         let required_bytes = header_len + (entry_count * entry_len);
 
@@ -946,9 +946,9 @@ impl PmuLookupTable {
 
         Ok(PmuLookupTable {
             version: data[0],
-            header_len: header_len as u8,
-            entry_len: entry_len as u8,
-            entry_count: entry_count as u8,
+            header_len: data[1],
+            entry_len: data[2],
+            entry_count: data[3],
             table_data,
         })
     }
@@ -958,7 +958,7 @@ impl PmuLookupTable {
             return Err(EINVAL);
         }
 
-        let index = (idx as usize) * self.entry_len as usize;
+        let index = (usize::from(idx)) * usize::from(self.entry_len);
         PmuLookupTableEntry::new(&self.table_data[index..])
     }
 
@@ -1127,8 +1127,8 @@ impl FwSecBiosImage {
     pub(crate) fn sigs(&self, desc: &FalconUCodeDescV3) -> Result<&[Bcrt30Rsa3kSignature]> {
         // The signatures data follows the descriptor.
         let sigs_data_offset = self.falcon_ucode_offset + core::mem::size_of::<FalconUCodeDescV3>();
-        let sigs_size =
-            desc.signature_count as usize * core::mem::size_of::<Bcrt30Rsa3kSignature>();
+        let sigs_count = usize::from(desc.signature_count);
+        let sigs_size = sigs_count * core::mem::size_of::<Bcrt30Rsa3kSignature>();
 
         // Make sure the data is within bounds.
         if sigs_data_offset + sigs_size > self.base.data.len() {
@@ -1148,7 +1148,7 @@ impl FwSecBiosImage {
                     .as_ptr()
                     .add(sigs_data_offset)
                     .cast::<Bcrt30Rsa3kSignature>(),
-                desc.signature_count as usize,
+                sigs_count,
             )
         })
     }
-- 
2.53.0



