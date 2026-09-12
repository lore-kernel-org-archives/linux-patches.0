Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB693DA7D2;
	Sat, 12 Sep 2026 08:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201922; cv=none; b=uo5U3SPTS7JZxnt+CQuLrmdGXcLlD74VCzNYipT8wsN3BUxw2zoUuyEfsnL0KNkz7smVe+7jnISk+J5Wkp0/gS/pqHUttBubLxgG5ZAGRySW9jUvZ7TYTrF1MCXdZyEXeAkKrrVGk5IbnEBZieGgSbYlFZnu+AfCYCvImxoW7Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201922; c=relaxed/simple;
	bh=V/dhNo72VDKR6Efq0K85RFhaPBZzYo2oWWLrHOpxNFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDv/zrFyqbQKrmAhWxxmI2RYE6sLAxP7vjVFp0UtktAIMhpEazgplXuK3GLKuxVetGJlNEtJF9LSqIlsEjfeeQb7TIh+GsdDNfgLM7qq2Hi7IQnkbfgWrocvVRPT+LAlrIfUtL+7WUIm+Z0EX91UTwgvwW7Sb+/599EvbsmA9es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkJbiCc9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkJbiCc9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69631F00893;
	Sat, 12 Sep 2026 08:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201916;
	bh=7Nc9rwxIwS3lzV0rJD0rOM7oFeGm5EXxpWePlhJmrsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vkJbiCc9hoOypccTD6vHZSenRpTc4XsICT2YApsRXoHUzj5UKeYpQO0Vej4H/tUI9
	 /40ndlAAHtpIVsjn0yP55y236WydKC7PY5vPy6HThhYy8PA1jHqvQKnq/pOTlA5Nzx
	 mwSValQr7XP9HmJxRo1Rl85lslpe1WDDXcJjkQ6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1093/1815] gpu: nova-core: factor out common FSP message header
Date: Sat, 12 Sep 2026 08:47:23 +0200
Message-ID: <20260912065714.679868549@linuxfoundation.org>
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

From: Zhi Wang <zhiw@nvidia.com>

[ Upstream commit 56006044df9c65e8e179b236851bcdf4406f2164 ]

Extract common MCTP + NVDM headers into FspMessageHeader, rename
FspMessage to FspCotMessage, and update FspResponse to use the shared
header. This prepares for adding new FSP message types.

Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Link: https://patch.msgid.link/20260604114339.1565660-3-zhiw@nvidia.com
Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Stable-dep-of: 5c9deba5578d ("gpu: nova-core: correct FRTS vidmem offset calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/nova-core/fsp.rs | 56 +++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/nova-core/fsp.rs b/drivers/gpu/nova-core/fsp.rs
index 8fc243c66e356..78b90bfbfba4a 100644
--- a/drivers/gpu/nova-core/fsp.rs
+++ b/drivers/gpu/nova-core/fsp.rs
@@ -57,12 +57,35 @@ struct NvdmPayloadCommandResponse {
     error_code: u32,
 }
 
-/// Complete FSP response structure with MCTP and NVDM headers.
+/// Common MCTP and NVDM headers shared by all FSP messages.
 #[repr(C, packed)]
 #[derive(Clone, Copy)]
-struct FspResponse {
+struct FspMessageHeader {
     mctp_header: MctpHeader,
     nvdm_header: NvdmHeader,
+}
+
+// SAFETY: FspMessageHeader is a packed C struct with only integral fields.
+unsafe impl AsBytes for FspMessageHeader {}
+
+// SAFETY: FspMessageHeader is a packed C struct with only integral fields.
+unsafe impl FromBytes for FspMessageHeader {}
+
+impl FspMessageHeader {
+    /// Construct a standard FSP message header for the given NVDM type.
+    fn new(nvdm_type: NvdmType) -> Self {
+        Self {
+            mctp_header: MctpHeader::single_packet(),
+            nvdm_header: NvdmHeader::new(nvdm_type),
+        }
+    }
+}
+
+/// Complete FSP response structure with MCTP and NVDM headers.
+#[repr(C, packed)]
+#[derive(Clone, Copy)]
+struct FspResponse {
+    header: FspMessageHeader,
     response: NvdmPayloadCommandResponse,
 }
 
@@ -94,17 +117,16 @@ struct NvdmPayloadCot {
     gsp_boot_args_sysmem_offset: u64,
 }
 
-/// Complete FSP message structure with MCTP and NVDM headers.
+/// Complete FSP COT (Chain of Trust) message structure.
 #[repr(C)]
 #[derive(Clone, Copy)]
-struct FspMessage {
-    mctp_header: MctpHeader,
-    nvdm_header: NvdmHeader,
+struct FspCotMessage {
+    header: FspMessageHeader,
     cot: NvdmPayloadCot,
 }
 
-impl FspMessage {
-    /// Returns an in-place initializer for [`FspMessage`].
+impl FspCotMessage {
+    /// Returns an in-place initializer for [`FspCotMessage`].
     fn new<'a>(
         fb_layout: &FbLayout,
         fsp_fw: &'a FspFirmware,
@@ -131,8 +153,7 @@ impl FspMessage {
         let size = num::usize_into_u16::<{ core::mem::size_of::<NvdmPayloadCot>() }>();
 
         Ok(init!(Self {
-            mctp_header: MctpHeader::single_packet(),
-            nvdm_header: NvdmHeader::new(NvdmType::Cot),
+            header: FspMessageHeader::new(NvdmType::Cot),
             // The payload is packed, so we cannot use `init!`. Initialize it member-by-member using
             // `chain`.
             cot <- pin_init::init_zeroed(),
@@ -153,11 +174,11 @@ impl FspMessage {
     }
 }
 
-// SAFETY: `FspMessage` is `#[repr(C)]` with no padding, so all of its
+// SAFETY: `FspCotMessage` is `#[repr(C)]` with no padding, so all of its
 // bytes are initialized.
-unsafe impl AsBytes for FspMessage {}
+unsafe impl AsBytes for FspCotMessage {}
 
-impl MessageToFsp for FspMessage {
+impl MessageToFsp for FspCotMessage {
     const NVDM_TYPE: NvdmType = NvdmType::Cot;
 }
 
@@ -251,8 +272,8 @@ impl Fsp {
             EIO
         })?;
 
-        let mctp_header = response.mctp_header;
-        let nvdm_header = response.nvdm_header;
+        let mctp_header = response.header.mctp_header;
+        let nvdm_header = response.header.nvdm_header;
         let command_nvdm_type = response.response.command_nvdm_type;
         let error_code = response.response.error_code;
 
@@ -310,7 +331,10 @@ impl Fsp {
     ) -> Result {
         dev_dbg!(dev, "Starting FSP boot sequence for {}\n", args.chipset);
 
-        let msg = KBox::init(FspMessage::new(fb_layout, &self.fsp_fw, args)?, GFP_KERNEL)?;
+        let msg = KBox::init(
+            FspCotMessage::new(fb_layout, &self.fsp_fw, args)?,
+            GFP_KERNEL,
+        )?;
 
         self.send_sync_fsp(dev, bar, &*msg)?;
 
-- 
2.53.0



