Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA3C11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:19:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C74C433C8;
	Mon, 11 Sep 2023 15:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445569;
	bh=zOxYafHTMzSTFx1g6mridF7jxj+9u1aZEhkIErsqFF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZqVoCW1iQG6PkwkU/CqyDWvW1kwtHXvMY5WSfrNRfO8yNwKQTw/qV/xxWJGIZsP+E
	 ahgNN7T6bVcQ9isONKRRqoESEMMHebMNPNXSMGrXb/PfZtzNiaQ+PolyTJ/UiT5+ZF
	 x44R0Fa0eKGlYlqmT+aMaEITeGoSTRlkSQtf0NHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Meskhidze <konstantin.meskhidze@huawei.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Ivanov Mikhail <ivanov.mikhail1@huawei-partners.com>
Subject: [PATCH 6.1 363/600] nvdimm: Fix memleak of pmu attr_groups in unregister_nvdimm_pmu()
Date: Mon, 11 Sep 2023 15:46:36 +0200
Message-ID: <20230911134644.395307640@linuxfoundation.org>
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



