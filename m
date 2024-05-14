Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC38B13CA9B;
	Tue, 14 May 2024 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683480; cv=none; b=RJwj5l7omEHipSjla9+Ak4rrHXgM1M16ByfeKcjZTFUoM1ZCgl3WlZoOFytasBzfJ3N6+oFskmW2ce1wVlYJ9M+lYE7UyHbb3a09uznsyqi7GFhi2xWLIuiuET0eXy71MzCY0cLPWRCHkXHcjKWudgDw2Hoypd+bd9qonDUkrKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683480; c=relaxed/simple;
	bh=VXr4QK+nnyYwgETL7fgdEFm9SIUzrPgRZgMfosCVa6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEbUn9C9wO1NVf40LPCesDtY4ZTNNfj5V4O19+KQDI7KyFmgenfgggYqToKC0cEKDrBs0KGc4+TCIZNgJLkv/1fj5m0bUYeo7KKNmnf5s5PdT1FmRMlgUVRbBp6PkyimuD/gnl7V8+UCZUkC0vQugQk5SFk8MT1iORWV+vDUza0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rq46UJbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rq46UJbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076FCC2BD10;
	Tue, 14 May 2024 10:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683480;
	bh=VXr4QK+nnyYwgETL7fgdEFm9SIUzrPgRZgMfosCVa6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rq46UJbW/8DwpyhXGtvkFOUPWQHraCCr3TGvOjcsMjPDsoWyHqrX4xWLow+P9lMkc
	 C7FmnQCU67VJJhZzBkRUqMiAuT1Edk8ViT3tnokKxYlLGHeazXYS3riC0mEZKgybri
	 YlMjcOaaC1IiMQ1dDdL8Fxfx3CCnbkUrTksnhlo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 225/336] net/smc: fix neighbour and rtable leak in smc_ib_find_route()
Date: Tue, 14 May 2024 12:17:09 +0200
Message-ID: <20240514101047.110483065@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 2ddc0dd7fec86ee53b8928a5cca5fbddd4fc7c06 ]

In smc_ib_find_route(), the neighbour found by neigh_lookup() and rtable
resolved by ip_route_output_flow() are not released or put before return.
It may cause the refcount leak, so fix it.

Link: https://lore.kernel.org/r/20240506015439.108739-1-guwen@linux.alibaba.com
Fixes: e5c4744cfb59 ("net/smc: add SMC-Rv2 connection establishment")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240507125331.2808-1-guwen@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ib.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/net/smc/smc_ib.c b/net/smc/smc_ib.c
index 97704a9e84c70..9297dc20bfe23 100644
--- a/net/smc/smc_ib.c
+++ b/net/smc/smc_ib.c
@@ -209,13 +209,18 @@ int smc_ib_find_route(struct net *net, __be32 saddr, __be32 daddr,
 	if (IS_ERR(rt))
 		goto out;
 	if (rt->rt_uses_gateway && rt->rt_gw_family != AF_INET)
-		goto out;
-	neigh = rt->dst.ops->neigh_lookup(&rt->dst, NULL, &fl4.daddr);
-	if (neigh) {
-		memcpy(nexthop_mac, neigh->ha, ETH_ALEN);
-		*uses_gateway = rt->rt_uses_gateway;
-		return 0;
-	}
+		goto out_rt;
+	neigh = dst_neigh_lookup(&rt->dst, &fl4.daddr);
+	if (!neigh)
+		goto out_rt;
+	memcpy(nexthop_mac, neigh->ha, ETH_ALEN);
+	*uses_gateway = rt->rt_uses_gateway;
+	neigh_release(neigh);
+	ip_rt_put(rt);
+	return 0;
+
+out_rt:
+	ip_rt_put(rt);
 out:
 	return -ENOENT;
 }
-- 
2.43.0



