Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B5C26D4F2;
	Tue, 15 Jul 2025 13:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586976; cv=none; b=riHXzyHNZ/eptyBYDdzMHeYqw3bvI3DI8uZwEYeNxsNjal6nyGbvhP5cx0xwJrsw75yFv+17L1ZRHYmxZzzDT8WrZCAAcyRt6OeWgoPYIyno0oSDNO2ExHMQgx+DhUK0LUUBzSeL0r6IVYGWFfOH2SjzSF4Rgltm4PUjy/mG/mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586976; c=relaxed/simple;
	bh=ESLTDTP6DCfObntqdBA4eIiHjqnYJthlQvrGFhgEIHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZEqo2To56CEKlQ5x0QZQjThLBxpOs90SHz812FAmENkB1C11qvJ0Vc/ng2Q0Lbr8IoS+MWTMbJgSDASRlrSirmjaoHkMjpHF424cyHx1mXX/VCeF4YYWBppwDc81hTPTVQV/srf7s2TuSJIGxiCl9jbR7xLeALCDQQ0GVcjPfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHy3a6y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHy3a6y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CF3C4CEF1;
	Tue, 15 Jul 2025 13:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586976;
	bh=ESLTDTP6DCfObntqdBA4eIiHjqnYJthlQvrGFhgEIHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHy3a6y9cXb4FCcsoHWZpfYXQAfnQWQCp5LmJTuODzb/CpRqIyfkd6gltNhxFgV/g
	 1w5W39Uzr4Y77wymUEiFuqcEbp5sJA08WobXnmU2PuOEU7k/61+5orRhJKZ2DeUzrL
	 UXDTzwbhAtOF+GPgVSd3imSLecylq6BHC3iQEdKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	peng.fan@nxp.com,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.15 118/192] clk: scmi: Handle case where child clocks are initialized before their parents
Date: Tue, 15 Jul 2025 15:13:33 +0200
Message-ID: <20250715130819.626594589@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 6306e0c5a0d28e9df2b5902f4a021204bee75173 upstream.

The SCMI clock driver currently assumes that parent clocks are always
initialized before their children. However, this assumption can fail if
a child clock is encountered before its parent during probe.

This leads to an issue during initialization of the parent_data array:

    sclk->parent_data[i].hw = hws[sclk->info->parents[i]];

If the parent clock's hardware structure has not been initialized yet,
this assignment results in invalid data.

To resolve this, allocate all struct scmi_clk instances as a contiguous
array at the beginning of the probe and populate the hws[] array
upfront. This ensures that any parent referenced later is already
initialized, regardless of the order in which clocks are processed.

Note that we can no longer free individual scmi_clk instances if
scmi_clk_ops_init() fails which shouldn't be a problem if the SCMI
platform has proper per-agent clock discovery.

Fixes: 65a8a3dd3b95f ("clk: scmi: Add support for clock {set,get}_parent")
Reviewed-by: peng.fan@nxp.com
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://lore.kernel.org/r/20250612-clk-scmi-children-parent-fix-v3-1-7de52a27593d@pengutronix.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/clk-scmi.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/clk/clk-scmi.c
+++ b/drivers/clk/clk-scmi.c
@@ -404,6 +404,7 @@ static int scmi_clocks_probe(struct scmi
 	const struct scmi_handle *handle = sdev->handle;
 	struct scmi_protocol_handle *ph;
 	const struct clk_ops *scmi_clk_ops_db[SCMI_MAX_CLK_OPS] = {};
+	struct scmi_clk *sclks;
 
 	if (!handle)
 		return -ENODEV;
@@ -430,18 +431,21 @@ static int scmi_clocks_probe(struct scmi
 	transport_is_atomic = handle->is_transport_atomic(handle,
 							  &atomic_threshold_us);
 
+	sclks = devm_kcalloc(dev, count, sizeof(*sclks), GFP_KERNEL);
+	if (!sclks)
+		return -ENOMEM;
+
+	for (idx = 0; idx < count; idx++)
+		hws[idx] = &sclks[idx].hw;
+
 	for (idx = 0; idx < count; idx++) {
-		struct scmi_clk *sclk;
+		struct scmi_clk *sclk = &sclks[idx];
 		const struct clk_ops *scmi_ops;
 
-		sclk = devm_kzalloc(dev, sizeof(*sclk), GFP_KERNEL);
-		if (!sclk)
-			return -ENOMEM;
-
 		sclk->info = scmi_proto_clk_ops->info_get(ph, idx);
 		if (!sclk->info) {
 			dev_dbg(dev, "invalid clock info for idx %d\n", idx);
-			devm_kfree(dev, sclk);
+			hws[idx] = NULL;
 			continue;
 		}
 
@@ -479,13 +483,11 @@ static int scmi_clocks_probe(struct scmi
 		if (err) {
 			dev_err(dev, "failed to register clock %d\n", idx);
 			devm_kfree(dev, sclk->parent_data);
-			devm_kfree(dev, sclk);
 			hws[idx] = NULL;
 		} else {
 			dev_dbg(dev, "Registered clock:%s%s\n",
 				sclk->info->name,
 				scmi_ops->enable ? " (atomic ops)" : "");
-			hws[idx] = &sclk->hw;
 		}
 	}
 


