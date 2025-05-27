Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C91525DAE1;
	Tue, 27 May 2025 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365759; cv=none; b=QcdnS/KCgr5XDMVMh2DJDB4R/G9uD2p7OGQ+cZzN36YHZR242v7MQmzameTtyniySjq56KeYlFRqW+Px6Agztpk4UcR5SRelXc/ZScU7G7zO+QkXM/EjhDW5b0+Sc1nfQNnyc7X53fkD1MDs7/HFFPP85wSL+JrrEFpEh4GzX0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365759; c=relaxed/simple;
	bh=ALnEFMn3w9LdtomcKG44nVEHb5/aP9bTEMXyj6LpjEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVJZlW5ksiBC40cy4d0fHZXxa27jOgiCdfCgCQcvaMdIUlRCMuVLriMHysnPsoPDM+jia4Kbik9ev0lr6/vzJf0ozyjdGQ9pL8UDiQ+hK9iIaT8WFWhmqPUyiVucaoMe7DHxtlGpbAtJCoK/AD025WfSOdHsKAqddBCCncGU/to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRwRsp4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRwRsp4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEDDC4CEE9;
	Tue, 27 May 2025 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365759;
	bh=ALnEFMn3w9LdtomcKG44nVEHb5/aP9bTEMXyj6LpjEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRwRsp4icbB3S4pgDZ1ROD9c6ug9XruQD4ssH41h37vpIMZLNubDN66QUgZZNJR4Q
	 Yo4n+veIGFkf7v9CplweCQaXTvLW1D5fAk/lDIq+VNCAkpkfeXYoHvnpq3b3kADmx6
	 zm19WSXCM912O+lQGrFtvGPnrr06p+AVl8h2Ykdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 449/626] ipv4: ip_gre: Fix set but not used warning in ipgre_err() if IPv4-only
Date: Tue, 27 May 2025 18:25:42 +0200
Message-ID: <20250527162503.247451023@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f1f31ebfc7934..9667f27740258 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -141,7 +141,6 @@ static int ipgre_err(struct sk_buff *skb, u32 info,
 	const struct iphdr *iph;
 	const int type = icmp_hdr(skb)->type;
 	const int code = icmp_hdr(skb)->code;
-	unsigned int data_len = 0;
 	struct ip_tunnel *t;
 
 	if (tpi->proto == htons(ETH_P_TEB))
@@ -182,7 +181,6 @@ static int ipgre_err(struct sk_buff *skb, u32 info,
 	case ICMP_TIME_EXCEEDED:
 		if (code != ICMP_EXC_TTL)
 			return 0;
-		data_len = icmp_hdr(skb)->un.reserved[1] * 4; /* RFC 4884 4.1 */
 		break;
 
 	case ICMP_REDIRECT:
@@ -190,10 +188,16 @@ static int ipgre_err(struct sk_buff *skb, u32 info,
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



