Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D396417C;
	Sun,  1 Sep 2024 17:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210307; cv=none; b=fL1YD2iq1ryTYm68aFNttnRSyBXwfkRrTSE0uz436YMZAi6R8hCq8dbmNZbIwNme/Bw2FGY+avSBNHGeGRT3qBHbVIZ+Y6BH87JQqlCfuhnkL0QGKMSS93xPpBSKvX6vppE/L+94DllKsgag49bxotAj9unxtLjN5h/XUDKOAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210307; c=relaxed/simple;
	bh=q+Jn4kt/Y+xarmPPd/IYriP1bn8+GUJFPpsjUZ1OvGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKYcPU97pMMI2Jplq8yAu4WqUluVFDREVvaQej3edzx+P0QlTJHj2B4xbJFlKu8nud1vumhfCQGJEk5DO4I+6i2LX4kj4eaJR8VbsCsHlYbEuEPsxeUJ1gJAs7UQlVxbOM7uGNUGVOeXhY2gUoAUJWcE9kf+51OyJZiuGjvX2PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlPctkHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlPctkHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DA6C4CEC3;
	Sun,  1 Sep 2024 17:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210307;
	bh=q+Jn4kt/Y+xarmPPd/IYriP1bn8+GUJFPpsjUZ1OvGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlPctkHpNTgy3NSxhfk35aw/tbJUh7D0PqzN2pNUNkbX1+8v5mZnzkMOmzf64j0Np
	 MMgm3/zPdeDrEY00Rs56XVZzZuJVpVkFTdSjqo5cECKUbGEa9LCOx6kMrWNec4rgvn
	 sN6B1V90/5k1rqY4vZ8Lp7D/NEwohwDnvoEnt/mc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 151/215] ipv6: prevent possible UAF in ip6_xmit()
Date: Sun,  1 Sep 2024 18:17:43 +0200
Message-ID: <20240901160829.072755510@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2d5ff7e339d04622d8282661df36151906d0e1c7 ]

If skb_expand_head() returns NULL, skb has been freed
and the associated dst/idev could also have been freed.

We must use rcu_read_lock() to prevent a possible UAF.

Fixes: 0c9f227bee11 ("ipv6: use skb_expand_head in ip6_xmit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8054a4a2f2a5e..b37121f872bc9 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -273,11 +273,15 @@ int ip6_xmit(const struct sock *sk, struct sk_buff *skb, struct flowi6 *fl6,
 		head_room += opt->opt_nflen + opt->opt_flen;
 
 	if (unlikely(head_room > skb_headroom(skb))) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, head_room);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOBUFS;
 		}
+		rcu_read_unlock();
 	}
 
 	if (opt) {
-- 
2.43.0



