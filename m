Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD29F34545;
	Tue,  9 Jul 2024 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524636; cv=none; b=qgj8ebMxkZuPrEI3jId6anflfD9vcgh0jsbWaw+MVltVt3DTy56gLBR1s88p0OWk4pt5hcRhPblQUT1MuQbptLtjq3NoM65oK8Cm4+H7ZGowNHER07RAGGAs1bJSyNRXY7TpEMmxIIbveeIVbvgsmb06Oy54jPQRyPZIBbtqOw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524636; c=relaxed/simple;
	bh=MzI1MfJUWr+lyOE+NP1wi4J3A+P3/QBSC5IRFmpNr7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzaHiaOADhREf2K3Xf45WJfxgosJfL8zoJALgIHApGxUvgq0qSryP0Uyv+y5TfI0HIMp7cQIRu/jcRL4lus6hkRa0qQBEwKY5rdRIWpCdpbhDQz0nkCeY/Fxdn7VUoHPGZMjHSNi4uHeL9MJZI46j+7W9m8NwOK/PbzhwR9lrAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL2Iu1h0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL2Iu1h0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63695C3277B;
	Tue,  9 Jul 2024 11:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524635;
	bh=MzI1MfJUWr+lyOE+NP1wi4J3A+P3/QBSC5IRFmpNr7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL2Iu1h0d6j9HH7W7IFjuNzPXLSTu7wHy0e5D7q7Y0/iHErMfNltaKuXpPYA3RKCQ
	 h6Fy95nn+X1YqtNt8HB/5+oq8guZfcX6MPfoQO8/yYHia0Df/5WjFp5vGKAiD8yGQW
	 EWznTviBodVLQGoAlCDDQtb+2fmmRuUmBKBpRFoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/102] tcp_metrics: validate source addr length
Date: Tue,  9 Jul 2024 13:10:11 +0200
Message-ID: <20240709110653.242769971@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a7364ff8b558d..a4e03a7a2c030 100644
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



