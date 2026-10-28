Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209344;
	b=cDtBb/pzlz3cxrvWWTk4KvasGaQu3fqVcZNteDTHqlUAgjAYylzj+WSfFIuKnH+AvyrN
	 yIQVjfWOXEo8/nsG2KtPPG0Yl4L+ieBtuh6tR9fm21OjvFdZ7y8n19DyWKlaOnYtR8+RD
	 b/YzMDTyfNAY7neD84vIVs64aPhzbTwSGNtYNBZbzHWFNMuevddJ/80RnY+b9ace9T+ON
	 I4vlivj8GFiZYd6shgNg4s0dsWyC+9ZtRqUm9PYYkiuQ5oUqxYGkmCBEAnbVPQbMn8Pqh
	 OCCqSZ2ESgK86v3yF6MFMepF4XBN9cM6cw5snxXxozMOE/bQjrx7OYwOG906Hg3eIvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d9Q4E/LYYiwLZmQ0DnfIUs42bgrxNvp9QIZRjfRooaw=;
	b=L6a63FnOR+TqNIbBr42HIDiWoooTfq5lB5JaFrXc+T8yd8EPGfCbx/JQWqEDUuI+19K1
	 bnhu4Szggg0SCAJ3s3wUUTJIyTVQV0R5zSIzlv65T5fn9m4ZLYkuGchuLY2FhaKtif99y
	 3sR3Ok73JjpVqRQQNbUYB+Y3nDgX0IfLg++a9m7CYRtXFthCxeC3/Fb3q+toJZpVUmHQO
	 xPg4untxthJyopBtmuqHVCLtL+fUWX06BkmSBGBBdQrZZhCXWlvuujUAVadBOYOaRT7Ig
	 EBPHcOAaKX3FJYD9ZXvk5+rZ8P0bXgrA33kB1sbaUeaydYf4ixODH+HFICUjY4HzUog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZXowHvv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F46F606A31A;
	Wed, 28 Oct 2026 17:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZXowHvv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7781F01825;
	Wed, 28 Oct 2026 17:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209343;
	bh=d9Q4E/LYYiwLZmQ0DnfIUs42bgrxNvp9QIZRjfRooaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZXowHvvbiURDxars/j5/DcdLSIGYYQqC9RdspCp/wC3LD6iY5FH0uXvtEJBncroN
	 SD8vSmESF1aXi1AJwP/sf4em1g6o1Ty/Y/IXqs5HkWUJxG1bCcxlbo8OZSVpl24AAn
	 ByrMFK9Dwl/EtUThD0yC4g8hJ6BuiMpTh6nR4qbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/516] netlink: reset skb headers before unicast and multicast filtering
Date: Wed, 28 Oct 2026 17:59:50 +0100
Message-ID: <20261028170013.860273112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 8bf659bd54e1f00e34cf5244b1d289c506fa47c0 ]

Socket filters can use SKF_NET_OFF and SKF_LL_OFF to read relative to
an skb's network and MAC headers. Netlink producers may reserve
headroom without resetting those headers, allowing a receiving socket's
filter to read data before the initialized message.

For example, IWPM HELLO replies are allocated with dev_alloc_skb(),
which reserves NET_SKB_PAD bytes. An unprivileged NETLINK_RDMA user can
attach a classic socket filter and disclose this headroom through the
length of the delivered reply. The resets in netlink_dump() do not help
because IWPM sends a separately allocated skb through netlink_unicast().

Reset both headers before running the receiver's filter in unicast and
broadcast delivery, as is already done for dump skbs. This also covers
other netlink producers that reserve headroom without changing their
allocation or message-building code.

Fixes: b1153f29ee07 ("netlink: make socket filters work on netlink")
Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261006224232.50724-1-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 9f9b28b329b32..291f7eabd37c4 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1339,6 +1339,8 @@ int netlink_unicast(struct sock *ssk, struct sk_buff *skb,
 	if (netlink_is_kernel(sk))
 		return netlink_unicast_kernel(sk, skb, ssk);
 
+	skb_reset_network_header(skb);
+	skb_reset_mac_header(skb);
 	if (sk_filter(sk, skb)) {
 		err = skb->len;
 		kfree_skb(skb);
@@ -1475,6 +1477,8 @@ static void do_one_broadcast(struct sock *sk,
 		goto out;
 	}
 
+	skb_reset_network_header(p->skb2);
+	skb_reset_mac_header(p->skb2);
 	if (sk_filter(sk, p->skb2)) {
 		kfree_skb(p->skb2);
 		p->skb2 = NULL;
-- 
2.53.0



