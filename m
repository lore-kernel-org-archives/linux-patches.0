Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31247BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:59:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A925FC433EF;
	Tue,  7 Mar 2023 17:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211957;
	bh=fg+x+bkFX6ZUErlos+KNhs00/QnMBAaIv1Y9TMxot/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qaeIL/xTLAXsQEo2t9m/jKGJFWAJdVXHly9srnZl3iiW6e+LQx+W9spaXIAcba+o6
	 0Ht7jRIQprJ5E+CO56UoElieHrzif4YH8IGlJxXMDYxmnYbOEMjMNGud6F4v8cuilS
	 tmthEd9O2zuHSr90mYtC0W1szO75j78CO3rcQZpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiheng Lin <linqiheng@huawei.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/885] ARM: zynq: Fix refcount leak in zynq_early_slcr_init
Date: Tue,  7 Mar 2023 17:49:07 +0100
Message-Id: <20230307170002.209388542@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 37707614885a5..9765b3f4c2fc5 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -213,6 +213,7 @@ int __init zynq_early_slcr_init(void)
 	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
 	if (IS_ERR(zynq_slcr_regmap)) {
 		pr_err("%s: failed to find zynq-slcr\n", __func__);
+		of_node_put(np);
 		return -ENODEV;
 	}
 
-- 
2.39.2



