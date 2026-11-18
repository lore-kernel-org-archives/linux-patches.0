Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050568;
	b=RI9cuKxZ87EBrra+8y+66TBbyUFRqp5095AqhAI+QUC+IAkE5fNqu6Sc/zmRjL2wBUD5
	 eQIOHvDP5gpWb/XlXt+BZIlibN2NIe6hQ1dqiW92xndg4bGq/5bA/t3008r0OTJtbeBTN
	 h1SJb9kCKbkekKTARswPdHuDhQUlahl1oC5ySZZNgcCWYWpENZLiADqpjEkpkLm94AeVn
	 Diyjisz1qrGWvkzdY7BRMyaBMlfYZlRwzEkARXEnTFBEnT/+9x19eEHpAG6bFyYYWghMO
	 wK/Qrw1BB0I3k+Cnh3tiNkOx7N0d23efaeOGOsmxqcsGTQtEQ0+E9hcWAIcJV59wGfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MxKSGL+NrHLltIgiwYddX9O5Y93himrYNgFwpd5T0OA=;
	b=XE6KIuSdb07MJsoYiYXNWE9cWlyrZ/DhxrJi7xJ2zlen81qafmhrpgNWknEsLpQoWmOk
	 AVdo4B70VQdJqQhY6XvYvXaAtwOsA0fHKDWWUBAk4MsuFUinGX/fe88MRMVS1R4KRRmC1
	 ele9OmIBVh2imUAvN3q+t0YNfPE4BZswl2MfYII9hfyNQIRwB5mQJ49KdL6vbEfLprolw
	 LD2vJfMgQbMZciREotD3dOVwvU3dFuIw5bN8EHno+tlQUmQFko2u8Ne0+FTDQY78b8m+X
	 M+Ca/HPYJTvFjiy5uW8dcRrZnC4zCrzQfiC9UvSAMmVNqOBacef8M+oQLmdT84RtQvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2I1q9adP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D1D606A320;
	Thu, 19 Nov 2026 01:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2I1q9adP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E7D1F000C4;
	Thu, 19 Nov 2026 01:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050568;
	bh=MxKSGL+NrHLltIgiwYddX9O5Y93himrYNgFwpd5T0OA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2I1q9adPjds5rsyzUghHBOxM4iFFJ+VcLh1UpusY5IOja6Cw3ttxA0OWrbrOLQpL0
	 W4GXWsK4GnPseHluuUCRfGdYkO77qP+HKOnHamWrFpkUCFLs9D8oz+jO3iTlKpwzXV
	 sW04x3gP6sVywO9aajK426iVfX9XHHxex/X7dYQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2752/2857] net: xps: bound the cleanup loop by the old maps num_tc
Date: Wed, 18 Nov 2026 16:03:06 +0100
Message-ID: <20261118150340.698352122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dudu Lu <phx0fer@gmail.com>

[ Upstream commit 6d5a2cb0b7d6caf170d37ae7ac74738d592d2a05 ]

__netif_set_xps_queue() walks the OLD dev_maps to free its entries.  The
per-row trip count uses the NEW num_tc while the row stride uses the OLD
dev_maps->num_tc, so when dev->num_tc was raised without rebuilding the
XPS map the last row indexes attr_map[] past the allocation:

  BUG: KASAN: slab-out-of-bounds in __netif_set_xps_queue+0x1458/0x1ee8
  Read of size 8 at addr ffff000014f69458 by task insmod/112

The loop frees entries in dev_maps, so both the trip count and the stride
must come from dev_maps->num_tc.  The map is sized
XPS_CPU_DEV_MAPS_SIZE(old num_tc)/XPS_RXQ_DEV_MAPS_SIZE(old num_tc, ...),
so iterating the new (larger) num_tc reads past the end.

Fixes: 255c04a87f43 ("net: embed num_tc in the xps maps")
Signed-off-by: Dudu Lu <phx0fer@gmail.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20261021155538.67867-1-phx0fer@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8c3f9946a6bfa..74c1a512a065f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2737,7 +2737,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_old_maps;
 
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
+		for (i = dev_maps->num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
 				continue;
-- 
2.53.0



