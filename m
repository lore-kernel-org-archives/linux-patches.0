Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624422;
	b=Khggmm4IIr3zxX0dPipAvgdD0Pc6ZKRzO5RcEfDkP8ZWHnAKEKlrcggPGXFJ+GlaNaZJ
	 XRPhhQzynjw6ICNoVsS5XfDJ5VYNRZapdnTa/Rnz3x1wxGzPlr9ZTFOVgsvKxqFEI+K55
	 gh72hlM+QPG9I3NhcERem6zXa4D/NGJqhHf4GZdcRAcpS7kjG6VY+rgWVXSssLZoyzKCd
	 QP8wd/+VyVv8Il23sTB4FkPepEh+8orwIK4cjcZg7MoNxmhVa4sBH01KRoMzs0eEk2NA9
	 0rDm5JEff9ytldb+35bB5GRjrI31apzmaiRmli8Ul+kAg+cHO3lNZ769+9Ky9OLhurg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I3P5swK8BSXrSWQfagTuWauoOA8uh04U1OjNIXjtO9s=;
	b=DNRPTll24Yn5pHqSu4c0cea/wmLfKJeVG65xgfBEjG4QY3EtVnhwOwTKCegbiOHP9NkM
	 /V7jwsW7Uu2daBfMTc1K+VxOexV4Y/T9XgIVCL2HdMbVs5AQ7Y1aIOrj4YRKSCI9Suatp
	 0gxcP2Tua/mp5PK1wE8VVYQlI/SbkhAhXrazbykrcwL1UmplkvxNCGXTuyzDdaOlUNimm
	 povuoOgpNPl8Jc2e/RkA7ae+IuFnxyFjJUA4fPqcNDxY7K9YW1GUAyI4W/FFzH6BbGN3C
	 9vW0HOGR52O4dW5L6lfGOj3Tbu7B2w8+AAF49IW/ytLyKV9gWUdw+VFwXBuLWcd/4lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUGmA+O3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9B6606A339;
	Wed, 25 Nov 2026 16:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUGmA+O3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B241F000E0;
	Wed, 25 Nov 2026 16:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624421;
	bh=I3P5swK8BSXrSWQfagTuWauoOA8uh04U1OjNIXjtO9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUGmA+O3cY9tFn8VeaDmzYx8bkXYh4v9iozRWlBT8j6fGM/RNi+wuvIHGTYX/TJ6n
	 zSxvm7SO8VpixnBAtvP7sIEGARLIQlsVNMGtDvKyf847ml/ZxhUqpN3ihJyvnz5bFN
	 OLPdmPNiUz5UHKWXsL573SDsQZARtM10d7TpRNy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/816] null_blk: fix opening closed zones at the active zone limit
Date: Wed, 25 Nov 2026 15:28:56 +0100
Message-ID: <20261125143853.547651412@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index 887915340fa8e..badedb4769220 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -311,10 +311,8 @@ static blk_status_t null_check_open(struct nullb_device *dev)
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
@@ -330,8 +328,11 @@ static blk_status_t null_check_open(struct nullb_device *dev)
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



