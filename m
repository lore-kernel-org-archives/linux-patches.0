Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB82C7262D;
	Mon, 18 Aug 2025 13:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522019; cv=none; b=odxDB9LdDwfLGDaUUX8YQKoUa5Hjds0d5KG2KzYxs+z/Gn2OOJdjR/mPqSR8VVU+MiXMpQRyVmPEinGbbBypPPHzRr1UAy4jWRsKsp0kUG60i+t+bqVXdIKzl4Khar4HTpfljZ6hwD74LOT0PFDnyO/Kq3lME274G6WAWh4WPvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522019; c=relaxed/simple;
	bh=7MFxIjwDk/AGlOlEmdjaV4yDXobwp8X6CVKSe7z+CAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JWLujB5YCoo3tPpd+Mo6QLL4/Nj9f2cx0mx/fRyO4d5B4dGaJztQOjeYbj1v81y92HFHxsytfdkpg9WfDYnZCW/ir8qfp11F70LXk+ltpf+jZqIkUSeK6nHTAYAQJQCd6tUNW9m3xGXIQKNPfGfVERpeGBAmVdK05ypos9so6XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VqFu0u64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VqFu0u64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87C7C4CEEB;
	Mon, 18 Aug 2025 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522019;
	bh=7MFxIjwDk/AGlOlEmdjaV4yDXobwp8X6CVKSe7z+CAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VqFu0u645nXo31jTZvc1oNhIs3UhI52iTFMYgIhujzAy5R8HJ+HywTQsgOUzq7jxf
	 xYgBlyOAvsZJ9i3WGQOHd0d4fyDVuJBBkTW/uhROEzN75E5ize+mrHFLt96MrOk/2D
	 X32PXFzCPz9s70gej3dbKpEb69IHyskqs25fe/mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oscar Maes <oscmaes92@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/444] net: ipv4: fix incorrect MTU in broadcast routes
Date: Mon, 18 Aug 2025 14:43:37 +0200
Message-ID: <20250818124456.027364914@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
index 73d555593f5c..9a5c9497b393 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2545,7 +2545,6 @@ static struct rtable *__mkroute_output(const struct fib_result *res,
 	do_cache = true;
 	if (type == RTN_BROADCAST) {
 		flags |= RTCF_BROADCAST | RTCF_LOCAL;
-		fi = NULL;
 	} else if (type == RTN_MULTICAST) {
 		flags |= RTCF_MULTICAST | RTCF_LOCAL;
 		if (!ip_check_mc_rcu(in_dev, fl4->daddr, fl4->saddr,
-- 
2.39.5



