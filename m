Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E983D19EEB6;
	Thu, 15 Aug 2024 13:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728762; cv=none; b=Ai7eedn7fcfOZb6WTGQNEqinOTQ0S2D8Yj1Q4ny2MZSTaoIiqJNDjltYXeLCELeMUwyk4vLWO1EjfbzH43iXW/9roSkYfeC+3Txp/sk0znpd2Cf0XOQ9TCNzYiymHQthWN15Wen9VnZza1TYQ1jEtgyUtUCBRMgGXiwmWa963Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728762; c=relaxed/simple;
	bh=mUneDBEx7VIv7iC10PG0dgoGen4LHj3ncw/PBMdObYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYYMfWG/bVFNQADtkV+XlUQD5pr21Ryo6fGKCHBe6UcIPv6mOP3TlzOgVUSsbtbQo01vSphuoPQ+jVQIemOzH+rbYEu47VjvyxDnliA4nDja3FDVXr1vemwnDcPajMUv1u9RGqDo1BzQzqgDjZOnYgw3Gq0dZ5ooLVxvHZ7skXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJmmBp/s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJmmBp/s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DAAC32786;
	Thu, 15 Aug 2024 13:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728761;
	bh=mUneDBEx7VIv7iC10PG0dgoGen4LHj3ncw/PBMdObYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJmmBp/sv44La2C8JReXQV84+YxNGcuRzKcxk2bHnIcGiGDP14vpTgDqFwhvrh3wI
	 bzYbPNw2NmKK/0XQU4WNRvjlrGsRu8un+yLePPoeiB62RFUmaBK2GIg0gwkb+UinTy
	 8zsOnKfzW4gzUF1jaPxR6QeT1+CwkAhBF/jlvJh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	David Ahern <dsahern@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 101/196] net: ip_rt_get_source() - use new style struct initializer instead of memset
Date: Thu, 15 Aug 2024 15:23:38 +0200
Message-ID: <20240815131855.947694068@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Żenczykowski <maze@google.com>

[ Upstream commit e351bb6227fbe2bb5da6f38a4cf5bd18810b0557 ]

(allows for better compiler optimization)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: cc73bbab4b1f ("ipv4: Fix incorrect source address in Record Route option")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 3c5401dafdeed..1aac0d77a3aa1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1273,18 +1273,15 @@ void ip_rt_get_source(u8 *addr, struct sk_buff *skb, struct rtable *rt)
 		src = ip_hdr(skb)->saddr;
 	else {
 		struct fib_result res;
-		struct flowi4 fl4;
-		struct iphdr *iph;
-
-		iph = ip_hdr(skb);
-
-		memset(&fl4, 0, sizeof(fl4));
-		fl4.daddr = iph->daddr;
-		fl4.saddr = iph->saddr;
-		fl4.flowi4_tos = RT_TOS(iph->tos);
-		fl4.flowi4_oif = rt->dst.dev->ifindex;
-		fl4.flowi4_iif = skb->dev->ifindex;
-		fl4.flowi4_mark = skb->mark;
+		struct iphdr *iph = ip_hdr(skb);
+		struct flowi4 fl4 = {
+			.daddr = iph->daddr,
+			.saddr = iph->saddr,
+			.flowi4_tos = RT_TOS(iph->tos),
+			.flowi4_oif = rt->dst.dev->ifindex,
+			.flowi4_iif = skb->dev->ifindex,
+			.flowi4_mark = skb->mark,
+		};
 
 		rcu_read_lock();
 		if (fib_lookup(dev_net(rt->dst.dev), &fl4, &res, 0) == 0)
-- 
2.43.0



