Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01B931A6160;
	Tue, 30 Jul 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356916; cv=none; b=jnHK2k73YY8+mYvtP8VaXiQ8iZGeOmyot2yQT6Db+ZC9IuBkW6A/w5iC2VbP+fNzl86vT4CrO9ge8eYiyL4aiu/Q2KacrqcyeePiaP0VvaEEiEoNxtgXt7yH3l0qtwV6WOJHH/M5L4SI3DdkNtXTBOmA0HziwqUPeqapcMX9520=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356916; c=relaxed/simple;
	bh=3Aut4sUtkT+gZAxB2MUqhKGCXq9tdYwVfZ5uG1VP29U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GL01lqDCoNmvKQ1B2acG8effEYOBKFt2PtiGoUohfcmhwimEFJj3WlVPEGcdh/jjtYqg4m2O46gJVu9fsZn8CnwMvmIk1Xt3E4jlghv5ROhWnh5yPb8OA69D/HrlTjUiJ4gOI9hulc33O7QPfgX2EvavSzIJQCqnxmhSFcvb5RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6uow78y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6uow78y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66E77C32782;
	Tue, 30 Jul 2024 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356915;
	bh=3Aut4sUtkT+gZAxB2MUqhKGCXq9tdYwVfZ5uG1VP29U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6uow78y0VIhdzIhyYQIVxnHZAs0Z6LBIqesOfYbsBHsRSR8HnI40WV5o3ucGlDax
	 Rkno4zoz3AKrYxI2n9laQjjPagV/ARdmKebJi4oUKi9aIDKePDmjLuitDaIN2bicDo
	 NSZdYl51AgMPbj15J6K1CVOikh7ETSLFvvoREp2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antony Antony <antony.antony@secunet.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 199/809] xfrm: Log input direction mismatch error in one place
Date: Tue, 30 Jul 2024 17:41:15 +0200
Message-ID: <20240730151732.468122490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 15f5fe9e84839dcc9eaa69b08ced9d24cb464369 ]

Previously, the offload data path decrypted the packet before checking
the direction, leading to error logging and packet dropping. However,
dropped packets wouldn't be visible in tcpdump or audit log.

With this fix, the offload path, upon noticing SA direction mismatch,
will pass the packet to the stack without decrypting it. The L3 layer
will then log the error, audit, and drop ESP without decrypting or
decapsulating it.

This also ensures that the slow path records the error and audit log,
making dropped packets visible in tcpdump.

Fixes: 304b44f0d5a4 ("xfrm: Add dir validation to "in" data path lookup")
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4_offload.c | 7 +++++++
 net/ipv6/esp6_offload.c | 7 +++++++
 net/xfrm/xfrm_input.c   | 5 -----
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index b3271957ad9a0..3f28ecbdcaef1 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -56,6 +56,13 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ip_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET);
+
+		if (unlikely(x && x->dir && x->dir != XFRM_SA_DIR_IN)) {
+			/* non-offload path will record the error and audit log */
+			xfrm_state_put(x);
+			x = NULL;
+		}
+
 		if (!x)
 			goto out_reset;
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 527b7caddbc68..919ebfabbe4ee 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -83,6 +83,13 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
 				      (xfrm_address_t *)&ipv6_hdr(skb)->daddr,
 				      spi, IPPROTO_ESP, AF_INET6);
+
+		if (unlikely(x && x->dir && x->dir != XFRM_SA_DIR_IN)) {
+			/* non-offload path will record the error and audit log */
+			xfrm_state_put(x);
+			x = NULL;
+		}
+
 		if (!x)
 			goto out_reset;
 
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 63c0041039120..e95462b982b0f 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -474,11 +474,6 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	if (encap_type < 0 || (xo && xo->flags & XFRM_GRO)) {
 		x = xfrm_input_state(skb);
 
-		if (unlikely(x->dir && x->dir != XFRM_SA_DIR_IN)) {
-			XFRM_INC_STATS(net, LINUX_MIB_XFRMINSTATEDIRERROR);
-			goto drop;
-		}
-
 		if (unlikely(x->km.state != XFRM_STATE_VALID)) {
 			if (x->km.state == XFRM_STATE_ACQ)
 				XFRM_INC_STATS(net, LINUX_MIB_XFRMACQUIREERROR);
-- 
2.43.0



