Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046345;
	b=hMjXFeHEcmQ6ahi9DbdcGFFPwCEt5/R+zdRtY4SVia7mCRbtimzpLZaZmlBkvVQ1WPCF
	 z8nf2558JK0QbfJRhDs9YzZM+bCMSUVpVkpTeOttvWMMt5qgLZaWp0Lc/hUuEvTMWX5sW
	 e2lUQ4eegrahD6wLf7YFh0LAn2X8XuOqZfJ7JZXwULdLG24S8AIp8iQDK5Hr18DH6pwqO
	 wK1/FDZrX3W1W8Erz6SiUuOnJNijOKNXBTB1c2s3QMMgvGQ2fMYBC4fAWXIsqnWnYlDul
	 bbIDLR4WzPK4LP+9eY9wq7X2utEYPgzQQy+fCHBRKZ9eb05z4GtUQQ6K85/iFxhRW8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=44hZ3EXdw+a8rfgnOc6s/H1oHxO53sr//hHt50beLlw=;
	b=ydYEkQ4MBy4ZP+wvf9xgtyxLTKuNCwYCYp9/OAeRuTLbXW2jFwNLd6VbywA28O0DQ+E0
	 IVBmLrQkTUyN2jJ4wXm8L8zwJHs8bZYhagk49QTpwpv8tsWdciI++k/Ui9gaMtuFLs5td
	 d2xYFd9KUExDQj5TNDrAi/htmhii07+ILNXP0UxxbzpOzPRbipKiqIiUIogIFL7zsb3g0
	 yvXHGzR9w4ekf2MaMdjptIdwTK/daxAmaZv8owTH+YWZXHChWX4s6XOhUBkhhr7qtz3MV
	 vOQbTZs7NHONDD/7OTQnWX+eKAeyZ9g3rG8pisIhmFGBm2K3TUrl3q+L7diN7Uk79Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QXDGJR4K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76AAF606A31C;
	Wed, 18 Nov 2026 23:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QXDGJR4K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B891F000C4;
	Wed, 18 Nov 2026 23:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046345;
	bh=44hZ3EXdw+a8rfgnOc6s/H1oHxO53sr//hHt50beLlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXDGJR4KUwBXZfbUYofV6vbNz0qLCzAdz0gjgDapv6BAQsIDJfMwqKqsxyOFjQ+eC
	 rzYHi4vClHGYRzlddIraRiNnRIaGQ76MBYcJPmy5uJ1KWYyaC9eXFBfWsXLiRdZxiJ
	 TB+S7wq60foxmnofQwixMvkiycV5yL+telyNEPAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Qiuyue <n0ps1edzz@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1207/2857] ipv6: raw: fix use-after-free in rawv6_send_hdrinc()
Date: Wed, 18 Nov 2026 15:37:21 +0100
Message-ID: <20261118150245.056551356@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7b17f1b2a6128..0430115bb26a4 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -645,6 +645,9 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
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



