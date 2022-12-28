Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78951863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C186C433D2;
	Wed, 28 Dec 2022 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240348;
	bh=NaX9lVHV3ViQPF2J7kvtfOtQ0W+iwzMLAjy6GUNUaII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vSOL3qCVq8VQCnoqtSc0RQOFtqyRNRL97ptr4WP41RV+VM62YWZgF7igaacsBA7Dx
	 Ha2u5pVJM3m3f/mlq1ZmlNrgIQEg/RtzYS0dZqdptIxXBsUuvHvWtOYvwoyF911ON5
	 c/JuQIFFFWKlf8O9UhT+iVUtRrY0NYpFEZUiQOu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0132/1073] perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()
Date: Wed, 28 Dec 2022 15:28:40 +0100
Message-Id: <20221228144331.619380411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 17b8d847b92d815d1638f0de154654081d66b281 ]

pci_get_device() will increase the reference count for the returned
pci_dev, so tgl_uncore_get_mc_dev() will return a pci_dev with its
reference count increased. We need to call pci_dev_put() to decrease the
reference count before exiting from __uncore_imc_init_box(). Add
pci_dev_put() for both normal and error path.

Fixes: fdb64822443e ("perf/x86: Add Intel Tiger Lake uncore support")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20221118063137.121512-5-wangxiongfeng2@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_snb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/events/intel/uncore_snb.c b/arch/x86/events/intel/uncore_snb.c
index 1ef4f7861e2e..1f4869227efb 100644
--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -1338,6 +1338,7 @@ static void __uncore_imc_init_box(struct intel_uncore_box *box,
 	/* MCHBAR is disabled */
 	if (!(mch_bar & BIT(0))) {
 		pr_warn("perf uncore: MCHBAR is disabled. Failed to map IMC free-running counters.\n");
+		pci_dev_put(pdev);
 		return;
 	}
 	mch_bar &= ~BIT(0);
@@ -1352,6 +1353,8 @@ static void __uncore_imc_init_box(struct intel_uncore_box *box,
 	box->io_addr = ioremap(addr, type->mmio_map_size);
 	if (!box->io_addr)
 		pr_warn("perf uncore: Failed to ioremap for %s.\n", type->name);
+
+	pci_dev_put(pdev);
 }
 
 static void tgl_uncore_imc_freerunning_init_box(struct intel_uncore_box *box)
-- 
2.35.1



