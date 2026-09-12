Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6474C208D0;
	Sat, 12 Sep 2026 09:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206048; cv=none; b=HTO8EIIsHUJHS2T+jckccWz/wo7vAGdVW6GLHsGBiLPedWvf4YbMVnoI8gyJajVuV1TK3BOWSwJMsi5FbVDvsM23BMgsQabvKsJZyqa/NrJVj3najHxNUZqJlMLWtDw2g9LAyDTTFXBv/yYUSygRXAuc7bV9U5TTwGCHJzo0aZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206048; c=relaxed/simple;
	bh=plv6+kqqnErIDwHiSdalilcf4hgiGtkWRbK2utPVGR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSHDhIOOdgO9bOjWzetCc3uiT4S80Kz3Qg5vpeC8pQeBwJ72h6sMvPv3QyGWzIOHhG15Cxy8RXtj2igJxdhlc1xm+jJhei/Si+94HrRwEXCyV8/O0IQijOrfnRkQbV7LfgQORpMoxGz21WTUf76LHxf+5ecQ2FP8Jbu0rmjxTg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVWitGrB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVWitGrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F581F000FF;
	Sat, 12 Sep 2026 09:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206047;
	bh=MRuYiJwe75vMLOjGx48XjRzS0APiX3FUbJ6nm3gKIz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gVWitGrBg5iHgjr3hFOEnLqbRAdlU2XqRrUcA201bAEfFJTws41OcskLI89qf7N50
	 BOPi63ek8ucGJNDZ8Ud0C096eovqEh3EHsTbfYerxIZNf4YHusFo+BkKdrvrjH0iCD
	 mEdVuRKx9opAFEH9Tba6JG/eUKEbN1FuFNmJ/KWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Wei Hou <wei.hou@scaleflux.com>,
	Li Ming <ming.li@zohomail.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0125/1518] cxl/pci: Remove incorrect mbox.valid check in cxl_pci_type3_init_mailbox()
Date: Sat, 12 Sep 2026 08:38:14 +0200
Message-ID: <20260912065626.315953179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Wei Hou <wei.hou@scaleflux.com>

[ Upstream commit d79b81893d0cc93737e811a465b9ef9a00156fd5 ]

The driver's design intent is that missing or malformed component
registers should not prevent mailbox initialization. cxl_pci_probe()
already reflects this: the CXL_REGLOC_RBI_COMPONENT setup path only
emits a dev_warn() and continues when component registers are absent,
rather than returning an error.

The check 'if (!cxlds->reg_map.device_map.mbox.valid)' violates this
intent and is also technically incorrect for two reasons:

1. Wrong struct: the MEMDEV register block is enumerated into a local
   variable 'map', not into 'cxlds->reg_map'. The device_map.mbox.valid
   field inside cxlds->reg_map is never written by the MEMDEV probe and
   will always read as zero regardless of actual hardware capability.

2. Already validated: cxl_pci_setup_regs(CXL_REGLOC_RBI_MEMDEV) calls
   cxl_probe_regs() which explicitly checks mbox.valid and returns
   -ENXIO if the mailbox is absent. If that check passes, the mailbox is
   guaranteed to be present by the time cxl_pci_type3_init_mailbox() is
   called.

The value that the check actually reads is component_map.ras.valid,
which aliases device_map.mbox.valid in the union. This is populated by
the COMPONENT probe, not the MEMDEV probe. On devices where the
component register BAR does not implement a CXL Component Capability
Array (e.g. certain DCD devices), cxl_probe_component_regs() returns
early leaving ras.valid=false. Through the union, this makes mbox.valid
read as false, causing cxl_pci_type3_init_mailbox() to return -ENODEV
(-19) even though the mailbox hardware is fully functional.

Remove the check. Mailbox presence has already been validated by
cxl_pci_setup_regs(CXL_REGLOC_RBI_MEMDEV). The presence or absence of
component registers is irrelevant to mailbox initialization.

Fixes: 8d8081cecfb9 ("cxl: Move mailbox related bits to the same context")
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Signed-off-by: Wei Hou <wei.hou@scaleflux.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://patch.msgid.link/20260628155857.239866-1-wei.hou@scaleflux.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/pci.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 2c42ab75e56a8..24fb1b230ca02 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -807,12 +807,6 @@ static int cxl_pci_type3_init_mailbox(struct cxl_dev_state *cxlds)
 {
 	int rc;
 
-	/*
-	 * Fail the init if there's no mailbox. For a type3 this is out of spec.
-	 */
-	if (!cxlds->reg_map.device_map.mbox.valid)
-		return -ENODEV;
-
 	rc = cxl_mailbox_init(&cxlds->cxl_mbox, cxlds->dev);
 	if (rc)
 		return rc;
-- 
2.53.0



