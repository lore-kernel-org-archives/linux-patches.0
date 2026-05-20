Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E7D3F4114;
	Wed, 20 May 2026 17:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296842; cv=none; b=m+NQ7chDhEHJ8ZWffrBy2t+ErwJy8BCF6z+/hMFclI8JPxs4BZEl1Oit9G8b0ga/R8bco0sZHBdRKJbhHELQyuQ71l1LNHw0XfYS7pzMdfTTYE8M26xhiOkXM+ADqWwKfqFjWh8ea9pgmvpMDm9ajn7rQtdm3OeDDJP/mfBnCIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296842; c=relaxed/simple;
	bh=Jq430R61qFgyURWUgzAHvAWB6Xqt7wdkVfOHO3Gkdas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyRysOsmEQwclhEdhOOAfhfcB3OEeYyXUYJBWxP7arYfzF1l9dd/kTDqOI3z9+VDBf75BPIQy3Ij37ZoP/iavOdnUMKIaVLOcOkUa3ipdherKIWKn85ur2Pkg5BdhEnmYqfzpwUcMMDS3tEOa73ZmfMUTGCToiPsua+74xLf1Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFjLp6Zr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFjLp6Zr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506091F00893;
	Wed, 20 May 2026 17:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296840;
	bh=h+ByJEBHpEhz5OwIQr+i6b2U6tD3/VgkGpLNjm4BeHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFjLp6ZrpcpxyWssZac9n5zZf+vtxpPD80IrO3iAw0FjnfBNr54RR8bsvUKDHy1ko
	 TFXHfdBJFe/MDrkUuNc/G+8CT4R7K3eTKeT+jOEE8ea5dan1YADps3sYXFJW516N+y
	 EFQKE8FTq/A8OlLm6OIv5VhHtJWEloAvqBEASL3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0950/1146] netpoll: fix IPv6 local-address corruption
Date: Wed, 20 May 2026 18:20:00 +0200
Message-ID: <20260520162209.733593614@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3bc179bc7146c26c9dff75d2943d10528274e301 ]

netpoll_setup() decides whether to auto-populate the local source
address by testing np->local_ip.ip, which only inspects the first 4
bytes of the union inet_addr storage.

For an IPv6 netpoll whose caller-supplied local address has a zero
high-32 bits (::1, ::<suffix>, IPv4-mapped ::ffff:a.b.c.d, etc.), this
misdetects the address as unset (which they are not, but the first
4 bytes are empty), calls netpoll_take_ipv6() and overwrites it with
whatever matching link-local/global address the device happens to expose
first.

Introduce a helper netpoll_local_ip_unset() that picks the correct
family-aware test (ipv6_addr_any() for IPv6, !.ip for IPv4) and use it
from netpoll_setup().

Reproducer is something like:

  echo "::2" > local_ip
  echo 1     > enabled
  cat local_ip
  # before this fix: 2001:db8::1   (caller-supplied ::2 was clobbered)
  # after  this fix: ::2

Fixes: b7394d2429c1 ("netpoll: prepare for ipv6")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260424-netpoll_fix-v1-1-3a55348c625f@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 5ae90c14ba493..84faace50ac28 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -706,6 +706,23 @@ static int netpoll_take_ipv4(struct netpoll *np, struct net_device *ndev)
 	return 0;
 }
 
+/*
+ * Test whether the caller left np->local_ip unset, so that
+ * netpoll_setup() should auto-populate it from the egress device.
+ *
+ * np->local_ip is a union of __be32 (IPv4) and struct in6_addr (IPv6),
+ * so an IPv6 address whose first 4 bytes are zero (e.g. ::1, ::2,
+ * IPv4-mapped ::ffff:a.b.c.d) must not be tested via the IPv4 arm —
+ * doing so would misclassify a caller-supplied address as unset and
+ * silently overwrite it with whatever address the device exposes.
+ */
+static bool netpoll_local_ip_unset(const struct netpoll *np)
+{
+	if (np->ipv6)
+		return ipv6_addr_any(&np->local_ip.in6);
+	return !np->local_ip.ip;
+}
+
 int netpoll_setup(struct netpoll *np)
 {
 	struct net *net = current->nsproxy->net_ns;
@@ -750,7 +767,7 @@ int netpoll_setup(struct netpoll *np)
 		rtnl_lock();
 	}
 
-	if (!np->local_ip.ip) {
+	if (netpoll_local_ip_unset(np)) {
 		if (!np->ipv6) {
 			err = netpoll_take_ipv4(np, ndev);
 			if (err)
-- 
2.53.0



