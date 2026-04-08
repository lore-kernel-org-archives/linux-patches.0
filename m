Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D88357A20;
	Wed,  8 Apr 2026 18:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673036; cv=none; b=KrRJUwMwz/ojiv0tshT9HEH4kbK9jg5t/B0VHQ/xhwDwC6QjPILYmB+hGPWcrfb4aYCG1Kr/rzfDdwxQRZrVUhTb9NZTn2Ee6OMuQq9+an3J+lSpkoXTm9n5JvgDpcsqeg1lh7gd2PmriwyBUIchJlbEpN5gerfnKf8tirs1fzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673036; c=relaxed/simple;
	bh=RMws8ZaPF3naf1I/WMkDbWb1zSv9HaWPCKL0pdEkmsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9Ba7ZLzqRrVXH1CvmyiEinzGPHkuaSxSz/i2aJsv0Lno/zh5w2FhiEd9quzuo1mqSMsI8mNC7LJKkqRiFfoJ3LpGVjRigP9Q+JpfLfDeVUT6PMMRQ6OYYcEKHq1N3ftk7IWURgcDXc5uGLvZvDMLWQw+GMakiGFqJEQSMGRBGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TdXy99vQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TdXy99vQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB68C19421;
	Wed,  8 Apr 2026 18:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673036;
	bh=RMws8ZaPF3naf1I/WMkDbWb1zSv9HaWPCKL0pdEkmsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdXy99vQFT0IgsJk9LHg4rSZShq9DoQwe4zKOQl+5GrVYSQaqGEmO2UwIaTeFoxsQ
	 UnC0G8ClzGbNLAwldRMLjQDwTjd45+RC8j9z+3RKPu5FUUlnLPzMFcx/HC7KhmJDpL
	 GFCi9Y+9YV6WCI9kuVd0Ym7tiCuJmNcjZdw/xfNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Clark Wang <xiaoning.wang@nxp.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/277] net: enetc: do not allow VF to configure the RSS key
Date: Wed,  8 Apr 2026 20:00:29 +0200
Message-ID: <20260408175935.503138325@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit a142d139168cce8d5776245b5494c7f7f5d7fb7d ]

VFs do not have privilege to configure the RSS key because the registers
are owned by the PF. Currently, if VF attempts to configure the RSS key,
enetc_set_rxfh() simply skips the configuration and does not generate a
warning, which may mislead users into thinking the feature is supported.
To improve this situation, add a check to reject RSS key configuration
on VFs.

Fixes: d382563f541b ("enetc: Add RFS and RSS support")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Clark Wang <xiaoning.wang@nxp.com>
Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Link: https://patch.msgid.link/20260326075233.3628047-3-wei.fang@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 8349d38dbd896..5166f16f196ff 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -775,8 +775,12 @@ static int enetc_set_rxfh(struct net_device *ndev,
 		return -EOPNOTSUPP;
 
 	/* set hash key, if PF */
-	if (rxfh->key && enetc_si_is_pf(si))
+	if (rxfh->key) {
+		if (!enetc_si_is_pf(si))
+			return -EOPNOTSUPP;
+
 		enetc_set_rss_key(si, rxfh->key);
+	}
 
 	/* set RSS table */
 	if (rxfh->indir)
-- 
2.53.0



