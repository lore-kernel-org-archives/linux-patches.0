Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B23304BCD;
	Sat, 25 Oct 2025 16:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409083; cv=none; b=hHIIQIuyhu4CH+J0s7hUlUDazB24h8zfqgmi9qkCnvK3pVPTIMm+KDqOIjgkO5Y6gHsWjhLk8UNw28ye7xzgyauPnqPYif4wtZTwOqs1X0dJOab64ux1h4co6zsdELk+9ps+CXWBMRrEoC0XLKTKUPIA1XHTXe+8ed/NIcYVmwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409083; c=relaxed/simple;
	bh=AyNy1tlQLGAKwjtMvADfL8C+bUqQfeWSjDArGuoYiRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YZrobiZJZU+LRdG3+TkE7vhnXFmz0FCwdgzBjdOlfuVMACIxsywHlttjzGlPyzdL587exSvUTpgkho99UtVgg5SGBQBnSiYHqPlRD+Q018OadTovqc9aaKTRTXZsdX74GpM9RdHFtdo4c1v6eITmBrEpFCQz7eBZEsxt38/ZH3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOc05IUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOc05IUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19A1C4CEFF;
	Sat, 25 Oct 2025 16:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409083;
	bh=AyNy1tlQLGAKwjtMvADfL8C+bUqQfeWSjDArGuoYiRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOc05IUi88N9CSd0dVsY1BamktuGF4oBisvZ0ZzudnvWSK9Msdw65ka0Z54FrF1OS
	 LhIPS7QpVwQlvIH5T64RXTKsoyUS+mEujW5LjsH4zJ5GVdI8HaaANkLALUgE0JwneR
	 LTNS11ZTu0z35QnKD0CicP+VI1N90kWfP7q7nfTaerrkD2qGzs+ofi82h3iw4gEyJi
	 TJ2VcK8makDy3xKapXypgY2PL8VHlZR97TGFw7a5nVp7JK1sRyTV3OVlUsJsHAknGk
	 yBgETYhsU5l0cL9On5kSYIs+9il0kIRUv1GQxCTbU31pIB5Eo9UNqOanzYd9Jl2jO2
	 uxIem9iAE4gxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kwilczynski@kernel.org,
	Frank.Li@nxp.com,
	jiangwang@kylinos.cn,
	khalfella@gmail.com,
	alexandre.f.demers@gmail.com,
	dlemoal@kernel.org,
	shinichiro.kawasaki@wdc.com
Subject: [PATCH AUTOSEL 6.17-6.12] PCI: endpoint: pci-epf-test: Limit PCIe BAR size for fixed BARs
Date: Sat, 25 Oct 2025 11:57:06 -0400
Message-ID: <20251025160905.3857885-195-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit d5f6bd3ee3f5048f272182dc91675c082773999e ]

Currently, the test allocates BAR sizes according to fixed table bar_size.
This does not work with controllers which have fixed size BARs that are
smaller than the requested BAR size. One such controller is Renesas R-Car
V4H PCIe controller, which has BAR4 size limited to 256 bytes, which is
much less than one of the BAR size, 131072 currently requested by this
test. A lot of controllers drivers in-tree have fixed size BARs, and they
do work perfectly fine, but it is only because their fixed size is larger
than the size requested by pci-epf-test.c

Adjust the test such that in case a fixed size BAR is detected, the fixed
BAR size is used, as that is the only possible option.

This helps with test failures reported as follows:

  pci_epf_test pci_epf_test.0: requested BAR size is larger than fixed size
  pci_epf_test pci_epf_test.0: Failed to allocate space for BAR4

Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
[mani: reworded description]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20250905184240.144431-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation
- Fixes a real test failure. The test function previously requested
  hard-coded BAR sizes from `bar_size[]`, e.g., `BAR_4` = 131072 bytes
  (128 KiB) in `drivers/pci/endpoint/functions/pci-epf-test.c:105`. On
  controllers with smaller fixed-size BARs (e.g., Renesas R-Car V4H BAR4
  = 256 bytes), `pci_epf_alloc_space()` rejected the request and the
  test failed with:
  - "requested BAR size is larger than fixed size"
  - "Failed to allocate space for BAR4"
  These messages originate from the fixed-size enforcement in
`pci_epf_alloc_space()` (drivers/pci/endpoint/pci-epf-core.c:267 and
error at drivers/pci/endpoint/pci-epf-core.c:282).

- Minimal, targeted change in the EPF test. The patch adjusts the
  allocation loop so that for each non-register BAR it first checks if
  the EPC declares the BAR as fixed-size and, if so, requests that exact
  size instead of the hard-coded test size:
  - Added fixed-size check and selection:
    drivers/pci/endpoint/functions/pci-epf-test.c:1070
  - Uses `fixed_size` for fixed BARs; otherwise falls back to
    `bar_size[]`: drivers/pci/endpoint/functions/pci-epf-test.c:1071 and
    drivers/pci/endpoint/functions/pci-epf-test.c:1073
  - Passes the selected size into `pci_epf_alloc_space()`:
    drivers/pci/endpoint/functions/pci-epf-test.c:1075

- Aligns with existing EPC semantics. `pci_epf_alloc_space()` already
  enforces fixed-size BARs by returning NULL when a request exceeds the
  fixed size and coerces accepted requests to the hardware’s fixed size
  (drivers/pci/endpoint/pci-epf-core.c:267 and drivers/pci/endpoint/pci-
  epf-core.c:282). The change avoids over-sized requests up front,
  preventing spurious failures, and is consistent with what
  `pci_epf_alloc_space()` would have done anyway.

- Does not alter critical behavior for the register BAR. The test still
  computes the register BAR size as register space + optional MSI-X
  table + PBA and allocates that for the chosen `test_reg_bar`
  (drivers/pci/endpoint/functions/pci-epf-test.c:1046–1055). If a
  controller’s register BAR itself is fixed and too small to hold the
  required registers/MSI-X structures, failing is correct because the
  test cannot run on such hardware.

- Low regression risk:
  - Scope-limited to a test EPF driver (`pci-epf-test`). No UAPI or ABI
    changes.
  - For controllers whose fixed size is larger than the test’s
    `bar_size[]`, this change merely allocates the larger, correct fixed
    size that hardware requires (previously `pci_epf_alloc_space()`
    would coerce the result to fixed size anyway).
  - If `fixed_size` is reported as zero (misconfigured or unsupported
    case), `pci_epf_alloc_space()` still falls back to a minimum sane
    allocation (128 bytes), preserving prior behavior.

- Clear user impact: It addresses real-world failures on controllers
  with smaller fixed BARs (e.g., Renesas R-Car Gen4 endpoints specify
  fixed-size BARs such as BAR4=256 bytes:
  drivers/pci/controller/dwc/pcie-rcar-gen4.c:426), allowing the EPF
  test to run without allocation errors.

- Meets stable backport criteria:
  - Bug fix, not a feature.
  - Small and contained.
  - Minimal risk and no architectural changes.
  - Confined to PCI endpoint test function code.

Given the above, this is a solid candidate for stable backporting.

 drivers/pci/endpoint/functions/pci-epf-test.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 044f5ea0716d1..31617772ad516 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -1067,7 +1067,12 @@ static int pci_epf_test_alloc_space(struct pci_epf *epf)
 		if (bar == test_reg_bar)
 			continue;
 
-		base = pci_epf_alloc_space(epf, bar_size[bar], bar,
+		if (epc_features->bar[bar].type == BAR_FIXED)
+			test_reg_size = epc_features->bar[bar].fixed_size;
+		else
+			test_reg_size = bar_size[bar];
+
+		base = pci_epf_alloc_space(epf, test_reg_size, bar,
 					   epc_features, PRIMARY_INTERFACE);
 		if (!base)
 			dev_err(dev, "Failed to allocate space for BAR%d\n",
-- 
2.51.0

