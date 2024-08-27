Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673751BC097;
	Tue, 27 Aug 2024 14:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770706; cv=none; b=NdYsrIJTuLPqOxSw5ee8yW80SohfSgsAVa/4cHtsaxDtSP4Yyjmz2kLk4gdkqCmtjzIq/j5vggJ+lwfTL3GkTcHhZDr2+oQSNubEgyXcVEzSbl4v/HFXX8ZgSVPGR39l7FPaDNeaRfJODVbITDm37jI1QDSdb7oXzFM8Ta4LOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770706; c=relaxed/simple;
	bh=YEMOrPiSGW9hT5QJPfNnJEQnFNI4Y26kQKqP1QOfwg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9hPCCPZ7d3yiaBPCdqNx1xYvJjTMPqW5oOwaEx/+Zmr0M+/nwrIq8wSITSXWGCIJblbfPjFuLsvxebXl8Su7AAV9OlNCx7JuHfLiTYbHqTh6eIdQtIc3GoPYo9dyokYOSMbJtxH3gr528wa4AsHqONfvPJS5RpDCZMOQEX9AFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGJ7Uvw0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGJ7Uvw0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84994C61044;
	Tue, 27 Aug 2024 14:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770706;
	bh=YEMOrPiSGW9hT5QJPfNnJEQnFNI4Y26kQKqP1QOfwg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGJ7Uvw0kDM+mWWZ+P4jfAGJyoHCNhUonYiwK88IdL6nA8Tie5RDWzf9883ws5Kdk
	 9aj7LJbaXvsQZXyG9BTXEED6wQ1q0q9Si5NcIR71bf31yOA5WInBmekuvetACVjP3m
	 1+U7TyqGCZ7LTTKmZRuuD1IMwtuUr4+3hoPcHkQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 309/341] nouveau/firmware: use dma non-coherent allocator
Date: Tue, 27 Aug 2024 16:39:00 +0200
Message-ID: <20240827143855.146832940@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 9b340aeb26d50e9a9ec99599e2a39b035fac978e upstream.

Currently, enabling SG_DEBUG in the kernel will cause nouveau to hit a
BUG() on startup, when the iommu is enabled:

kernel BUG at include/linux/scatterlist.h:187!
invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
CPU: 7 PID: 930 Comm: (udev-worker) Not tainted 6.9.0-rc3Lyude-Test+ #30
Hardware name: MSI MS-7A39/A320M GAMING PRO (MS-7A39), BIOS 1.I0 01/22/2019
RIP: 0010:sg_init_one+0x85/0xa0
Code: 69 88 32 01 83 e1 03 f6 c3 03 75 20 a8 01 75 1e 48 09 cb 41 89 54
24 08 49 89 1c 24 41 89 6c 24 0c 5b 5d 41 5c e9 7b b9 88 00 <0f> 0b 0f 0b
0f 0b 48 8b 05 5e 46 9a 01 eb b2 66 66 2e 0f 1f 84 00
RSP: 0018:ffffa776017bf6a0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffa77600d87000 RCX: 000000000000002b
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffffa77680d87000
RBP: 000000000000e000 R08: 0000000000000000 R09: 0000000000000000
R10: ffff98f4c46aa508 R11: 0000000000000000 R12: ffff98f4c46aa508
R13: ffff98f4c46aa008 R14: ffffa77600d4a000 R15: ffffa77600d4a018
FS:  00007feeb5aae980(0000) GS:ffff98f5c4dc0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f22cb9a4520 CR3: 00000001043ba000 CR4: 00000000003506f0
Call Trace:
 <TASK>
 ? die+0x36/0x90
 ? do_trap+0xdd/0x100
 ? sg_init_one+0x85/0xa0
 ? do_error_trap+0x65/0x80
 ? sg_init_one+0x85/0xa0
 ? exc_invalid_op+0x50/0x70
 ? sg_init_one+0x85/0xa0
 ? asm_exc_invalid_op+0x1a/0x20
 ? sg_init_one+0x85/0xa0
 nvkm_firmware_ctor+0x14a/0x250 [nouveau]
 nvkm_falcon_fw_ctor+0x42/0x70 [nouveau]
 ga102_gsp_booter_ctor+0xb4/0x1a0 [nouveau]
 r535_gsp_oneinit+0xb3/0x15f0 [nouveau]
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? nvkm_udevice_new+0x95/0x140 [nouveau]
 ? srso_return_thunk+0x5/0x5f
 ? srso_return_thunk+0x5/0x5f
 ? ktime_get+0x47/0xb0

Fix this by using the non-coherent allocator instead, I think there
might be a better answer to this, but it involve ripping up some of
APIs using sg lists.

Cc: stable@vger.kernel.org
Fixes: 2541626cfb79 ("drm/nouveau/acr: use common falcon HS FW code for ACR FWs")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240815201923.632803-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/core/firmware.c |    9 ++++++---
 drivers/gpu/drm/nouveau/nvkm/falcon/fw.c     |    6 ++++++
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/core/firmware.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/firmware.c
@@ -187,7 +187,8 @@ nvkm_firmware_dtor(struct nvkm_firmware
 		break;
 	case NVKM_FIRMWARE_IMG_DMA:
 		nvkm_memory_unref(&memory);
-		dma_free_coherent(fw->device->dev, sg_dma_len(&fw->mem.sgl), fw->img, fw->phys);
+		dma_free_noncoherent(fw->device->dev, sg_dma_len(&fw->mem.sgl),
+				     fw->img, fw->phys, DMA_TO_DEVICE);
 		break;
 	default:
 		WARN_ON(1);
@@ -212,10 +213,12 @@ nvkm_firmware_ctor(const struct nvkm_fir
 		break;
 	case NVKM_FIRMWARE_IMG_DMA: {
 		dma_addr_t addr;
-
 		len = ALIGN(fw->len, PAGE_SIZE);
 
-		fw->img = dma_alloc_coherent(fw->device->dev, len, &addr, GFP_KERNEL);
+		fw->img = dma_alloc_noncoherent(fw->device->dev,
+						len, &addr,
+						DMA_TO_DEVICE,
+						GFP_KERNEL);
 		if (fw->img) {
 			memcpy(fw->img, src, fw->len);
 			fw->phys = addr;
--- a/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/fw.c
@@ -89,6 +89,12 @@ nvkm_falcon_fw_boot(struct nvkm_falcon_f
 		nvkm_falcon_fw_dtor_sigs(fw);
 	}
 
+	/* after last write to the img, sync dma mappings */
+	dma_sync_single_for_device(fw->fw.device->dev,
+				   fw->fw.phys,
+				   sg_dma_len(&fw->fw.mem.sgl),
+				   DMA_TO_DEVICE);
+
 	FLCNFW_DBG(fw, "resetting");
 	fw->func->reset(fw);
 


