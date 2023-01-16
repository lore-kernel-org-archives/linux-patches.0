Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8124C46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070A5C433EF;
	Mon, 16 Jan 2023 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886269;
	bh=5uNCaiQLG1bq26f6K71hyG/8oB86S2dt+hc1j0Eg74g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlUWIN5NgOK6UzWtIt9sF1kiHZTGgCcpj0fQKbmGnqIq8jXEidihztmLDgRRga4wn
	 r7tEx5YzNDGm7XLuxgmUUncf1lA3FLYf7JW2WY3/71xbsEJszwYBKmfMXwSjWl9qYD
	 EtlW9ZzEVgbdN7MShTWYufiTG1MEGA66TM4a5tAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 349/658] iommu/amd: Fix pci device refcount leak in ppr_notifier()
Date: Mon, 16 Jan 2023 16:47:17 +0100
Message-Id: <20230116154925.527193171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 6cf0981c2233f97d56938d9d61845383d6eb227c ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put(). So call it before returning from ppr_notifier()
to avoid refcount leak.

Fixes: daae2d25a477 ("iommu/amd: Don't copy GCR3 table root pointer")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221118093604.216371-1-yangyingliang@huawei.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 05f3d93cf480..db391dd779c0 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -591,6 +591,7 @@ static int ppr_notifier(struct notifier_block *nb, unsigned long e, void *data)
 	put_device_state(dev_state);
 
 out:
+	pci_dev_put(pdev);
 	return ret;
 }
 
-- 
2.35.1



