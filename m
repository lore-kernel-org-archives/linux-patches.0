Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DD9208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0gJt6kA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275B2C433C8;
	Tue, 31 Oct 2023 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698774618;
	bh=qIyQ1rZY02ZWdsUDBE1n6YQG1WVgJlk/SE0cbi3t4x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0gJt6kA1Yn/0X4lXVsFbQvITL8GAxWkezhR46pDEOQL/sIe/XG+MMtqNZwMWdq/q
	 7c40VFdKlu+sAAHPCjAoPQBLJjgnN6vEqY3cuELFxg4DABizARGZLXzck3Y1e3/+k1
	 bXu2dVy80CpKzQUuny7HcK3l79oaXbQiGIgPmgR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedikt Spranger <b.spranger@linutronix.de>,
	Maxime Ripard <mripard@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.5 108/112] clk: socfpga: gate: Account for the divider in determine_rate
Date: Tue, 31 Oct 2023 18:01:49 +0100
Message-ID: <20231031165904.674916881@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
References: <20231031165901.318222981@linuxfoundation.org>
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

From: Maxime Ripard <mripard@kernel.org>

commit 601cb6d573facde5fc88efa935b074da64ae63c9 upstream.

Commit 9607beb917df ("clk: socfpga: gate: Add a determine_rate hook")
added a determine_rate implementation set to the
clk_hw_determine_rate_no_reparent, but failed to account for the
internal divider that wasn't used before anywhere but in recalc_rate.

This led to inconsistencies between the clock rate stored in
clk_core->rate and the one returned by clk_round_rate() that leverages
determine_rate().

Since that driver seems to be widely used (and thus regression-prone)
and not supporting rate changes (since it's missing a .set_rate
implementation), we can just report the current divider programmed in
the clock but not try to change it in any way.

This should be good enough to fix the issues reported, and if someone
ever wants to allow the divider to change then it should be easy enough
using the clk-divider helpers.

Link: https://lore.kernel.org/linux-clk/20231005095927.12398-2-b.spranger@linutronix.de/
Fixes: 9607beb917df ("clk: socfpga: gate: Add a determine_rate hook")
Reported-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Link: https://lore.kernel.org/r/20231012083729.2148044-1-mripard@kernel.org
[sboyd@kernel.org: Fix hw -> hwclk]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/socfpga/clk-gate.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/socfpga/clk-gate.c b/drivers/clk/socfpga/clk-gate.c
index 8dd601bd8538..0a5a95e0267f 100644
--- a/drivers/clk/socfpga/clk-gate.c
+++ b/drivers/clk/socfpga/clk-gate.c
@@ -87,10 +87,8 @@ static int socfpga_clk_set_parent(struct clk_hw *hwclk, u8 parent)
 	return 0;
 }
 
-static unsigned long socfpga_clk_recalc_rate(struct clk_hw *hwclk,
-	unsigned long parent_rate)
+static u32 socfpga_clk_get_div(struct socfpga_gate_clk *socfpgaclk)
 {
-	struct socfpga_gate_clk *socfpgaclk = to_socfpga_gate_clk(hwclk);
 	u32 div = 1, val;
 
 	if (socfpgaclk->fixed_div)
@@ -105,12 +103,33 @@ static unsigned long socfpga_clk_recalc_rate(struct clk_hw *hwclk,
 			div = (1 << val);
 	}
 
+	return div;
+}
+
+static unsigned long socfpga_clk_recalc_rate(struct clk_hw *hwclk,
+					     unsigned long parent_rate)
+{
+	struct socfpga_gate_clk *socfpgaclk = to_socfpga_gate_clk(hwclk);
+	u32 div = socfpga_clk_get_div(socfpgaclk);
+
 	return parent_rate / div;
 }
 
+
+static int socfpga_clk_determine_rate(struct clk_hw *hwclk,
+				      struct clk_rate_request *req)
+{
+	struct socfpga_gate_clk *socfpgaclk = to_socfpga_gate_clk(hwclk);
+	u32 div = socfpga_clk_get_div(socfpgaclk);
+
+	req->rate = req->best_parent_rate / div;
+
+	return 0;
+}
+
 static struct clk_ops gateclk_ops = {
 	.recalc_rate = socfpga_clk_recalc_rate,
-	.determine_rate = clk_hw_determine_rate_no_reparent,
+	.determine_rate = socfpga_clk_determine_rate,
 	.get_parent = socfpga_clk_get_parent,
 	.set_parent = socfpga_clk_set_parent,
 };
-- 
2.42.0



