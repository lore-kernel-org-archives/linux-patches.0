Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C5E2E7379;
	Sat, 30 May 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162789; cv=none; b=Sww8WYMYWUup/vw8IQTcuaa36Cg77GEyusEXMGfYxj+pOM6ocoNLnj8nRe3oHeAkk+6xoVh8t6qof2fRji3kW3Q2TdkbC9qOC7uoxORHsCaLXZ2c4av9YAyizjvBDPPi01FJYox35slL15zFdrH+mq7CUVi1IFtTumiN45j68XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162789; c=relaxed/simple;
	bh=/Yi1khe5g03CiB7Hv5W14uOfaDbJQEEkUMuXo0bDqtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuwiZIFvpva41VQ2Z4nQ2z+jTWP7J0ahWoqnVm7orlXLcM5CoCXKAKR0TozO//WSnkrxmSEOBwnJ7hwKgkaknyKPn3meU/uwFHPELvWmCRw2p0BhZ6JUll770iBFu4Snc7jddLLzaxTygmcQozZB64FUM1QAPAUkVIXSHO0aVWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5OBb1V+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5OBb1V+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A201F00893;
	Sat, 30 May 2026 17:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162787;
	bh=VgfueHzhV15sj/JIK7+5MLu4pXUtggMKuY+S0MTjLg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5OBb1V+ZEBcdmFhGv+pP9R4Dy8VNLIlhZQyhouaPlhqw/A/vTht5EOyZ4DFWKMW9
	 CU+Y1x/cBIH7b01/pC+ziauJ60hMUip6YduGxVBnZbDn6CGXtgx0oddRsGwWJ+wieo
	 +LW/rSMx61SqNKX75taaQPqZTNEx7cjcYilKSBZo=
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
Subject: [PATCH 5.15 036/776] netfilter: ip6t_eui64: reject invalid MAC header for all packets
Date: Sat, 30 May 2026 17:55:50 +0200
Message-ID: <20260530160241.221283433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



