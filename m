Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DE457D22B;
	Wed,  9 Sep 2026 14:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964552; cv=none; b=iwv5Ua5g4X9APdfbhsJ/20zr2A6O6z/GM7fAo1uMFmuSNrpqyIBYiuHeq4/2eVbX9/KAlt9rYU/9cC4Ym998WgUu5iumegfoi9aBkfZEz+X7CJRepKyteq6dADdZLGpOSECW0xTeZa3xF3Huc+1hM6R7A8hz+lx/dmhCaZjTa/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964552; c=relaxed/simple;
	bh=wlwJ/u+iTFfWaFl8wIr59OByychL7rnDJpRP9/FDxGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8/d8ObUNYqY47s1ogoiUf+dsUNc1bRYFnsUgDOMy5NNVJ4Plwxqwe+YKvoXW24BpAZsadVaofItNsOORdyHoZ/vSiBxjbNsPuErKilH69hadxVi8JkEvUNI8khPwd5g1vY/X/LSN2UTnXmmMKloO+nOEzgEBO/kFlrA+8EK3L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWmcsi9+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWmcsi9+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C2D1F00A3A;
	Wed,  9 Sep 2026 14:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964551;
	bh=cARFXFRPvP581whQA6imm2CxhiuuNBkAXjcYiPsibSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWmcsi9+ienwRtzDpxCTWMRZ54n4jFMzlcgUJSotJFlNfx+G3ROje0j7Ws2FYRqeg
	 /u6yBGPsYBeJQ0B2ePDQqh9sgSVzJuNjZqJmrCx98EzUwMzi8EGZHPfYIVQ88RkOeU
	 EGGIEd2fS7LYnvONXaGiUhqLzhWpJyP9N3DmaSlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko@linuxfoundation.org>,
	Terry Bowman <terry.bowman@amd.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 462/583] cxl/ras: Fix cxl_rch_get_aer_info() out-of-bounds AER register read
Date: Wed,  9 Sep 2026 15:42:27 +0200
Message-ID: <20260909134253.915617709@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Terry Bowman <terry.bowman@amd.com>

[ Upstream commit 29458e62d0829cbc99435f3e44fd560f9bbf1da7 ]

cxl_rch_get_aer_info() copies the RCH Downstream Port AER capability from
the RCRB MMIO block using a readl() loop bounded by sizeof(struct
aer_capability_regs). This struct is a software layout and its embedded
struct pcie_tlp_log is larger than the on-wire AER capability. As a
result the loop reads past the mapped AER register block.

The over-read also populates the software-only tail fields including
header_log.header_len. An out-of-range header_len passed to
pcie_print_tlp_log() can then loop past the header log buffer and cause
a second out-of-bounds read.

The read was correct when introduced, but struct pcie_tlp_log has since
grown (Header Log and TLP Prefix Log sizes, header_len and flit fields),
so sizeof(struct aer_capability_regs) no longer matches the physical AER
capability.

Bound the read to the physical AER registers, header through the 16 byte
Header Log. Zero the destination first so the software-only fields are
deterministic.

Fixes: 6ac07883dbb5 ("cxl/pci: Add RCH downstream port error logging")
Reported-by: Sashiko <sashiko@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260803221810.3685703-2-terry.bowman@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/ras_rch.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/drivers/cxl/core/ras_rch.c
+++ b/drivers/cxl/core/ras_rch.c
@@ -58,13 +58,28 @@ void cxl_disable_rch_root_ints(struct cx
 static bool cxl_rch_get_aer_info(void __iomem *aer_base,
 				 struct aer_capability_regs *aer_regs)
 {
-	int read_cnt = sizeof(struct aer_capability_regs) / sizeof(u32);
+	/*
+	 * Bound the copy to the physically-defined AER registers (header
+	 * through the 16-byte Header Log). struct aer_capability_regs is a
+	 * software layout whose embedded struct pcie_tlp_log is larger than
+	 * the on-wire AER capability; copying sizeof(*aer_regs) would
+	 * over-read the RCRB-mapped MMIO block.
+	 */
+	int read_cnt = (PCI_ERR_HEADER_LOG + 16) / sizeof(u32);
 	u32 *aer_regs_buf = (u32 *)aer_regs;
 	int n;
 
 	if (!aer_base)
 		return false;
 
+	/*
+	 * Zero the destination so the software-only tail fields
+	 * (e.g. header_log.header_len) are deterministic rather than
+	 * left as uninitialized stack, which could drive a bogus loop
+	 * length in pcie_print_tlp_log().
+	 */
+	memset(aer_regs, 0, sizeof(*aer_regs));
+
 	/* Use readl() to guarantee 32-bit accesses */
 	for (n = 0; n < read_cnt; n++)
 		aer_regs_buf[n] = readl(aer_base + n * sizeof(u32));


