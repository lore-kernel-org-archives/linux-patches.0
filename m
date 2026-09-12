Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B342D2BDC0E;
	Sat, 12 Sep 2026 08:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200081; cv=none; b=O4FGXRAIceG9UOp8xRxEnQrekQ1hjc1ItreSFN7wPQ2etajlq1AdVRmNnvqJzyZ6S4BzctjDNJjSrqXoEqGQIsU0bLdXUF82n1ygFN5Oxd0kChagdmcpdh6S2IOz08NTKiY8D6Wh0CfMdGewk28l4SOKr1hn7LHEtuWr3KgmiR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200081; c=relaxed/simple;
	bh=QLWvbbyfChF/OvPMn17pMJpj6O/SilcaaVggO1EVO7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtk9l8Due9DRt2/6MrSWcYHDTh1x4aaWbu50oZAsASpNy5K5VcdGXDxffsjMio8F26Ex0JJmaa2kViUv+E1wS5+drRi2GdmF6usPkiFlbyk9t8e2LaP2iuRDsHZGsI+rOKDoTdM0n9eeLgDNjMPlkm10QYID7Ejp8Jh0DnCJZFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llCyEcC+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llCyEcC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539D81F000FF;
	Sat, 12 Sep 2026 08:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200080;
	bh=XfYeMhFxf85XCZIhy0I7Wky+3J9Fx+UDUSVa7/gvsLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llCyEcC+LUg91as1yu7kXrLc/txSQvEedibvPPIKsTa+ax1livKq1wKch/QhQQkaB
	 +9TOiAv714BEusfIBA9vyoikgYrYrK9T4xq+0pCXSV1O5cJK10Ek8H4kMLOn7JEu1q
	 65utHubFjIEGkWsEgOhmeLO2pTA+9SVlsKyYLB0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kostas Damaskinakis <kostas.damaskinakis@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Xuyang Dong <dongxuyang@eswincomputing.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0716/1815] clk: eswin: Zero-initialize stack-allocated clk_init_data
Date: Sat, 12 Sep 2026 08:41:06 +0200
Message-ID: <20260912065705.707228849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kostas Damaskinakis <kostas.damaskinakis@gmail.com>

[ Upstream commit 011d8de504bc84402aabc1dda1cf0552fe9a5af2 ]

eswin_clk_register_pll() and eswin_register_clkdiv() declare a struct
clk_init_data on the stack and only initialize some of its fields
(parent_data respectively parent_hws). clk_core_populate_parent_map()
checks parent_names first and parent_data second before falling back
to parent_hws, so leftover stack garbage in the uninitialized fields
hijacks parent resolution and the clk core dereferences a bogus
pointer:

  Unable to handle kernel NULL pointer dereference at virtual address 000000000000000c
  Oops [#1]
  epc : __clk_register+0x31a/0x7f0
  [<ffffffff805dc774>] __clk_register+0x31a/0x7f0
  [<ffffffff805dcd76>] devm_clk_hw_register+0x2a/0x94
  [<ffffffff805e319a>] eswin_register_clkdiv+0x80/0xd0
  [<ffffffff805e34a0>] eswin_clk_register_clks+0x162/0x1a0
  [<ffffffff805e3736>] eic7700_clk_probe+0x146/0x180
  [<ffffffff8065d23c>] platform_probe+0x3c/0x7a

Observed on EIC7700 hardware (with the driver backported to a 6.17
tree); whether the bug triggers depends entirely on what the stack
happens to contain when the registration helpers run.

Zero-initialize both structures.

Fixes: cd44f127c1d4 ("clk: eswin: Add eic7700 clock driver")
Signed-off-by: Kostas Damaskinakis <kostas.damaskinakis@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Acked-by: Xuyang Dong <dongxuyang@eswincomputing.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/eswin/clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/eswin/clk.c b/drivers/clk/eswin/clk.c
index e09a52cc35872..79d1e4c5e637a 100644
--- a/drivers/clk/eswin/clk.c
+++ b/drivers/clk/eswin/clk.c
@@ -204,7 +204,7 @@ int eswin_clk_register_pll(struct device *dev, struct eswin_pll_clock *clks,
 			   int nums, struct eswin_clock_data *data)
 {
 	struct eswin_clk_pll *p_clk = NULL;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk_hw *clk_hw;
 	int i, ret;
 
@@ -419,7 +419,7 @@ struct clk_hw *eswin_register_clkdiv(struct device *dev, unsigned int id,
 				     unsigned long priv_flag, spinlock_t *lock)
 {
 	struct eswin_divider_clock *dclk;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk_hw *clk_hw;
 	int ret;
 
-- 
2.53.0



