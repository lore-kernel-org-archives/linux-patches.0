Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EB9266583;
	Tue,  8 Apr 2025 11:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111042; cv=none; b=T1o91N2srVXjxjv6+fV/wVIagTxxSZ/v67Tm+vpzbozV1Ts5ExTD6jfs0a5Q+S76zX6yBZNvjmpHl1sg9znhOcr3l8Ak4wsqyBooIcBNJE28jMqp59cRdj+LJ4TXsS3ej1EyXkZvh11g5OPCf60g4encVdSZgx1PE11Qy+0hW1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111042; c=relaxed/simple;
	bh=g/OeTDXbkYtPBuNX0HsCXUFb/RcHxX5cLRreOYJyfSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UR796aStlpDss3fNxl0ShkIZiqX/rJk/ynKT/XSK2i+/E5dPb666D7LeiZJtThsjNQCx0FHmTedrJlx361Eu906BRteC9jA8tZcO5+v+gBPK9cYA7+4rTG1Md+Js0+ydeCz71UyzWGIBBJNe6SoImCNPuES+LxyZhatj0PfSamU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aISFWoKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aISFWoKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACEACC4CEE5;
	Tue,  8 Apr 2025 11:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111042;
	bh=g/OeTDXbkYtPBuNX0HsCXUFb/RcHxX5cLRreOYJyfSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aISFWoKmDEBe12H93uQYQ1gmYjZ+ux4wawawNFCPu8Y3gGabTu2XonwJSdTGtVlph
	 nlAfmj1h1I59wBgRApl++81blJEVeCjAK3KUEo7DQZdvSTGnHf+DYMWwgOEtt6SYp2
	 mP8iFnctii80bqmaGIY8w3ZwXEME+5w1jPLvRCN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Xiaochun Lee <lixc17@lenovo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 287/731] PCI: Simplify size1 assignment logic
Date: Tue,  8 Apr 2025 12:43:04 +0200
Message-ID: <20250408104920.954332274@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit a55bf64b30e4ee04c8f690e2c3d0924beb7fbd62 ]

In pbus_size_io() and pbus_size_mem(), a complex ?: operation is performed
to set size1.  Decompose this so it's easier to read.

In the case of pbus_size_mem(), simply initializing size1 to zero ensures
the size1 checks work as expected.

Link: https://lore.kernel.org/r/20241216175632.4175-4-ilpo.jarvinen@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Xiaochun Lee <lixc17@lenovo.com>
Stable-dep-of: 67f9085596ee ("PCI: Allow relaxed bridge window tail sizing for optional resources")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 3a1fcaad142a4..d9f129a7735a5 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -927,9 +927,14 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 
 	size0 = calculate_iosize(size, min_size, size1, 0, 0,
 			resource_size(b_res), min_align);
-	size1 = (!realloc_head || (realloc_head && !add_size && !children_add_size)) ? size0 :
-		calculate_iosize(size, min_size, size1, add_size, children_add_size,
-			resource_size(b_res), min_align);
+
+	size1 = size0;
+	if (realloc_head && (add_size > 0 || children_add_size > 0)) {
+		size1 = calculate_iosize(size, min_size, size1, add_size,
+					 children_add_size, resource_size(b_res),
+					 min_align);
+	}
+
 	if (!size0 && !size1) {
 		if (bus->self && (b_res->start || b_res->end))
 			pci_info(bus->self, "disabling bridge window %pR to %pR (unused)\n",
@@ -1058,7 +1063,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			 struct list_head *realloc_head)
 {
 	struct pci_dev *dev;
-	resource_size_t min_align, win_align, align, size, size0, size1;
+	resource_size_t min_align, win_align, align, size, size0, size1 = 0;
 	resource_size_t aligns[24]; /* Alignments from 1MB to 8TB */
 	int order, max_order;
 	struct resource *b_res = find_bus_resource_of_type(bus,
@@ -1153,9 +1158,11 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			 b_res, &bus->busn_res);
 	}
 
-	size1 = (!realloc_head || (realloc_head && !add_size && !children_add_size)) ? size0 :
-		calculate_memsize(size, min_size, add_size, children_add_size,
-				resource_size(b_res), add_align);
+	if (realloc_head && (add_size > 0 || children_add_size > 0)) {
+		size1 = calculate_memsize(size, min_size, add_size, children_add_size,
+					  resource_size(b_res), add_align);
+	}
+
 	if (!size0 && !size1) {
 		if (bus->self && (b_res->start || b_res->end))
 			pci_info(bus->self, "disabling bridge window %pR to %pR (unused)\n",
-- 
2.39.5



