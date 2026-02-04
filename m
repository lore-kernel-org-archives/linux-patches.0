Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5524218AB;
	Wed,  4 Feb 2026 15:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218615; cv=none; b=OHTU+ZrpnggoP7pyAgXZcdj3NKHNAX+URSomRlR85wxWY/ZMA57SZmUZdM6j7Fu7MjXCq0JBO8YwJY6NuS9iufmyPnUEIK8XxRH1U7fkkNbKpd82cEBL27XMK8PbwOWJzOCEDgul8W9Z7RfefK9OLF+IiqFA5gnlFuZN5LjFqMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218615; c=relaxed/simple;
	bh=s9uDNbDp1JFkvaIFp9rXqirWqcXb21X4YPM7DNgCl2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRdgrsdoHKGN2sgT8YQLOodsnvPGhGtoXSaS/k/aU/PxEKLmqyZW3pFxvNu9iAb7vg8WMSRbvXz7jMtbMqgcDPZpaJD01wg5T5MUtUROCJWQN6QcuUfsrrQELN6Lhbw0ob1FvzviU/yx+fMlpt0N11dhfFejavd5hPX2SyDgXSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JymdOBIf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JymdOBIf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4544FC4CEF7;
	Wed,  4 Feb 2026 15:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218615;
	bh=s9uDNbDp1JFkvaIFp9rXqirWqcXb21X4YPM7DNgCl2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JymdOBIfLd9eTuw7AR1vUmckYlx18ZlaeK0LYBZwyvkG12uEm3rR8o1aosA3PaAEH
	 SR9hoZtjSq25YIRT9RNfVUk1cLaGW2dqQgBDXvO+ZJKUILhnUaltKJcdWm+JaBiLGd
	 ZeSLTozi8NhTh/fiy5+VR+NU6pXBXH/LTiI4ACs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 10/87] ipv6: use the right ifindex when replying to icmpv6 from localhost
Date: Wed,  4 Feb 2026 15:40:08 +0100
Message-ID: <20260204143847.283911905@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 03cbcdf93866e61beb0063392e6dbb701f03aea2 ]

When replying to a ICMPv6 echo request that comes from localhost address
the right output ifindex is 1 (lo) and not rt6i_idev dev index. Use the
skb device ifindex instead. This fixes pinging to a local address from
localhost source address.

$ ping6 -I ::1 2001:1:1::2 -c 3
PING 2001:1:1::2 (2001:1:1::2) from ::1 : 56 data bytes
64 bytes from 2001:1:1::2: icmp_seq=1 ttl=64 time=0.037 ms
64 bytes from 2001:1:1::2: icmp_seq=2 ttl=64 time=0.069 ms
64 bytes from 2001:1:1::2: icmp_seq=3 ttl=64 time=0.122 ms

2001:1:1::2 ping statistics
3 packets transmitted, 3 received, 0% packet loss, time 2032ms
rtt min/avg/max/mdev = 0.037/0.076/0.122/0.035 ms

Fixes: 1b70d792cf67 ("ipv6: Use rt6i_idev index for echo replies to a local address")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260121194409.6749-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 8117c17845967..13a796bfc2f93 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -770,7 +770,9 @@ static enum skb_drop_reason icmpv6_echo_reply(struct sk_buff *skb)
 	fl6.daddr = ipv6_hdr(skb)->saddr;
 	if (saddr)
 		fl6.saddr = *saddr;
-	fl6.flowi6_oif = icmp6_iif(skb);
+	fl6.flowi6_oif = ipv6_addr_loopback(&fl6.daddr) ?
+			 skb->dev->ifindex :
+			 icmp6_iif(skb);
 	fl6.fl6_icmp_type = type;
 	fl6.flowi6_mark = mark;
 	fl6.flowi6_uid = sock_net_uid(net, NULL);
-- 
2.51.0



