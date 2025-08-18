Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B306F26F2AC;
	Mon, 18 Aug 2025 13:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523742; cv=none; b=o04frvhocjMIpbwLNX7331yEtaIlp8UcLftUEoijoHGxLQ/9shdR+i+X14yABXKcx8p5Rw/Jsh1diQnmJ5lbVTJv0jEHy3dl6GalL3pdfRhmscEx1733U6GBz19TJJmqp7+rhZlfUgkkL6Fi83xHyjcu2iOhGRSVUgB95S6xDDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523742; c=relaxed/simple;
	bh=ri8SsNSLwrTh4X0h1Rv93UY4UAklhxTgxA6PQkzoDb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t664CUh4PxKUL2tIc72fTjEdcZfILnRmpxTy04tR67Be3QjOpCUkLR/SVIt1M38gY07xnv8AAmZABbd1rF/lNNjqEFibONQCeRMBdMsG6xKRbz76A2GVTwGYqKT2LwrL/TE4ZxAnuygGEar3rXnUAbBOR0ncqGGyVPCN+iB7Zxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iU2SXTp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iU2SXTp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B755C4CEEB;
	Mon, 18 Aug 2025 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523742;
	bh=ri8SsNSLwrTh4X0h1Rv93UY4UAklhxTgxA6PQkzoDb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iU2SXTp662L+G7oRDcbChd6ajd+1bHRB5KPPm9fBkqr5J2A4Xc5DJnMJ3xAynXALQ
	 Ywbu1sYUpqOyu9itomyCcqUOTWpaCX/p/GPCr9+8Fwo00XCGuv0TEPME++uU0NbVYd
	 3TlXbDWxkCq/i4V5hbaaVaMQVafefqInnw14wTYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Maes <oscmaes92@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 228/515] net: ipv4: fix incorrect MTU in broadcast routes
Date: Mon, 18 Aug 2025 14:43:34 +0200
Message-ID: <20250818124507.146262921@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oscar Maes <oscmaes92@gmail.com>

[ Upstream commit 9e30ecf23b1b8f091f7d08b27968dea83aae7908 ]

Currently, __mkroute_output overrules the MTU value configured for
broadcast routes.

This buggy behaviour can be reproduced with:

ip link set dev eth1 mtu 9000
ip route del broadcast 192.168.0.255 dev eth1 proto kernel scope link src 192.168.0.2
ip route add broadcast 192.168.0.255 dev eth1 proto kernel scope link src 192.168.0.2 mtu 1500

The maximum packet size should be 1500, but it is actually 8000:

ping -b 192.168.0.255 -s 8000

Fix __mkroute_output to allow MTU values to be configured for
for broadcast routes (to support a mixed-MTU local-area-network).

Signed-off-by: Oscar Maes <oscmaes92@gmail.com>
Link: https://patch.msgid.link/20250710142714.12986-1-oscmaes92@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e686f088bc67..50b3d270f606 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2578,7 +2578,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 	do_cache = true;
 	if (type == RTN_BROADCAST) {
 		flags |= RTCF_BROADCAST | RTCF_LOCAL;
-		fi = NULL;
 	} else if (type == RTN_MULTICAST) {
 		flags |= RTCF_MULTICAST | RTCF_LOCAL;
 		if (!ip_check_mc_rcu(in_dev, fl4->daddr, fl4->saddr,
-- 
2.39.5



