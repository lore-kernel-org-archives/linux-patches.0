Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01C92773F4;
	Tue, 21 Oct 2025 20:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077607; cv=none; b=tDG0+PadOb5+HYUwdTLCKotaaLkbC0PZxfl2F+X/WCfuNmvb6S35fe3TU97AmKEWXC3LChNRIsd+EY8gP61zgzoLNXNBnofPvLPHYNk5XqNV+IG7B9RpqiAmjwrSPHj6KhXnhrJyNm9LXq0zY9Pg4vTxY91L1phGMDE3bNiMFtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077607; c=relaxed/simple;
	bh=5d+bbL8szPp25YP1OJbpjzWF7d1IsUPYygq9QA8IwT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EMeuHNwkQloCIDMHTCApEU7Dv0+u6m1iMdw2xFwFm6xLzHnrdblJq8E2xFZhPbgPAoSvpcSZKCNVcQ7DLMuf144oSZ79rIdSn8gsTEXdsEXv/D3XDCi8tAMrAmGHHc/EYpC/h1YH+m0wf3+QN/IlhD0VZQIpe8YpaFJUyhIReaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/e2tUfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/e2tUfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB565C4CEF1;
	Tue, 21 Oct 2025 20:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077607;
	bh=5d+bbL8szPp25YP1OJbpjzWF7d1IsUPYygq9QA8IwT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X/e2tUfExc25BkgpQLfhzRr7S7e9697KmLNJnrxyqDtUMdLGX6J5Dxon47f/HFTKX
	 N9Xbj/nqPIMacy0NzAxSc0fn5TDNXwDJuXnHwZvDfitUhMDNNdSsheM4GwSqssM3QJ
	 o/jnzW/21XX6LfXQceCIhW7F46pb5I+jayOh/XHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 158/159] drm/xe: Move rebar to be done earlier
Date: Tue, 21 Oct 2025 21:52:15 +0200
Message-ID: <20251021195046.980942991@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit d30203739be798d3de5c84db3060e96f00c54e82 ]

There may be cases in which the BAR0 also needs to move to accommodate
the bigger BAR2. However if it's not released, the BAR2 resize fails.
During the vram probe it can't be released as it's already in use by
xe_mmio for early register access.

Add a new function in xe_vram and let xe_pci call it directly before
even early device probe. This allows the BAR2 to resize in cases BAR0
also needs to move, assuming there aren't other reasons to hold that
move:

	[] xe 0000:03:00.0: vgaarb: deactivate vga console
	[] xe 0000:03:00.0: [drm] Attempting to resize bar from 8192MiB -> 16384MiB
	[] xe 0000:03:00.0: BAR 0 [mem 0x83000000-0x83ffffff 64bit]: releasing
	[] xe 0000:03:00.0: BAR 2 [mem 0x4000000000-0x41ffffffff 64bit pref]: releasing
	[] pcieport 0000:02:01.0: bridge window [mem 0x4000000000-0x41ffffffff 64bit pref]: releasing
	[] pcieport 0000:01:00.0: bridge window [mem 0x4000000000-0x41ffffffff 64bit pref]: releasing
	[] pcieport 0000:01:00.0: bridge window [mem 0x4000000000-0x43ffffffff 64bit pref]: assigned
	[] pcieport 0000:02:01.0: bridge window [mem 0x4000000000-0x43ffffffff 64bit pref]: assigned
	[] xe 0000:03:00.0: BAR 2 [mem 0x4000000000-0x43ffffffff 64bit pref]: assigned
	[] xe 0000:03:00.0: BAR 0 [mem 0x83000000-0x83ffffff 64bit]: assigned
	[] pcieport 0000:00:01.0: PCI bridge to [bus 01-04]
	[] pcieport 0000:00:01.0:   bridge window [mem 0x83000000-0x840fffff]
	[] pcieport 0000:00:01.0:   bridge window [mem 0x4000000000-0x44007fffff 64bit pref]
	[] pcieport 0000:01:00.0: PCI bridge to [bus 02-04]
	[] pcieport 0000:01:00.0:   bridge window [mem 0x83000000-0x840fffff]
	[] pcieport 0000:01:00.0:   bridge window [mem 0x4000000000-0x43ffffffff 64bit pref]
	[] pcieport 0000:02:01.0: PCI bridge to [bus 03]
	[] pcieport 0000:02:01.0:   bridge window [mem 0x83000000-0x83ffffff]
	[] pcieport 0000:02:01.0:   bridge window [mem 0x4000000000-0x43ffffffff 64bit pref]
	[] xe 0000:03:00.0: [drm] BAR2 resized to 16384M
	[] xe 0000:03:00.0: [drm:xe_pci_probe [xe]] BATTLEMAGE  e221:0000 dgfx:1 gfx:Xe2_HPG (20.02) ...

For BMG there are additional fix needed in the PCI side, but this
helps getting it to a working resize.

All the rebar logic is more pci-specific than xe-specific and can be
done very early in the probe sequence. In future it would be good to
move it out of xe_vram.c, but this refactor is left for later.

Cc: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: stable@vger.kernel.org # 6.12+
Link: https://lore.kernel.org/intel-xe/fafda2a3-fc63-ce97-d22b-803f771a4d19@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20250918-xe-pci-rebar-2-v1-2-6c094702a074@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 45e33f220fd625492c11e15733d8e9b4f9db82a4)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pci.c  |    2 ++
 drivers/gpu/drm/xe/xe_vram.c |   34 ++++++++++++++++++++++++++--------
 drivers/gpu/drm/xe/xe_vram.h |    1 +
 3 files changed, 29 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -805,6 +805,8 @@ static int xe_pci_probe(struct pci_dev *
 	if (err)
 		return err;
 
+	xe_vram_resize_bar(xe);
+
 	err = xe_device_probe_early(xe);
 	/*
 	 * In Boot Survivability mode, no drm card is exposed and driver
--- a/drivers/gpu/drm/xe/xe_vram.c
+++ b/drivers/gpu/drm/xe/xe_vram.c
@@ -26,15 +26,35 @@
 
 #define BAR_SIZE_SHIFT 20
 
-static void
-_resize_bar(struct xe_device *xe, int resno, resource_size_t size)
+/*
+ * Release all the BARs that could influence/block LMEMBAR resizing, i.e.
+ * assigned IORESOURCE_MEM_64 BARs
+ */
+static void release_bars(struct pci_dev *pdev)
+{
+	struct resource *res;
+	int i;
+
+	pci_dev_for_each_resource(pdev, res, i) {
+		/* Resource already un-assigned, do not reset it */
+		if (!res->parent)
+			continue;
+
+		/* No need to release unrelated BARs */
+		if (!(res->flags & IORESOURCE_MEM_64))
+			continue;
+
+		pci_release_resource(pdev, i);
+	}
+}
+
+static void resize_bar(struct xe_device *xe, int resno, resource_size_t size)
 {
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
 	int bar_size = pci_rebar_bytes_to_size(size);
 	int ret;
 
-	if (pci_resource_len(pdev, resno))
-		pci_release_resource(pdev, resno);
+	release_bars(pdev);
 
 	ret = pci_resize_resource(pdev, resno, bar_size);
 	if (ret) {
@@ -50,7 +70,7 @@ _resize_bar(struct xe_device *xe, int re
  * if force_vram_bar_size is set, attempt to set to the requested size
  * else set to maximum possible size
  */
-static void resize_vram_bar(struct xe_device *xe)
+void xe_vram_resize_bar(struct xe_device *xe)
 {
 	int force_vram_bar_size = xe_modparam.force_vram_bar_size;
 	struct pci_dev *pdev = to_pci_dev(xe->drm.dev);
@@ -119,7 +139,7 @@ static void resize_vram_bar(struct xe_de
 	pci_read_config_dword(pdev, PCI_COMMAND, &pci_cmd);
 	pci_write_config_dword(pdev, PCI_COMMAND, pci_cmd & ~PCI_COMMAND_MEMORY);
 
-	_resize_bar(xe, LMEM_BAR, rebar_size);
+	resize_bar(xe, LMEM_BAR, rebar_size);
 
 	pci_assign_unassigned_bus_resources(pdev->bus);
 	pci_write_config_dword(pdev, PCI_COMMAND, pci_cmd);
@@ -148,8 +168,6 @@ static int determine_lmem_bar_size(struc
 		return -ENXIO;
 	}
 
-	resize_vram_bar(xe);
-
 	lmem_bar->io_start = pci_resource_start(pdev, LMEM_BAR);
 	lmem_bar->io_size = pci_resource_len(pdev, LMEM_BAR);
 	if (!lmem_bar->io_size)
--- a/drivers/gpu/drm/xe/xe_vram.h
+++ b/drivers/gpu/drm/xe/xe_vram.h
@@ -11,6 +11,7 @@
 struct xe_device;
 struct xe_vram_region;
 
+void xe_vram_resize_bar(struct xe_device *xe);
 int xe_vram_probe(struct xe_device *xe);
 
 struct xe_vram_region *xe_vram_region_alloc(struct xe_device *xe, u8 id, u32 placement);


