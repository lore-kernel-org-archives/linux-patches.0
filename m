Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46A7E3D3001;
	Thu, 17 Sep 2026 19:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671683; cv=none; b=ciM677XCxyZ5OulE+T0+/FGWHtKJ4IT1GESOzBmWrbe154HLfF03VNTJIwCF4P2jGUishOd/01wnHrwjWdDb0UCMVroZuB6dRTIMKSrXjwI+efA4N/uhjQTp5YKHVcdpAykzQKmjGGS3uATzMPO6K/TlInWB3ZmH9HsElmiPDRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671683; c=relaxed/simple;
	bh=UYXXltDdNJycU4aYaHv3RgDty1TjLIkA8GoKw5gXjEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjJ9/qQrjBTXRu1jF3G/BCbuIFGL4e4Cy+DFR38ijvZj3jMvP12HEU/wfVE4LofgtObYKWxhBU3MqB27KYGOwgntCZzcRmO+knlH+NB/0KfNHSGviMLFoS/AvdXMSc3JDSYxdNsbVp3iqKMpghQ0PzE4en5eXeMMg9dE/ZbRUoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JJ9z/mMv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JJ9z/mMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5F21F0089D;
	Thu, 17 Sep 2026 19:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671651;
	bh=5WPuCgw6b2+hVW6qwF34UT0YPAeOM+Osnbk03cxHlwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJ9z/mMvXwxSoob/q3rTcqHqGs8lKR23XVg6EZf1synNza4QLuvXHWTSUHuqJPlCs
	 k4hER9ravs0SikStEdFS0GnFsh37wk+F4JP+WeXarpGnE9pO7MIUm3Hdp1vlzcC7/W
	 JOJ9jmv365IxBTTRcd9JUENOzWoDr1G9I5IEcp4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko@linuxfoundation.org>,
	Terry Bowman <terry.bowman@amd.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1008/1102] cxl/ras: Fix cxl_rch_get_aer_info() out-of-bounds AER register read
Date: Thu, 17 Sep 2026 16:15:51 +0100
Message-ID: <20260917151606.052398665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


