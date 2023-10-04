Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419EF1DA24
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ryt6L/aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB66DC433C8;
	Wed,  4 Oct 2023 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444171;
	bh=V3y9wo0qmFT5yKw8xJksPaTrtgpOa3FR+AP0oMd8oYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ryt6L/aMaSlzR8mO5ttzi78QxtnPFls/fAgDpVG6Wd8NGYoLF6ykYZEcQNiG+dx03
	 I6rn5vIqnlOZ5R2Jmoj2n9o1y+RZHX9t0zSuyYH9awrmQ1qP1BkrqhJnXabKe5KmOi
	 8HkrnwlOI7pOe5zssdp/wdSBL6oss7kLPXuTGbHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Rossi <nathan.rossi@digi.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 148/321] soc: imx8m: Enable OCOTP clock for imx8mm before reading registers
Date: Wed,  4 Oct 2023 19:54:53 +0200
Message-ID: <20231004175236.109686605@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

From: Nathan Rossi <nathan.rossi@digi.com>

[ Upstream commit 9d1e8275a28f51599d754ce661c91e0a689c0234 ]

Commit 836fb30949d9 ("soc: imx8m: Enable OCOTP clock before reading the
register") added configuration to enable the OCOTP clock before
attempting to read from the associated registers.

This same kexec issue is present with the imx8m SoCs that use the
imx8mm_soc_uid function (e.g. imx8mp). This requires the imx8mm_soc_uid
function to configure the OCOTP clock before accessing the associated
registers. This change implements the same clock enable functionality
that is present in the imx8mq_soc_revision function for the
imx8mm_soc_uid function.

Signed-off-by: Nathan Rossi <nathan.rossi@digi.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Fixes: 836fb30949d9 ("soc: imx8m: Enable OCOTP clock before reading the register")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 1dcd243df5677..ec87d9d878f30 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -100,6 +100,7 @@ static void __init imx8mm_soc_uid(void)
 {
 	void __iomem *ocotp_base;
 	struct device_node *np;
+	struct clk *clk;
 	u32 offset = of_machine_is_compatible("fsl,imx8mp") ?
 		     IMX8MP_OCOTP_UID_OFFSET : 0;
 
@@ -109,11 +110,20 @@ static void __init imx8mm_soc_uid(void)
 
 	ocotp_base = of_iomap(np, 0);
 	WARN_ON(!ocotp_base);
+	clk = of_clk_get_by_name(np, NULL);
+	if (IS_ERR(clk)) {
+		WARN_ON(IS_ERR(clk));
+		return;
+	}
+
+	clk_prepare_enable(clk);
 
 	soc_uid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH + offset);
 	soc_uid <<= 32;
 	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW + offset);
 
+	clk_disable_unprepare(clk);
+	clk_put(clk);
 	iounmap(ocotp_base);
 	of_node_put(np);
 }
-- 
2.40.1



