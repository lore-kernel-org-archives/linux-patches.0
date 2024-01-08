Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1093647791;
	Mon,  8 Jan 2024 15:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MWDKSFPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED66C433CB;
	Mon,  8 Jan 2024 15:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726876;
	bh=EDgatXhHgcjA0cwU/mrXZB/1y7+Tvs7Vf8jOAxmqF9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWDKSFPaA6bTFXuRsKdWDT1hpcqIXpTMLze6eDSgFbDTwWL/PxrdfQWgpq3D/PEwm
	 Bpzf+5d9v1IJG2b4e/hYr3spcaGnAo/livdmltg1+otJTXosinjZezNKnH3njoREqT
	 kYgCAsWpxNJUqptBJ5y3Voouv6uirMtLcokK9lnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 106/124] cxl/pmu: Ensure put_device on pmu devices
Date: Mon,  8 Jan 2024 16:08:52 +0100
Message-ID: <20240108150607.845391746@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Ira Weiny <ira.weiny@intel.com>

[ Upstream commit ef3d5cf9c59cccb012aa6b93d99f4c6eb5d6648e ]

The following kmemleaks were detected when removing the cxl module
stack:

unreferenced object 0xffff88822616b800 (size 1024):
...
  backtrace:
    [<00000000bedc6f83>] kmalloc_trace+0x26/0x90
    [<00000000448d1afc>] devm_cxl_pmu_add+0x3a/0x110 [cxl_core]
    [<00000000ca3bfe16>] 0xffffffffa105213b
    [<00000000ba7f78dc>] local_pci_probe+0x41/0x90
    [<000000005bb027ac>] pci_device_probe+0xb0/0x1c0
...
unreferenced object 0xffff8882260abcc0 (size 16):
...
  hex dump (first 16 bytes):
    70 6d 75 5f 6d 65 6d 30 2e 30 00 26 82 88 ff ff  pmu_mem0.0.&....
  backtrace:
...
    [<00000000152b5e98>] dev_set_name+0x43/0x50
    [<00000000c228798b>] devm_cxl_pmu_add+0x102/0x110 [cxl_core]
    [<00000000ca3bfe16>] 0xffffffffa105213b
    [<00000000ba7f78dc>] local_pci_probe+0x41/0x90
    [<000000005bb027ac>] pci_device_probe+0xb0/0x1c0
...
unreferenced object 0xffff8882272af200 (size 256):
...
  backtrace:
    [<00000000bedc6f83>] kmalloc_trace+0x26/0x90
    [<00000000a14d1813>] device_add+0x4ea/0x890
    [<00000000a3f07b47>] devm_cxl_pmu_add+0xbe/0x110 [cxl_core]
    [<00000000ca3bfe16>] 0xffffffffa105213b
    [<00000000ba7f78dc>] local_pci_probe+0x41/0x90
    [<000000005bb027ac>] pci_device_probe+0xb0/0x1c0
...

devm_cxl_pmu_add() correctly registers a device remove function but it
only calls device_del() which is only part of device unregistration.

Properly call device_unregister() to free up the memory associated with
the device.

Fixes: 1ad3f701c399 ("cxl/pci: Find and register CXL PMU devices")
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20231016-pmu-unregister-fix-v1-1-1e2eb2fa3c69@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/pmu.c b/drivers/cxl/core/pmu.c
index 7684c843e5a59..5d8e06b0ba6e8 100644
--- a/drivers/cxl/core/pmu.c
+++ b/drivers/cxl/core/pmu.c
@@ -23,7 +23,7 @@ const struct device_type cxl_pmu_type = {
 
 static void remove_dev(void *dev)
 {
-	device_del(dev);
+	device_unregister(dev);
 }
 
 int devm_cxl_pmu_add(struct device *parent, struct cxl_pmu_regs *regs,
-- 
2.43.0



