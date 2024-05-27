Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60489262BE;
	Mon, 27 May 2024 19:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838061; cv=none; b=VXdBNlF/ReBwK+8KXg3Kag/XegAcplWC0qj8lXaJdMNnDX5UQmpkZ1kELG9EX+ayG+UNKcIywlTLImQI+D227WxX8B1Pws6+bEmDf0m4idNUF+LKWKSV/dnY9ywPD5MbUULTJhLVmEqX2nkX2qewa3mcXJ72NrX7kKypDHMMffo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838061; c=relaxed/simple;
	bh=Px9DcZy/bOnMVoamtCiAwBL1lY+7LglazCNZSZjBkU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L/y/OYBeVFBIfXFIfARGWtOl1A938lAb8y2kzIQNmRr6mtHmZu5o4wHGUYoY3L24HhPSVMn1Wvnu+N7j6j8Ml2WYQtrgUgyfLSnETGHq2KlSi5A3nxqAbCuKRu7ie+H2uc/RzSuebx5YMk22kMJ6EXtZaQQIxPEcHYR8/zlyhJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNppuKk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNppuKk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5CFC2BBFC;
	Mon, 27 May 2024 19:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838061;
	bh=Px9DcZy/bOnMVoamtCiAwBL1lY+7LglazCNZSZjBkU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNppuKk0jCarda4HyGpg1G6U1/+e6/dntrUgp0+CEbZkwqc1K9iWrLhIfn8sIxmyR
	 gELLxa5OUgVC3YWCZW3WPC5Qo+Dxp/+xpZHSJUEs3B2QFcDquzGYS/Nya9s8ZnFoqr
	 PAa6TjEUA2aKQbZEezOdiB1ad5yHtAab2LJxj47w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chen <chenhao418@huawei.com>,
	Junhao He <hejunhao3@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 250/493] drivers/perf: hisi: hns3: Actually use devm_add_action_or_reset()
Date: Mon, 27 May 2024 20:54:12 +0200
Message-ID: <20240527185638.478646302@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Chen <chenhao418@huawei.com>

[ Upstream commit 582c1aeee0a9e73010cf1c4cef338709860deeb0 ]

pci_alloc_irq_vectors() allocates an irq vector. When devm_add_action()
fails, the irq vector is not freed, which leads to a memory leak.

Replace the devm_add_action with devm_add_action_or_reset to ensure
the irq vector can be destroyed when it fails.

Fixes: 66637ab137b4 ("drivers/perf: hisi: add driver for HNS3 PMU")
Signed-off-by: Hao Chen <chenhao418@huawei.com>
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240425124627.13764-4-hejunhao3@huawei.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hns3_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/hisilicon/hns3_pmu.c b/drivers/perf/hisilicon/hns3_pmu.c
index cbdd53b0a0342..60062eaa342aa 100644
--- a/drivers/perf/hisilicon/hns3_pmu.c
+++ b/drivers/perf/hisilicon/hns3_pmu.c
@@ -1527,7 +1527,7 @@ static int hns3_pmu_irq_register(struct pci_dev *pdev,
 		return ret;
 	}
 
-	ret = devm_add_action(&pdev->dev, hns3_pmu_free_irq, pdev);
+	ret = devm_add_action_or_reset(&pdev->dev, hns3_pmu_free_irq, pdev);
 	if (ret) {
 		pci_err(pdev, "failed to add free irq action, ret = %d.\n", ret);
 		return ret;
-- 
2.43.0



