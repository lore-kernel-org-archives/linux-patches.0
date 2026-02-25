Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4789418B0A;
	Wed, 25 Feb 2026 01:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983223; cv=none; b=QePjXTbvX016+1mCYzD7cxtBtFsBggkUvJ+P6W/osih7fyyEFQ5R7Ifc1/G53+HQxqeHOZvKly6m6SKozSdNhsft7bzua1isahNH9v7aVk3Xs6nXRPRQTBPWJHPp2lEiqoj29FxQw/JC+0SeZVJWEk/7ecHAy4VqaH9LckCR+wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983223; c=relaxed/simple;
	bh=2QJsAXxITh7SEbEgUCkU+XAgh4mR1P1kb/q3onsni2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DISDKgpwlF/u54H5hjzd1N2Ca0FbYASx0riQ0Q42+TdpBGnuN5mikSFPuzaWoE2VNf4vMjziHlxFxehHX9lK9fYBTthwPH36rqYxhSCpNHgR9LvB7tGiGnAaxNwx5BHTPxzBQ+OISYV6surBaUacgVsK8renDXId8Hxu3refHyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u53BtVbA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u53BtVbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFBE3C116D0;
	Wed, 25 Feb 2026 01:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983223;
	bh=2QJsAXxITh7SEbEgUCkU+XAgh4mR1P1kb/q3onsni2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u53BtVbAPqM5fJGa/vBFq+uxYQ95FK/t4xWoFazUeHjPwRJczuHOfQG1K0PE/y9mz
	 rE957t9rf1XLi9TK+tI6KhmKH2/ABF5yujMzwYuQJ7/opogAnMAmFP+LgxPYe/zIZ1
	 9xhM/9KP7PhyOy4JnmUqaXP3+X+pj39Imr+qJ8Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Malte=20Schr=C3=B6der?= <malte+lkml@tnxip.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 369/781] PCI: Stop over-estimating bridge window size
Date: Tue, 24 Feb 2026 17:17:58 -0800
Message-ID: <20260225012408.734961677@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 3958bf16e2fe1b1c95467e58694102122c951a31 ]

New way to calculate the bridge window head alignment produces tight-fit,
that is, it does not leave any gaps between the resources.  Similarly,
relaxed tail alignment does not leave extra tail room.

Start to use bridge window calculation that does not over-estimate the size
of the required window.

pbus_upstream_space_available() can be removed.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Malte Schröder <malte+lkml@tnxip.de>
Link: https://patch.msgid.link/20251219174036.16738-4-ilpo.jarvinen@linux.intel.com
Stable-dep-of: f909e3ee3ed1 ("PCI: Remove old_size limit from bridge window sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 97 +++--------------------------------------
 1 file changed, 5 insertions(+), 92 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 99086980e102e..ed23778659114 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1266,68 +1266,6 @@ static resource_size_t calculate_head_align(resource_size_t *aligns,
 	return head_align;
 }
 
-/**
- * pbus_upstream_space_available - Check no upstream resource limits allocation
- * @bus:	The bus
- * @res:	The resource to help select the correct bridge window
- * @size:	The size required from the bridge window
- * @align:	Required alignment for the resource
- *
- * Check that @size can fit inside the upstream bridge resources that are
- * already assigned. Select the upstream bridge window based on the type of
- * @res.
- *
- * Return: %true if enough space is available on all assigned upstream
- * resources.
- */
-static bool pbus_upstream_space_available(struct pci_bus *bus,
-					  struct resource *res,
-					  resource_size_t size,
-					  resource_size_t align)
-{
-	struct resource_constraint constraint = {
-		.max = RESOURCE_SIZE_MAX,
-		.align = align,
-	};
-	struct pci_bus *downstream = bus;
-
-	while ((bus = bus->parent)) {
-		if (pci_is_root_bus(bus))
-			break;
-
-		res = pbus_select_window(bus, res);
-		if (!res)
-			return false;
-		if (!res->parent)
-			continue;
-
-		if (resource_size(res) >= size) {
-			struct resource gap = {};
-
-			if (find_resource_space(res, &gap, size, &constraint) == 0) {
-				gap.flags = res->flags;
-				pci_dbg(bus->self,
-					"Assigned bridge window %pR to %pR free space at %pR\n",
-					res, &bus->busn_res, &gap);
-				return true;
-			}
-		}
-
-		if (bus->self) {
-			pci_info(bus->self,
-				 "Assigned bridge window %pR to %pR cannot fit 0x%llx required for %s bridging to %pR\n",
-				 res, &bus->busn_res,
-				 (unsigned long long)size,
-				 pci_name(downstream->self),
-				 &downstream->busn_res);
-		}
-
-		return false;
-	}
-
-	return true;
-}
-
 /**
  * pbus_size_mem() - Size the memory window of a given bus
  *
@@ -1354,7 +1292,6 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 	struct pci_dev *dev;
 	resource_size_t min_align, win_align, align, size, size0, size1 = 0;
 	resource_size_t aligns[28] = {}; /* Alignments from 1MB to 128TB */
-	resource_size_t aligns2[28] = {};/* Alignments from 1MB to 128TB */
 	int order, max_order;
 	struct resource *b_res = pbus_select_window_for_type(bus, type);
 	resource_size_t children_add_size = 0;
@@ -1413,13 +1350,8 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 				continue;
 			}
 			size += max(r_size, align);
-			/*
-			 * Exclude ranges with size > align from calculation of
-			 * the alignment.
-			 */
-			if (r_size <= align)
-				aligns[order] += align;
-			aligns2[order] += align;
+
+			aligns[order] += align;
 			if (order > max_order)
 				max_order = order;
 
@@ -1433,38 +1365,19 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 
 	old_size = resource_size(b_res);
 	win_align = window_alignment(bus, b_res->flags);
-	min_align = calculate_mem_align(aligns, max_order);
+	min_align = calculate_head_align(aligns, max_order);
 	min_align = max(min_align, win_align);
-	size0 = calculate_memsize(size, min_size, 0, 0, old_size, min_align);
+	size0 = calculate_memsize(size, min_size, 0, 0, old_size, win_align);
 
 	if (size0) {
 		resource_set_range(b_res, min_align, size0);
 		b_res->flags &= ~IORESOURCE_DISABLED;
 	}
 
-	if (bus->self && size0 &&
-	    !pbus_upstream_space_available(bus, b_res, size0, min_align)) {
-		min_align = calculate_head_align(aligns2, max_order);
-		size0 = calculate_memsize(size, min_size, 0, 0, old_size, win_align);
-		resource_set_range(b_res, min_align, size0);
-		pci_info(bus->self, "bridge window %pR to %pR requires relaxed alignment rules\n",
-			 b_res, &bus->busn_res);
-	}
-
 	if (realloc_head && (add_size > 0 || children_add_size > 0)) {
 		add_align = max(min_align, add_align);
 		size1 = calculate_memsize(size, min_size, add_size, children_add_size,
-					  old_size, add_align);
-
-		if (bus->self && size1 &&
-		    !pbus_upstream_space_available(bus, b_res, size1, add_align)) {
-			min_align = calculate_head_align(aligns2, max_order);
-			size1 = calculate_memsize(size, min_size, add_size, children_add_size,
-						  old_size, win_align);
-			pci_info(bus->self,
-				 "bridge window %pR to %pR requires relaxed alignment rules\n",
-				 b_res, &bus->busn_res);
-		}
+					  old_size, win_align);
 	}
 
 	if (!size0 && !size1) {
-- 
2.51.0



