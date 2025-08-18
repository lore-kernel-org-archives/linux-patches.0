Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A822BCF5;
	Mon, 18 Aug 2025 13:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525478; cv=none; b=F9IPBz9FDVD9TaJijUXSrOX/gLIokOVVW/Si31ElIZ8ojrVLQjlwQIUXAbARu8m3y8mxJjYzt1FLFV3RWB2fVB15jx/waL1ecRKIbtJginNGxY0NL8WQEY3FSw6fJjjxG5YN0Z8KHs4HaRhIr2hSDfUw9J+W5/ZE9UwxN2Q39qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525478; c=relaxed/simple;
	bh=dO2YWRvUVWsbLOuxItBATajVw0H61HM4wWBL24SefaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5UbbL2VexfEUx5s5dJzmqg4INDTqTU+ld5yi7cOlNAXy0paFbKe3get0K+kbZhNwoDqSEwOs2TAf/tfWTaDK811szpSTSkDw6QRAJu9qOM5Bqwb8qzw6ihP6hgccGSmsbxQWmQpdxuSSOvgq+eOeecHJ/ZX7sX5dFOL9cCQ2H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUfVBIoG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUfVBIoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2DDC4CEEB;
	Mon, 18 Aug 2025 13:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525478;
	bh=dO2YWRvUVWsbLOuxItBATajVw0H61HM4wWBL24SefaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUfVBIoGRMGN4Z3U3qrrWTlaIlr0mOIMTIQrCaPR/wdvg7iZt6FvZ51RQsQqkIxoj
	 t7DgQLYQXIgK1P/s2sDXA+iU8EnXWjNttD7Kxa0kehICys0XqZSxF7Il6gjSYxKdSZ
	 P/HY9m5KSbtc+Yn3NWWubCTu3xnt068N+opRm4gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Maes <oscmaes92@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 244/570] net: ipv4: fix incorrect MTU in broadcast routes
Date: Mon, 18 Aug 2025 14:43:51 +0200
Message-ID: <20250818124515.219520919@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index bd5d48fdd62a..7b8e80c4f1d9 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2586,7 +2586,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 	do_cache = true;
 	if (type == RTN_BROADCAST) {
 		flags |= RTCF_BROADCAST | RTCF_LOCAL;
-		fi = NULL;
 	} else if (type == RTN_MULTICAST) {
 		flags |= RTCF_MULTICAST | RTCF_LOCAL;
 		if (!ip_check_mc_rcu(in_dev, fl4->daddr, fl4->saddr,
-- 
2.39.5



