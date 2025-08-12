Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A0328505A;
	Tue, 12 Aug 2025 19:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026528; cv=none; b=WYhDcJYUdhNIR3nvPOFbptiqtZ1w5CVDM5QpsO1I8UhM1P5Rlm8LMMi5TgZv5wU3o/7xXOObrd8pxF2b9d/j5psVIePMxRw6NoXDqYNDkmBsHw8W0XnsExM/tDQ8t+EgoXIpDPHRDW5QOBRW1o1Wmxsf6E+vuaO3m15cGzMCBX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026528; c=relaxed/simple;
	bh=ICkebNkbM93krg28NMu3moOGYbYDWvxrCndizzOY3Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDDLh1XMoaPcHGXKX83DB40voUrsS7MhwJJjGFZVE3+X/Wb4yyw93ptKLIQYEsTw632TWryLZP6ffT/jX1BWTczt90o+9j5Fy2l7iOt9rb0zcqEAhaxm+UDuHzw52n1LjaXmhZnlvzAsjT3EdsSoEuHTxN2BMfNZ8uIaA0MEupU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWtzLMK1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWtzLMK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12453C4CEF7;
	Tue, 12 Aug 2025 19:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026528;
	bh=ICkebNkbM93krg28NMu3moOGYbYDWvxrCndizzOY3Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWtzLMK1ajTEDa7JqNl0U2vnegCcxctechO6ue+RQlpi0Q5IpI2xEtWl+1mJEEcMM
	 1Ywlxlu1FFemJGC/LkGBUA7PnESMxym0TXDt7IhGbuHOizRchAAP/9F+lt6qZEj6tW
	 Jh75pHVMF26mi1CS+vA9z0igEHIbxA3cW7TK+0sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 363/480] vfio: Prevent open_count decrement to negative
Date: Tue, 12 Aug 2025 19:49:31 +0200
Message-ID: <20250812174412.401587131@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Pan <jacob.pan@linux.microsoft.com>

[ Upstream commit 982ddd59ed97dc7e63efd97ed50273ffb817bd41 ]

When vfio_df_close() is called with open_count=0, it triggers a warning in
vfio_assert_device_open() but still decrements open_count to -1. This allows
a subsequent open to incorrectly pass the open_count == 0 check, leading to
unintended behavior, such as setting df->access_granted = true.

For example, running an IOMMUFD compat no-IOMMU device with VFIO tests
(https://github.com/awilliam/tests/blob/master/vfio-noiommu-pci-device-open.c)
results in a warning and a failed VFIO_GROUP_GET_DEVICE_FD ioctl on the first
run, but the second run succeeds incorrectly.

Add checks to avoid decrementing open_count below zero.

Fixes: 05f37e1c03b6 ("vfio: Pass struct vfio_device_file * to vfio_device_open/close()")
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jacob Pan <jacob.pan@linux.microsoft.com>
Link: https://lore.kernel.org/r/20250618234618.1910456-2-jacob.pan@linux.microsoft.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/vfio_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582..5046cae05222 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -583,7 +583,8 @@ void vfio_df_close(struct vfio_device_file *df)
 
 	lockdep_assert_held(&device->dev_set->lock);
 
-	vfio_assert_device_open(device);
+	if (!vfio_assert_device_open(device))
+		return;
 	if (device->open_count == 1)
 		vfio_df_device_last_close(df);
 	device->open_count--;
-- 
2.39.5



