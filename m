Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060145;
	b=vZdbdshU8s7GmFR7KGiv3b8mWjAJ2akXyi2XP+6swiFo7hplpbAB4FoHHhmbta9Mpe94
	 H338M9ywxyTzmbbd0hqg6H+ahEwYrd+lpw9OCSxAp0j56vINlBnLHi+8KKw4zdMP0oBVE
	 taLLoN1IsiUhZN7TvslQRN6b8j38pazVn3Hz0JZuGndFxntGQNF7RluP4B9XdYoFyNkod
	 NERn7eLoWKxdXP1BQmzapd1OawqALNj0GDpuGS5HGVFbuFIZ2KBVfdZrDNczXHvl5jMSS
	 DRJ7UKHpsf8c0W+bxdd5SIF5Nbp0Q92X/WsUZoD1VU/3kAw1AbArzieP1n+VieEUQqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5a/nvtNsHqTnLowbewYL2/jG1EdcP9lAkk8FQoFaJTY=;
	b=QLDaMKi/KKMxJF0pDnZaXZPiRF6dEl+KG2uVkbccKBFjPdOTJSG5RjrCvxbj9IGpQuXH
	 cH9Zi4t3ZJrZEtyt85QDtQUZkq5UIVZsQDBACKPQ08BCBgh3Wr9zMZha04bkYLVnpWNhW
	 KMOphoGIOgR2vQoccRvMadH57/6B79xUxifGk3jCb5X9lD8BgHX0YQZqdZb3w5WJ3EHtS
	 HSQ1wYX+hdZD1BIXYMqs/LMOcuQjfWuLGH9RykU/eu3ZZRsc1x5B3OPZS44nSUiI/vyWT
	 d7m3Y0QCogpGFpdJpl8l0X8RdPFQImfTAPldIdAlzYngb5Jq3LujGFB2F2z/kRP1MsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzREXQIg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEAF606A320;
	Thu, 19 Nov 2026 03:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TzREXQIg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221E91F000C4;
	Thu, 19 Nov 2026 03:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060144;
	bh=5a/nvtNsHqTnLowbewYL2/jG1EdcP9lAkk8FQoFaJTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TzREXQIgUoCjCHN3/AIlmitp2DYXwscyjQ/utQxcmkw7iyF4Fb2iTfHUjv/zh8iKn
	 yAhR/mfrXc85XfU0zD6ND/R1NAu/2I7IhhRloy5LppfGgTRrIEcZgveQpJNrMBMISg
	 iufE4PZ/MhMo0bZrHyQXKCp7dsMMtwwxkzQVM1gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Qiuyue <n0ps1edzz@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1093/1848] ipv6: raw: fix use-after-free in rawv6_send_hdrinc()
Date: Wed, 18 Nov 2026 15:52:11 +0100
Message-ID: <20261118150004.581786800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Zhou Qiuyue <n0ps1edzz@gmail.com>

[ Upstream commit 66dfb2cacda7faae614d688943d85e75abf7f586 ]

rawv6_send_hdrinc() caches the route before handing the skb to
l3mdev_ip6_out(). The VRF output path may replace skb->dst and release
the original route, leaving the cached pointer stale.

The function later dereferences that pointer for statistics accounting
and as the output device passed to NF_HOOK(). Its RCU read-side critical
section starts after l3mdev_ip6_out(), so it cannot prevent the old route
from being reclaimed in between.

Reload the route from the current skb destination after
l3mdev_ip6_out() returns.

KASAN reports a slab-use-after-free in rawv6_sendmsg(), with the route
allocated by ip6_dst_alloc(), freed by dst_destroy() from rcu_core(), and
the related RCU callback queued from vrf_l3_out().

Fixes: 4c1feac58e06 ("net: vrf: Flip IPv6 output path from FIB lookup hook to out hook")
Cc: stable@vger.kernel.org
Signed-off-by: Zhou Qiuyue <n0ps1edzz@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
[ sashal: Replaced the unavailable dst_rt6_info() helper with a direct cast to struct rt6_info *. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6ec51b1a4e26b..e24e49cdf141c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -650,6 +650,9 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 	if (unlikely(!skb))
 		return 0;
 
+	/* l3mdev_ip6_out() may have replaced the skb dst. */
+	rt = (struct rt6_info *)skb_dst(skb);
+
 	/* Acquire rcu_read_lock() in case we need to use rt->rt6i_idev
 	 * in the error path. Since skb has been freed, the dst could
 	 * have been queued for deletion.
-- 
2.53.0



