Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9569E3D3326;
	Wed, 30 Sep 2026 19:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795891; cv=none; b=eCdH5VfRQ17m0142ho2nGr2EvG0rG+uZuDS862tOOfnl1A9PhMDD2yF0UrH5eEXz9s5/PInVB6FY4FXK7sKHQMGy178WSGwmhVefW2nHjk1JVkZF5nVB5hYcAkg+/xc6s9vRHAhoYhlrMnN3/3qRVkW1K278Cm2KiCs6jG5OzxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795891; c=relaxed/simple;
	bh=aAKTSttB3B4gpiXn7bHPHBU9u+6uh2L4vYuDOPoKcp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJ2sbN4VNKfC2SpEakG5zeTEUTQqjsor8IwlXZ+gkm8Q5KkM4n6Uhe8QFDOCByNJCmYYihtJ5WkfH9EMz3Z3ypgSH/xmWWwk6iehpjj2zES63PTw+MKjyUdK36dMTGT7C0Tx49bpJCMes0Js43mxDgCkHSip4/9pLqd0x/n3w1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wzkc51vO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wzkc51vO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4931F000FF;
	Wed, 30 Sep 2026 19:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795890;
	bh=WsabAY8ULYNX2IOUSF1iJ4mqDNLfIfzJBRJclOTef7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wzkc51vO6rt3MhOAgdg/Hg3Q/0M3BICw6diP7GBgTNu03xNaXuMwadeOJ6f6I+tvM
	 Tpxh8FhODE7jKPV5s2U6s/m1h5C/PgOfsU53TeY+Mi15dDowpGtnTxHEDXBs00/tLw
	 XUzOFuCSfFlAlQpaHQBHPGycEH5djsPKZWWuyMIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0721/1193] xfrm: fix compat ALLOCSPI request use-after-free
Date: Wed, 30 Sep 2026 17:23:25 +0200
Message-ID: <20260930152450.268815668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit d1ebd9081879fd9ae9c8fb7e8928f19cc88ae320 ]

xfrm_state_netlink() builds the ALLOCSPI response with
dump_one_state(), which already calls alloc_compat() with the response
skb and header.

xfrm_alloc_userspi() then calls alloc_compat() again, but passes the
original request skb and its header. For a compat request, the
translator therefore interprets the 228-byte compat xfrm_userspi_info
as the 232-byte native layout and reads four bytes past the declared
payload. It also publishes the translated child through the request's
frag_list.

A multicast clone of the request shares skb_shared_info and can observe
that child. xfrm_user_rcv_msg() frees it after the request handler
returns, racing a compat receiver which may still be copying from it and
resulting in a use-after-free.

Remove the redundant conversion. The response keeps its correct compat
translation from dump_one_state(), and no child is attached to the
inbound request.

Fixes: 5f3eea6b7e8f ("xfrm/compat: Attach xfrm dumps to 64=>32 bit translator")
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 5634973136c3a..b926d4651c068 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1586,7 +1586,6 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
 	struct xfrm_userspi_info *p;
-	struct xfrm_translator *xtr;
 	struct sk_buff *resp_skb;
 	xfrm_address_t *daddr;
 	int family;
@@ -1639,17 +1638,6 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 	}
 
-	xtr = xfrm_get_translator();
-	if (xtr) {
-		err = xtr->alloc_compat(skb, nlmsg_hdr(skb));
-
-		xfrm_put_translator(xtr);
-		if (err) {
-			kfree_skb(resp_skb);
-			goto out;
-		}
-	}
-
 	err = nlmsg_unicast(xfrm_net_nlsk(net, skb), resp_skb, NETLINK_CB(skb).portid);
 
 out:
-- 
2.53.0



