Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6744157E61;
	Tue,  9 Jul 2024 11:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524263; cv=none; b=rLiy6pwsE9c1/d/eZoowpID5O0M9lM9Y5P2yQs4sR/w4Jd1XMn/8k6Hvfj375bRcuhHPmna2u22poMktR6bUgjiCzSvYHPJp3DuIzFxhCP6Fzr6d0dOUUx5gIt9AWSrwhA5fCJT9B+dObO5MpOXbei5WHQWdghK2RdOoLCx1gys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524263; c=relaxed/simple;
	bh=Gq2rUioRrEycQHJrezxwHdaA1RzLh/TtiaWGssh+bR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpd8LEmTghlUHP66ty6eN+IdE8raYUDHczyQ4PtUYEH5cBTpsJH5CqWapnQR6uihjN5ZHnYYwLmnjXwLM+XyuFxGPugGpJVLffiGHZSiAQJjWtsFQrDmTUIRK/scRYF2hB2d851WiQAWJ2QybSjfI4EzaTyyr427FkvKmgzS46I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOcYVjM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOcYVjM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA07C3277B;
	Tue,  9 Jul 2024 11:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524263;
	bh=Gq2rUioRrEycQHJrezxwHdaA1RzLh/TtiaWGssh+bR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOcYVjM1FJ96V81jy0JSQnb7NbK6+cE7rm49hZNT2fZ5Ib1P33NyJ9LuklzKH9U9V
	 zVifQpnQl0YJUN8DIPU05bLMuXWG+xj2CLBq26gJtG0UDTXssDsr28mWYCGNVAmR3P
	 PxhNDwwZMYuzlpx7Vo7jPmm0Rmc7Gt1mb18j1Q0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 098/197] tcp_metrics: validate source addr length
Date: Tue,  9 Jul 2024 13:09:12 +0200
Message-ID: <20240709110712.753295321@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 66be40e622e177316ae81717aa30057ba9e61dff ]

I don't see anything checking that TCP_METRICS_ATTR_SADDR_IPV4
is at least 4 bytes long, and the policy doesn't have an entry
for this attribute at all (neither does it for IPv6 but v6 is
manually validated).

Reviewed-by: Eric Dumazet <edumazet@google.com>
Fixes: 3e7013ddf55a ("tcp: metrics: Allow selective get/del of tcp-metrics based on src IP")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index c2a925538542b..e0883ba709b0b 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -619,6 +619,7 @@ static const struct nla_policy tcp_metrics_nl_policy[TCP_METRICS_ATTR_MAX + 1] =
 	[TCP_METRICS_ATTR_ADDR_IPV4]	= { .type = NLA_U32, },
 	[TCP_METRICS_ATTR_ADDR_IPV6]	= { .type = NLA_BINARY,
 					    .len = sizeof(struct in6_addr), },
+	[TCP_METRICS_ATTR_SADDR_IPV4]	= { .type = NLA_U32, },
 	/* Following attributes are not received for GET/DEL,
 	 * we keep them for reference
 	 */
-- 
2.43.0



