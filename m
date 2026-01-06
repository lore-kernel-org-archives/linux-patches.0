Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7F535A948;
	Tue,  6 Jan 2026 17:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721550; cv=none; b=FlV1QuYUhEmJB0b9/REtvHWFB1d1I9b4TxBA4eFzqvTQNsk/arTCj/C1/9g0F0EYXGsjQCkxrCGvRuAQplm5qfWYVyos0ZsohygCUj0VFCOook/uw/0nYrn1kX9Nk2K6L2M3KDk1s6s9dDyy33kkoq3YuEoxqrey7KYGJm9iggs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721550; c=relaxed/simple;
	bh=F/TkiO3+hV+KOFZYn1RDiAgcZB87ZW6FDJJkQ9xDowY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfzQE8A4Yc6/0MZzUPITEQ8LgFNrGyCfSjl/+6EO+x8qzYTHZ0UsRZg4Z6H30Mh4nPZdK+1lPw8d5DSJ6bZRHDv63wE6I7+T+9D6lnw13/IqsBuNxWe42nJPOm+VoS6A+GnTELQMqcmJnOBVhDK0h325UNSB068+XtIbivSVZDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ff96a1s2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ff96a1s2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB209C16AAE;
	Tue,  6 Jan 2026 17:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721550;
	bh=F/TkiO3+hV+KOFZYn1RDiAgcZB87ZW6FDJJkQ9xDowY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ff96a1s2AqU/16r1RQdxGjWWqQ8MVzPOI7BW3IKpfT+6DUjNRY08CEr4Repz7adls
	 rQB6y1vU3jKJf4GuAQVofediE+gCvNh+W9l5BwwAAeyLq68UEP9+9fU0tfqwo+Ik+L
	 zALgylDBYwUvaNkLJsPiEg9e9XDxJqk5yvxuKvWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farrah Chen <farrah.chen@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex@shazbot.org>
Subject: [PATCH 6.12 562/567] vfio/pci: Disable qword access to the PCI ROM bar
Date: Tue,  6 Jan 2026 18:05:44 +0100
Message-ID: <20260106170512.218751092@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

From: Kevin Tian <kevin.tian@intel.com>

[ Upstream commit dc85a46928c41423ad89869baf05a589e2975575 ]

Commit 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio
pci") enables qword access to the PCI bar resources. However certain
devices (e.g. Intel X710) are observed with problem upon qword accesses
to the rom bar, e.g. triggering PCI aer errors.

This is triggered by Qemu which caches the rom content by simply does a
pread() of the remaining size until it gets the full contents. The other
bars would only perform operations at the same access width as their
guest drivers.

Instead of trying to identify all broken devices, universally disable
qword access to the rom bar i.e. going back to the old way which worked
reliably for years.

Reported-by: Farrah Chen <farrah.chen@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220740
Fixes: 2b938e3db335 ("vfio/pci: Enable iowrite64 and ioread64 for vfio pci")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://lore.kernel.org/r/20251218081650.555015-2-kevin.tian@intel.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vfio/pci/nvgrace-gpu/main.c |    4 ++--
 drivers/vfio/pci/vfio_pci_rdwr.c    |   24 ++++++++++++++++++------
 include/linux/vfio_pci_core.h       |   10 +++++++++-
 3 files changed, 29 insertions(+), 9 deletions(-)

--- a/drivers/vfio/pci/nvgrace-gpu/main.c
+++ b/drivers/vfio/pci/nvgrace-gpu/main.c
@@ -482,7 +482,7 @@ nvgrace_gpu_map_and_read(struct nvgrace_
 		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
 					     nvdev->resmem.ioaddr,
 					     buf, offset, mem_count,
-					     0, 0, false);
+					     0, 0, false, VFIO_PCI_IO_WIDTH_8);
 	}
 
 	return ret;
@@ -600,7 +600,7 @@ nvgrace_gpu_map_and_write(struct nvgrace
 		ret = vfio_pci_core_do_io_rw(&nvdev->core_device, false,
 					     nvdev->resmem.ioaddr,
 					     (char __user *)buf, pos, mem_count,
-					     0, 0, true);
+					     0, 0, true, VFIO_PCI_IO_WIDTH_8);
 	}
 
 	return ret;
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -141,7 +141,8 @@ VFIO_IORDWR(64)
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-			       size_t x_end, bool iswrite)
+			       size_t x_end, bool iswrite,
+			       enum vfio_pci_io_width max_width)
 {
 	ssize_t done = 0;
 	int ret;
@@ -157,7 +158,7 @@ ssize_t vfio_pci_core_do_io_rw(struct vf
 			fillable = 0;
 
 #if defined(ioread64) && defined(iowrite64)
-		if (fillable >= 8 && !(off % 8)) {
+		if (fillable >= 8 && !(off % 8) && max_width >= 8) {
 			ret = vfio_pci_iordwr64(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
 			if (ret)
@@ -165,13 +166,13 @@ ssize_t vfio_pci_core_do_io_rw(struct vf
 
 		} else
 #endif
-		if (fillable >= 4 && !(off % 4)) {
+		if (fillable >= 4 && !(off % 4) && max_width >= 4) {
 			ret = vfio_pci_iordwr32(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
 			if (ret)
 				return ret;
 
-		} else if (fillable >= 2 && !(off % 2)) {
+		} else if (fillable >= 2 && !(off % 2) && max_width >= 2) {
 			ret = vfio_pci_iordwr16(vdev, iswrite, test_mem,
 						io, buf, off, &filled);
 			if (ret)
@@ -242,6 +243,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_
 	void __iomem *io;
 	struct resource *res = &vdev->pdev->resource[bar];
 	ssize_t done;
+	enum vfio_pci_io_width max_width = VFIO_PCI_IO_WIDTH_8;
 
 	if (pci_resource_start(pdev, bar))
 		end = pci_resource_len(pdev, bar);
@@ -268,6 +270,16 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_
 			goto out;
 		}
 		x_end = end;
+
+		/*
+		 * Certain devices (e.g. Intel X710) don't support qword
+		 * access to the ROM bar. Otherwise PCI AER errors might be
+		 * triggered.
+		 *
+		 * Disable qword access to the ROM bar universally, which
+		 * worked reliably for years before qword access is enabled.
+		 */
+		max_width = VFIO_PCI_IO_WIDTH_4;
 	} else {
 		int ret = vfio_pci_core_setup_barmap(vdev, bar);
 		if (ret) {
@@ -284,7 +296,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_
 	}
 
 	done = vfio_pci_core_do_io_rw(vdev, res->flags & IORESOURCE_MEM, io, buf, pos,
-				      count, x_start, x_end, iswrite);
+				      count, x_start, x_end, iswrite, max_width);
 
 	if (done >= 0)
 		*ppos += done;
@@ -353,7 +365,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_
 	 * to the memory enable bit in the command register.
 	 */
 	done = vfio_pci_core_do_io_rw(vdev, false, iomem, buf, off, count,
-				      0, 0, iswrite);
+				      0, 0, iswrite, VFIO_PCI_IO_WIDTH_8);
 
 	vga_put(vdev->pdev, rsrc);
 
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -102,6 +102,13 @@ struct vfio_pci_core_device {
 	struct rw_semaphore	memory_lock;
 };
 
+enum vfio_pci_io_width {
+	VFIO_PCI_IO_WIDTH_1 = 1,
+	VFIO_PCI_IO_WIDTH_2 = 2,
+	VFIO_PCI_IO_WIDTH_4 = 4,
+	VFIO_PCI_IO_WIDTH_8 = 8,
+};
+
 /* Will be exported for vfio pci drivers usage */
 int vfio_pci_core_register_dev_region(struct vfio_pci_core_device *vdev,
 				      unsigned int type, unsigned int subtype,
@@ -137,7 +144,8 @@ pci_ers_result_t vfio_pci_core_aer_err_d
 ssize_t vfio_pci_core_do_io_rw(struct vfio_pci_core_device *vdev, bool test_mem,
 			       void __iomem *io, char __user *buf,
 			       loff_t off, size_t count, size_t x_start,
-			       size_t x_end, bool iswrite);
+			       size_t x_end, bool iswrite,
+			       enum vfio_pci_io_width max_width);
 bool vfio_pci_core_range_intersect_range(loff_t buf_start, size_t buf_cnt,
 					 loff_t reg_start, size_t reg_cnt,
 					 loff_t *buf_offset,


