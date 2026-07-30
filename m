Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D591D3806D9;
	Thu, 30 Jul 2026 15:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425444; cv=none; b=LUwZddHilWcMxmQi+zG/rJsu51Yr3ZIpBHhu20/adMvh3ZOGpcf6hVgck86z9kZvz28IKAlqAExrB7apqxgJW76VVnJ2knQSz/lc3nuPCPxFdrw/nj82iz6M9rdINTvBLLQyoZ5TYwkb+S0CYuj9Gw96JBvvpUjH6MyOMfHIg5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425444; c=relaxed/simple;
	bh=yIuIl+grXMIN+07A3eZ779HELzfZOggM7MDQEQsJMnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6K+mrIk5Srtb5nYdSExra5JsWWj/JWFn/FdZey7sfOi2shmPI5QKEiMO7YDrPBHoE868W6kkms8hGkdl5nXAfqqsrti5BtgHOBVUNIs85599W4Aym2KluxNtlISqOdWZf3uwxag47TGLU9jfwnwJM+Ikbzga11EFeMItOFTCKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJrgZdkW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJrgZdkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7941F000E9;
	Thu, 30 Jul 2026 15:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425443;
	bh=WYemsGW56z8e0PusLsH4uniS/8j9XzHDAdLZ+ay8Yb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HJrgZdkWt5s1uwek9FtGwECe8LdvomxaM+B2N7cLfoSkO2VMOjbcf7kyyPj0vRPt6
	 uQcIKHCzKpQrlKZVv1MJczhsoRTCjdVlCil44T3a4Gb8JDojnafYRKp9JxPr5i9bxW
	 LDUXtiYqyQl0vpcoJvd+PRQw8e1FDI2pc4xq2kME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Gerlitz <ogerlitz@ddn.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/602] RDMA/cma: Fix hardware address comparison length in netevent callback
Date: Thu, 30 Jul 2026 16:07:16 +0200
Message-ID: <20260730141436.931876150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@ddn.com>

[ Upstream commit 18313833e2c6de222a4f6c072da759d0d5888528 ]

The cited commit hardcoded the hardware address comparison len to ETH_ALEN.

This breaks IPoIB, which uses 20-byte addresses. By truncating the
memcmp, the CMA may incorrectly assume the target address is
unchanged and fails to abort the stalled connection.

Fix this by replacing ETH_ALEN with the dynamic neigh->dev->addr_len
to correctly evaluate the full address regardless of the link layer.

Fixes: 925d046e7e52 ("RDMA/core: Add a netevent notifier to cma")
Signed-off-by: Or Gerlitz <ogerlitz@ddn.com>
Link: https://patch.msgid.link/20260617-fix-cma-ipoib-v1-1-03f869344304@ddn.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 52d70eeb0c52ec..a225eae78d3e58 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5231,7 +5231,7 @@ static int cma_netevent_callback(struct notifier_block *self,
 
 	list_for_each_entry(current_id, &ips_node->id_list, id_list_entry) {
 		if (!memcmp(current_id->id.route.addr.dev_addr.dst_dev_addr,
-			   neigh->ha, ETH_ALEN))
+			   neigh->ha, neigh->dev->addr_len))
 			continue;
 		cma_id_get(current_id);
 		if (!queue_work(cma_wq, &current_id->id.net_work))
-- 
2.53.0



