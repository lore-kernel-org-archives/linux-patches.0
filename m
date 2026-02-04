Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CAD4218B0;
	Wed,  4 Feb 2026 14:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217176; cv=none; b=OYi7N3NDED7GmLXWYj4ap8uKKA/DZHIizeSXk/c2oBNfmOseNR5ajlyNMgdbt1qHZEo+WMybRF3vDztMKWo7wNOcLB+DprPvwe7nScqpol2iE2xJdf5/uD8cz9HDDwmN87RJqopYytIHlOaMVDZd86TFLuGWCUy62hkVfhw7o3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217176; c=relaxed/simple;
	bh=5IlF6mU2FeDH4x/icbZ9JLO6Sm8oXsrvNHkO5PX4OIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVxSm2QCG0dlv59C/Y/46Tcs2Vtoe4FanQSd8X1bp26hoiJGaNbHMYHPzRw9S4KHTNHFVdV4xg4HA8+eQkK4epeKv+PFelJYNOqFcPgageBCxy2t/cSh65oj5z8QQjtoYAcxR6fCDhFjtFbnkVXDCWlT+z6JLSXF5NiSGJSngHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT8Kh6dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT8Kh6dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8D6C4CEF7;
	Wed,  4 Feb 2026 14:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217175;
	bh=5IlF6mU2FeDH4x/icbZ9JLO6Sm8oXsrvNHkO5PX4OIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT8Kh6dMT2IRrgF6yVZoCn1CF4Zj33h5Ono1BUtDHGVZhuI8r9Zi+29Ncq9IZVGEE
	 a8QoEpWhZNLKyAtO1ob0M967Cq49ZTv3v/4kab7AYbq/gAZnbFwZvfA0sUX7qQzxaU
	 JkX+Sk1hs0CM0JqjG8HwR6sEbJa6XcgkTpmc03ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Kaiser <martin@kaiser.cx>,
	Florian Westphal <fw@strlen.de>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 147/206] net: bridge: fix static key check
Date: Wed,  4 Feb 2026 15:39:38 +0100
Message-ID: <20260204143903.499540088@linuxfoundation.org>
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

From: Martin Kaiser <martin@kaiser.cx>

[ Upstream commit cc0cf10fdaeadf5542d64a55b5b4120d3df90b7d ]

Fix the check if netfilter's static keys are available. netfilter defines
and exports static keys if CONFIG_JUMP_LABEL is enabled. (HAVE_JUMP_LABEL
is never defined.)

Fixes: 971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260127101925.1754425-1-martin@kaiser.cx
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index f3d49343f7dbe..14423132a3df5 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -225,7 +225,7 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 	int ret;
 
 	net = dev_net(skb->dev);
-#ifdef HAVE_JUMP_LABEL
+#ifdef CONFIG_JUMP_LABEL
 	if (!static_key_false(&nf_hooks_needed[NFPROTO_BRIDGE][NF_BR_PRE_ROUTING]))
 		goto frame_finish;
 #endif
-- 
2.51.0



