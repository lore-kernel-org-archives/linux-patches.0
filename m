Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A84A344055;
	Wed, 21 Jan 2026 18:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020248; cv=none; b=WLJgO4I4cfhYwnE2xy3Z88JkOZPbi7bX6N0eFYX3o8EOJYh1oiuz8cpvU3ZHz9lx0Eoa2cUBoCj/hrxyMkruyGmES9GRbdn4kiPCEngQVYr5MlFDSqDZ7qleTNhCWm365U6ZFdv9k2QvadliXnsTAmo6o+hzT04qHxPn9+733O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020248; c=relaxed/simple;
	bh=TnmXr41vRtavySyGwf3+u4CVyIsSVavVuRGFK8UtH0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlufEF/J1T7+p/yIAMkHy8XZBqnGOugw2UA2VRnyl4JPoqf23YrldguG1HSIfZp/iRpb4t3UJH/i2fNVP92SYKLmQUAGLiZ5DTkENseixGh2FuRkcIdx/kOR61vArLyYW4tvyPxDWGx9tb2BFoskw2ODCz3DJifmzTgP15/LV0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMMqUAt/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMMqUAt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E455AC4CEF1;
	Wed, 21 Jan 2026 18:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020248;
	bh=TnmXr41vRtavySyGwf3+u4CVyIsSVavVuRGFK8UtH0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMMqUAt/MbUtSaS3O7CXlaxRWvwBPhQwSiaHnX5d/RID0Cq5Y4X8tLCg/8IRd9jkL
	 2FHG90ibh6SAPe6LTHI71br+ut0iI4D9G1ZNMxLfyuShY9/8c1WCyaJ69NQnwAXcnt
	 YyJlwzWvrdKaOfkOdmDWVB9noSSWq+WUsx7aWfDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lizhi Hou <lizhi.hou@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Anthony Brandon <anthony@amarulasolutions.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/198] dmaengine: xilinx: xdma: Fix regmap max_register
Date: Wed, 21 Jan 2026 19:14:58 +0100
Message-ID: <20260121181421.078635985@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anthony Brandon <anthony@amarulasolutions.com>

[ Upstream commit c7d436a6c1a274c1ac28d5fb3b8eb8f03b6d0e10 ]

The max_register field is assigned the size of the register memory
region instead of the offset of the last register.
The result is that reading from the regmap via debugfs can cause
a segmentation fault:

tail /sys/kernel/debug/regmap/xdma.1.auto/registers
Unable to handle kernel paging request at virtual address ffff800082f70000
Mem abort info:
  ESR = 0x0000000096000007
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x07: level 3 translation fault
[...]
Call trace:
 regmap_mmio_read32le+0x10/0x30
 _regmap_bus_reg_read+0x74/0xc0
 _regmap_read+0x68/0x198
 regmap_read+0x54/0x88
 regmap_read_debugfs+0x140/0x380
 regmap_map_read_file+0x30/0x48
 full_proxy_read+0x68/0xc8
 vfs_read+0xcc/0x310
 ksys_read+0x7c/0x120
 __arm64_sys_read+0x24/0x40
 invoke_syscall.constprop.0+0x64/0x108
 do_el0_svc+0xb0/0xd8
 el0_svc+0x38/0x130
 el0t_64_sync_handler+0x120/0x138
 el0t_64_sync+0x194/0x198
Code: aa1e03e9 d503201f f9400000 8b214000 (b9400000)
---[ end trace 0000000000000000 ]---
note: tail[1217] exited with irqs disabled
note: tail[1217] exited with preempt_count 1
Segmentation fault

Fixes: 17ce252266c7 ("dmaengine: xilinx: xdma: Add xilinx xdma driver")
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Anthony Brandon <anthony@amarulasolutions.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xdma-regs.h | 1 +
 drivers/dma/xilinx/xdma.c      | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/xilinx/xdma-regs.h b/drivers/dma/xilinx/xdma-regs.h
index 6ad08878e9386..70bca92621aa4 100644
--- a/drivers/dma/xilinx/xdma-regs.h
+++ b/drivers/dma/xilinx/xdma-regs.h
@@ -9,6 +9,7 @@
 
 /* The length of register space exposed to host */
 #define XDMA_REG_SPACE_LEN	65536
+#define XDMA_MAX_REG_OFFSET	(XDMA_REG_SPACE_LEN - 4)
 
 /*
  * maximum number of DMA channels for each direction:
diff --git a/drivers/dma/xilinx/xdma.c b/drivers/dma/xilinx/xdma.c
index 0d88b1a670e14..5ecf8223c112e 100644
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -38,7 +38,7 @@ static const struct regmap_config xdma_regmap_config = {
 	.reg_bits = 32,
 	.val_bits = 32,
 	.reg_stride = 4,
-	.max_register = XDMA_REG_SPACE_LEN,
+	.max_register = XDMA_MAX_REG_OFFSET,
 };
 
 /**
-- 
2.51.0



