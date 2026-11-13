Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591097;
	b=3JY69GEFuJG9+nDKL29EFLjqZcoNVrDYqxNThMIylObNGOYIqV6cNgVO2eA+D8E8AQUz
	 v0v0+tzjHyzgjNJ7syembkKHkSJmLvHjYGBkH60jkbPJ48+BIwyOapJcwS1UxpT+esKVr
	 8LE65fR7lt7OlRNKgpzXa8HAvVkBfg8FkgtYx5rL1iXhOap4/YHdN5plw84K1fDLcKmVJ
	 hr21FVdszmeHoR+NX2CC2tCvSsGUACSZX2JB0NiEC+L30UCO9PVcHalV+2+yH1QiznYmU
	 YJS0Q7/Q18OxBFQ2uXTDlVbOU9aYV5b38O64Ru2Il3AAkLZY0DOCUa4X15MtIPmGOHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591097;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sV0i5yYY6PU/QMWbX1w4VM+dQXVK12JCafk8ZLWpQHg=;
	b=ofsB3mbgvIdCBbSClHWwOw+TakzsloYoY3mFMKdXRa+2qO/JeoBWxxGgSyfy7b8nuBn4
	 rsQY1Q0n6NZgB6lG+rPz1nFJ6HWDf+tvJ281lCHXaG3kQI3xzjgwVHmwkRvAPyM1365K2
	 Ys+AVVXhjLwneGOZ4EJgQm01wV1aoQMFs6UNX6JiJLRQS1zrHXNRGGtKa4Xmt9IK7YmZA
	 CuyXdgs0jYRWSvu6BAY/gp4RfE0f8qYIC1X1sJd93fNxJrQTqKvRGnQNPTlEKDvrHgev1
	 kFWlOjILaoVQRtjuGh8iappA+LS1WBD9riPkzTGQr3IA/tAXN1ZeEqlUVt3WWlvgshw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qu6tr/F8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D161607321F;
	Fri, 13 Nov 2026 17:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qu6tr/F8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2971F1F000C4;
	Fri, 13 Nov 2026 17:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591097;
	bh=sV0i5yYY6PU/QMWbX1w4VM+dQXVK12JCafk8ZLWpQHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qu6tr/F8cEmpWZQ6e41YGOJensn9iYGMB9geNffINCpZXvDqLnvy3+jQ3RVeHU5sG
	 H9Mq+ZtPhmI5E3Kvw8ZiNKMm2P1ICF6aNbq3tlMgqtn2Pu2ufca3pXgQpFbAs2z7RD
	 7Y3+CdzLJ2GzUL3kuOjRf4UTPoirTjpLEit925Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Qiuyue <n0ps1edzz@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/670] ipv6: raw: fix use-after-free in rawv6_send_hdrinc()
Date: Fri, 13 Nov 2026 10:46:04 -0500
Message-ID: <20261113153818.750265876@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/raw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index deaaae63bda0a..27bb9443c8848 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -652,6 +652,9 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
 	if (unlikely(!skb))
 		return 0;
 
+	/* l3mdev_ip6_out() may have replaced the skb dst. */
+	rt = dst_rt6_info(skb_dst(skb));
+
 	/* Acquire rcu_read_lock() in case we need to use rt->rt6i_idev
 	 * in the error path. Since skb has been freed, the dst could
 	 * have been queued for deletion.
-- 
2.53.0



