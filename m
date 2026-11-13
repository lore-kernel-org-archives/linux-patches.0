Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585429;
	b=XIHYBtObfVjIJBFKxtfLDuAlrMhr0sjJV8aKH5jRQpWwfX7hSeAnRrKstWWkQiNKJZFY
	 m3y4gSI7RMo/Pc22RdK2r5FlYjKumiOGVHRSJ8PiaxOSi7mj18mQj/MEMsbV293TeG7JK
	 nT8k0MbAvNfmch/+wLsWEoV09g5NRmXsou9LJT0TM9RzgP3IK0PdBX6pcFg6Ttfspa8nN
	 2AJVXKr1Dc9bKlM+YBoOLADQ+iZoE0b8lk7Esv6F7yadbb5WTF5E4W+ChCL3URHG/HZl/
	 DU/XIlOIbKBqOlzz076SFT2uf3YWgdV/fkJ21zcAxsCL8lNG03agN257jx1EwlrMjLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NIMOP0D3ufWVHTckAtuiUBgDavaSkuwm5+r7jwCWVkI=;
	b=zU3TjWerbmYW8KbCWcEaDUM1GBA3GOfWdNlZYAdiNBVjtV63SGgIIe2WSreleBnpWBPf
	 iqOyB1hQ9ObfMRYlD8SJOygEEBQiquVcjOIacFYt13FowKLv9wA8H1QVBdKfOCmHxLnBh
	 9x8WPBDNDYUaRZ5JAbFh7MrWXh6e9ZEem7PuJxuaDDTmOZPohXz8tQlr1Fb4ztOLjiV6G
	 0A1S19j+1Js7mhiKomLMWMpj8Con0ZrgrGOaFHWw/h3bBNRTLzIA9sgQeZg8YT/VW/cIv
	 JMBlmVIxtpilmbLLv/bEYda85lV2uR4/6oNY38DOMZ1QoVAMbzwtW1zvcsifJOunCDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owiW9KpL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC6560A3839;
	Fri, 13 Nov 2026 15:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owiW9KpL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2F81F000C5;
	Fri, 13 Nov 2026 15:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585428;
	bh=NIMOP0D3ufWVHTckAtuiUBgDavaSkuwm5+r7jwCWVkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owiW9KpLj2CN4py83UmuhdT4RmbqDtRaqfedYptRIkaHgyIQta5gm3LDPYs8yiVb6
	 hvL2FFUH0jeVz6WBVb2BCwb9bZy3dN49ioroO25W6POXuOk/AdK7Es5LcAesfFBELW
	 XQL9L9AWw43BU71tqF8ObaXzLFGZ9sWIKtV2RPvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhou Qiuyue <n0ps1edzz@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 090/507] ipv6: raw: fix use-after-free in rawv6_send_hdrinc()
Date: Fri, 13 Nov 2026 10:46:34 -0500
Message-ID: <20261113153757.065217743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b965258cf9e5f..bdea825434ea7 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -654,6 +654,9 @@ static int rawv6_send_hdrinc(struct sock *sk, struct msghdr *msg, int length,
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



