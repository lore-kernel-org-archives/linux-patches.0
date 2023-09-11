Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15EE71170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856ECC433C7;
	Mon, 11 Sep 2023 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441456;
	bh=kDIGIiClBgJvcdok2deF5vZxFLuFeH6YuVjCFPKFYhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JlfyT86ydXhXRnzYr8OsE8IbKrxhjReKoRW2n5wgDRc8Lm3dfYrXcgqxAYsEK9mWI
	 ILutj2LHY1CEGVzd4fCJCUzjr4nUC5fysu8Lx5qHC94k1EcLrP1mYyGOz/gGzD4P08
	 DfVuGUuCCGsr4TIaMQvlD3H3zVd3zW1y0AbG4+uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 6.5 419/739] nvdimm: Fix dereference after free in register_nvdimm_pmu()
Date: Mon, 11 Sep 2023 15:43:38 +0200
Message-ID: <20230911134702.881144721@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>

[ Upstream commit 08ca6906a4b7e48f8e93b7c1f49a742a415be6d5 ]

'nd_pmu->pmu.attr_groups' is dereferenced in function
'nvdimm_pmu_free_hotplug_memory' call after it has been freed. Because in
function 'nvdimm_pmu_free_hotplug_memory' memory pointed by the fields of
'nd_pmu->pmu.attr_groups' is deallocated it is necessary to call 'kfree'
after 'nvdimm_pmu_free_hotplug_memory'.

Fixes: 0fab1ba6ad6b ("drivers/nvdimm: Add perf interface to expose nvdimm performance stats")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://lore.kernel.org/r/20230817114103.754977-1-konstantin.meskhidze@huawei.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/nd_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
index 14881c4e03e6b..2b6dc80d8fb5b 100644
--- a/drivers/nvdimm/nd_perf.c
+++ b/drivers/nvdimm/nd_perf.c
@@ -308,8 +308,8 @@ int register_nvdimm_pmu(struct nvdimm_pmu *nd_pmu, struct platform_device *pdev)
 
 	rc = perf_pmu_register(&nd_pmu->pmu, nd_pmu->pmu.name, -1);
 	if (rc) {
-		kfree(nd_pmu->pmu.attr_groups);
 		nvdimm_pmu_free_hotplug_memory(nd_pmu);
+		kfree(nd_pmu->pmu.attr_groups);
 		return rc;
 	}
 
-- 
2.40.1



