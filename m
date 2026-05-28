Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0EF2F260C;
	Thu, 28 May 2026 20:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998633; cv=none; b=MlzS3LxM4BBOZvjY5qUU5wjGzwQZAbLHFvnbvaDze7iMss5nm5WRA8o90W49PtaS11llApxrz82RxpddVhqeyKn+QkQlAuc6J4VjrzN39vBZ0iOKP06p0xUBVkl3LA80BQNbr2Sd+hff1BZ94zF4SzMsgZbSnu2Z3hPx6KPSC4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998633; c=relaxed/simple;
	bh=ebrBioKiDwoPLDFoQ9mW5VNPjgzlUtEjokWsPPo577g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbKPsCIyjJB1P84KbPIW22c3iY+ayy7bZT3Opu1ZRgCGDO28stM1Kv0K3kWtztbDns+GyzQknpm2gHDucXZBcm8Rr3onhAFXED7PdZC6GQi2XF/r6We2Sh6rAEAz/TXwpxTXGwkiOidjW6NeNVQhn7VtZAjTXwrv8lL7jnXc0LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYN782ul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYN782ul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F0D1F000E9;
	Thu, 28 May 2026 20:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998631;
	bh=EtQY3i2wmkO5LjFNtKjyZVv4/T/XAnPY2KNmYsMA7ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYN782ulHO7diRxUmmD2oEJ2Zh0PqpZiqNW/1W5yvFPg8bb+Tj9UCKHiY1pFWNOGM
	 7lQFre21SPR+lgAwltn1avjO2Ht/mEmitO0tOr51vS3q954zXunB89cGqz7IJljAp4
	 2625dDcQIJBACtM46KQxZU1/h06XcAKJIUrN/X08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 243/461] nvme-pci: fix use-after-free in nvme_free_host_mem()
Date: Thu, 28 May 2026 21:46:12 +0200
Message-ID: <20260528194654.178922814@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>

[ Upstream commit b35a13036755c5803168a7cb93bc66035c3e65b8 ]

nvme_free_host_mem() frees dev->hmb_sgt via dma_free_noncontiguous()
but never clears the pointer afterward.  This leads to a use-after-free
if nvme_free_host_mem() is called twice in the same error path.

This can happen during nvme_probe() when nvme_setup_host_mem() succeeds
in allocating the HMB (setting dev->hmb_sgt) but nvme_set_host_mem()
fails with an I/O error:

  nvme_setup_host_mem()
    nvme_alloc_host_mem_single()   -> sets dev->hmb_sgt
    nvme_set_host_mem()            -> fails with -EIO
    nvme_free_host_mem()           -> frees hmb_sgt, but does NOT NULL it
    return error

  nvme_probe() error path:
    nvme_free_host_mem()           -> dev->hmb_sgt is stale, use-after-free

The second call dereferences the freed sgt, causing a NULL pointer
dereference in iommu_dma_free_noncontiguous() when it accesses
sgt->sgl->dma_address (the backing memory has been freed and zeroed).

This is reproducible on Thunderbolt-attached NVMe devices (e.g., OWC
Envoy Express behind a Dell WD22TB4 dock) where the device intermittently
returns I/O errors during HMB setup due to PCIe link instability.

 BUG: kernel NULL pointer dereference, address: 0000000000000010
 RIP: 0010:iommu_dma_free_noncontiguous+0x22/0x80
 Call Trace:
  <TASK>
  dma_free_noncontiguous+0x3b/0x130
  nvme_free_host_mem+0x30/0xf0 [nvme]
  nvme_probe.cold+0xcc/0x275 [nvme]
  local_pci_probe+0x43/0xa0
  pci_device_probe+0xeea/0x290
  really_probe+0xf9/0x3b0
  __driver_probe_device+0x8b/0x170
  driver_probe_device+0x24/0xd0
  __driver_attach_async_helper+0x6b/0x110
  async_run_entry_fn+0x37/0x170
  process_one_work+0x1ac/0x3d0
  worker_thread+0x1b8/0x360
  kthread+0xf7/0x130
  ret_from_fork+0x2d8/0x3a0
  ret_from_fork_asm+0x1a/0x30
  </TASK>

Fix this by setting dev->hmb_sgt to NULL after freeing it, so the
second call takes the multi-descriptor path which safely handles the
already-cleaned-up state.

Fixes: 63a5c7a4b4c4 ("nvme-pci: use dma_alloc_noncontigous if possible")
Signed-off-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 4c052ed18cb8d..6d522c52dca67 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2533,11 +2533,13 @@ static void nvme_free_host_mem_multi(struct nvme_dev *dev)
 
 static void nvme_free_host_mem(struct nvme_dev *dev)
 {
-	if (dev->hmb_sgt)
+	if (dev->hmb_sgt) {
 		dma_free_noncontiguous(dev->dev, dev->host_mem_size,
 				dev->hmb_sgt, DMA_BIDIRECTIONAL);
-	else
+		dev->hmb_sgt = NULL;
+	} else {
 		nvme_free_host_mem_multi(dev);
+	}
 
 	dma_free_coherent(dev->dev, dev->host_mem_descs_size,
 			dev->host_mem_descs, dev->host_mem_descs_dma);
-- 
2.53.0



