Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3064115DBD8;
	Mon, 27 May 2024 19:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836888; cv=none; b=r59J/Go8TfiyBSm0316+MversTZwb+vNhi4lPCTEmPEym86jpLdq9j533K7g9UgLzoZuuTHEAJ9PeDjYhjoF6bPTlgR867URvdk3YB/t04PqnsSOmozucdluG5WsLtwhwdQmfFhKNGSDYFVT0Dxs1Tzw3jpWROkzyo/e0eS9gJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836888; c=relaxed/simple;
	bh=A4Qa7lxtVO+or4qOw6VsDcrQn+gPCkgBYumLOfNcjf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB3BmI5KRyrM3SFwnJABMJhLVlUrd18LO3IcAJTV0jRA+J6lwxaeWVHvg03wQzeO3TkFp8EfAmsYD3oo3urrrgluMVT/FZhdMa7McMaTKP10A0e9vfgjvlRmOkq8FOecagKicup95yCiScigZd7MlcxKQmA2dLeswHDKXlwMVP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBxDeHem; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBxDeHem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E71C2BBFC;
	Mon, 27 May 2024 19:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836888;
	bh=A4Qa7lxtVO+or4qOw6VsDcrQn+gPCkgBYumLOfNcjf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBxDeHemGIK7ISnhviqSRqKGBkD5lJGsXx+cFX+dhjcygkCPSS6woeq0ZhzjVIGQf
	 SyJNzbhAcC6rVF65BUU3WomuA6zusweSbOm9jByTlMBaSIsJ+cT2yvlV28ZWOYZfQg
	 3gHPzEKX0TpLD6Y3GOPZx0HPWZxCBZWKYJg+2F8g=
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
Subject: [PATCH 6.9 185/427] drivers/perf: hisi: hns3: Actually use devm_add_action_or_reset()
Date: Mon, 27 May 2024 20:53:52 +0200
Message-ID: <20240527185619.495248735@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



