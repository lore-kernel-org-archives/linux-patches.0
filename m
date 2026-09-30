Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C12F3C871B;
	Wed, 30 Sep 2026 19:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795398; cv=none; b=b0+VTRbhKjMCAN4A3R9NYzikVP+0Tq/s+HMtEQNuzMli5Ek7Djcxl3ao5lgI9Wo25FCNixvxZhDPBxKggtb3IRZ/Rtes+f3CE6T7kWYzf2mz9iESwTQDDHCE6bBXztdpy9n4v+pwA8J4gDrU3j13YCLwvBoxfNMTtlvUxVswl5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795398; c=relaxed/simple;
	bh=UEHc+LC03Dlg42shgRZEqdkWwcqzjTiBSJzrIjXcOno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AO4OCKHlqYWfaEHcSjufZGuDdxuAwT9ds53UHjhi5ybwNSdt0LkHIpLuGtmESoSVrp26TsjkIXIEXGB8oVqNkwEH4EigWvGQLCVpwdvNcoRqtX2S3chYZodRU2HTn4wJJJfl9OSnGQxjyZOlMU6+S37Kd3IIbwHbVo49AlPG9pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQyFpp+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQyFpp+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9E171F000FF;
	Wed, 30 Sep 2026 19:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795396;
	bh=8mRoH4hM19La00aU+LBLPaTcV1gvUFUSD3RlZRjOc7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQyFpp+C6Xx4C7ADO8oIpVur9zu9GzKRGHZ5BiI77VFv1PzTh7BiqYxFJTt06xba1
	 hivaXaMzoKUKesv4NoIiMIc6/Acdd23Y/Jja/w7s8+XFXb37ZdsaEN5jm6y+KTd80S
	 VMcJwtCLVYhz653Oq4V+CpAVlot8S2XbfqhbbeMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0546/1193] net: ethernet: cortina: No mapping is a dropped rx
Date: Wed, 30 Sep 2026 17:20:30 +0200
Message-ID: <20260930152446.360354406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa0e798e5581e..3531ebb036dea 100644
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



