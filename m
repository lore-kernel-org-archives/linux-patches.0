Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550901863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF07C433D2;
	Wed, 28 Dec 2022 15:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240319;
	bh=rhCB+WaL4XZfaMPn3n25f3dMxAmtvJ2BFmgERi8/Aco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bKERqvHbNLlKLA9S68HmDg1fvgttNiqWHBKCm04p/zKTzhXlorHV16H9BOiHMFzMi
	 Wie1sIr1yNnZ3kZDRNYiRC+bXTuf3vJtiD87WE2t5hK6JlN5OlLdWA9j5nxhIEPCjw
	 7vFhW7MZb9JrdurMK6hZm0nb6UG8A/jp9gSVS4F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/731] clk: socfpga: Fix memory leak in socfpga_gate_init()
Date: Wed, 28 Dec 2022 15:37:08 +0100
Message-Id: <20221228144305.880010115@linuxfoundation.org>
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

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 0b8ba891ad4d1ef6bfa4c72efc83f9f9f855f68b ]

Free @socfpga_clk and @ops on the error path to avoid memory leak issue.

Fixes: a30a67be7b6e ("clk: socfpga: Don't have get_parent for single parent ops")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221123031622.63171-1-xiujianfeng@huawei.com
Acked-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/socfpga/clk-gate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/socfpga/clk-gate.c b/drivers/clk/socfpga/clk-gate.c
index 1ec9678d8cd3..ee2a2d284113 100644
--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -188,8 +188,10 @@ void __init socfpga_gate_init(struct device_node *node)
 		return;
 
 	ops = kmemdup(&gateclk_ops, sizeof(gateclk_ops), GFP_KERNEL);
-	if (WARN_ON(!ops))
+	if (WARN_ON(!ops)) {
+		kfree(socfpga_clk);
 		return;
+	}
 
 	rc = of_property_read_u32_array(node, "clk-gate", clk_gate, 2);
 	if (rc)
@@ -243,6 +245,7 @@ void __init socfpga_gate_init(struct device_node *node)
 
 	err = clk_hw_register(NULL, hw_clk);
 	if (err) {
+		kfree(ops);
 		kfree(socfpga_clk);
 		return;
 	}
-- 
2.35.1



