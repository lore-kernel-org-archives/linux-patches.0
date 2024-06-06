Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B5C1C617F;
	Thu,  6 Jun 2024 14:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683693; cv=none; b=ryLJD40HGndbZkMycGEr6Vqfr9fcBCUkMf25AhzUK1a0sZedlnXApxxYvtav7UwTNtwLOf5ZNLbHR7R9TuwSgPf3qjfeXVOfleukvHTTVcbmiB01koZSpuRQgyXcvL0wqw1M5KHqV1Sy9u10oLuxSxaqPZs0BciupUbltHzhdDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683693; c=relaxed/simple;
	bh=TSzllp3QPMf/E8/Sh1DU6lyhOYj6UJCkBWYTsKOti6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed/snFQYGfvQTXRDGiP7l2GCzHF66+Qe107pWlTFCRl9oGk4U21xugRMBVzlqiPLzegwAuzmGVxmuYvGct/xRaA0pBeP3PYdI+Li0BNnVzL0A4Urwj9QzG7BgAaK+NAAVPn8LW1ETzLIlWzJiUxITgk1WtmtwKPLJUA0y0r/pmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCtXojUh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCtXojUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78417C4AF08;
	Thu,  6 Jun 2024 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683693;
	bh=TSzllp3QPMf/E8/Sh1DU6lyhOYj6UJCkBWYTsKOti6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCtXojUh6MhPMIcWdRzIMUBS+d6GgB0phPSzdavRV3dLU8wb7f8OOG9pZ8xG5jT5H
	 ZYxtWJh/DESI/szKLpkZaA2Hnm8B+Quk1sKszJA0qyfkp4jzaudvYwwddQwBtf5niM
	 uY+KB1AqBvAZGKfg4uYamTdHsll5HmlHgmTmKdWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 605/744] cxl/region: Fix cxlr_pmem leaks
Date: Thu,  6 Jun 2024 16:04:37 +0200
Message-ID: <20240606131751.893072377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 1c987cf22d6b65ade46145c03eef13f0e3e81d83 ]

Before this error path, cxlr_pmem pointed to a kzalloc() memory, free
it to avoid this memory leaking.

Fixes: f17b558d6663 ("cxl/pmem: Refactor nvdimm device registration, delete the workqueue")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240428030748.318985-1-lizhijian@fujitsu.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index e2a82ee4ff0cf..c65ab42546238 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2549,6 +2549,7 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 		if (i == 0) {
 			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd);
 			if (!cxl_nvb) {
+				kfree(cxlr_pmem);
 				cxlr_pmem = ERR_PTR(-ENODEV);
 				goto out;
 			}
-- 
2.43.0



