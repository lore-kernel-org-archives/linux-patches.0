Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968121DFFB;
	Thu, 15 Aug 2024 13:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728596; cv=none; b=rGj949ysEH8RrERwcW/cUQsVeQdQy7sBx7MKFyMf7Cdfl+c5Ns+hfSrg2y7q44gb4wkgnhk/I7HYcrg18NSSXGYZ2ojV5yphARKrhPFIqgxXUwEIjqzvIKUOok3bXvjaHSocSxTJlnpda6QOYzvHOEq6/M/B4wCUB+NNFtJdifI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728596; c=relaxed/simple;
	bh=sAd/ZQ/e0tVVut/UcZaCjynGySXfcFaa/L2Xf0mQ41k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHDukyf0vdHzGe0cJP3ChFh1NKlOTce/L+B8XtgfgN/S3sHd8dgHQpsVmz5d+IH3yPmk2CfFdjbkZRdmLjaHpbSIvL3J29ovxtWukdGALMn3xwyd0oo1nWX0OZUbbbswY2jUaGIPLTxz5/lRjfWbw8jIHTvgX4WRhdA0YAYQGNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+yeWvjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+yeWvjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C585C32786;
	Thu, 15 Aug 2024 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728596;
	bh=sAd/ZQ/e0tVVut/UcZaCjynGySXfcFaa/L2Xf0mQ41k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+yeWvjxvSTQROqtS5wUFwoBQ91VVtxYTIheLfBX+sht26562WPsogXg2Kff0bPG3
	 OZ3Hiyha1j0RMDBSAuL73twVUcsG9ISVNY1qF3DZZWt3ea+BIp8eRtu4WNFMjSDD3W
	 P033O360o0ORLOVNCIUWAbwj0rOEKJrBa6JqQQwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Derrick <jonathan.derrick@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/196] PCI: Equalize hotplug memory and io for occupied and empty slots
Date: Thu, 15 Aug 2024 15:22:39 +0200
Message-ID: <20240815131853.692787412@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Derrick <jonathan.derrick@intel.com>

[ Upstream commit de3ffa301142bf8802a7b0de17f9985acde5c223 ]

Currently, a hotplug bridge will be given hpmemsize additional memory
and hpiosize additional io if available, in order to satisfy any future
hotplug allocation requirements.

These calculations don't consider the current memory/io size of the
hotplug bridge/slot, so hotplug bridges/slots which have downstream
devices will be allocated their current allocation in addition to the
hpmemsize value.

This makes for possibly undesirable results with a mix of unoccupied and
occupied slots (ex, with hpmemsize=2M):

  02:03.0 PCI bridge: <-- Occupied
	  Memory behind bridge: d6200000-d64fffff [size=3M]
  02:04.0 PCI bridge: <-- Unoccupied
	  Memory behind bridge: d6500000-d66fffff [size=2M]

This change considers the current allocation size when using the
hpmemsize/hpiosize parameters to make the reservations predictable for
the mix of unoccupied and occupied slots:

  02:03.0 PCI bridge: <-- Occupied
	  Memory behind bridge: d6200000-d63fffff [size=2M]
  02:04.0 PCI bridge: <-- Unoccupied
	  Memory behind bridge: d6400000-d65fffff [size=2M]

Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Stable-dep-of: 903534fa7d30 ("PCI: Fix resource double counting on remove & rescan")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/setup-bus.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 87c8190de622f..7f58360b42b7e 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -774,6 +774,8 @@ static struct resource *find_free_bus_resource(struct pci_bus *bus,
 static resource_size_t calculate_iosize(resource_size_t size,
 		resource_size_t min_size,
 		resource_size_t size1,
+		resource_size_t add_size,
+		resource_size_t children_add_size,
 		resource_size_t old_size,
 		resource_size_t align)
 {
@@ -786,15 +788,18 @@ static resource_size_t calculate_iosize(resource_size_t size,
 #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
-	size = ALIGN(size + size1, align);
+	size = size + size1;
 	if (size < old_size)
 		size = old_size;
+
+	size = ALIGN(max(size, add_size) + children_add_size, align);
 	return size;
 }
 
 static resource_size_t calculate_memsize(resource_size_t size,
 		resource_size_t min_size,
-		resource_size_t size1,
+		resource_size_t add_size,
+		resource_size_t children_add_size,
 		resource_size_t old_size,
 		resource_size_t align)
 {
@@ -804,7 +809,8 @@ static resource_size_t calculate_memsize(resource_size_t size,
 		old_size = 0;
 	if (size < old_size)
 		size = old_size;
-	size = ALIGN(size + size1, align);
+
+	size = ALIGN(max(size, add_size) + children_add_size, align);
 	return size;
 }
 
@@ -893,12 +899,10 @@ static void pbus_size_io(struct pci_bus *bus, resource_size_t min_size,
 		}
 	}
 
-	size0 = calculate_iosize(size, min_size, size1,
+	size0 = calculate_iosize(size, min_size, size1, 0, 0,
 			resource_size(b_res), min_align);
-	if (children_add_size > add_size)
-		add_size = children_add_size;
-	size1 = (!realloc_head || (realloc_head && !add_size)) ? size0 :
-		calculate_iosize(size, min_size, add_size + size1,
+	size1 = (!realloc_head || (realloc_head && !add_size && !children_add_size)) ? size0 :
+		calculate_iosize(size, min_size, size1, add_size, children_add_size,
 			resource_size(b_res), min_align);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
@@ -1042,12 +1046,10 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 
 	min_align = calculate_mem_align(aligns, max_order);
 	min_align = max(min_align, window_alignment(bus, b_res->flags));
-	size0 = calculate_memsize(size, min_size, 0, resource_size(b_res), min_align);
+	size0 = calculate_memsize(size, min_size, 0, 0, resource_size(b_res), min_align);
 	add_align = max(min_align, add_align);
-	if (children_add_size > add_size)
-		add_size = children_add_size;
-	size1 = (!realloc_head || (realloc_head && !add_size)) ? size0 :
-		calculate_memsize(size, min_size, add_size,
+	size1 = (!realloc_head || (realloc_head && !add_size && !children_add_size)) ? size0 :
+		calculate_memsize(size, min_size, add_size, children_add_size,
 				resource_size(b_res), add_align);
 	if (!size0 && !size1) {
 		if (b_res->start || b_res->end)
-- 
2.43.0



