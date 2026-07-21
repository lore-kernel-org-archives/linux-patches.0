Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8410434F279;
	Tue, 21 Jul 2026 17:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653389; cv=none; b=CdO7mpFEqAC5Os1OupM26pMAf8AZP2rEKmE0lKN4VTAftVbiqB9sR3eQ0TYsDCOQZVvxp8uoKIIxknUNNuXnjLmCag4J/CzXzF6egukoxVsUC4DF1jUJJqjlbcryRUsXx7DHiQzuDIwRCy01d6Tfr2SGHXi0ak4tgD3GPYIKXCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653389; c=relaxed/simple;
	bh=Ly0yXVl6iXN8wLM9LGnM09doizDaSa07NSjuGcSyRx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ob9+eqLKmFY0N0Jo+OCEBJ6rJtbtiqxQOKqgaCJqIFpVnS+r4xhuIRqKgBWinHP2Barx92OldYLfG9B3NEBvYorYW0QrvesMEeYDsWELEKBUyHrQFoa+s5uh0ppJ5ggL35NN9c3j+6IMv+EXWUxryfa38AI0TdzWcjkDss6INFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CICgMxCt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CICgMxCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD2A1F000E9;
	Tue, 21 Jul 2026 17:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653388;
	bh=2XR80XjZ/Ekz5CdP984fn9dRkjMGgLCuB9GUqzew6n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CICgMxCt6pqUW+C/1NcZ9GyotA1iQU9VEkXf6QzyPxlAg2OTvZ22km6xq3j6/g7T+
	 U8qAXVfhwXtTw0DPj014dbalXgYttp1zPY4FYD+AO3BAFPPCtnrU1iVSypCeG3zn2P
	 DsCdeGdcO/FgDxkR7QDDcUhKNuHOd+CSAgfNgOIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yang.yicong@picoheart.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1308/2077] ACPI: RIMT: Only defer the IOMMU configuration in init stage
Date: Tue, 21 Jul 2026 17:16:21 +0200
Message-ID: <20260721152623.671643049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yang.yicong@picoheart.com>

[ Upstream commit b8f62414fa05144924257db283c5c35f74d21121 ]

The IOMMU configuration will be deferred if the IOMMU driver
isn't probed by the time. Make this deferral only in the
initialization stage with driver_deferred_probe_check_state().
Otherwise the devices depends on IOMMU will be deferred forever
in case the IOMMU device probe failed or it doesn't appear in
the ACPI namespace.

Fixes: 8f7729552582 ("ACPI: RISC-V: Add support for RIMT")
Signed-off-by: Yicong Yang <yang.yicong@picoheart.com>
Link: https://patch.msgid.link/20260625094702.11558-1-yang.yicong@picoheart.com
[pjw@kernel.org: added Fixes line]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/riscv/rimt.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/riscv/rimt.c b/drivers/acpi/riscv/rimt.c
index 906282b0e63c0c..e4538fa6c2c822 100644
--- a/drivers/acpi/riscv/rimt.c
+++ b/drivers/acpi/riscv/rimt.c
@@ -9,6 +9,7 @@
 
 #include <linux/acpi.h>
 #include <linux/acpi_rimt.h>
+#include <linux/device/driver.h>
 #include <linux/iommu.h>
 #include <linux/list.h>
 #include <linux/pci.h>
@@ -257,11 +258,11 @@ static int rimt_iommu_xlate(struct device *dev, struct acpi_rimt_node *node, u32
 	rimt_fwnode = rimt_get_fwnode(node);
 
 	/*
-	 * The IOMMU drivers may not be probed yet.
-	 * Defer the IOMMU configuration
+	 * The IOMMU drivers may not be probed yet. Defer the IOMMU
+	 * configuration if it's still in initialization stage.
 	 */
 	if (!rimt_fwnode)
-		return -EPROBE_DEFER;
+		return driver_deferred_probe_check_state(dev);
 
 	/*
 	 * EPROBE_DEFER ensures IOMMU is probed before the devices that
-- 
2.53.0



