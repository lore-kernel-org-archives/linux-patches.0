Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C383DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZttdObHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C56B9C433C7;
	Wed, 15 Nov 2023 19:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078349;
	bh=SRxHyg9NUkUFUAfZturvw8K0Fvxlb3SJIM8jJyaYAkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZttdObHL3B1yDUL9IEj60zH9fh2gBL+e2sdUcIwLt+yBfP7APbG1jG902C1d+IZqj
	 0l3NjNDM2wlSD4an5laQjcGToTzmXam6Qo6rhD9qBDINgXgUMhoCT9NIpzkGjo60BT
	 x5f3iOvlvZhjlIZ8zFRxail/3Px42pqEoDYvM1Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Prinke <michael.prinke@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Lijun Pan <lijun.pan@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 267/379] dmaengine: idxd: Register dsa_bus_type before registering idxd sub-drivers
Date: Wed, 15 Nov 2023 14:25:42 -0500
Message-ID: <20231115192700.922685512@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit 88928addeec577386e8c83b48b5bc24d28ba97fd ]

idxd sub-drivers belong to bus dsa_bus_type. Thus, dsa_bus_type must be
registered in dsa bus init before idxd drivers can be registered.

But the order is wrong when both idxd and idxd_bus are builtin drivers.
In this case, idxd driver is compiled and linked before idxd_bus driver.
Since the initcall order is determined by the link order, idxd sub-drivers
are registered in idxd initcall before dsa_bus_type is registered
in idxd_bus initcall. idxd initcall fails:

[   21.562803] calling  idxd_init_module+0x0/0x110 @ 1
[   21.570761] Driver 'idxd' was unable to register with bus_type 'dsa' because the bus was not initialized.
[   21.586475] initcall idxd_init_module+0x0/0x110 returned -22 after 15717 usecs
[   21.597178] calling  dsa_bus_init+0x0/0x20 @ 1

To fix the issue, compile and link idxd_bus driver before idxd driver
to ensure the right registration order.

Fixes: d9e5481fca74 ("dmaengine: dsa: move dsa_bus_type out of idxd driver to standalone")
Reported-by: Michael Prinke <michael.prinke@intel.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Lijun Pan <lijun.pan@intel.com>
Tested-by: Lijun Pan <lijun.pan@intel.com>
Link: https://lore.kernel.org/r/20230924162232.1409454-1-fenghua.yu@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/Makefile | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/idxd/Makefile b/drivers/dma/idxd/Makefile
index a1e9f2b3a37cc..817ffa95a9b11 100644
--- a/drivers/dma/idxd/Makefile
+++ b/drivers/dma/idxd/Makefile
@@ -1,12 +1,12 @@
 ccflags-y += -DDEFAULT_SYMBOL_NAMESPACE=IDXD
 
+obj-$(CONFIG_INTEL_IDXD_BUS) += idxd_bus.o
+idxd_bus-y := bus.o
+
 obj-$(CONFIG_INTEL_IDXD) += idxd.o
 idxd-y := init.o irq.o device.o sysfs.o submit.o dma.o cdev.o
 
 idxd-$(CONFIG_INTEL_IDXD_PERFMON) += perfmon.o
 
-obj-$(CONFIG_INTEL_IDXD_BUS) += idxd_bus.o
-idxd_bus-y := bus.o
-
 obj-$(CONFIG_INTEL_IDXD_COMPAT) += idxd_compat.o
 idxd_compat-y := compat.o
-- 
2.42.0



