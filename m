Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B102210DB;
	Thu, 12 Dec 2024 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021169; cv=none; b=HmCVk7M2sFpB0LTKPtdI7886Xwf/o0fKLA7jqCxO9GxnpJIC4eaRs5hECf9lap0VbCNW7JZs7FTBoQP3zHlnjLlDZdqiXy8SOLdysbeoZurvNeYNjk6i+Zl/hpRhHwGbnX/MJMz47z9nhLLgXgkkhj8W6GMy6fvXzrRfY6LLDHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021169; c=relaxed/simple;
	bh=7C5+z8Q+8X3OCo4OYXhEPIOImEdrkcBK5t00MS/kkMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TCs20pf1wZr0k/yB0Ro4BLDdRCb5SMLMItYE/BscElSpGh0NPd22o4917iJx838/Neto91A2EfbvsCWLi3KfpljgXM1SPXWoHLGD+LqIHnYX/rKUu83vKjmLiQXnXpo04wj99CdOBulrm3Q8nJXA7NZbji3OaeKLhN1inh+NmBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9VTPmNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9VTPmNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1525DC4CECE;
	Thu, 12 Dec 2024 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021169;
	bh=7C5+z8Q+8X3OCo4OYXhEPIOImEdrkcBK5t00MS/kkMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9VTPmNl+MKqGalynC9HAwsCcL2MaQRTw5CiNcCmjEue36ekV0WU31sMx3MbMJSTl
	 yrKl+kba6TR9VYqxlh8767sJinTi5BiLJh7JTmY7dqcECS8d/eJxtxam+ICfiyjkEb
	 kUtIwLIEDn3zjvE9wPa3GvJOFO7+qCIuFjP2VyBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 665/772] net: ethernet: fs_enet: Use %pa to format resource_size_t
Date: Thu, 12 Dec 2024 16:00:10 +0100
Message-ID: <20241212144417.397961858@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit 45fe45fada261e1e83fce2a07fa22835aec1cf0a ]

The correct format string for resource_size_t is %pa which
acts on the address of the variable to be formatted [1].

[1] https://elixir.bootlin.com/linux/v6.11.3/source/Documentation/core-api/printk-formats.rst#L229

Introduced by commit 9d9326d3bc0e ("phy: Change mii_bus id field to a string")

Flagged by gcc-14 as:

drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c: In function 'fs_mii_bitbang_init':
drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c:126:46: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Wformat=]
  126 |         snprintf(bus->id, MII_BUS_ID_SIZE, "%x", res.start);
      |                                             ~^   ~~~~~~~~~
      |                                              |      |
      |                                              |      resource_size_t {aka long long unsigned int}
      |                                              unsigned int
      |                                             %llx

No functional change intended.
Compile tested only.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/netdev/711d7f6d-b785-7560-f4dc-c6aad2cce99@linux-m68k.org/
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20241014-net-pa-fmt-v1-2-dcc9afb8858b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
index 21de56345503f..f743112730194 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
@@ -126,7 +126,7 @@ static int fs_mii_bitbang_init(struct mii_bus *bus, struct device_node *np)
 	 * we get is an int, and the odds of multiple bitbang mdio buses
 	 * is low enough that it's not worth going too crazy.
 	 */
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%x", res.start);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res.start);
 
 	data = of_get_property(np, "fsl,mdio-pin", &len);
 	if (!data || len != 4)
-- 
2.43.0



