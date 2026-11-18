Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033048;
	b=FUa2NTPuAz9T04T3aSWgIVm0PdRpJXlaS09OcL5ODYWiezcUjub8oZAwTmGynvtm37+L
	 RTB0iiljoOIxrh+l/Qjyrj6QAwJyFSZ+04iF8SP33qzqM0cI98b5ohcuKYlF/5CKWY6Jm
	 SDNvb9SxkQHHREj9JBJ8VyuzV/llDx7mzBf7Z1syfU99YjXTUUBHcvXQssNJsUPGjX7be
	 wFiGQInoTl2H7gaKAG2s6ygSLeE8gF+AjPCHq/+lUMoWswu207KV/UZ/5OAoYRTUU+S3T
	 UXaulVs5e2gEH1c3533vZYzKrYmvYVv2SP39dWuRVuxq6ti/4yiqf/5B7XEfy9Kz32w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2YJHoyDhtthQNLgyXKh3IRBpMCyz9XtO40VBgnl9SXc=;
	b=nG1UJGzFdm0/bOgK6e6TR2gCgeZWmJOxGr3LIpEfiDr40Pe6slyRVWS771a4xBxk048F
	 ojh6XLAHX8tePy/YQAmfESfSleOiq0EbHmfrHGWx9661l3BINkGC763dSKl8UMicOq6oO
	 vCXjrNrnBYcPOVLqd9YY8HmSyFQmEnE+QwCU+7cnqSNkf22kZs35QGBKXpH5ycIledh0I
	 L6oi1yAe5ZvqlmonsdmuSY8zR9sCyn/AZ6iIR2TfYwudm2x8rxJr8tp9IeUIrrujJf5UG
	 fxW466kcY3ft5/REaA+qCTLTHrWxlgAkBjN+malARgEPUzt4wU0J9MBNSOTrEg1Mb4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wb70G3Om;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDBE606A331;
	Wed, 18 Nov 2026 20:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wb70G3Om
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B79B1F000C5;
	Wed, 18 Nov 2026 20:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033047;
	bh=2YJHoyDhtthQNLgyXKh3IRBpMCyz9XtO40VBgnl9SXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wb70G3OmT38aWjTZmFu42s5YclyWHDAxLqYayZHgVQUqXuEHiVo8Fnx/GqVeUOPL6
	 mql6X6DIDrH+wSBRgu4qHNvtkZRQZRKyIyCz6xU4+VaFMy5Ghu7QSh9yu/1ZRWZt52
	 ccliZS2Rj02bE3APbeAifwvg/E2rqgFZYjSJqAJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dudu Lu <phx0fer@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1602/1756] net: xps: bound the cleanup loop by the old maps num_tc
Date: Wed, 18 Nov 2026 16:02:09 +0100
Message-ID: <20261118150113.669741767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f42ec2837143e..857d195bef231 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2788,7 +2788,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		goto out_no_old_maps;
 
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
+		for (i = dev_maps->num_tc, tci = j * dev_maps->num_tc; i--; tci++) {
 			map = xmap_dereference(dev_maps->attr_map[tci]);
 			if (!map)
 				continue;
-- 
2.53.0



