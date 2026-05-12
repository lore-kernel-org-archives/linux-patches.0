Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F213E5A2A;
	Tue, 12 May 2026 17:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608157; cv=none; b=ZPBYAho7NgqfM4ayTAiklLlOBUljogj4wg8rtwPgBFCrj33f0V4HD9yKti1HEJvi6p5gNR+mYL0MBAXu1sbgP/PC697Py+A1X7shh2fjtezb5D4PIk/ryzODfQnPR4sHLK45RonsWO/Ai46vv1KGn/zY+JdLBfynGruXsWlzNDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608157; c=relaxed/simple;
	bh=nSUVsWgzdZohcXrzJJch+CQEBAyCc0APCP77GmMQdTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcsD97Nm0cvUC3PjR3HWoOFwtpX1mek2Ne69rYyGyZVXClG5NixMWz05cnGWXDdKAa1Y+IwSzY68Il3gP7XVhicgcfBlwdBytJeYoyiXwgncq5EQJ5la34vvyKpC9UEXsnuvByVOhE5BcY82QTkjJk3WLxg2b0nHCDuTjEjRwMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2c3C57L6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2c3C57L6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3C8C2BCC7;
	Tue, 12 May 2026 17:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608157;
	bh=nSUVsWgzdZohcXrzJJch+CQEBAyCc0APCP77GmMQdTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2c3C57L6OX4wpLV9LwmDW4TqOCiNNCkZ9bhp24hcTluV7nNEXRS5x2PtBpeKc2u6J
	 CCWHeDI8HIbC46NG7Bk+C2CDPuiz2EhZiCyY1LoVe8H7MT2+X/i0ZbKcTHNFOg0voL
	 niLU4UwL88xLL5g78gkxQUHW4rI0rhFpB155MqTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Li <lichao@loongson.cn>,
	Dongyan Qian <qiandongyan@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 177/206] LoongArch: Use per-root-bridge PCIH flag to skip mem resource fixup
Date: Tue, 12 May 2026 19:40:29 +0200
Message-ID: <20260512173936.609258085@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 49f33840dcc907d21313d369e34872880846b61c upstream.

When firmware enables 64-bit PCI host bridge support, some root bridges
already provide valid 64-bit mem resource windows through ACPI.

In this case, the LoongArch-specific mem resource high-bits fixup in
acpi_prepare_root_resources() should not be applied unconditionally.
Otherwise, the kernel may override the native resource layout derived
from firmware, and later BAR assignment can fail to place device BARs
into the intended 64-bit address space correctly.

Add a per-root-bridge ACPI flag, PCIH, and evaluate it from the current
root bridge device scope. When PCIH is set, skip the mem resource high-
bits fixup path and let the kernel use the firmware-provided resource
description directly. When PCIH is absent or cleared, keep the existing
behavior and continue filling the high address bits from the host bridge
address.

This makes the behavior per-root-bridge configurable and avoids breaking
valid 64-bit BAR space allocation on bridges whose 64-bit windows have
already been fully described by firmware.

Cc: stable@vger.kernel.org
Suggested-by: Chao Li <lichao@loongson.cn>
Tested-by: Dongyan Qian <qiandongyan@loongson.cn>
Signed-off-by: Dongyan Qian <qiandongyan@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/pci/acpi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/loongarch/pci/acpi.c
+++ b/arch/loongarch/pci/acpi.c
@@ -61,11 +61,16 @@ static void acpi_release_root_info(struc
 static int acpi_prepare_root_resources(struct acpi_pci_root_info *ci)
 {
 	int status;
+	unsigned long long pci_h = 0;
 	struct resource_entry *entry, *tmp;
 	struct acpi_device *device = ci->bridge;
 
 	status = acpi_pci_probe_root_resources(ci);
 	if (status > 0) {
+		acpi_evaluate_integer(device->handle, "PCIH", NULL, &pci_h);
+		if (pci_h)
+			return status;
+
 		resource_list_for_each_entry_safe(entry, tmp, &ci->resources) {
 			if (entry->res->flags & IORESOURCE_MEM) {
 				entry->offset = ci->root->mcfg_addr & GENMASK_ULL(63, 40);


