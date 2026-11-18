Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056869;
	b=2bz9hf6ynuf4SbqP6veUuBLBc87mYwkksABeqAd6PUWX5ObsiJgT2yCn3TBjcol3b0Bc
	 kmeva1Xqi369ZQjxWRb/5yjG9ZtujamSfGgeYW0QPtz0UPfORTIlpN3wVXKY6W1alxKo7
	 XdrjH8pdUnUYOTUMN3G9NPy44WMojxVY6iJ1jgNt8GDKV0Kv0qQA0XP0L2Mnt88Ku7HG3
	 QXrvRCSsgecABtlL/kYCMJPGtW/WYc/hmj/QRGqk/R17+7LaGflET7x4aiyzjXd779s2e
	 v+Otz5exmCYK69GjhGIaWWQcuDYaItuTaclds0+ZG4Ma3RxVDGRkmIBaeEl+fvFAVXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P2KORXJSUM88IjXoxBYvVh4s8zt5dYcxVkrAp1H1SCc=;
	b=tyFXD44lADNKNhnFztcNMea1WjcYKXajX73M89VrMjCjA/nOt84Bj8FDwmHbfIr2DsNV
	 cRHjdIdXkZJU8AGC/YrAT7tsnNkVRUbWTeIhT7BQuNKobTwaWaHZZB9+0WyQbh65pD0HC
	 C2CEeUpog/6P8tNWbhSLlUsHTvvC76ZT1PmgEN0tn4Y6WbE/VeMlfcFOfviQiNFZWudRY
	 56YfNj5U8fndSoowvG5XYj7fPUQw/nAk41Vgo8ZppahJrS1fNkgK8Fuyfh8xQsIpDIFdH
	 CSWRdGo9+/U7uwrWuXeCTT9pHYdw5F1EykTeRQuFt8NbK0H46JGqrec2AbSOhe33UUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6bJ5h0N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D45606A320;
	Thu, 19 Nov 2026 02:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6bJ5h0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9751F000C4;
	Thu, 19 Nov 2026 02:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056869;
	bh=P2KORXJSUM88IjXoxBYvVh4s8zt5dYcxVkrAp1H1SCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6bJ5h0NKpMohVUgmuFXlDfemsarNUzbxZ60a6p0O4Ze2Fu/WdXMEFZVi4u26dske
	 nxRqNHUBi3y6URLWgTFGl1QDJ2l9Xe8NNsExmLhiIx97XVwdHXlFtpmhiTDFty+8Ea
	 lKw5kvHVKStELhXs94hW9U8HEOqdjWEM9/2cygRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2141/2214] net: xps: bound the cleanup loop by the old maps num_tc
Date: Wed, 18 Nov 2026 16:03:37 +0100
Message-ID: <20261118150136.151218930@linuxfoundation.org>
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
index 61813b29f5784..6890098bd028a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2752,7 +2752,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_old_maps;
 
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
+		for (i = dev_maps->num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
 				continue;
-- 
2.53.0



