Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE6130E42;
	Tue, 23 Jan 2024 00:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969073; cv=none; b=kG4uB8YlfR8r4YZ65RcA6qrnXFq0Sk/IKf7OlCBTQUtD6dC7Br/pVoJD2oJIUfrcerRkPvwM1Ie0hqd1iHhCaRhu4TDMAjuw/s5Xi6wzU8wny0ZOr08mLjG9kFFtezCOQBFxB5y3Zn4ADA79Ez9NHQrojdxkNKzQVhvrBG47WSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969073; c=relaxed/simple;
	bh=rjI43STLYu8TZDfGakDbdOZ7gkWFdprOMdxQeZhFPyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbeXZUj2UTSdtjYKOcQaTmZPh82cjpn96KXc0Lvyxfh0IdC4LsyaUyGCT/sU+3D38kRSb8ePpXb7sjRbZddgk/SUlURjhaK45LZ0BzWp074mAu0icGbxqqFgphVYFrd9xKM2sg+CZ9niTv/MH4y6BiMf01NconKMoSclv1K4s+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOCdZskz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOCdZskz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F4C433F1;
	Tue, 23 Jan 2024 00:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969073;
	bh=rjI43STLYu8TZDfGakDbdOZ7gkWFdprOMdxQeZhFPyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOCdZskzjtxqWVePH04+3oZFa9tlCILu8zlcB+jEmlswQvgnItwOM5XQvcKRz+Ilu
	 StXu2Egpkgmk2+QBLDm15CJEfxlb2eqYLl6NcKqRwg1e3Ag+oAR+ZKBmulBOZE1PZf
	 h3zW/KU2X3iK6hp7WpNre/yJzvdsqyli+OkvMIlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/194] ipvs: avoid stat macros calls from preemptible context
Date: Mon, 22 Jan 2024 15:58:38 -0800
Message-ID: <20240122235727.279497539@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit d6938c1c76c64f42363d0d1f051e1b4641c2ad40 ]

Inside decrement_ttl() upon discovering that the packet ttl has exceeded,
__IP_INC_STATS and __IP6_INC_STATS macros can be called from preemptible
context having the following backtrace:

check_preemption_disabled: 48 callbacks suppressed
BUG: using __this_cpu_add() in preemptible [00000000] code: curl/1177
caller is decrement_ttl+0x217/0x830
CPU: 5 PID: 1177 Comm: curl Not tainted 6.7.0+ #34
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xbd/0xe0
 check_preemption_disabled+0xd1/0xe0
 decrement_ttl+0x217/0x830
 __ip_vs_get_out_rt+0x4e0/0x1ef0
 ip_vs_nat_xmit+0x205/0xcd0
 ip_vs_in_hook+0x9b1/0x26a0
 nf_hook_slow+0xc2/0x210
 nf_hook+0x1fb/0x770
 __ip_local_out+0x33b/0x640
 ip_local_out+0x2a/0x490
 __ip_queue_xmit+0x990/0x1d10
 __tcp_transmit_skb+0x288b/0x3d10
 tcp_connect+0x3466/0x5180
 tcp_v4_connect+0x1535/0x1bb0
 __inet_stream_connect+0x40d/0x1040
 inet_stream_connect+0x57/0xa0
 __sys_connect_file+0x162/0x1a0
 __sys_connect+0x137/0x160
 __x64_sys_connect+0x72/0xb0
 do_syscall_64+0x6f/0x140
 entry_SYSCALL_64_after_hwframe+0x6e/0x76
RIP: 0033:0x7fe6dbbc34e0

Use the corresponding preemption-aware variants: IP_INC_STATS and
IP6_INC_STATS.

Found by Linux Verification Center (linuxtesting.org).

Fixes: 8d8e20e2d7bb ("ipvs: Decrement ttl")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 43ef3e25ea7d..5c81772158d8 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -271,7 +271,7 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 			skb->dev = dst->dev;
 			icmpv6_send(skb, ICMPV6_TIME_EXCEED,
 				    ICMPV6_EXC_HOPLIMIT, 0);
-			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 
 			return false;
 		}
@@ -286,7 +286,7 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
 	{
 		if (ip_hdr(skb)->ttl <= 1) {
 			/* Tell the sender its packet died... */
-			__IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
+			IP_INC_STATS(net, IPSTATS_MIB_INHDRERRORS);
 			icmp_send(skb, ICMP_TIME_EXCEEDED, ICMP_EXC_TTL, 0);
 			return false;
 		}
-- 
2.43.0



