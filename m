Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC07A445AD8;
	Thu, 30 Jul 2026 15:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427077; cv=none; b=j3FNuq411QBkhD79YwEIXo8Zn+YCX2IP7C9gIcvvrrUDyNPI68r2THolXbI5mYRLEAikEgoURNGWP4bSk2W9OwYvU1gVpncdVqLlBEq2uK8iHzbagPlZ7DorhAygr8oADLGXfE8Ippaoze7KSNwbpuB+9RrOE+fGI1LSSbq5yd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427077; c=relaxed/simple;
	bh=DWNkN1AXzE230Zar/TqeNFK4GTsnBjbE7N73Gfla+lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL+xR3myFU6dl41ClQz9Lvum23nXuUpokSivdj+vUofwb+jZ+tjgX9kCqzWCiPdT1iOfPSjqHIv15ymx8KL3+LBrlLPTZkW+SUhvNqaxOqR2fH+obLZSqpzSb/C2nka8908aAiCxZ/RCg173SW7LIpU+fNRxO/arbCBCNoddV3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmAY0EO/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmAY0EO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2951F000E9;
	Thu, 30 Jul 2026 15:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427075;
	bh=nwDwZ7ey2HgS41SC/2r8+SvbyRK70cuAtgG3MKyl6ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmAY0EO/cYbVIs66uACFBoQYjzCg4YUOxlRgmjQpt3sy/gDApux6ONGIcazPYjR0D
	 mqfm09HJG/h4t+Ll5WFY+vufhuWUPSSEW3Bfi7wJiWPCcROfnTgn97rLhneH42bZzs
	 Fp5e3FBaO2GpKN6ZNaW9/i21uwMKVFkDhCiWly78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Gerlitz <ogerlitz@ddn.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 036/484] RDMA/cma: Fix hardware address comparison length in netevent callback
Date: Thu, 30 Jul 2026 16:08:53 +0200
Message-ID: <20260730141424.208598118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7db79ff3fa06c3..87164dd745ecb5 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5215,7 +5215,7 @@ static int cma_netevent_callback(struct notifier_block *self,
 
 	list_for_each_entry(current_id, &ips_node->id_list, id_list_entry) {
 		if (!memcmp(current_id->id.route.addr.dev_addr.dst_dev_addr,
-			   neigh->ha, ETH_ALEN))
+			   neigh->ha, neigh->dev->addr_len))
 			continue;
 		cma_id_get(current_id);
 		if (!queue_work(cma_wq, &current_id->id.net_work))
-- 
2.53.0



