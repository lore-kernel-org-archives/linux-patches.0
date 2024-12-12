Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69358223C74;
	Thu, 12 Dec 2024 17:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023195; cv=none; b=JyjZX1L6Sq5nx0Yu6Dyz3PgM9Z7iTRCg1r6WGjp1sML0W1lkTPzo4eqCeJUKT7So0qhwzEhXMSmGXs2gbgC30RRPnKmY4EhplmI+VEl4U6tYVAm9TCARBxH5n1kuh1h5KQ9MtWwL8QzrqmyblXp4FwPPzjCb77GKj3/tllfg9SQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023195; c=relaxed/simple;
	bh=hlexmcx3dBLtidtL0P3FWdhRKWT4dqZ5vLmNrjEKJ1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aISIrXpnrNK8wUH7JCbmPIq46YO7jAwju4uk0zLLpshSoaxyqPqVSpV02Zxcs988kWbZ4h4whOunlOVrUegubKdQJVb8+nTx/cWHnJ1ijyJ54QvvAqEXYQVwxNy8Or5QPkk7pNoyHdpYsvPhI/0z1k7fDJhkARdnbAIfVL05qy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E83cljRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E83cljRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7239C4CECE;
	Thu, 12 Dec 2024 17:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023195;
	bh=hlexmcx3dBLtidtL0P3FWdhRKWT4dqZ5vLmNrjEKJ1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E83cljRgwqZ2tyfjUEBipxcxPLr1wJRki8kQyxUAl09Nno42BTI0siSvpECXIwYzC
	 S8HqcpOdQmbAPiL4wyRFV7sgX92qIE2WvJ4mD3j3me1V2/O+/WmA9/4/4wcTy0aWvO
	 AoAnTjhU5p5BBL94ulya9msnhFN1tBc9V01PaJj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Wiesner <jwiesner@suse.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 414/565] net/ipv6: release expired exception dst cached in socket
Date: Thu, 12 Dec 2024 16:00:09 +0100
Message-ID: <20241212144328.024385743@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Wiesner <jwiesner@suse.de>

[ Upstream commit 3301ab7d5aeb0fe270f73a3d4810c9d1b6a9f045 ]

Dst objects get leaked in ip6_negative_advice() when this function is
executed for an expired IPv6 route located in the exception table. There
are several conditions that must be fulfilled for the leak to occur:
* an ICMPv6 packet indicating a change of the MTU for the path is received,
  resulting in an exception dst being created
* a TCP connection that uses the exception dst for routing packets must
  start timing out so that TCP begins retransmissions
* after the exception dst expires, the FIB6 garbage collector must not run
  before TCP executes ip6_negative_advice() for the expired exception dst

When TCP executes ip6_negative_advice() for an exception dst that has
expired and if no other socket holds a reference to the exception dst, the
refcount of the exception dst is 2, which corresponds to the increment
made by dst_init() and the increment made by the TCP socket for which the
connection is timing out. The refcount made by the socket is never
released. The refcount of the dst is decremented in sk_dst_reset() but
that decrement is counteracted by a dst_hold() intentionally placed just
before the sk_dst_reset() in ip6_negative_advice(). After
ip6_negative_advice() has finished, there is no other object tied to the
dst. The socket lost its reference stored in sk_dst_cache and the dst is
no longer in the exception table. The exception dst becomes a leaked
object.

As a result of this dst leak, an unbalanced refcount is reported for the
loopback device of a net namespace being destroyed under kernels that do
not contain e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev"):
unregister_netdevice: waiting for lo to become free. Usage count = 2

Fix the dst leak by removing the dst_hold() in ip6_negative_advice(). The
patch that introduced the dst_hold() in ip6_negative_advice() was
92f1655aa2b22 ("net: fix __dst_negative_advice() race"). But 92f1655aa2b22
merely refactored the code with regards to the dst refcount so the issue
was present even before 92f1655aa2b22. The bug was introduced in
54c1a859efd9f ("ipv6: Don't drop cache route entry unless timer actually
expired.") where the expired cached route is deleted and the sk_dst_cache
member of the socket is set to NULL by calling dst_negative_advice() but
the refcount belonging to the socket is left unbalanced.

The IPv4 version - ipv4_negative_advice() - is not affected by this bug.
When the TCP connection times out ipv4_negative_advice() merely resets the
sk_dst_cache of the socket while decrementing the refcount of the
exception dst.

Fixes: 92f1655aa2b22 ("net: fix __dst_negative_advice() race")
Fixes: 54c1a859efd9f ("ipv6: Don't drop cache route entry unless timer actually expired.")
Link: https://lore.kernel.org/netdev/20241113105611.GA6723@incl/T/#u
Signed-off-by: Jiri Wiesner <jwiesner@suse.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241128085950.GA4505@incl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 35d3f02ddf163..407dba4327f53 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2769,10 +2769,10 @@ static void ip6_negative_advice(struct sock *sk,
 	if (rt->rt6i_flags & RTF_CACHE) {
 		rcu_read_lock();
 		if (rt6_check_expired(rt)) {
-			/* counteract the dst_release() in sk_dst_reset() */
-			dst_hold(dst);
+			/* rt/dst can not be destroyed yet,
+			 * because of rcu_read_lock()
+			 */
 			sk_dst_reset(sk);
-
 			rt6_remove_exception_rt(rt);
 		}
 		rcu_read_unlock();
-- 
2.43.0



