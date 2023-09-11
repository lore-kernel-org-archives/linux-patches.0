Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339451170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3400C433C7;
	Mon, 11 Sep 2023 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441454;
	bh=AWagPv/KSPep/Uujh2clqAqTwz0qmcGN+jCxIRgZm2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvlSTd1EUGldvM7we2U00VvSbGcHW3iI7N+06HaiPkzOaQ9zxwBeNkeFtQnyVJt11
	 cMpfB4hWNvEB0xswUszCo4w/+VJZ1/RVDBJvEpbB4CsuZyZVw+/e9H9DNAePK9H8ta
	 yfqbfl9hIohSdZfAvHpmFcwKYUQ1zMIqmWzneiiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 6.5 418/739] nvdimm: Fix memleak of pmu attr_groups in unregister_nvdimm_pmu()
Date: Mon, 11 Sep 2023 15:43:37 +0200
Message-ID: <20230911134702.854371149@linuxfoundation.org>
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

[ Upstream commit 85ae42c72142346645e63c33835da947dfa008b3 ]

Memory pointed by 'nd_pmu->pmu.attr_groups' is allocated in function
'register_nvdimm_pmu' and is lost after 'kfree(nd_pmu)' call in function
'unregister_nvdimm_pmu'.

Fixes: 0fab1ba6ad6b ("drivers/nvdimm: Add perf interface to expose nvdimm performance stats")
Co-developed-by: Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://lore.kernel.org/r/20230817115945.771826-1-konstantin.meskhidze@huawei.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/nd_perf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/nd_perf.c b/drivers/nvdimm/nd_perf.c
index 433bbb68ae641..14881c4e03e6b 100644
--- a/drivers/nvdimm/nd_perf.c
+++ b/drivers/nvdimm/nd_perf.c
@@ -324,6 +324,7 @@ void unregister_nvdimm_pmu(struct nvdimm_pmu *nd_pmu)
 {
 	perf_pmu_unregister(&nd_pmu->pmu);
 	nvdimm_pmu_free_hotplug_memory(nd_pmu);
+	kfree(nd_pmu->pmu.attr_groups);
 	kfree(nd_pmu);
 }
 EXPORT_SYMBOL_GPL(unregister_nvdimm_pmu);
-- 
2.40.1



