Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590214;
	b=upoM/+MNlZYahT8nX8Xb8QDB0cp5TJyxB8qUrUE7KAmxUrG0z7wqtfGinQGyHkwG0kPi
	 KKZUc3UB3dLDsZo8/5Ij/pOSH41av3icIF+EKsbzmFGz0jnwKk+nbzRRlF6b8Qm+YqBW4
	 mnhQzWyb0Cb17vNPC67pfCg/uMkCForQEZbKM34vwgsb8fvA3kM/5D3Z1Ype9ILqzV3hq
	 +Hnl1m4ka7w6SdJOM6g/KMX4nH5OSkvBSMrFGM2cuF/+8UnnnhAoozLQ0OJ+xI2Ol30Qi
	 mgSTp+zy5m05GTZ+y0TN/eUef41ICLlXiiQDwKSmMd5z3QH+WazGspc0Ol50+/fZUMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590214;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s/+PJVj7LR9QhqWkcl/Fs7C3bXoShrKT4F9ETRgPS6U=;
	b=ln9d2uekftG1yytuzm1UVwaJBY24ikOgYaQNch3aC9Kn5/12ovsTiDDMTuOjBsNp9sBi
	 viDuGpzvBZDHnHbpvKdDWIv9pKMWMicQBiiJIjUw4Ky3VzyUNvI/5PgKe+U1fqBCIUDyq
	 Ko79Lwc6gz3wAVGZSJ7VGN4bmkuCXpbgxb3QZ4MsJsbAaNehPEDxbJIsPJ5frcMx62CDL
	 mcQ+r30Egt5rReI40feb9svpWtjKe/437VyCOA8fmcp85r/qp9FSoWlt2K7fbxi5jf9w7
	 nbzoMeIg2p4rPs6lLyQm5byN2YtnVgDZ1yE0ZscbNkUAentdNeF4nAbKOMmPjkqZHlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HphcVlKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63AC606BD2A;
	Fri, 13 Nov 2026 17:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HphcVlKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545041F000C5;
	Fri, 13 Nov 2026 17:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590214;
	bh=s/+PJVj7LR9QhqWkcl/Fs7C3bXoShrKT4F9ETRgPS6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HphcVlKY6BDlWt/nahnk4zrl/zwqaz4kCK1JWz0GvKnduSV0eDcXTWmkdeaai/Se8
	 dkWtvSEvr6cEh44x2LDlTFzCvcdZp48dOEKuEcXVG6CYLEGJlDUg2p23B5fuHq0ylp
	 xdLDTkAPGQv6KCV52H/8ZkQrZISOlWwWo4+TA97w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Qiuyue <n0ps1edzz@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 216/686] ipv6: raw: fix use-after-free in rawv6_send_hdrinc()
Date: Fri, 13 Nov 2026 10:45:49 -0500
Message-ID: <20261113153828.352385895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b796d84db5ce2..5ecbb9c775be0 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -653,6 +653,9 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
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



