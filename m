Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040D126FA60;
	Wed, 25 Feb 2026 01:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984035; cv=none; b=T5s+4+LEVI6QuhcEZipUfX0z9rEYtKqgM2+3Lvc/TMY8QugEqPavUW8SUELPIioMNoXyOuhN5WgvyTY2YBl4PRRUHtql/dvDqZ1PkDUKTG8wB9/rIahTFEmWQayzvPvcer2rDnR9o5QZEGStjvcr3hrjLKlUDqyKcyBWs5ueonc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984035; c=relaxed/simple;
	bh=Gss8vdChYzwUGJIdYEv8uG3WhbIgXorwHx/1VZuEX50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QK3jzrwJvBoP43g3LnNqR63/lmyvW2WCDzQ45l6XwXIuLrbxVV65gLVkWBPSk4PXCctkRbmhcKnHWPzxXkG5qu6hrmr0FJQ92qFtk/KAf9e8YhnJ3SQDTB1A9jhG7y/m3i+sd2vYGoGIdQAkYxHK5iVbeOiLRrzmx7cYlN/hl04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQHLK9W4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQHLK9W4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4CAC116D0;
	Wed, 25 Feb 2026 01:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984034;
	bh=Gss8vdChYzwUGJIdYEv8uG3WhbIgXorwHx/1VZuEX50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQHLK9W4T02CouHD3cKgMa4o4AZ/9Wj6LCEsK/6j94uQzr9zZTKeXcyppop07fSTI
	 F4KiFmapE0cOijKfZWUc/8DwUrYUVOs5RyhsXSNBd56LOQH5CdvxRaI0C+p7jipdm0
	 JuaNiDrKYcQkLz1gydIe9pIBexqDH8rV8q1fIU9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Malte=20Schr=C3=B6der?= <malte+lkml@tnxip.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 278/641] PCI: Rewrite bridge window head alignment function
Date: Tue, 24 Feb 2026 17:20:04 -0800
Message-ID: <20260225012355.521466065@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

[ Upstream commit bc75c8e5071120e919beb39e69f0979cccfdf219 ]

The calculation of bridge window head alignment is done by
calculate_mem_align() [*]. With the default bridge window alignment, it
is used for both head and tail alignment.

The selected head alignment does not always result in tight-fitting
resources (gap at d4f00000-d4ffffff):

  d4800000-dbffffff : PCI Bus 0000:06
    d4800000-d48fffff : PCI Bus 0000:07
      d4800000-d4803fff : 0000:07:00.0
        d4800000-d4803fff : nvme
    d4900000-d49fffff : PCI Bus 0000:0a
      d4900000-d490ffff : 0000:0a:00.0
        d4900000-d490ffff : r8169
      d4910000-d4913fff : 0000:0a:00.0
    d4a00000-d4cfffff : PCI Bus 0000:0b
      d4a00000-d4bfffff : 0000:0b:00.0
        d4a00000-d4bfffff : 0000:0b:00.0
      d4c00000-d4c07fff : 0000:0b:00.0
    d4d00000-d4dfffff : PCI Bus 0000:15
      d4d00000-d4d07fff : 0000:15:00.0
        d4d00000-d4d07fff : xhci-hcd
    d4e00000-d4efffff : PCI Bus 0000:16
      d4e00000-d4e7ffff : 0000:16:00.0
      d4e80000-d4e803ff : 0000:16:00.0
        d4e80000-d4e803ff : ahci
    d5000000-dbffffff : PCI Bus 0000:0c

This has not caused problems (for years) with the default bridge window
tail alignment that grossly over-estimates the required tail alignment
leaving more tail room than necessary. With the introduction of relaxed
tail alignment that leaves no extra tail room whatsoever, any gaps will
immediately turn into assignment failures.

Introduce head alignment calculation that ensures no gaps are left and
apply the new approach when using relaxed alignment. We may want to
consider using it for the normal alignment eventually, but as the first
step, solve only the problem with the relaxed tail alignment.

([*] I don't understand the algorithm in calculate_mem_align().)

Link: https://git.kernel.org/history/history/c/5d0a8965aea9 ("[PATCH] 2.5.14: New PCI allocation code (alpha, arm, parisc) [2/2]")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220775
Reported-by: Malte Schröder <malte+lkml@tnxip.de>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Malte Schröder <malte+lkml@tnxip.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251219174036.16738-3-ilpo.jarvinen@linux.intel.com
Stable-dep-of: f909e3ee3ed1 ("PCI: Remove old_size limit from bridge window sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 53 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 5ba878f15db35..cd12926a72af7 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1223,6 +1223,45 @@ static inline resource_size_t calculate_mem_align(resource_size_t *aligns,
 	return min_align;
 }
 
+/*
+ * Calculate bridge window head alignment that leaves no gaps in between
+ * resources.
+ */
+static resource_size_t calculate_head_align(resource_size_t *aligns,
+					    int max_order)
+{
+	resource_size_t head_align = 1;
+	resource_size_t remainder = 0;
+	int order;
+
+	/* Take the largest alignment as the starting point. */
+	head_align <<= max_order + __ffs(SZ_1M);
+
+	for (order = max_order - 1; order >= 0; order--) {
+		resource_size_t align1 = 1;
+
+		align1 <<= order + __ffs(SZ_1M);
+
+		/*
+		 * Account smaller resources with alignment < max_order that
+		 * could be used to fill head room if alignment less than
+		 * max_order is used.
+		 */
+		remainder += aligns[order];
+
+		/*
+		 * Test if head fill is enough to satisfy the alignment of
+		 * the larger resources after reducing the alignment.
+		 */
+		while ((head_align > align1) && (remainder >= head_align / 2)) {
+			head_align /= 2;
+			remainder -= head_align;
+		}
+	}
+
+	return head_align;
+}
+
 /**
  * pbus_upstream_space_available - Check no upstream resource limits allocation
  * @bus:	The bus
@@ -1310,13 +1349,13 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, win_align, align, size, size0, size1 = 0;
-	resource_size_t aligns[28]; /* Alignments from 1MB to 128TB */
+	resource_size_t aligns[28] = {}; /* Alignments from 1MB to 128TB */
+	resource_size_t aligns2[28] = {};/* Alignments from 1MB to 128TB */
 	int order, max_order;
 	struct resource *b_res = pbus_select_window_for_type(bus, type);
 	resource_size_t children_add_size = 0;
 	resource_size_t children_add_align = 0;
 	resource_size_t add_align = 0;
-	resource_size_t relaxed_align;
 	resource_size_t old_size;
 
 	if (!b_res)
@@ -1326,7 +1365,6 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 	if (b_res->parent)
 		return;
 
-	memset(aligns, 0, sizeof(aligns));
 	max_order = 0;
 	size = 0;
 
@@ -1377,6 +1415,7 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 			 */
 			if (r_size <= align)
 				aligns[order] += align;
+			aligns2[order] += align;
 			if (order > max_order)
 				max_order = order;
 
@@ -1401,9 +1440,7 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 
 	if (bus->self && size0 &&
 	    !pbus_upstream_space_available(bus, b_res, size0, min_align)) {
-		relaxed_align = 1ULL << (max_order + __ffs(SZ_1M));
-		relaxed_align = max(relaxed_align, win_align);
-		min_align = min(min_align, relaxed_align);
+		min_align = calculate_head_align(aligns2, max_order);
 		size0 = calculate_memsize(size, min_size, 0, 0, old_size, win_align);
 		resource_set_range(b_res, min_align, size0);
 		pci_info(bus->self, "bridge window %pR to %pR requires relaxed alignment rules\n",
@@ -1417,9 +1454,7 @@ static void pbus_size_mem(struct pci_bus *bus, unsigned long type,
 
 		if (bus->self && size1 &&
 		    !pbus_upstream_space_available(bus, b_res, size1, add_align)) {
-			relaxed_align = 1ULL << (max_order + __ffs(SZ_1M));
-			relaxed_align = max(relaxed_align, win_align);
-			min_align = min(min_align, relaxed_align);
+			min_align = calculate_head_align(aligns2, max_order);
 			size1 = calculate_memsize(size, min_size, add_size, children_add_size,
 						  old_size, win_align);
 			pci_info(bus->self,
-- 
2.51.0



