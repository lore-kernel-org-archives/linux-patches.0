Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856A14B7A35;
	Thu, 17 Sep 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667767; cv=none; b=tiLJ9I9oBj/1Bb2Onks/2stiguZlCMKvrBYvalt7GtWRt5LRW4Dc07SSuTSvXo912I7eKIpyF1NiNEXtn0mOmiusXiw/d+Ewl7UftNqlcA8kRz962Voj3t79k6Vt8imGwJiZ9qRGX4nNXBS5w7TQei9ZSkg1WNCWyjQC8pncOwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667767; c=relaxed/simple;
	bh=7JD2s6dPeUDYelU0E3xRgU9CtZsGTZGETVTOBr7aTSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XiLsz6me3mVdUopJ9WM56rfZ2tAmsjFeSbOfxYVCKT/ZuAQ8MdJCf1ujtS8BCgEUdEG+VBEey/2pdSlKGjrqAJXWO+8EM+v2c0oYiopjii3bH5FFu4SsM0u2YSbpOLFsgIYKpHFZsf5RrIzTxc5KkRQQTBReTITAWgzyDbD650w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPSUIABn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPSUIABn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8591F000FF;
	Thu, 17 Sep 2026 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667766;
	bh=+1Q+D6P/gdbzQbhiKO3twMHYjMpzaXadCqN9hv12UHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPSUIABn5Cb4q8cZu1gSRr5ZIVb9TxAPzJHiP3XJKYrzJB0Van6QtnFrpZmLzAFub
	 S2rj4KCbdyfqD4CyTMmuB5pfj8i4R3/tr/khZ7v+9Y/RSO77PUILGLw6hO8jZjKJFF
	 y/ZipGpYpgc4iTTccG1ZSppEj5ghYIQTlgOIKkcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0201/1102] ACPI: scan: Honor _DEP for ACPI0016 PCI/CXL host bridge
Date: Thu, 17 Sep 2026 16:02:24 +0100
Message-ID: <20260917151544.619605485@linuxfoundation.org>
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

From: Chen Pei <cp0613@linux.alibaba.com>

[ Upstream commit bf5418a5fe63f35da35941ae896d5df121d95ffc ]

CXL root devices (ACPI0017) declare _DEP on their parent ACPI0016
PCI/CXL host bridge so that cxl_acpi probes only after acpi_pci_root
has attached the PCI root and registered it for acpi_pci_find_root().
However, acpi_dev_ready_for_enumeration() only consults dep_unmet
when the supplier's HID is on acpi_honor_dep_ids[]; otherwise the
dependency is silently ignored.

Without honoring the dependency, cxl_acpi can probe before the PCI
root is ready. The resulting CXL topology is broken: decoder targets
read as 0 and no port/endpoint devices appear under
/sys/bus/cxl/devices/.

Add ACPI0016 to acpi_honor_dep_ids[] so the _DEP declared by ACPI0017
is enforced. This relies on the preceding patch ("ACPI: PCI: clear
_DEP dependencies after PCI root bridge attach"), which releases the
dependency once the PCI root is fully enumerated; the two patches
must be applied together.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20260526025118.38935-3-cp0613@linux.alibaba.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 42f0840212e87..ae744ab62b1c0 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -871,6 +871,7 @@ static const char * const acpi_honor_dep_ids[] = {
 	"RSCV0005", /* RISC-V SBI MPXY MBOX */
 	"RSCV0006", /* RISC-V RPMI SYSMSI */
 	"PNP0C0F",  /* PCI Link Device */
+	"ACPI0016", /* CXL/PCIe host bridge: CXL root (ACPI0017) depends on PCI root attach */
 	NULL
 };
 
-- 
2.53.0



