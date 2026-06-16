Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF59478E26;
	Tue, 16 Jun 2026 17:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630381; cv=none; b=emnkMjAXtJg8WCt+kKY2WHKXVIPZ6YFis95uVfrLqhwXPlK0qYZwEfKdpxbtfzgBhbLL5J+zqZNkf1AKnGS4a1pkYeK7d6E7HoHPY2aMfqmc2jGClZvNu/pmm1RYAsXWW5LmoGln7hpl0npROm6RWerZK2G58WnR2s+P4WCPZtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630381; c=relaxed/simple;
	bh=1uFvhPGz7yZrTIvTjDFG8nSBYe0EZ9Wr4V2NHb05sCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OT2tqTGOli+LNeiaRWTRpzpObT8CJH01zjLrJ4gnuynzkdYZgOpOPkF0rHZnmD7Sjfn3rtTW8rMU4ihywWiMdoccHtPm9pnlMrornXPgtz7MQzmvp5lwTZWgWfQUOSyPsGncArPpxL4R7PrzMeqvK8ufU2L5tKyRJGZDx6SWFWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGvfI+EW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGvfI+EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AEEB1F000E9;
	Tue, 16 Jun 2026 17:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630380;
	bh=bpVo61kea3xOqwfFzWKYchR8CMcHK/1OtVFnBol31Xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGvfI+EWaEY0xKkp+ciH7DM3f2GQyxjxM7RGDQqr/azlx+MtN3w84pxuqT0wRqnFt
	 B9M8BXGCDfGwBjb0tLuur3ntLHLOdfjFqqixCDiLz/iF/86lSXEqMvhtH9xEib1L4Y
	 h6U5crKcWAyFUQwJoHaFmxPkOUHFKcIsHy579TaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/522] net: netlink: fix sending unassigned nsid after assigned one
Date: Tue, 16 Jun 2026 20:22:45 +0530
Message-ID: <20260616145126.374652210@linuxfoundation.org>
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

[ Upstream commit 70f8592ee90585272018a725054b6eb2ab7e99ca ]

If the current skb is not shared, it is re-used directly for all the
sockets subscribed to the notification.  If we have remote all-nsid
socket receiving a message first, then the 'nsid_is_set' will be
set to 'true'.  If the nsid is NOT_ASSIGNED for the next socket in
the list, the 'nsid_is_set' will remain 'true' and the negative value
is be delivered to the user space.  All subsequent nsid values will be
delivered as well, since there is no code path that sets the flag
back to 'false'.

Fix that by always dropping the flag to 'false' first.

Fixes: 7212462fa6fd ("netlink: don't send unknown nsid")
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Link: https://patch.msgid.link/20260520172317.175168-2-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 8c441c98ba5630..f502a57ad5470e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1473,6 +1473,7 @@ static void do_one_broadcast(struct sock *sk,
 		p->skb2 = NULL;
 		goto out;
 	}
+	NETLINK_CB(p->skb2).nsid_is_set = false;
 	NETLINK_CB(p->skb2).nsid = peernet2id(sock_net(sk), p->net);
 	if (NETLINK_CB(p->skb2).nsid != NETNSA_NSID_NOT_ASSIGNED)
 		NETLINK_CB(p->skb2).nsid_is_set = true;
-- 
2.53.0



