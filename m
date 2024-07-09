Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D571A158842;
	Tue,  9 Jul 2024 11:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523669; cv=none; b=YfbE6tzXEOsEYBJaM3wt1KnJr/wm3pbw422WQchifMjkJ8gvwXtGQvmpBNZfUb1M/1WGMgC4rspgGqNmACMpCUXG0ACr5uCNIV47+VunBole/yISFnsOJlUfYDCZcvC1TBIi1AjkPtx2eXcMs0kul8wCKIs4A4LXCyk0pF0QSek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523669; c=relaxed/simple;
	bh=unH/cvfYQ4T4Z9fijJ4uNN+XG3tgC0DRQuWiFDvX8sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ew0CuKqhYTzoQUHE25QR6+G4cdtbyEJIx14uZ3KYrP8FE4r62HqZh9m5VNEv/rnTIpzDnj9ew51SiR26lO7c6bmkM4bjx32EUpVsakpZT6+CedQeoYZJ9vbYMgvHRotjB2PnWTaXa+ElieLpVsPf0Je5NVWa7zQkVUMCjb27HZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1n0r2q6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1n0r2q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7FBC4AF0F;
	Tue,  9 Jul 2024 11:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523669;
	bh=unH/cvfYQ4T4Z9fijJ4uNN+XG3tgC0DRQuWiFDvX8sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1n0r2q6J2hmSCwD/sJa6U/WOOmdX70RUfdIIi3YZxDjfqeYxk499B8qykhOIET3P
	 OS7HMMf9KJMrTNyv/Hm/BqUv6T1cQqFMlMWICsGfaEujF3KZU8Egbn48REVrpkW2jo
	 BMGFYg88rr2Ey1Ajq0ZIXacczZ5T7iCA9agzFOoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/139] tcp_metrics: validate source addr length
Date: Tue,  9 Jul 2024 13:09:30 +0200
Message-ID: <20240709110700.883305354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7aca12c59c184..b71f94a5932ac 100644
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



