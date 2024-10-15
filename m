Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72B91C07C4;
	Tue, 15 Oct 2024 12:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997092; cv=none; b=CTQu5GBICgzv5m5oeN9WNtMSYyL29igZjq37S5NW9D8tNbndIupLoUJryF/92IOl/C4mazjP6dedbBjQN/r1uWyJ25dv/y8A/yWKGJxWGNeW93drXJbYGMFKgpqPbTrZQRYyu+oZidoYzgUcHY6eFifYtbnjxIVlUWDVB4Mq8OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997092; c=relaxed/simple;
	bh=vCOMhehN2ntKCcdWGdWKC0gIigGzv3Aw578bo23x8Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXBLMpd5xX5xwFkG8cbXl0iTuT09khz+4SnD5BzX0k1pdQAUJrH+6R363IL3WzxKKEQ4vhSh5keWmCitacFI9FIXqlt+tsSl0v0xOG/NTwcMKDdNT5d3Qj8bipz7HdvxmuzGfai0LGj4fm9BPymoWQaTcoRgXPm3PgRwFmULLHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yU5fbTri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yU5fbTri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272D4C4CEC6;
	Tue, 15 Oct 2024 12:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997092;
	bh=vCOMhehN2ntKCcdWGdWKC0gIigGzv3Aw578bo23x8Hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yU5fbTri1ACDgxwmnH9q2RNZe8Jgo/Oq2KvC7gh3OQLSyKZOeVCt/YS2SOrccUliX
	 5gGnKNOqQKAq5P0XyepVw5KeZQdqIQzLQtUvzo1oWCnWB4qe0iv9BIKftRzsoo81z5
	 mpUFgx7vU65z1uDaEHJKqACtLrymo5io3HHbcXUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/518] bareudp: Pull inner IP header on xmit.
Date: Tue, 15 Oct 2024 14:39:49 +0200
Message-ID: <20241015123920.286487768@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit c471236b2359e6b27388475dd04fff0a5e2bf922 ]

Both bareudp_xmit_skb() and bareudp6_xmit_skb() read their skb's inner
IP header to get its ECN value (with ip_tunnel_ecn_encap()). Therefore
we need to ensure that the inner IP header is part of the skb's linear
data.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/267328222f0a11519c6de04c640a4f87a38ea9ed.1726046181.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 8efd61bdee997..826f912ea820d 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -311,6 +311,9 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be32 saddr;
 	int err;
 
+	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+		return -EINVAL;
+
 	if (!sock)
 		return -ESHUTDOWN;
 
@@ -374,6 +377,9 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	__be16 sport;
 	int err;
 
+	if (!skb_vlan_inet_prepare(skb, skb->protocol != htons(ETH_P_TEB)))
+		return -EINVAL;
+
 	if (!sock)
 		return -ESHUTDOWN;
 
-- 
2.43.0



