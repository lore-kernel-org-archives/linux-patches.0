Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC54E4071DA;
	Sun,  7 Jun 2026 10:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827337; cv=none; b=RUFrsz6mmqiAB8ASca89cbsuviYDhpWsR600+GoVfuxT/XG8m3DKfEFz4nLnT/gGTCwzP2NTdvkO6V1cG/IbbtaSTUpnhnv+fofmDAOa62CXrZawhwLihk1mhxqviPaPHPQjyCyzgUu+u0Qox1yy+PI5RMiM/f3RDoVh2a9GWd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827337; c=relaxed/simple;
	bh=t5UURlrkjzXwxnMf9KZmgdSKOAjuYxJZAVgSlP1yz48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hcv5iBnObtk4d6z9HK2H6i/Ctpdbd+u/5213P6bDDTBMxIIX6jdrwy2MZpL0C9hslkeTr0Wgukr/WAYWhQP6jMrLPVL9P9N5P3wUqdoT2e1u/+5A3ardvFUXQxC4u2+k0KZ5EhnuqGcCiWgGvuRHI/rK/w3md9mF2637bOmeD9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OnbbY5Hu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OnbbY5Hu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B24C1F00893;
	Sun,  7 Jun 2026 10:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827336;
	bh=Wf94cxUsJ5Xzpkvfz+9WgnyUxzRA6ZQy1rYPzW/rPwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnbbY5HuJSX77rKDoNU4KVSD2/V5kBZb3RadJt+J0keK1LwgdBC+OnnvyoT/oQYmf
	 +87mLe3i24rXNNL2Tc3wNxmyQbZjCH3ZL0YAz8cNl2cKebuM9QRYPYYiPLYrkv9bFx
	 Nuqq1wzPNQ4i5xcltmYen3upgvzmC4yJ4BxJSWq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/307] net: netlink: fix sending unassigned nsid after assigned one
Date: Sun,  7 Jun 2026 11:57:14 +0200
Message-ID: <20260607095729.048716426@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8b060465a2be1a..287b4f921c607e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1477,6 +1477,7 @@ static void do_one_broadcast(struct sock *sk,
 		p->skb2 = NULL;
 		goto out;
 	}
+	NETLINK_CB(p->skb2).nsid_is_set = false;
 	NETLINK_CB(p->skb2).nsid = peernet2id(sock_net(sk), p->net);
 	if (NETLINK_CB(p->skb2).nsid != NETNSA_NSID_NOT_ASSIGNED)
 		NETLINK_CB(p->skb2).nsid_is_set = true;
-- 
2.53.0



