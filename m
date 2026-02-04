Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606AF35029F;
	Wed,  4 Feb 2026 14:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217147; cv=none; b=ox7mXNfIP5M85DLRDYTVcEy6plrzg4MUJ4qzGo7qAi9ZAkjvmUV5vTFHKKjazLh6VJ4jJAOq0TjaYEH9SFTWZ8fxyOahjR6/uTQ0VNZo4mKiLIBdx2YTr2rW/KrrmhqM4cU0otGIzfuy3Iv7325JNPRIoU9l8C4TU3KqqNTr6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217147; c=relaxed/simple;
	bh=rZWSHZbQqSWw+25zwR1Y+U4SRNfks3+4AwsNzqGTnWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw28Ik8cxt63ZksjGyii6pXV800QqzHyK0JyQZAE1pDlyAf6eXeLhdMKIr+fjxXjZYN3R0m/i+6uMovIywk0c5fzhdXVcvrQ5ShPWUOsO341EUrv1r2v0719Avhj0X0bxhvwRHvqXtNdL10zZAXDwneGs+giD5/RGt5yWQIDTQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOGDeGtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOGDeGtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95248C4CEF7;
	Wed,  4 Feb 2026 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217147;
	bh=rZWSHZbQqSWw+25zwR1Y+U4SRNfks3+4AwsNzqGTnWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOGDeGttNMAIubnBS0Exqz1npjebhzRmZo4GRE4OhR+Qdm3qTWcQJJD87SVKNvPPn
	 BxvndgQmm30MBdxQDPNMdIcTbkZ4dUnrVs0PfBXBFmUxvifP7bWx3LlIsXnYSWEB6Q
	 gMci1D7aOqa3rZSA8d54xa0FfnA9ZOQ1Kwui9fC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/206] ipv6: use the right ifindex when replying to icmpv6 from localhost
Date: Wed,  4 Feb 2026 15:39:29 +0100
Message-ID: <20260204143903.176534455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 71a69166a6bd2..8601c76f3cc93 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -761,7 +761,9 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
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



