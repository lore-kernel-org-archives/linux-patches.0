Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BF413A25F;
	Tue,  9 Jul 2024 11:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523781; cv=none; b=D3NErI6N5dLd2htBXHq7uIMWAV6GnFda7kd2Pcjf+8tz5XMWt/+9zelzVsNdzwBCR6fsuPO121yWSwz2wFrnw448tfRULoySS7215GGeJnBEZggPrWMmzBSMyn7jx3DSoomze99tn2Iejh5qVntAN65T0HzU41uCgGjhL0U5A0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523781; c=relaxed/simple;
	bh=92pR0oOEQETWhdjXczXp3/1JklW180AOMPlaFyUC6UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfNvIncafh9yBVUd7wZwgZh22ewbEiS9tMpcbxV20EaUcIRtRLl5Fw6NUPhnZ/HXDiWt9435bXdXKciwWIV7ExdNN3VpTvxq6DB4wZJMeV8gOSXMViEpvt6HTxssoiAZ6EZX/SqtQIVyQu35nTPEPTD3yWvA2gsE+xAigG1ix/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jdft3Ka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jdft3Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E86C3277B;
	Tue,  9 Jul 2024 11:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523781;
	bh=92pR0oOEQETWhdjXczXp3/1JklW180AOMPlaFyUC6UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jdft3KaXw/hZQzFnqyxQ3cBaVa0n0vPS3rqxRoVI+QzczroRTnpUD6r5l7iXHYoT
	 VCAfPNAhjWB+TqKdcB+ScBR+y1jJYCulEFiWbTX0oMIC3JZDcseMwMvrMt0bYccEOY
	 Sd857AhRU+SDCC+amgcHibjurL+C81IzIEUNEjKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Robert J. Pafford" <pafford.9@buckeyemail.osu.edu>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Chen-Yu Tsai <wens@csie.org>
Subject: [PATCH 6.6 106/139] clk: sunxi-ng: common: Dont call hw_to_ccu_common on hw without common
Date: Tue,  9 Jul 2024 13:10:06 +0200
Message-ID: <20240709110702.272121628@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Oltmanns <frank@oltmanns.dev>

commit ea977d742507e534d9fe4f4d74256f6b7f589338 upstream.

In order to set the rate range of a hw sunxi_ccu_probe calls
hw_to_ccu_common() assuming all entries in desc->ccu_clks are contained
in a ccu_common struct. This assumption is incorrect and, in
consequence, causes invalid pointer de-references.

Remove the faulty call. Instead, add one more loop that iterates over
the ccu_clks and sets the rate range, if required.

Fixes: b914ec33b391 ("clk: sunxi-ng: common: Support minimum and maximum rate")
Reported-by: Robert J. Pafford <pafford.9@buckeyemail.osu.edu>
Closes: https://lore.kernel.org/lkml/DM6PR01MB58047C810DDD5D0AE397CADFF7C22@DM6PR01MB5804.prod.exchangelabs.com/
Cc: stable@vger.kernel.org
Signed-off-by: Frank Oltmanns <frank@oltmanns.dev>
Tested-by: Robert J. Pafford <pafford.9@buckeyemail.osu.edu>
Link: https://lore.kernel.org/r/20240623-sunxi-ng_fix_common_probe-v1-1-7c97e32824a1@oltmanns.dev
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/sunxi-ng/ccu_common.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_common.c b/drivers/clk/sunxi-ng/ccu_common.c
index ac0091b4ce24..be375ce0149c 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -132,7 +132,6 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 
 	for (i = 0; i < desc->hw_clks->num ; i++) {
 		struct clk_hw *hw = desc->hw_clks->hws[i];
-		struct ccu_common *common = hw_to_ccu_common(hw);
 		const char *name;
 
 		if (!hw)
@@ -147,14 +146,21 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 			pr_err("Couldn't register clock %d - %s\n", i, name);
 			goto err_clk_unreg;
 		}
+	}
 
-		if (common->max_rate)
-			clk_hw_set_rate_range(hw, common->min_rate,
-					      common->max_rate);
+	for (i = 0; i < desc->num_ccu_clks; i++) {
+		struct ccu_common *cclk = desc->ccu_clks[i];
+
+		if (!cclk)
+			continue;
+
+		if (cclk->max_rate)
+			clk_hw_set_rate_range(&cclk->hw, cclk->min_rate,
+					      cclk->max_rate);
 		else
-			WARN(common->min_rate,
+			WARN(cclk->min_rate,
 			     "No max_rate, ignoring min_rate of clock %d - %s\n",
-			     i, name);
+			     i, clk_hw_get_name(&cclk->hw));
 	}
 
 	ret = of_clk_add_hw_provider(node, of_clk_hw_onecell_get,
-- 
2.45.2



