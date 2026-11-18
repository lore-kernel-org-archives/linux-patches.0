Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055210;
	b=k8TEBjbnoOI0fpDSLCAdANLzaMnpC7BiuNZS35jHZ1wRYM5hVJofXC7nDZLK7o/peemD
	 pPCiJUh+GhSFwd/RsPOCqh4wZIx+v77luynLvZrvbZd5HKqznsyhRUZK/91ivNIq9WaxA
	 5sJ56VqCgZ9fhkmtrK49uyBPwhhKoQobV8KFfiAHPPg41EPJs+/3ylzUc4OHYZVgNzXKP
	 JF7AGLxN1oOhRgeQKmH1hPoNCyn581fsPUINi0p25OZh5izK5hDOvfo8sd8vUgSeAAXdO
	 sO5v933C676aBIthJVGjA7H8NmdcJ2g0T/17iYCb92XqTk/ePdt9oqYTsONMzkd/U5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zQrQtBssdj5izH/uWkB7Ucs4sj2TO23j5CjJO+cyHAI=;
	b=uU1FeNGKdJlB8uhpTxavRdittQXzEcxMGDQlPb+jWr7PvaYFrKlRytOBu+mzV4dfFLMH
	 5Gm65hls15oM5B6NIsTnXbiri51CxaFt3aNZEU6NCPrFV28IaM0FHnPiUdUBrsPUAipNL
	 +SfdP8CyT3otRxZ0yz3k7KZVRAcWSBDQLLcrQF8qc0AXi0NwJ9Xmmrj/89k+Dx5jkiNqL
	 5zkEWENI9jIQrbPln96spSGSZiFIJGudKUzgSs9ko/DDUyuJ5p6uhv8ftojDa9OVXqm6k
	 IhFWL1Hpyn8CPgoGKgYWxZtM/KZKsiznPJ9WakORLLjo8o9T8KmKlXtXWtUz9czT9aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+19Jyjy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D4A606A31C;
	Thu, 19 Nov 2026 02:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X+19Jyjy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81A51F000C4;
	Thu, 19 Nov 2026 02:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055210;
	bh=zQrQtBssdj5izH/uWkB7Ucs4sj2TO23j5CjJO+cyHAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+19Jyjyyv066N2lSVK5FgptUkKklgbAm37dmFCHdvdEHzI92VjUNY+rG05rlq2Ln
	 Ys8KhQ8U1qoiD1nm+2NxvZvqnTrunDoBBDaVDQyhFYfUDWUsiAWH5AW3eqtpqpe4Df
	 koYMxwxv019QiTUaSAe/Fq0KpSKfQPT+MuJL7sf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1548/2214] RDMA/core: Fix partial copy of IPv6 flow_lbl in LAG hash skb
Date: Wed, 18 Nov 2026 15:53:44 +0100
Message-ID: <20261118150114.050815523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit b63d21631f836528ef660d7b5a0d84890ff6dbd5 ]

rdma_build_skb() constructs a synthetic IPv6 header for LAG slave
selection and copies the flow label from the AH attribute:

	memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
	       sizeof(*ip6h->flow_lbl));

ipv6hdr.flow_lbl is __u8[3], so sizeof(*ip6h->flow_lbl) dereferences the
array to a single __u8 and yields 1.  The memcpy therefore copies only
the first byte of the flow label, leaving flow_lbl[1] and flow_lbl[2]
uninitialised in the skb buffer (alloc_skb() does not zero the data).
The resulting LAG hash is computed over one byte of real flow-label
data and two bytes of kmalloc residue, so IPv6 RoCEv2 traffic on a
bonded interface can be steered to the wrong slave.

Use sizeof(ip6h->flow_lbl) (the array, 3 bytes) so the whole flow label
is copied.

Fixes: bd3920eac1331 ("RDMA/core: Add LAG functionality")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260916120926.1761-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/lag.c b/drivers/infiniband/core/lag.c
index 7063e41eaf261..fc1dd6b5bf5ef 100644
--- a/drivers/infiniband/core/lag.c
+++ b/drivers/infiniband/core/lag.c
@@ -60,7 +60,7 @@ static struct sk_buff *rdma_build_skb(struct ib_device *device,
 		ip6h->version = 6;
 		ip6h->nexthdr = IPPROTO_UDP;
 		memcpy(&ip6h->flow_lbl, &ah_attr->grh.flow_label,
-		       sizeof(*ip6h->flow_lbl));
+		       sizeof(ip6h->flow_lbl));
 		memcpy(&ip6h->saddr, ah_attr->grh.sgid_attr->gid.raw,
 		       sizeof(struct in6_addr));
 		memcpy(&ip6h->daddr, ah_attr->grh.dgid.raw,
-- 
2.53.0



