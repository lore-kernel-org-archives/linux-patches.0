Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AAC11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B88C433C9;
	Mon, 11 Sep 2023 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445691;
	bh=VdCOEZVsrUEH8b48GhUb+mKrAddOcLNQeYTcyJMUb18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wMVW+FURmrtRDGTaRnErB8BiJ+JH9SM3kwiFcfKmfeqlAgXS0ehjWVe2IiSnQy4DS
	 yjcdSb+PtidUKlomnvAg4zG/LjFH3HAqX0/mEIsmUz2rSaSp25DriFkVXeE96uM/jn
	 N2rs2+EybYYu5YrSCO++o7dx3AjACtelT5nC8NV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/600] driver core: Call dma_cleanup() on the test_remove path
Date: Mon, 11 Sep 2023 15:47:51 +0200
Message-ID: <20230911134646.580663727@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit f429378a9bf84d79a7e2cae05d2e3384cf7d68ba ]

When test_remove is enabled really_probe() does not properly pair
dma_configure() with dma_remove(), it will end up calling dma_configure()
twice. This corrupts the owner_cnt and renders the group unusable with
VFIO/etc.

Add the missing cleanup before going back to re_probe.

Fixes: 25f3bcfc54bc ("driver core: Add dma_cleanup callback in bus_type")
Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Closes: https://lore.kernel.org/all/6472f254-c3c4-8610-4a37-8d9dfdd54ce8@huawei.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/0-v2-4deed94e283e+40948-really_probe_dma_cleanup_jgg@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 97ab1468a8760..380a53b6aee81 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -674,6 +674,8 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 
 		device_remove(dev);
 		driver_sysfs_remove(dev);
+		if (dev->bus && dev->bus->dma_cleanup)
+			dev->bus->dma_cleanup(dev);
 		device_unbind_cleanup(dev);
 
 		goto re_probe;
-- 
2.40.1



