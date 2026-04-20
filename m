Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398C42E2665;
	Mon, 20 Apr 2026 16:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700898; cv=none; b=SkZr9Ec8dcUpciSieFejBZPGbbxenDljZ/ttSI+BB9sfukSpXRx2usL3Bn+pRt1AsvN+520YTac04CG0pGDJ8fD5mhXtwPwwkEXq836RrYhTSZK3AcroaynSAtATHydYuwgH/M7xzCQwgnn9I7oILBzxexcSpQ2U2DeFgWsgSsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700898; c=relaxed/simple;
	bh=8c19x629VirKLS5kfJZ+M3LepCR3jmlApGAFH0vxaGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L59ovLGV0Y/crlfBsmMe16T09WQZ6F+NHLk3+yzFPNKpRHriZbOWixz3/APMQWYoL5SHwo/yAqsJwxCg81VJr4n6e5eApM169B03HbXatvABAFpPbauKo6VMpDC0Q3potMiRGgHzzK9bIYVo2E3vsq8E418lNxqstx4UWE/htkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cD9QF2QF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cD9QF2QF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BC1C19425;
	Mon, 20 Apr 2026 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700898;
	bh=8c19x629VirKLS5kfJZ+M3LepCR3jmlApGAFH0vxaGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cD9QF2QF0wR3gIgDEkhWpcDC9GHLX04UYV8VIbuR9JR9tU0IkJ+5I7iwNILVlOLly
	 0PO1FJJmqew+ReH4PmNTd5Z/WtjJg6AaKfGOKqtvbAe+pZA4l7tLFtVv4XGZzEXZnE
	 xP2Ua9kFPAjDdAM+ZwH+5jiQtHONno5RzgP0wD/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/198] netfilter: ip6t_eui64: reject invalid MAC header for all packets
Date: Mon, 20 Apr 2026 17:41:20 +0200
Message-ID: <20260420153939.239110717@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit fdce0b3590f724540795b874b4c8850c90e6b0a8 ]

`eui64_mt6()` derives a modified EUI-64 from the Ethernet source address
and compares it with the low 64 bits of the IPv6 source address.

The existing guard only rejects an invalid MAC header when
`par->fragoff != 0`. For packets with `par->fragoff == 0`, `eui64_mt6()`
can still reach `eth_hdr(skb)` even when the MAC header is not valid.

Fix this by removing the `par->fragoff != 0` condition so that packets
with an invalid MAC header are rejected before accessing `eth_hdr(skb)`.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_eui64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index d704f7ed300c2..da69a27e8332c 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -22,8 +22,7 @@ eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	unsigned char eui64[8];
 
 	if (!(skb_mac_header(skb) >= skb->head &&
-	      skb_mac_header(skb) + ETH_HLEN <= skb->data) &&
-	    par->fragoff != 0) {
+	      skb_mac_header(skb) + ETH_HLEN <= skb->data)) {
 		par->hotdrop = true;
 		return false;
 	}
-- 
2.53.0



