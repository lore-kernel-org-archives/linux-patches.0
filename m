Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037507;
	b=cjOWc5Qy9mnSvKFaEgRRlFaRGn2/L7o/kN3KtbfKlXqf+aVTMoHBPBUEOWawAfdgtlgM
	 T19d50Q0QraDDd55K0OYkoxJrfRfOn/g2mxkqc/KY9Ssn85cicH9Db7LSR3grxZLvAcJu
	 jwFRnziTLV00GLi5NgEc4P9FJ+9Ch5KcrAGhGZgnRYwgxZCTyIxSccQx1jqn3RPcf6k5h
	 rO4Qs52QzDhX0LAgqpyXeOFy7+iGJM8+32ctAYuoC1eynXntpHJb1QIRc8U1k1ziVNesw
	 kIMKU59cQw3DAOhuKQV8aR21bNQvGtTsU9jeyBKCfhoSlnRqJnjo2qA9g6I8rakocCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xUVEBRdphjMVrmDNNZpazux7+i/C/RD/MBpHs11yUvg=;
	b=cLiR7qSFeLEOlMmeA/mJsCLbMbW+jSsBpgB/CrxSufHAoo6Kq/qARRe4uoQyFEfawx/9
	 ymqVRbGLPvj2PQGnLqLyw8rA05MWTqtU/XhMoIAwXTa9uOzvikBChDVWVQWc9/JrNvbn4
	 5aUDEkJ4dq3Zx9RkgUvtY3M3F8ExZrl0Ov/LiU5N7V2qwdynwzfDO9YFoQzUMz1B1iZsJ
	 58qjJWaHmgSQ/IfXL2OqIchk2DBMscwKdgDfsfkXgJ1SHAbnJ6bjhmne7R70FqofI2MsX
	 aSWpvT2ucIMdqHP3g7XNaSTGzh429DHjAdZac2neVWUnQ4bs7bAApf5BMNo8bQFONSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ScREDKCZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B73606A333;
	Wed, 18 Nov 2026 21:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ScREDKCZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C401F000C5;
	Wed, 18 Nov 2026 21:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037507;
	bh=xUVEBRdphjMVrmDNNZpazux7+i/C/RD/MBpHs11yUvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ScREDKCZ4fVNZzD9lHemP4+p4lUVtpZW9BBlY3mERO1O2IXjZ5uGBNn31jLlSilnT
	 dYDd3vSNB+1HroInCj559xtL8CUCWY72cmgRgk1rwzwe4FpVJAapJsH8U2NNAFPgmS
	 h8dzX7D+ighSoxHGr9R5TpRkk2XtoRUkFZq3q7vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Qiuyue <n0ps1edzz@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1419/3318] ipv6: raw: fix use-after-free in rawv6_send_hdrinc()
Date: Wed, 18 Nov 2026 15:34:01 +0100
Message-ID: <20261118150403.267250129@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 95d7dd7a4d048..847c18e0a7207 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -646,6 +646,9 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
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



