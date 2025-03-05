Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C1014884C;
	Wed,  5 Mar 2025 17:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197580; cv=none; b=imAkel9hS19Pl0NAdqNSN0keWNyWfR+v5qCjP8MQMZM4TAyHdwJaNCbV3cVNISawJtW9ZAzRnTSA13uOK1zWbnAWPEckUtqbFjjtOFDzInW5itOmwVLKRj26sqfoDELx4Ae/qjm/UjsXPYLDKfVZZLR9cbTG7bbEBcka6HfwmDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197580; c=relaxed/simple;
	bh=KTXgqbKmoI1vZpSWGSdW6Tjwew7rqugrDkA4D+12y9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwjmG/q8WaoWGbrqoJA+9BphyCjNzS4eNZqpLahU+pZACFywMiWLPGxiZcSaPU0k6MLM8rP2R0v7tXQHQQFmIiRlTjt1EL6mKhA5LYPZbSWBQJunq7szoOvF9sDOsfQeiBxi6DqoisHHKlkR9Zro2X0e/QX+FllwzZmCwJBNWbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CvZD4fz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CvZD4fz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D30C4CED1;
	Wed,  5 Mar 2025 17:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197580;
	bh=KTXgqbKmoI1vZpSWGSdW6Tjwew7rqugrDkA4D+12y9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvZD4fz8oL4n4F9lFIDAllUO5LJp8cWYFSQZmBZz7NPplS6i+j+PPKcJ5odvNXMAY
	 KHivrcXCYYLaAkMIQonAFPtJmabdOZxlWzmrDXzB1FzdgE7HDtWDleex7bWhLuUOui
	 ImQ/4yo9K4mmhOIxb5cBImaySmbaQRTO0bS7XmrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/142] ipv4: Convert icmp_route_lookup() to dscp_t.
Date: Wed,  5 Mar 2025 18:47:27 +0100
Message-ID: <20250305174501.472606267@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 913c83a610bb7dd8e5952a2b4663e1feec0b5de6 ]

Pass a dscp_t variable to icmp_route_lookup(), instead of a plain u8,
to prevent accidental setting of ECN bits in ->flowi4_tos. Rename that
variable ("tos" -> "dscp") to make the intent clear.

While there, reorganise the function parameters to fill up horizontal
space.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/294fead85c6035bcdc5fcf9a6bb4ce8798c45ba1.1727807926.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 27843ce6ba3d ("ipvlan: ensure network headers are in skb linear part")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index a154339845dd4..855fcef829e2c 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -484,13 +484,11 @@ static struct net_device *icmp_get_route_lookup_dev(struct sk_buff *skb)
 	return route_lookup_dev;
 }
 
-static struct rtable *icmp_route_lookup(struct net *net,
-					struct flowi4 *fl4,
+static struct rtable *icmp_route_lookup(struct net *net, struct flowi4 *fl4,
 					struct sk_buff *skb_in,
-					const struct iphdr *iph,
-					__be32 saddr, u8 tos, u32 mark,
-					int type, int code,
-					struct icmp_bxm *param)
+					const struct iphdr *iph, __be32 saddr,
+					dscp_t dscp, u32 mark, int type,
+					int code, struct icmp_bxm *param)
 {
 	struct net_device *route_lookup_dev;
 	struct rtable *rt, *rt2;
@@ -503,7 +501,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 	fl4->saddr = saddr;
 	fl4->flowi4_mark = mark;
 	fl4->flowi4_uid = sock_net_uid(net, NULL);
-	fl4->flowi4_tos = tos & INET_DSCP_MASK;
+	fl4->flowi4_tos = inet_dscp_to_dsfield(dscp);
 	fl4->flowi4_proto = IPPROTO_ICMP;
 	fl4->fl4_icmp_type = type;
 	fl4->fl4_icmp_code = code;
@@ -551,7 +549,7 @@ static struct rtable *icmp_route_lookup(struct net *net,
 		orefdst = skb_in->_skb_refdst; /* save old refdst */
 		skb_dst_set(skb_in, NULL);
 		err = ip_route_input(skb_in, fl4_dec.daddr, fl4_dec.saddr,
-				     tos, rt2->dst.dev);
+				     inet_dscp_to_dsfield(dscp), rt2->dst.dev);
 
 		dst_release(&rt2->dst);
 		rt2 = skb_rtable(skb_in);
@@ -747,8 +745,9 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 	ipc.opt = &icmp_param.replyopts.opt;
 	ipc.sockc.mark = mark;
 
-	rt = icmp_route_lookup(net, &fl4, skb_in, iph, saddr, tos, mark,
-			       type, code, &icmp_param);
+	rt = icmp_route_lookup(net, &fl4, skb_in, iph, saddr,
+			       inet_dsfield_to_dscp(tos), mark, type, code,
+			       &icmp_param);
 	if (IS_ERR(rt))
 		goto out_unlock;
 
-- 
2.39.5



