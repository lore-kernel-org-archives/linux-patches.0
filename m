Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951BB285404;
	Wed,  4 Feb 2026 15:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217261; cv=none; b=cVqmhtq5U/yFb1465FUVjWG3Hvxw3OS0/KRlDzpWltAq6E2PureEUeT9qZ1xqG/A0f05CZfycdy89OrTRyspOkNfwPDCqgjz6c8EvqWWRRY9bsraVL2qKv8F4XlDz6+6ANOLQItfPWvmputhzsiBEFqByyaPAX4ngO3jOEW4u4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217261; c=relaxed/simple;
	bh=BP5Db284pz1HA+kXGrbyi9fg6qpRVeDTlw2JU4VTopw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQMhFwj1QVctZTxe8BqNVvuyACfJgnjHq99Mw0VEokilZuyf4vq5N7uOEO5gHq00VRhLlxNTAwBROlJ9RkFsUf3vuFQ0TTRiB1vavluIHtYFVLIa7deSna94xAqSGXYIg2iwZwwPtCY+ScoD2D/+rvZljmAD48avOAaJFagOxOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLCLOm0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLCLOm0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4022C116C6;
	Wed,  4 Feb 2026 15:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217261;
	bh=BP5Db284pz1HA+kXGrbyi9fg6qpRVeDTlw2JU4VTopw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLCLOm0/2cKgOi5CqEg9NJ/QXyX3GLd/H/4KVzcgLT5R8NuMkP/LYzidZBigQAgC/
	 Mw4iRKAsKNdt51Ik83/zcvNzEKrWHXkTFAFCUeOAtc1Nk8A66OB/FWScWsrAi/mSST
	 C8u3niQqLSaD4cRkzK+0D2Xob9CzmJbyVhWm7MkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/206] net: mvpp2: cls: Fix memory leak in mvpp2_ethtool_cls_rule_ins()
Date: Wed,  4 Feb 2026 15:39:28 +0100
Message-ID: <20260204143903.141123902@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 09f979d1f312627b31d2ee1e46f9692e442610cd ]

In mvpp2_ethtool_cls_rule_ins(), the ethtool_rule is allocated by
ethtool_rx_flow_rule_create(). If the subsequent conversion to flow
type fails, the function jumps to the clean_rule label.

However, the clean_rule label only frees efs, skipping the cleanup
of ethtool_rule, which leads to a memory leak.

Fix this by jumping to the clean_eth_rule label, which properly calls
ethtool_rx_flow_rule_destroy() before freeing efs.

Compile tested only. Issue found using a prototype static analysis tool
and code review.

Fixes: f4f1ba18195d ("net: mvpp2: cls: Report an error for unsupported flow types")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260123065716.2248324-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
index d2757cc116139..038382a0b8e9f 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_cls.c
@@ -1389,7 +1389,7 @@ int mvpp2_ethtool_cls_rule_ins(struct mvpp2_port *port,
 	efs->rule.flow_type = mvpp2_cls_ethtool_flow_to_type(info->fs.flow_type);
 	if (efs->rule.flow_type < 0) {
 		ret = efs->rule.flow_type;
-		goto clean_rule;
+		goto clean_eth_rule;
 	}
 
 	ret = mvpp2_cls_rfs_parse_rule(&efs->rule);
-- 
2.51.0



