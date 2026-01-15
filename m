Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D2A33A7F43;
	Thu, 15 Jan 2026 16:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496389; cv=none; b=Nw4g0Ib+BI535L6/SNeyqV+2oi0V4XOgwphssqVIsWFjHwEoo1r27idVgnEreufMbqwaaf36hlV5+v6sxxWHP6cQcWQ5aCG3Q/o48xMpQJ3vzoYud16bYSWJ3bF+oTq2L3I8JD+fFfILSvMEjmNKwMIoUZzQkmNpHDgNY1Y3mrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496389; c=relaxed/simple;
	bh=ImIw5xZ20LjCbBkcRY9x6Jeo8YNcN1CLTjdsVMm95hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UEh9gPiKGV+Ip5eIXrdXB5Zr4UL+pLyoCSytirMr5hKPW5CLmY1j39lDsY6pA4KB2zi7Z2WeeIfcxBFit3DBwCjlywQwPAsHTGhIkYirGeqZEghomMGseIPfhdllDiUzRIzybGeHyIzXSbSsHtGdRmlcD0qIuECgdvHBpDX9XQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsYD8Z2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsYD8Z2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF55BC116D0;
	Thu, 15 Jan 2026 16:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496389;
	bh=ImIw5xZ20LjCbBkcRY9x6Jeo8YNcN1CLTjdsVMm95hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsYD8Z2Z9kplvppA8KAV7xSFgE6EMOMI+p2ZCVUrhqssRnYEM8ij3CjNftoR9sdT3
	 ZhzjykbPu7NxBipCgRAXk7prOmnH8fWB+PFvEPr66kvr6sYq9hY4H6iwKJoEwW2FhW
	 lCjTlFS+tcd9fiohzd7IlgeTs6hA6mAkw6ga+vLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathaniel Roach <nroach44@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/181] sparc/PCI: Correct 64-bit non-pref -> pref BAR resources
Date: Thu, 15 Jan 2026 17:48:02 +0100
Message-ID: <20260115164207.550557440@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit bdb32359eab94013e80cf7e3d40a3fd4972da93a ]

SPARC T5-2 dts describes some PCI BARs as 64-bit resources without the
pref(etchable) bit (0x83... vs 0xc3... in assigned-addresses) for address
ranges above the 4G threshold. Such resources cannot be placed into a
non-prefetchable PCI bridge window that is capable only of 32-bit
addressing. As such, it looks like the platform is improperly described by
the dts.

The kernel detects this problem (see the IORESOURCE_PREFETCH check in
pci_find_parent_resource()) and fails to assign these BAR resources to the
resource tree due to lack of a compatible bridge window.

Prior to 754babaaf333 ("sparc/PCI: Remove pcibios_enable_device() as they
do nothing extra") SPARC arch code did not test whether device resources
were successfully in the resource tree when enabling a device, effectively
hiding the problem. After removing the arch-specific enable code,
pci_enable_resources() refuses to enable the device when it finds not all
mem resources are assigned, and therefore mpt3sas can't be enabled:

  pci 0001:04:00.0: reg 0x14: [mem 0x801110000000-0x80111000ffff 64bit]
  pci 0001:04:00.0: reg 0x1c: [mem 0x801110040000-0x80111007ffff 64bit]
  pci 0001:04:00.0: BAR 1 [mem 0x801110000000-0x80111000ffff 64bit]: can't claim; no compatible bridge window
  pci 0001:04:00.0: BAR 3 [mem 0x801110040000-0x80111007ffff 64bit]: can't claim; no compatible bridge window
  mpt3sas 0001:04:00.0: BAR 1 [mem size 0x00010000 64bit]: not assigned; can't enable device

For clarity, this filtered log only shows failures for one mpt3sas device
but other devices fail similarly. In the reported case, the end result with
all the failures is an unbootable system.

Things appeared to "work" before 754babaaf333 ("sparc/PCI: Remove
pcibios_enable_device() as they do nothing extra") because the resource
tree is agnostic to whether PCI BAR resources are properly in the tree or
not. So as long as there was a parent resource (e.g. a root bus resource)
that contains the address range, the resource tree code just places
resource request underneath it without any consideration to the
intermediate BAR resource. While it worked, it's incorrect setup still.

Add an OF fixup to set the IORESOURCE_PREFETCH flag for a 64-bit PCI
resource that has the end address above 4G requiring placement into the
prefetchable window. Also log the issue.

Fixes: 754babaaf333 ("sparc/PCI: Remove pcibios_enable_device() as they do nothing extra")
Reported-by: Nathaniel Roach <nroach44@gmail.com>
Closes: https://github.com/sparclinux/issues/issues/22
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Nathaniel Roach <nroach44@gmail.com>
Link: https://patch.msgid.link/20251124170411.3709-1-ilpo.jarvinen@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/kernel/pci.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index a9448088e762e..b290107170e94 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -181,6 +181,28 @@ static int __init ofpci_debug(char *str)
 
 __setup("ofpci_debug=", ofpci_debug);
 
+static void of_fixup_pci_pref(struct pci_dev *dev, int index,
+			      struct resource *res)
+{
+	struct pci_bus_region region;
+
+	if (!(res->flags & IORESOURCE_MEM_64))
+		return;
+
+	if (!resource_size(res))
+		return;
+
+	pcibios_resource_to_bus(dev->bus, &region, res);
+	if (region.end <= ~((u32)0))
+		return;
+
+	if (!(res->flags & IORESOURCE_PREFETCH)) {
+		res->flags |= IORESOURCE_PREFETCH;
+		pci_info(dev, "reg 0x%x: fixup: pref added to 64-bit resource\n",
+			 index);
+	}
+}
+
 static unsigned long pci_parse_of_flags(u32 addr0)
 {
 	unsigned long flags = 0;
@@ -244,6 +266,7 @@ static void pci_parse_of_addrs(struct platform_device *op,
 		res->end = op_res->end;
 		res->flags = flags;
 		res->name = pci_name(dev);
+		of_fixup_pci_pref(dev, i, res);
 
 		pci_info(dev, "reg 0x%x: %pR\n", i, res);
 	}
-- 
2.51.0



