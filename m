Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054500;
	b=pMQ2XVTUZya8SHqePcrp7VhujsZ/uOqet44a1UBGqFr8i7DkHLR6U7DmWpe9NulF+T8T
	 dqoC8cmWPdX6Xi54MHrJiMFZcYwD57XmYnePkyc1SGGFUfLAQsCimqgQHgHnVBL9jbAUW
	 6mGDvZzROs7oM3VV80RsZZmZUlVdCgFxnurqfRU4yfgEDDzUnicoSlXws6RxfIEUE2m0v
	 fYLI5ibATKHmbDY78P3VVcP1jBSrIpAOtEY5rz3N4tKJtWnQOom7sP+zS8nQ7ULCJbxgp
	 TqAOzr4WBCuCmJM/iMMr+QxA2SSy8GAACuA9LFc6EA/GVg0uEwuxYRW2BnglmucVn6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yYLZrhPVByHh7iHY+MIdeaSJLHqZ0c3zIyofl0SUdIs=;
	b=w8uN/AdWtMIjuzcxjuLgOjBTKkWQdeKZcwHIVdcjPOeOFmbRlA8jIC+u23Js+SCNMZkb
	 7MoVVOV1Yds+4dzZqkuCnQVBkLKv2EG7Yo+CtXCabhz7NoTmdBldrEr3WkdbnT5X7CDtU
	 TT3M6PGaIhbSu5OZVgKwYIM7q/2TFHwxZXlK4E4iKRyfZGpi8aAFIqtVCrHrICp0dA6HY
	 Smn0z3NjXqKKFyiO5qRZec1ED/kxaM1Q6zALRcm7DyJeaFYJyuY3YIMN+71xYFmvxQuba
	 buNi+VmFH1z2VioJHgKKkEhs67A+kH8BuY0plVpVnJnx6p+PyLWgPTYjKfFPJlVnOFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DH4cMkY9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F5B606A325;
	Thu, 19 Nov 2026 02:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DH4cMkY9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E0F1F000C5;
	Thu, 19 Nov 2026 02:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054500;
	bh=yYLZrhPVByHh7iHY+MIdeaSJLHqZ0c3zIyofl0SUdIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DH4cMkY9om+TKegm4IKQRbWXHo/yn2BlTOaYtX3/GZ9wBhE6Q05sEcyUI0aVCzDfh
	 NrEJvGZfyBC8J4s/KHhkojgFdvn2E7Vq1k/nEqBG9csmtC3O3/itedG+980DlbL/2b
	 kLl3LeazVmIcartmxyBi3cU0vHyrZjJxJHpg/6Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Qiuyue <n0ps1edzz@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1297/2214] ipv6: raw: fix use-after-free in rawv6_send_hdrinc()
Date: Wed, 18 Nov 2026 15:49:33 +0100
Message-ID: <20261118150103.426254136@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c3719e5ac89fc..2d72f5c5d8381 100644
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



