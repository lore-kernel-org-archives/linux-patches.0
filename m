Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCC83FC5DE;
	Wed, 20 May 2026 18:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301429; cv=none; b=RUdmT9O9f6EZAPuT/iM2l01g+ywa8gz8EIUPm9c3eoc9rIV3oLRy8nm0aOmYiM+de5n7dKec8qI8mvR68rSHMnYOLWX/MRsGkraYirvNaQKNGY1y/EFTBhzEf4aPbfVjk8aUBpuZuM8JtETb0IjqhW24UMnEJ9KhMZrgqYkzwf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301429; c=relaxed/simple;
	bh=iHA762wzn1TZvchoo8C4M1ISc5uQvfZuVWRFZEPbmMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BYOBQTQ5zDaqFqxYbwmRxZXQR1xjtC2YgET8aSGalO9wJ4eRfS04WUhfkvJkFmtiyyXNV8gGDKE8OipkE8HKUfxGNtcmdzyM06ZA4xQk0GU2WUTzdxzKmCo27MosZwYPJ5l1+ljTI8SBs2DoUQmNlHoIMYyMUwvkS+wXj8YdjJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyP0DqDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyP0DqDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2011F000E9;
	Wed, 20 May 2026 18:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301428;
	bh=4iDeeN8pebZkSWxDxj1qZqYwesE7T121zxY0z34Mk+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyP0DqDFs648MZt4rYDT/GAdfaF+Bb+ozz/5/iXeQm2OYwK+kbtddGS/XXOTq7iCB
	 MC9PIuurtBee4lbmPz+M34SSSjk/Etjr5+HXjAEYASRGROOtbdOWdTC1OUCF1mE2H0
	 tHfJ6xZ4FFAFL5RdDIfVKw18x6qq+uMxcdZcRi6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 550/666] netpoll: fix IPv6 local-address corruption
Date: Wed, 20 May 2026 18:22:41 +0200
Message-ID: <20260520162123.189696282@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b5305ff217a8b..b754341db50fe 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -750,6 +750,23 @@ static int netpoll_take_ipv4(struct netpoll *np, struct net_device *ndev)
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
@@ -793,7 +810,7 @@ int netpoll_setup(struct netpoll *np)
 		rtnl_lock();
 	}
 
-	if (!np->local_ip.ip) {
+	if (netpoll_local_ip_unset(np)) {
 		if (!np->ipv6) {
 			err = netpoll_take_ipv4(np, ndev);
 			if (err)
-- 
2.53.0



