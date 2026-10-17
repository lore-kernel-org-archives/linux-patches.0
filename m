Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10373A6F00;
	Sat, 17 Oct 2026 18:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260584; cv=none; b=p0LYrce4TF2sVezxlchmSpy5N/LSz4sOq3HzcpkVOhBcUqAK38A82PiQmnUUdQ5S2cViJwq644XP96/1A5fQuY4QYuH4uPhfB5Xne/x67ZFFXipAMi2aew+ipuQ5mip9clrK8gtIx3P5YsexLyS4EDJD+PrVLTqRRR7r1zcbL0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260584; c=relaxed/simple;
	bh=Z4qrTQAQCtOz3HSX7WmhDSPSOhZ7TukyP/smQHrL62U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNJpGghwB7Ysj0elCNSyIYi8AO7Zgj0RFVSFsv4riewhPVyrPQB2K3drLc1blGn+TSUadrF3nyXCeTuuoMrsByxb3ZTuMzdL5G6sTJFmi6HRFzjjldF/hC7LjCOJv29RUghLkStJ4lImvTja2Nd95uL1/GPuTgasm1WNzaSNoBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDMIobYi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDMIobYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8D01F000C4;
	Sat, 17 Oct 2026 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260583;
	bh=QziS2h/5EhOIbP7ISudqYnsvPVZ6y9ODU2Y/MIqQ7Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDMIobYiUiO90qcEvpVJRRB+bOewbJFKe09sQR3TYObfOpOg5L0mzFs8GLXypV2BR
	 bQoMivbl36zsguYd5gxK2ltf0MQtMAqb5V+NhE8eB5aYJ4ngbhGqXoQljRXwvVDEfx
	 +f497FUqyqBO63xALOiA+RBYycmG2McYUXnlzVls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1594/1674] ipv6: flowlabel: cap duplicate leases per socket
Date: Sat, 17 Oct 2026 18:04:26 +0200
Message-ID: <20261017160512.003977626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 8d6cd188508513503805c156165de38e4e4a8615 ]

ipv6_flowlabel_get() allocates an ipv6_fl_socklist entry for every
successful GET. The recheck path for a compatible existing flowlabel
links another lease without applying any lease admission check. Repeated
GET requests for one shareable label can therefore grow a socket's lease
list without bound.

Reject a new unprivileged lease once the socket already holds
FL_MAX_PER_SOCK leases. Check this on the shared recheck path so reuse
of a globally interned label, including the fl_intern() collision path,
is covered as well. New-label admission remains under the existing
mem_check() policy.

Use capable(CAP_NET_ADMIN) rather than ns_capable(), matching
mem_check(). An unprivileged user must not bypass the cap by creating a
user namespace and a netns where they have CAP_NET_ADMIN, which would
still consume host memory.

Check the capability only when the socket reaches the limit, so
successful unprivileged GET requests below the cap do not generate a
capability audit. Do the admission check before updating linger and
expires so a rejected GET does not refresh the shared label, matching
the existing socket-list allocation failure path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/83f8535972ff6e3741548476a1d50dec24c758be.1788415194.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_flowlabel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index bf909fa69a977..f6f2e25215c5c 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -463,6 +463,22 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 	return NULL;
 }
 
+static bool fl_sock_at_lease_limit(const struct sock *sk)
+{
+	const struct ipv6_pinfo *np = inet6_sk(sk);
+	const struct ipv6_fl_socklist *sfl;
+	int count = 0;
+
+	rcu_read_lock();
+	for_each_sk_fl_rcu(np, sfl) {
+		if (++count >= FL_MAX_PER_SOCK)
+			break;
+	}
+	rcu_read_unlock();
+
+	return count >= FL_MAX_PER_SOCK;
+}
+
 static int mem_check(struct sock *sk)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
@@ -673,6 +689,10 @@ static int ipv6_flowlabel_get(struct sock *sk, struct in6_flowlabel_req *freq,
 			err = -ENOMEM;
 			if (!sfl1)
 				goto release;
+			err = -ENOBUFS;
+			if (fl_sock_at_lease_limit(sk) &&
+			    !capable(CAP_NET_ADMIN))
+				goto release;
 			if (fl->linger > fl1->linger)
 				fl1->linger = fl->linger;
 			if ((long)(fl->expires - fl1->expires) > 0)
-- 
2.53.0



