Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F8502D40;
	Wed, 30 Sep 2026 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785404; cv=none; b=HVSVLmujF971ooK+tDQjfYB3+I92PRb5ASklTIl+o8s68bzb6Bk5Xq3hNSnUvDd6XRUpWDqtrQjOXcuY18bc9HHgjwdoc5xpC2lmn63FmOrmntKQMDEaVJWTgEyBq7fk52dOQUQngV6AfnVUryZy7VgvmrvCmOiaqpLyeZSaKlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785404; c=relaxed/simple;
	bh=nceXatrEWCmygsXY3y3udCQFDCjXJMDCyPp7BqiaTPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZLDf+42l62P3kIQIFWZlgVMiHxS45pVS33GbJxS+z63REM3KORln4gGyLbkmNzlY0ZYPjYC4pmxQS6pnXEpJW5WG/LDuYrIkIJYVKZHH7qZ99ygTgM36o+fhiSCDdVpiYAWvAzEsjatLoUS6rcnjPBwtoeGCkP0GPxZslP6J7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRcNEqpp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRcNEqpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424241F00898;
	Wed, 30 Sep 2026 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785398;
	bh=7P3hxSjBCP+HkWSX1zbU1NJibY/Ga6bDh/Y1PxQXIQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRcNEqpp4SiVm1ZgNXExPjKsgXI5rpN8LeWQJqPJduMoEoOKtK0Q/5lRM+twD61oH
	 4ylKHxSO+VpiY1kQIbibrBXxIpj8i8ImMTI16arTbE6tA7qt/lWTElX1LCaf76zvDP
	 Jdwu/UymikPfZ414pMiiOgd2SrCkeGt8aq/xaVFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 450/982] net: ethernet: cortina: No mapping is a dropped rx
Date: Wed, 30 Sep 2026 17:19:46 +0200
Message-ID: <20260930152426.459882754@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 2cb156213093a62b80cf40b1ec71738e93491971 ]

Increase stats.rx_dropped++ even if this is the first fragment
(skb == NULL) so we are doing proper accounting.

Fixes: b266bacba796 ("net: ethernet: cortina: Drop half-assembled SKB")
Link: https://sashiko.dev/#/patchset/20260505-gemini-ethernet-fix-v2-1-997c31d06079%40kernel.org
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260509-gemini-ethernet-fixes-v1-1-6c5d20ddc35b@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 6520198c430c ("net: ethernet: cortina: Count RX drops once per frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 62ddaf3e99775..85d476301f3ea 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1500,9 +1500,9 @@ static unsigned int gmac_rx(struct net_device *netdev, unsigned int budget)
 		gpage = gmac_get_queue_page(geth, port, mapping + PAGE_SIZE);
 		if (!gpage) {
 			dev_err(geth->dev, "could not find mapping\n");
+			port->stats.rx_dropped++;
 			if (skb) {
 				napi_free_frags(&port->napi);
-				port->stats.rx_dropped++;
 				skb = NULL;
 				frag_nr = 0;
 			}
-- 
2.53.0



