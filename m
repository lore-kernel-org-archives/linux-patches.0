Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC402C861
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwuEJz3h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AADC433C8;
	Wed, 15 Nov 2023 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076290;
	bh=TOQ6nBGXsW9tMJDT0svLKTfHnqXj5vopwCQxCghmi9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwuEJz3hTgXInJqjeByrZHnEr8o5Mow2BKmQnwHOkpxLod/330hzUo5FHmohu4VRD
	 yawllslwcxI2xLVjO6YlJaywr1cxbdmCAxo4AHyZu6dcIHj5zgZ9zepBeixz3FWxKV
	 XGIzmP5xBwDNXhWjwH8MgmMxpd5jZRXUiuXfibec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 171/550] clk: ralink: mtmips: quiet unused variable warning
Date: Wed, 15 Nov 2023 14:12:35 -0500
Message-ID: <20231115191612.559684434@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 619102313466eaf8a6ac188e711f5df749dac6d4 ]

When CONFIG_OF is disabled then the matching table is not referenced and
the following warning appears:

drivers/clk/ralink/clk-mtmips.c:821:34: warning: unused variable 'mtmips_of_match' [-Wunused-const-variable]
821 |   static const struct of_device_id mtmips_of_match[] = {
    |                          ^

There are two match tables in the driver: one for the clock driver and the
other for the reset driver. The only difference between them is that the
clock driver uses 'data' and does not have 'ralink,rt2880-reset' compatible.
Both just can be merged into a single one just by adding the compatible
'ralink,rt2880-reset' entry to 'mtmips_of_match[]', which will allow it to
be used for 'mtmips_clk_driver' (which doesn't use the data) as well as for
'mtmips_clk_init()' (which doesn't need get called for 'ralink,rt2880-reset').

Doing in this way ensures that 'CONFIG_OF' is not disabled anymore so the
above warning disapears.

Fixes: 6f3b15586eef ("clk: ralink: add clock and reset driver for MTMIPS SoCs")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202307242310.CdOnd2py-lkp@intel.com/
Suggested-by: Arnd Bergmann <arnd@kernel.org>
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20230827023932.501102-1-sergio.paracuellos@gmail.com
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ralink/clk-mtmips.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/ralink/clk-mtmips.c b/drivers/clk/ralink/clk-mtmips.c
index 1e7991439527a..50a443bf79ecd 100644
--- a/drivers/clk/ralink/clk-mtmips.c
+++ b/drivers/clk/ralink/clk-mtmips.c
@@ -821,6 +821,10 @@ static const struct mtmips_clk_data mt76x8_clk_data = {
 };
 
 static const struct of_device_id mtmips_of_match[] = {
+	{
+		.compatible = "ralink,rt2880-reset",
+		.data = NULL,
+	},
 	{
 		.compatible = "ralink,rt2880-sysc",
 		.data = &rt2880_clk_data,
@@ -1088,25 +1092,11 @@ static int mtmips_clk_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id mtmips_clk_of_match[] = {
-	{ .compatible = "ralink,rt2880-reset" },
-	{ .compatible = "ralink,rt2880-sysc" },
-	{ .compatible = "ralink,rt3050-sysc" },
-	{ .compatible = "ralink,rt3052-sysc" },
-	{ .compatible = "ralink,rt3352-sysc" },
-	{ .compatible = "ralink,rt3883-sysc" },
-	{ .compatible = "ralink,rt5350-sysc" },
-	{ .compatible = "ralink,mt7620-sysc" },
-	{ .compatible = "ralink,mt7628-sysc" },
-	{ .compatible = "ralink,mt7688-sysc" },
-	{}
-};
-
 static struct platform_driver mtmips_clk_driver = {
 	.probe = mtmips_clk_probe,
 	.driver = {
 		.name = "mtmips-clk",
-		.of_match_table = mtmips_clk_of_match,
+		.of_match_table = mtmips_of_match,
 	},
 };
 
-- 
2.42.0



