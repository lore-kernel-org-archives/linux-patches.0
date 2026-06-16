Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C31C1A6803;
	Tue, 16 Jun 2026 17:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630386; cv=none; b=Q0jnkfkspf9EngGkrGGVqHyxTCUDNCSKdZAca2R/OxcxaiUmaAelU866y68mvN/qDhWO7ppLuOZOphErdIiLKmJYGICdnK5sMUSiEZ4o8ZiNHPHnyRgsWHV/sM2P8ndWPXfieBand2cqoHZXnvHwJ282Mt1wDRRGBD2eXVq7waw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630386; c=relaxed/simple;
	bh=hEgWkfublnusiYH9oFk0LZOuXIvVCXO+nDEvtLkpXi8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJZX1DpuRk5jzlWjTES1PLJO0gEm4AYo8WRrHScZtyoFVdS93Hja8CojMnOGKuPIMHxVNrdFwGrWIVFimF9CWulSNySket8qJejj7QsNO2hH3kNLgF3X2IHhLnc3sx7YFj0VZqW/f8wzV/YCm0gsXyJZZtlzX735MxwgT+DivE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHCvi7If; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHCvi7If"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C931F000E9;
	Tue, 16 Jun 2026 17:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630385;
	bh=xCx4EbNdVUf6iFWIXgUeksm0LOeKztHI6KQ88ftWBl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHCvi7Ifjqd9W11kgvvLQV9DJzeNBJ3TjNmZhf//dq8Kr5poRA7ZSQEV51SpgQySX
	 UPM1eZ5rmIxf5Qbyag7rklbOZgK9+G7/81vBjJMsCIq+GwedVbm3fwX7jADIFuY7Ir
	 5HXnPM/RxtYladfjoxHvoHX3HoM8nQF+/o7AHYGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matteo Perin <matteo.perin@canonical.com>,
	Ilya Maximets <i.maximets@ovn.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/522] net: netlink: dont set nsid on local notifications
Date: Tue, 16 Jun 2026 20:22:46 +0530
Message-ID: <20260616145126.432062998@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 88b126b39f9757e9debc322d4679239e9af089c7 ]

In most cases, notifications on sockets with NETLINK_LISTEN_ALL_NSID
do not contain NSID in their ancillary data in case the event is local
to the listener.

However, when a self-referential NSID is allocated for a namespace,
every local notification starts sending this ID to the user space.

This is problematic, because the listener cannot tell if those
notifications are local or not anymore without making extra requests
to figure out if the provided NSID is local or not.  The listener
can also not figure out the local NSID beforehand as it can be
allocated at any point in time by other processes, changing the
structure of the future notifications for everyone.

The value is practically not useful, since it's the namespace's own
ID that the application has to obtain from other sources in order to
figure out if it's the same or not.  So, for the application it's
just an extra busy work with no benefits.  Moreover, applications
that do not know about this quirk may be mishandling notifications
with NSID set as notifications from remote namespaces.  This is the
case for ovs-vswitchd and the iproute2's 'ip monitor' that stops
printing 'current' and starts printing the nsid number mid-session.

Lack of clear documentation for this behavior is also not helping.

A search though open-source projects doesn't reveal any projects
that use NETNSA_NSID_NOT_ASSIGNED and rely on metadata to contain
self-referential NSIDs (expected, since the value is not useful).
Quite the opposite, as already mentioned, there are few applications
that rely on NSID to not be present in local events.

Since the value is not useful and actively harmful in some cases,
let's not report it for local events, making the notifications more
consistent.

Also adding some blank lines for readability.

Fixes: 59324cf35aba ("netlink: allow to listen "all" netns")
Reported-by: Matteo Perin <matteo.perin@canonical.com>
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://patch.msgid.link/20260520172317.175168-3-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f502a57ad5470e..f5d4eba785d03c 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1473,10 +1473,14 @@ static void do_one_broadcast(struct sock *sk,
 		p->skb2 = NULL;
 		goto out;
 	}
+
 	NETLINK_CB(p->skb2).nsid_is_set = false;
-	NETLINK_CB(p->skb2).nsid = peernet2id(sock_net(sk), p->net);
-	if (NETLINK_CB(p->skb2).nsid != NETNSA_NSID_NOT_ASSIGNED)
-		NETLINK_CB(p->skb2).nsid_is_set = true;
+	if (!net_eq(sock_net(sk), p->net)) {
+		NETLINK_CB(p->skb2).nsid = peernet2id(sock_net(sk), p->net);
+		if (NETLINK_CB(p->skb2).nsid != NETNSA_NSID_NOT_ASSIGNED)
+			NETLINK_CB(p->skb2).nsid_is_set = true;
+	}
+
 	val = netlink_broadcast_deliver(sk, p->skb2);
 	if (val < 0) {
 		netlink_overrun(sk);
-- 
2.53.0



