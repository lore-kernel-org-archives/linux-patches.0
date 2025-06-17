Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9096021018A;
	Tue, 17 Jun 2025 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176758; cv=none; b=OE5JmUP7HeAvLmvlYZR3Twu3eZFv+u0dhJ714WUqc2SdkZjt60Hg+GZbRaKXPKLw6mCxOdHNKU33HjjyDTLOvUjztKuJW2Aw1944lIfsvdIXdZJF9VuUKS7MgPqFSRQt9N1OhwuW7zlu/UZ2GWeSgUfYFOIZGBettjDFfsgyJik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176758; c=relaxed/simple;
	bh=jC7VrFA8s+NLJgmYZe8+GJkuGfhzBfEIkC20TeJMlzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ak+JWa2+qGHLv3j1J7eG6Q2rmf+LIEGB+TjdkzmX0OyQNwNwHSj/9Lt+kvZJHCL9YSiPuGF8voGbKKNiFctLc9iQ27ibMflY0SXxakvXzlKhway+MTt9gu4F8Mr43tXIWUQYb1BiF3vzNyyq7vyT2wpX/A6OxCn4SQpEXozf6q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li8vSIfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li8vSIfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96965C4CEE3;
	Tue, 17 Jun 2025 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176758;
	bh=jC7VrFA8s+NLJgmYZe8+GJkuGfhzBfEIkC20TeJMlzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li8vSIfqECPMcABw7oN1iZ0u7HUzaMczuNoVJfbNMPhOX3fLBRSShWcfcMqgfGZSH
	 P81KkdqTYebUNFz55X3ykLQCOGonNvrE85ZIqhaFOyo5ihDEYAbx6ASu780nxqp0cr
	 Mq0Yd4KHzC+8/BBM8HnZtQcu0lrO98Yp/CY2pw6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Robin Murphy <robin.murphy@arm.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 223/780] iommu/io-pgtable-arm: dynamically allocate selftest device struct
Date: Tue, 17 Jun 2025 17:18:51 +0200
Message-ID: <20250617152500.534474029@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit fa26198d30f3cdd7627ce47362057848219de765 ]

In general a 'struct device' is way too large to be put on the kernel
stack. Apparently something just caused it to grow a slightly larger,
which pushed the arm_lpae_do_selftests() function over the warning
limit in some configurations:

drivers/iommu/io-pgtable-arm.c:1423:19: error: stack frame size (1032) exceeds limit (1024) in 'arm_lpae_do_selftests' [-Werror,-Wframe-larger-than]
 1423 | static int __init arm_lpae_do_selftests(void)
      |                   ^

Change the function to use a dynamically allocated faux_device
instead of the on-stack device structure.

Fixes: ca25ec247aad ("iommu/io-pgtable-arm: Remove iommu_dev==NULL special case")
Link: https://lore.kernel.org/all/ab75a444-22a1-47f5-b3c0-253660395b5a@arm.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20250423164826.2931382-1-arnd@kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-arm.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 7632c80edea63..396c4f6f5a5bd 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -13,6 +13,7 @@
 #include <linux/bitops.h>
 #include <linux/io-pgtable.h>
 #include <linux/kernel.h>
+#include <linux/device/faux.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -1433,15 +1434,17 @@ static int __init arm_lpae_do_selftests(void)
 	};
 
 	int i, j, k, pass = 0, fail = 0;
-	struct device dev;
+	struct faux_device *dev;
 	struct io_pgtable_cfg cfg = {
 		.tlb = &dummy_tlb_ops,
 		.coherent_walk = true,
-		.iommu_dev = &dev,
 	};
 
-	/* __arm_lpae_alloc_pages() merely needs dev_to_node() to work */
-	set_dev_node(&dev, NUMA_NO_NODE);
+	dev = faux_device_create("io-pgtable-test", NULL, 0);
+	if (!dev)
+		return -ENOMEM;
+
+	cfg.iommu_dev = &dev->dev;
 
 	for (i = 0; i < ARRAY_SIZE(pgsize); ++i) {
 		for (j = 0; j < ARRAY_SIZE(address_size); ++j) {
@@ -1461,6 +1464,8 @@ static int __init arm_lpae_do_selftests(void)
 	}
 
 	pr_info("selftest: completed with %d PASS %d FAIL\n", pass, fail);
+	faux_device_destroy(dev);
+
 	return fail ? -EFAULT : 0;
 }
 subsys_initcall(arm_lpae_do_selftests);
-- 
2.39.5



