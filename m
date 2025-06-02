Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F225C233149;
	Mon,  2 Jun 2025 14:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873948; cv=none; b=pJSUJFV23gfKShwM/AtuF0Z6M+p822maBhNRWQe+MoprPwGGXZTFc/fY0vCjU0eGIlU3hK1BseAG03dHmqf/7qWVrIpqRomz05hKBpbsC/rt+GPQ1Kgx6A2LNeaAEyz6rbZfXhNKUUwRv/rULm0AhlH28dhH28PVv7wWdizJYFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873948; c=relaxed/simple;
	bh=9IaX5VL4cT2dViwlk6qnHGau4p/rC1+fprix7iEc2AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gIjhWOL939lCvC/jczH8Ypaz1Pdd+5VR91fwAeymSg01yDVgiGLOsvdPyGmvhYQcLt2l/k+FvS+FrnomAy0C4drm8kLvtwbwPl6GjMhQaOaR06gTx+v0dWBB+UXJHfFIOiOrC/OvGJsL5tQ8VBPvqn0YxwddbHPfwRncCAqU9rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpNA88gs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpNA88gs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79802C4CEEB;
	Mon,  2 Jun 2025 14:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873947;
	bh=9IaX5VL4cT2dViwlk6qnHGau4p/rC1+fprix7iEc2AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpNA88gsru4kkISZB79nDDJpdBnlYzyGJ6EKp9mCn3LgJ3OSMXcyXIQNttKR5R51x
	 rfehYOeVBc8e/cTrVU9voJFlk+7mSmBlBAekrqewUYHdBkTm1uj2gBF55k0k0RiYWY
	 vyE/0YOJoroU1+/Ss0hFsgK9DsCw0sA5+XpaQPRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 276/444] ipv4: ip_gre: Fix set but not used warning in ipgre_err() if IPv4-only
Date: Mon,  2 Jun 2025 15:45:40 +0200
Message-ID: <20250602134352.160265531@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 50f37fc2a39c4a8cc4813629b4cf239b71c6097d ]

if CONFIG_NET_IPGRE is enabled, but CONFIG_IPV6 is disabled:

    net/ipv4/ip_gre.c: In function ‘ipgre_err’:
    net/ipv4/ip_gre.c:144:22: error: variable ‘data_len’ set but not used [-Werror=unused-but-set-variable]
      144 |         unsigned int data_len = 0;
	  |                      ^~~~~~~~

Fix this by moving all data_len processing inside the IPV6-only section
that uses its result.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501121007.2GofXmh5-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/d09113cfe2bfaca02f3dddf832fb5f48dd20958b.1738704881.git.geert@linux-m68k.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_gre.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 890c15510b421..f261e29adc7c2 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -140,7 +140,6 @@ static int ipgre_err(struct sk_buff *skb, u32 info,
 	const struct iphdr *iph;
 	const int type = icmp_hdr(skb)->type;
 	const int code = icmp_hdr(skb)->code;
-	unsigned int data_len = 0;
 	struct ip_tunnel *t;
 
 	if (tpi->proto == htons(ETH_P_TEB))
@@ -181,7 +180,6 @@ static int ipgre_err(struct sk_buff *skb, u32 info,
 	case ICMP_TIME_EXCEEDED:
 		if (code != ICMP_EXC_TTL)
 			return 0;
-		data_len = icmp_hdr(skb)->un.reserved[1] * 4; /* RFC 4884 4.1 */
 		break;
 
 	case ICMP_REDIRECT:
@@ -189,10 +187,16 @@ static int ipgre_err(struct sk_buff *skb, u32 info,
 	}
 
 #if IS_ENABLED(CONFIG_IPV6)
-	if (tpi->proto == htons(ETH_P_IPV6) &&
-	    !ip6_err_gen_icmpv6_unreach(skb, iph->ihl * 4 + tpi->hdr_len,
-					type, data_len))
-		return 0;
+	if (tpi->proto == htons(ETH_P_IPV6)) {
+		unsigned int data_len = 0;
+
+		if (type == ICMP_TIME_EXCEEDED)
+			data_len = icmp_hdr(skb)->un.reserved[1] * 4; /* RFC 4884 4.1 */
+
+		if (!ip6_err_gen_icmpv6_unreach(skb, iph->ihl * 4 + tpi->hdr_len,
+						type, data_len))
+			return 0;
+	}
 #endif
 
 	if (t->parms.iph.daddr == 0 ||
-- 
2.39.5



