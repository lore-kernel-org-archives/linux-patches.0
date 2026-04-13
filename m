Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5D8225A38;
	Mon, 13 Apr 2026 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097932; cv=none; b=DPuLHbFcXFvAZant7gX8Dq66Q/mjThthUziCrytsEerDF/p8oNr2Outah2rI4SbsVYGB7X63IN1qmrmmmK6kCRPo12uiCUULkdy49SyfVP2rzqWSlenKFNe69iEYbxLyRxqmnb52Ck4q+qZbzHsk84IiskiiGuF13lqUhYflzW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097932; c=relaxed/simple;
	bh=QTV+FV6C8DaDFjum8SP2+I7ckjsYmRVs6tMiBdrTsvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1PLSUBU2xrIOu+aXDUizYG0jmIO78JHdht+AQmpC+gqWuNaYd8/k0GIvzZmHDwc0emueSU88U5RfMVaxOPA6EMueq+To5DP5SKSWLDgNxfF7tRHM79QbauoxMCg+R01/6t2a7QO/tS+Sw2+JGWRdM+nMcue/p74Gt2AgCBicoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlD5BqaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlD5BqaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E54C2BCAF;
	Mon, 13 Apr 2026 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097932;
	bh=QTV+FV6C8DaDFjum8SP2+I7ckjsYmRVs6tMiBdrTsvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlD5BqaR361mUu8TRYynVwccUQi6VCDxv25s4UN0EbDu1Pkcj6bo3wzeFks3bM7QB
	 ZjP0GCA5JvoTWhuDHfEyFxhwcBUyOjoOGG4uByDxRtdpUxtBj/qVlq4XoDt/ZJucAF
	 8gT1w9ipObp/CTyL4nL0PCYQHXw6qT5f3QEjj2mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 327/570] rtnetlink: count IFLA_INFO_SLAVE_KIND in if_nlmsg_size
Date: Mon, 13 Apr 2026 17:57:38 +0200
Message-ID: <20260413155842.745112973@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit ee00a12593ffb69db4dd1a1c00ecb0253376874a ]

rtnl_link_get_slave_info_data_size counts IFLA_INFO_SLAVE_DATA, but
rtnl_link_slave_info_fill adds both IFLA_INFO_SLAVE_DATA and
IFLA_INFO_SLAVE_KIND.

Fixes: ba7d49b1f0f8 ("rtnetlink: provide api for getting and setting slave info")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/049843b532e23cde7ddba263c0bbe35ba6f0d26d.1773919462.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 674f33bae66e2..89c22b66886d4 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -532,11 +532,14 @@ static size_t rtnl_link_get_slave_info_data_size(const struct net_device *dev)
 		goto out;
 
 	ops = master_dev->rtnl_link_ops;
-	if (!ops || !ops->get_slave_size)
+	if (!ops)
+		goto out;
+	size += nla_total_size(strlen(ops->kind) + 1);  /* IFLA_INFO_SLAVE_KIND */
+	if (!ops->get_slave_size)
 		goto out;
 	/* IFLA_INFO_SLAVE_DATA + nested data */
-	size = nla_total_size(sizeof(struct nlattr)) +
-	       ops->get_slave_size(master_dev, dev);
+	size += nla_total_size(sizeof(struct nlattr)) +
+		ops->get_slave_size(master_dev, dev);
 
 out:
 	rcu_read_unlock();
-- 
2.51.0



