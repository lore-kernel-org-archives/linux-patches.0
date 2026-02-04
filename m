Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B10423169;
	Wed,  4 Feb 2026 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218038; cv=none; b=cBuVamjGQH6baov3T2Vq9dRTCchvncEZXW1lNlbEToRCCCVAtoe3tNiJRECZR4XKUa64LlFlZd3HDLyNdKfUqNNJhg/bL4vfJy2CxS8IjqBnsu8Soz1GcQZNks6RacUQgaQpXxjNOUJPo8O0wziG8c6oWAJhfk3jqOscAktmqw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218038; c=relaxed/simple;
	bh=GH/A10EIRpJgm/R7XC/kosWlCs9AhOhxGQHsIS0WBBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMweSe3ayOH5kECmnnE+mpBuGelJXUdShe4YX+R/bQqQxrQg6cjtVyiYH8BIjRxDVcxFTUl58/qAy37PuZlu36ZHREtPha0X9PGQ7l0nV7mn0yR8OvpLi46qbE2Re/asrk7En29K/HLThnczQCoYdfAIGgtZf+O9OL5jH/lOqb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGVT4fXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGVT4fXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878A4C4CEF7;
	Wed,  4 Feb 2026 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218038;
	bh=GH/A10EIRpJgm/R7XC/kosWlCs9AhOhxGQHsIS0WBBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGVT4fXoZk8aiF0+xR/yt8QjNyMTtmZKaXtmIJC96V5qogamMxLbXiF4vGpobO/Qq
	 Y2i4iPNSGcyGdxR1xQDbig3VOeJF6TiDlXHOFXSx1+l5p3r01mWjmejArtaEt70YwH
	 eJe4HDlNpteacE1sncgitxrC1SJRsJmImQ4NUGG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/280] net: mvpp2: cls: Fix memory leak in mvpp2_ethtool_cls_rule_ins()
Date: Wed,  4 Feb 2026 15:39:26 +0100
Message-ID: <20260204143916.518189201@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



