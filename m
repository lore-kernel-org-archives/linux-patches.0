Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA47CA40;
	Tue, 16 Jul 2024 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144390; cv=none; b=O+dOzngGiR4tRZROnLAsh6rB0gaKLW6giFVuzjfoyQI4bO/4TvfroO5dOSHruXRq1/hggRT4r0/PIT3QxyWv6G1oiU5HQXwNpp70qvlgxiMNmUwQrUxT7hC97pje+LM6hmqOPUb4o955rYBaVud42sIRi1/ePqeOTHlflrzwUz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144390; c=relaxed/simple;
	bh=w3ujy9DBljKPCcUcDpFRf9JmXMBqKFtXonSNq7u1Hog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqA5OvVT4EyiNlGI+bWB+fdzXpWjxsvGcAsuwOXJLolFgrfpzGCpZP62bVGGP2NiERDJSaNZt48bpGgamm6RGnMHARbnzN8hCCpK8J4mhr5WXeVOCtgx8rhehRIVWXXIClREaQ0SvAXQ5XPeUqsN8mrVJt9WkpkMWF6HfjZubFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RiPmkoXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RiPmkoXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16E8C116B1;
	Tue, 16 Jul 2024 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144390;
	bh=w3ujy9DBljKPCcUcDpFRf9JmXMBqKFtXonSNq7u1Hog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RiPmkoXMvR/br8l/ta1NjfPfL8c0r8J961J+PMJMFKK+CWl5ZWQJ3hiuxJt+xbF7c
	 mThmHVzJzlVZsydXSuQC9P04bpYT1XI5CSfQfWRCI5/T8uHbpjrUdA8H+qz2NavCke
	 pBvC7nGhU+1qoky4u00P5X0g6T0RMD4f2LcJfkV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/78] tcp_metrics: validate source addr length
Date: Tue, 16 Jul 2024 17:30:58 +0200
Message-ID: <20240716152741.648151354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152740.626160410@linuxfoundation.org>
References: <20240716152740.626160410@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 627e3be0f754b..f6483d6401fb4 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -614,6 +614,7 @@ static const struct nla_policy tcp_metrics_nl_policy[TCP_METRICS_ATTR_MAX + 1] =
 	[TCP_METRICS_ATTR_ADDR_IPV4]	= { .type = NLA_U32, },
 	[TCP_METRICS_ATTR_ADDR_IPV6]	= { .type = NLA_BINARY,
 					    .len = sizeof(struct in6_addr), },
+	[TCP_METRICS_ATTR_SADDR_IPV4]	= { .type = NLA_U32, },
 	/* Following attributes are not received for GET/DEL,
 	 * we keep them for reference
 	 */
-- 
2.43.0



