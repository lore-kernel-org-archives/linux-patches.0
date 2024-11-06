Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7730F1F8925;
	Wed,  6 Nov 2024 12:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897166; cv=none; b=UM7M8k0zHFm0t2oEvLXddEeSYQwGMpJCVku0NQZz11jKP43LF+RxvEBqUvaJ8eLMqcnWEptfR/xcQoHMGhUrMUWcvU4LhDqBDgs6KGQ1n554NuG9NNDjaN9sMeShQ+cVNh5Q0DqOyb+dAHE5AoUvjY6Dn/q7o+tJJQVekVZfdmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897166; c=relaxed/simple;
	bh=PfXJ3qFShqWRd9tY9kF2nQFe9NGcNEuk3R8zXSdPUpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sa5Cdw6xL2WvoG4vm3TvwvAkLMTjv6npA2VDZL9kBJsDGVG2tqJJXOexZMKovyckcMv6AtzgrqmFl0ubDVbhF+9CwoSELBbt2nSSeJ2ML1h1sBF/FWvjuPLT0nm8BF1G1g/+BedE1khXQ1WzNpy9haDlKDGrMCR8zceceSl61M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9NbyPtz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9NbyPtz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96180C4CECD;
	Wed,  6 Nov 2024 12:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897165;
	bh=PfXJ3qFShqWRd9tY9kF2nQFe9NGcNEuk3R8zXSdPUpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W9NbyPtzs3do+VaFZJuEcmRotjzu3WMTVXSBEG/9FqLpLAgsAcLPPxLqlAwRGfJK/
	 FN7Su5V93agcq3/vdSqIcsF5MWisDMQoXko66xJXlLT1P+TfbASbc8nZ+ECUIyhVcb
	 c+/YviuY5iXsLoI54862NCHeeKllIhDdlH5yIkEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/126] cxl/port: Fix cxl_bus_rescan() vs bus_rescan_devices()
Date: Wed,  6 Nov 2024 13:04:50 +0100
Message-ID: <20241106120308.475997830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 3d6ebf16438de5d712030fefbb4182b46373d677 ]

It turns out since its original introduction, pre-2.6.12,
bus_rescan_devices() has skipped devices that might be in the process of
attaching or detaching from their driver. For CXL this behavior is
unwanted and expects that cxl_bus_rescan() is a probe barrier.

That behavior is simple enough to achieve with bus_for_each_dev() paired
with call to device_attach(), and it is unclear why bus_rescan_devices()
took the position of lockless consumption of dev->driver which is racy.

The "Fixes:" but no "Cc: stable" on this patch reflects that the issue
is merely by inspection since the bug that triggered the discovery of
this potential problem [1] is fixed by other means.  However, a stable
backport should do no harm.

Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Link: http://lore.kernel.org/20241004212504.1246-1-gourry@gourry.net [1]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/172964781104.81806.4277549800082443769.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index f0875fa86c616..20f052d3759e0 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -1786,11 +1786,18 @@ static void cxl_bus_remove(struct device *dev)
 
 static struct workqueue_struct *cxl_bus_wq;
 
-static void cxl_bus_rescan_queue(struct work_struct *w)
+static int cxl_rescan_attach(struct device *dev, void *data)
 {
-	int rc = bus_rescan_devices(&cxl_bus_type);
+	int rc = device_attach(dev);
+
+	dev_vdbg(dev, "rescan: %s\n", rc ? "attach" : "detached");
 
-	pr_debug("CXL bus rescan result: %d\n", rc);
+	return 0;
+}
+
+static void cxl_bus_rescan_queue(struct work_struct *w)
+{
+	bus_for_each_dev(&cxl_bus_type, NULL, NULL, cxl_rescan_attach);
 }
 
 void cxl_bus_rescan(void)
-- 
2.43.0



