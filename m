Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882FD1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2CEC433D2;
	Wed, 28 Dec 2022 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239011;
	bh=3A+SBrRFxWKVJUUDtRJhCLdZyBljL+UkRhtIduD9JIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YAFfPrJPiOlZEglz24Tgkehdby1IbDqQjgw1pExjvwqB5g2wBy0/8kKmgAUFwCMhU
	 EVismXNoxt8oOrg4/LRMf2My4Y7d/kBL9DdiqKMokDk1BE5WluVUKy4LsMeunOYmcM
	 KN8QHaO6Y6OetCkghOJ+MwXyJGomXtjz6tVH95UU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/731] perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map()
Date: Wed, 28 Dec 2022 15:33:22 +0100
Message-Id: <20221228144259.304208786@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 8ebd16c11c346751b3944d708e6c181ed4746c39 ]

pci_get_device() will increase the reference count for the returned
pci_dev, so snr_uncore_get_mc_dev() will return a pci_dev with its
reference count increased. We need to call pci_dev_put() to decrease the
reference count. Let's add the missing pci_dev_put().

Fixes: ee49532b38dd ("perf/x86/intel/uncore: Add IMC uncore support for Snow Ridge")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-4-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snbep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index f5d89d06c66a..fcd95e93f479 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -4860,6 +4860,8 @@ static int snr_uncore_mmio_map(struct intel_uncore_box *box,
 
 	addr += box_ctl;
 
+	pci_dev_put(pdev);
+
 	box->io_addr = ioremap(addr, type->mmio_map_size);
 	if (!box->io_addr) {
 		pr_warn("perf uncore: Failed to ioremap for %s.\n", type->name);
-- 
2.35.1



