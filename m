Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD668481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A15C433EF;
	Fri, 10 Mar 2023 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457685;
	bh=66dWPDY6YQiRJZ/wdMnTaRXpUh5VpRssfKqmzur64bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXlhCMmTtU9anmJQj4gaFByCM1Bw/+idw7MrcLKAJpyOQWuIwHhV8T5SRtHLyHGou
	 nSBwI2GWO77Hy+Dzfe91oxuQ8959crH88PJB9yXMFoSfZJYWZIxU/UG1CqVACzqVHH
	 ONguWkchyP87FwHYAzMZtmI/DLKnQm6DSgTf3oww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiheng Lin <linqiheng@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 005/252] ARM: zynq: Fix refcount leak in zynq_early_slcr_init
Date: Fri, 10 Mar 2023 14:36:15 +0100
Message-Id: <20230310133718.975094913@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qiheng Lin <linqiheng@huawei.com>

[ Upstream commit 9eedb910a3be0005b88c696a8552c0d4c9937cd4 ]

of_find_compatible_node() returns a node pointer with refcount incremented,
we should use of_node_put() on error path.
Add missing of_node_put() to avoid refcount leak.

Fixes: 3329659df030 ("ARM: zynq: Simplify SLCR initialization")
Signed-off-by: Qiheng Lin <linqiheng@huawei.com>
Link: https://lore.kernel.org/r/20221129140544.41293-1-linqiheng@huawei.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-zynq/slcr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index f0292a30e6f69..6b75ef7be3fda 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -222,6 +222,7 @@ int __init zynq_early_slcr_init(void)
 	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
 	if (IS_ERR(zynq_slcr_regmap)) {
 		pr_err("%s: failed to find zynq-slcr\n", __func__);
+		of_node_put(np);
 		return -ENODEV;
 	}
 
-- 
2.39.2



