Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05D13BF307;
	Thu, 15 Jan 2026 17:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497127; cv=none; b=ezRyueZ7wNNmz2WOcwk4fmQHOT/HIwOGk6YoPdZSLPlaxRPdTK/gyxU7xc96dS0K2RB0vZrWvG57tF/oPWueUhaBI8eoi02+AIlHNIHz5SQaLM3PtG4NL4G8efGRaACjt82C3Mz9FCGzEWhj5O0BcJgThETbgjhwfOL1+0NdYds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497127; c=relaxed/simple;
	bh=WPoCdOoRC3jJ/tFYHfUliNUnNfgJ114C5+X9n9jJ46g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofu55UvdLBtOVdA7R0HEg39EdU7/zxrHp3hEtmU/stGxwNii/XJM4//3iknfPAyyJhFtCs46/FETdMS04xZuK5aUtS4XRsDoLP64bumQ2B3goD5kJlxjWkxmizEPAZqJSAgK8fove61B6/w+9R9AMdjH5tTWP66AXFOXf9BpvEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRYz6PSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRYz6PSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D32DC16AAE;
	Thu, 15 Jan 2026 17:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497126;
	bh=WPoCdOoRC3jJ/tFYHfUliNUnNfgJ114C5+X9n9jJ46g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRYz6PSlMN8whBzYCNi9fekf0RbfwCVd+o5Jinw7iodAHDISsXZz5iQeBZfR1DX1C
	 5Dezjs1s7C4wG6aqIRb+IlVCjf5kqcpdsqHDdA9cLpyV2DLbXJwQKdxv0DkYYdSfHZ
	 WVrV1WeLHTwVbI/xUCPDTj/TnBiHCZS6KQsBw1EU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Subject: [PATCH 6.1 18/72] tls: Use __sk_dst_get() and dst_dev_rcu() in get_netdev_for_sock().
Date: Thu, 15 Jan 2026 17:48:28 +0100
Message-ID: <20260115164144.155667295@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit c65f27b9c3be2269918e1cbad6d8884741f835c5 ]

get_netdev_for_sock() is called during setsockopt(),
so not under RCU.

Using sk_dst_get(sk)->dev could trigger UAF.

Let's use __sk_dst_get() and dst_dev_rcu().

Note that the only ->ndo_sk_get_lower_dev() user is
bond_sk_get_lower_dev(), which uses RCU.

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250916214758.650211-6-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Keerthana: Backport to v5.15-v6.1 ]
Signed-off-by: Keerthana K <keerthana.kalyanasundaram@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -125,17 +125,19 @@ static void tls_device_queue_ctx_destruc
 /* We assume that the socket is already connected */
 static struct net_device *get_netdev_for_sock(struct sock *sk)
 {
-	struct dst_entry *dst = sk_dst_get(sk);
-	struct net_device *netdev = NULL;
+	struct net_device *dev, *lowest_dev = NULL;
+	struct dst_entry *dst;
 
-	if (likely(dst)) {
-		netdev = netdev_sk_get_lowest_dev(dst->dev, sk);
-		dev_hold(netdev);
+	rcu_read_lock();
+	dst = __sk_dst_get(sk);
+	dev = dst ? dst_dev_rcu(dst) : NULL;
+	if (likely(dev)) {
+		lowest_dev = netdev_sk_get_lowest_dev(dev, sk);
+		dev_hold(lowest_dev);
 	}
+	rcu_read_unlock();
 
-	dst_release(dst);
-
-	return netdev;
+	return lowest_dev;
 }
 
 static void destroy_record(struct tls_record_info *record)


