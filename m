Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0044FC8D1;
	Wed, 23 Sep 2026 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174192; cv=none; b=pC4xGw2/RnOtPbs3HP2Am7vxkrYkLBnM3t3FYZ62SOpwrzquizsrzE1saP87Fy73y8jXRQ9k5XnARGSQoxo//3KigrdpcST2YXREVesD+NCSsEEQ2Ft89puDJZFBA0QaPXpf8SjwSV3UYqIaJNs8xSZ/Wb+kjUpLEMsv05lOGSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174192; c=relaxed/simple;
	bh=Lc5SuoQdq7E5CtZd54KVxsEu7eg9aneTEUyZf92eDcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqz6UPbPK6069e6ZdjYDviRdadcXNuL8XAonapn9OElZq/5+ZZpE9lUnGqSR37HYLFhCVeIuX9jfqq57SDfCVuPQ2LCyMr42ve1OBevsEuGnpgA/C1VE7xdo1nLyHr9f9djrlqpZIAliiX2cqKYummZoyt1615cTrDh93ce0HGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/wdYHWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/wdYHWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD0F1F000FF;
	Wed, 23 Sep 2026 14:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174191;
	bh=YDJ7lybnl4XPDAiM+0DwhS8w8wTZvzW7R6ZChiZ6bcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/wdYHWtfDaYlMrYuYxD7YHUQkGapOU9UZh35A5LcoqoODDsYBKeWAmTH6AtfDe6x
	 3svTXgnpUDSkaZUSZ3Zgac1rHEhy6K0618+pX00LwKH+qhWCnoTtmzqlY3J+YjoSuZ
	 dvXRbTe7F64Qi4NByzIkF0GYMw9cqw/eGNvF4V5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/398] xfrm: fix compat ALLOCSPI request use-after-free
Date: Wed, 23 Sep 2026 16:01:34 +0200
Message-ID: <20260923140643.959564187@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 4e80e1b5ef4b4..2560f3653bd38 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1830,7 +1830,6 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_state *x;
 	struct xfrm_userspi_info *p;
-	struct xfrm_translator *xtr;
 	struct sk_buff *resp_skb;
 	xfrm_address_t *daddr;
 	int family;
@@ -1896,17 +1895,6 @@ static int xfrm_alloc_userspi(struct sk_buff *skb, struct nlmsghdr *nlh,
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



