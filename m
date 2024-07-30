Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E403D1A76A5;
	Tue, 30 Jul 2024 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360755; cv=none; b=a272pxGaEBVWErKmJBu016n9T+GFS9txwjuBHZpBIXjg4dqjzNpyR3NYNBe3ISsTAuyk1fB7swIf10cGi2a6UFmN6qYPjkniyEEeh91j4IBA3MEVadCNkLWIkrYA4AiJuwHyDBSEVqHQtB9/1Ns1CiKgaeCC4Okm0pW9LRo6iFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360755; c=relaxed/simple;
	bh=2xUageQSE0Y9Z28rPhcpMzzRQiF6shxuMPZ6kgIkfJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4gtvy2u6HygZm4/j2EkY1s66mSSyTY6elSwjjN2DvZxssjSgQzPybnURgG0TWEtXxZrH8wkT9+aKlsGBxGBCG+z0Kv2EZ+IrdnTL23epoUlmtMH9y3hyA5i2TeV11xoLbY/adyiQfvE0fGiduAvZ93Wcz8pQtQS8fbyyH50bK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTfzcyI3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTfzcyI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DDCC32782;
	Tue, 30 Jul 2024 17:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360754;
	bh=2xUageQSE0Y9Z28rPhcpMzzRQiF6shxuMPZ6kgIkfJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTfzcyI3LQGf591tAWjUEVpxS2SyoGd4Ov7bYdGb5bG5OvjmqEETmJ1rYGCXR/deY
	 8qCDm6vpwEdydtyV1CmbJtw30Lra4BFM3L3bcV/AJT8GkTmkEJvRcfASJd240yCiCT
	 6NBaA5LVvUbJMcrlhsxmeeyC2D94Oyru6ANZMMTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Tung Nguyen <tung.q.nguyen@endava.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 766/809] tipc: Return non-zero value from tipc_udp_addr2str() on error
Date: Tue, 30 Jul 2024 17:50:42 +0200
Message-ID: <20240730151755.220573403@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit fa96c6baef1b5385e2f0c0677b32b3839e716076 ]

tipc_udp_addr2str() should return non-zero value if the UDP media
address is invalid. Otherwise, a buffer overflow access can occur in
tipc_media_addr_printf(). Fix this by returning 1 on an invalid UDP
media address.

Fixes: d0f91938bede ("tipc: add ip/udp media type")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Tung Nguyen <tung.q.nguyen@endava.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/udp_media.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
index b849a3d133a01..439f755399772 100644
--- a/net/tipc/udp_media.c
+++ b/net/tipc/udp_media.c
@@ -135,8 +135,11 @@ static int tipc_udp_addr2str(struct tipc_media_addr *a, char *buf, int size)
 		snprintf(buf, size, "%pI4:%u", &ua->ipv4, ntohs(ua->port));
 	else if (ntohs(ua->proto) == ETH_P_IPV6)
 		snprintf(buf, size, "%pI6:%u", &ua->ipv6, ntohs(ua->port));
-	else
+	else {
 		pr_err("Invalid UDP media address\n");
+		return 1;
+	}
+
 	return 0;
 }
 
-- 
2.43.0



