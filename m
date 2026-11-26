Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705161;
	b=ax4vxh/xRq7gTpLYpSple7l+7iQRxhVjlCkxzbmfLDi+aa1qKgi9HEWxUlQxHPKCh5Aw
	 G2lfb8PbZfBBkXL3jOhnsdjsJrDRrRsPrB/Hu9VCW5MpSHGyFSbxB/qgBrK8WuUsDwdZC
	 VaVjMXQohS4BNLCH6uK50dfZf/PFkyGjkjOp/ZhOJlbq3ndA/JnivPOwauR6MyW0Pncg2
	 id99pVCf8Hpags6gKL1cSb/zigOAO35PvDbH25XboUC/68bavVh/l34JgZ0zOjCqKREa4
	 sXfCK+m7B0zYABI7t4QhHfk8drvRimiWENPfEcT7Gpk1o33eWnwlYtt3cd7AEkrY3gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705161;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B6O/TJe7ZmyP2ZvOT5YhH22v3YmmfCaxNb1zuER34Ak=;
	b=pF7Ai9icEKDZyXGRE2uQwrIIqzJclrVhXS3KM/WzjggAHDl8CP03QbrPmrif/mJ+pmmb
	 qxLjVAWdaFj3l2NKX3p8BD5LJfyXHJUI7OsoVRRVB7zdUAb3WMoBophjNuaAOPQFXOzVK
	 sc2AiRomKQPGQD/43cEs3B9WGbBm0xkBZ8eJi4N5dUlz/sMAmEo6PY1jY59rQCvNbrXsl
	 X8MPVW82E4Iee3axDv/B6GqSzMf38Q1QhIKZoyuhGiooIcJloCstEs960XKVzTC1l0sbt
	 Lr3vJ6ZknRluw0Ewtk0w/dvmxG5v2yQYmOvFzXxLBPA2M1ZZnqo/xL7XiaK7yE4ZuAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YunrP5Az;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3B7606A321;
	Thu, 26 Nov 2026 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YunrP5Az
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8E21F000C4;
	Thu, 26 Nov 2026 14:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705161;
	bh=B6O/TJe7ZmyP2ZvOT5YhH22v3YmmfCaxNb1zuER34Ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YunrP5Azq6dGYCKPqmgIjBCdZ4KSLsjpQ1lw+cro2mIcUXLY/fCBY4Ukv30pj29/1
	 pqDEjCj3OqngLSfLwKyOzzek5YpimsKjLiKXhexKFf4BaRvKCtgTj4eV1vM/Ti8oRZ
	 jzAtAVApBgS5WDjpBvWK3ztA4BWL3AEejlcxNnxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/319] null_blk: fix opening closed zones at the active zone limit
Date: Thu, 26 Nov 2026 15:37:25 +0100
Message-ID: <20261126144008.478635306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 6f2b59737bf9cf3623719857ac149f0d431db109 ]

When the open zone limit is reached, null_check_open() closes an
implicitly open zone only if the active zone limit is not reached.

Closing an implicitly open zone does not change the number of active
zones, so this check is wrong. For an empty zone, the active zone limit
was already checked by null_check_zone_resources(). For a closed zone,
the check makes writing to, opening or finishing the zone fail with
BLK_STS_ZONE_OPEN_RESOURCE at the active zone limit, whereas ZBC-3
(4.5.3.2.7.2) and NVMe ZNS (2.1.1.4.1) require closing an implicitly
open zone instead.

Remove the check, and update the comment above
null_check_zone_resources() accordingly.

Fixes: dc4d137ee3b7 ("null_blk: add support for max open/active zone limit for zoned devices")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20261022092158.2248831-6-cassel@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/zoned.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index e41ec5096a631..d0c882a121c32 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -338,10 +338,8 @@ static blk_status_t null_check_open(struct nullb_device *dev)
 		return BLK_STS_OK;
 
 	if (dev->nr_zones_imp_open) {
-		if (null_check_active(dev) == BLK_STS_OK) {
-			null_close_imp_open_zone(dev);
-			return BLK_STS_OK;
-		}
+		null_close_imp_open_zone(dev);
+		return BLK_STS_OK;
 	}
 
 	return BLK_STS_ZONE_OPEN_RESOURCE;
@@ -357,8 +355,11 @@ static blk_status_t null_check_open(struct nullb_device *dev)
  *
  * ZBC states that an implicit open zone shall be closed only if there is not
  * room within the open limit. However, with the addition of an active limit,
- * it is not certain that closing an implicit open zone will allow a new zone
- * to be opened, since we might already be at the active limit capacity.
+ * it is not certain that closing an implicit open zone will allow an empty
+ * zone to be opened, since we might already be at the active limit capacity.
+ * Therefore, the active limit is checked first for an empty zone. A closed
+ * zone already holds an active zone resource, so only the open limit has to
+ * be checked for a closed zone.
  */
 static blk_status_t null_check_zone_resources(struct nullb_device *dev,
 					      struct nullb_zone *zone)
-- 
2.53.0



