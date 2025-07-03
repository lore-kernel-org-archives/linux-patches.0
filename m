Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A372D126BFF;
	Thu,  3 Jul 2025 14:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554195; cv=none; b=glrF1571ESyCKmcEy+N+vD+8n+6q0BupxvDCwhCNxvgKM1jz+ATGr1Sw8FEOqGokoHgHsqXbXYlhMes3JIRgoXyPS+AXy1eDZHOecX+L8zcVjhcTKWcfl5/wDXY1IKTYHYy3j/ljJBw2lFvq6LLIcdnoEf2Pb1kkBG+yt22/nuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554195; c=relaxed/simple;
	bh=kz0bYjSm9k7ppsidS59qzLS+whNDwDXVyfEgeRgp/BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kb1Hkqf0tA2B2U0uvpvz9HWYL6WSkjtT7Vc1oYvheOQ4hE6EKstjFvT3CoY7y79cxk5RBMc3jCkGIVCBVysaHtzGqmQ1ScxssT1ifrz9PadBgvTldX7HKKBADk3Mr2BXqg3tUm6UuBgGIKqzZ5QCuaQC1n5gGdd7by2f7kXoTbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Giy6qV7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Giy6qV7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBCAC4CEE3;
	Thu,  3 Jul 2025 14:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554195;
	bh=kz0bYjSm9k7ppsidS59qzLS+whNDwDXVyfEgeRgp/BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Giy6qV7F5JTkwvPT1JsktI2440skz+Z5dnLghXVf1B2PzJuc4d9wz4oesuT+K7zdc
	 N+KLSvqECqZ0MNayvUA0EqWrO9o+jqUVGLWnWDa/CBh2Gnov02dZyTT3zrTEihh3CB
	 8wSIznRyGOi1QRlDwRfBaE7JEzjtMzF6PYMcqk+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/218] net: selftests: fix TCP packet checksum
Date: Thu,  3 Jul 2025 16:40:58 +0200
Message-ID: <20250703144000.339982415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8d89661a36dd3bb8c9902cff36dc0c144dce3faf ]

The length in the pseudo header should be the length of the L3 payload
AKA the L4 header+payload. The selftest code builds the packet from
the lower layers up, so all the headers are pushed already when it
constructs L4. We need to subtract the lower layer headers from skb->len.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Gerhard Engleder <gerhard@engleder-embedded.com>
Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250624183258.3377740-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/selftests.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index 561653f9d71d4..ef27594d6a996 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -160,8 +160,9 @@ static struct sk_buff *net_test_get_skb(struct net_device *ndev,
 	skb->csum = 0;
 	skb->ip_summed = CHECKSUM_PARTIAL;
 	if (attr->tcp) {
-		thdr->check = ~tcp_v4_check(skb->len, ihdr->saddr,
-					    ihdr->daddr, 0);
+		int l4len = skb->len - skb_transport_offset(skb);
+
+		thdr->check = ~tcp_v4_check(l4len, ihdr->saddr, ihdr->daddr, 0);
 		skb->csum_start = skb_transport_header(skb) - skb->head;
 		skb->csum_offset = offsetof(struct tcphdr, check);
 	} else {
-- 
2.39.5



