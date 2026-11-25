Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621422;
	b=HvD8aGpJKfCtg0sWzLhxaIz+gl8E5X9kMFHGR6WiGfZG0ngJm/zMa9r1tO30HcfbV1h5
	 2TNakt5Wnrho4CqC1/bbiY8d4MWBi12tK+Obph+AANx16B+kGB+cYBJhxx9gYt7vDukD3
	 jyGE+4SXrz6GJU5vJBmD2sCOT9qm3iAvDPQfxPq+4q/3+ZRPYydPWzRllO3jxp4U1Amc3
	 v22YP1eRkrXhHU4uRucZm+ITbnrNDYsp8CQYitHzCm4iq0Q7rVW9sHnlApYL/S/qeREMx
	 /mkhAoEC1eitM6k3oXZ6QWlB0UK7iJBTNRnubEzp32pzp1YENvZ01SnDjE3ogoLINog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=peSRwXV8Qs0DWIUkC75UScMSo9BjZA58IDU8YX4zft4=;
	b=qWFNJTA10EbZ5iSFXgWuYbrpl4NGh5AkKLOtU7PxC9qp8LRwziEnTq1hrvY2MJLCMBGx
	 VzTzY2CSfJGWtk5SmO9j5N24KLxhuqQtUZcL1EK/091A8A8af1zz9IN3eDDYv6y5Xhn3e
	 XaKAAdEZo1/ruri/pVXkkjfGGNmCoROlLqcbbEZgVd2gVKMPXH/ZRHqJoXYV+0pncVSd4
	 NCnCxFtjp3QJzC9Gfpn1CEIsTqy2CeEJgCTstYieaT8V0ittVq+xUorA+r6N7B4tVntch
	 BraW4d2CYcJeyiyKYI+JP7iPlUDJUDgOaia/pz8EDRNj6bPitGJ4bUlSuxIL08bjmcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ag+XSlHU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E12D606A69D;
	Wed, 25 Nov 2026 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ag+XSlHU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B841F000C0;
	Wed, 25 Nov 2026 15:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621422;
	bh=peSRwXV8Qs0DWIUkC75UScMSo9BjZA58IDU8YX4zft4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ag+XSlHUMc2o7Jvk1wZy0SGPtUpgdyQNXpLQbUDmVL1JBPS56k78xMnrZthoZPAcq
	 t4gyV3yrKqLeGRt67jLlX+OY43mXRHGty8SgTBlpGOVBltNV+WhSn/ZUzyPrOSAZxU
	 fn70qdZWQcmpfCHaMlQKNA2WC0fxuzsgWmhlxtf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 221/990] null_blk: fix opening closed zones at the active zone limit
Date: Wed, 25 Nov 2026 15:26:28 +0100
Message-ID: <20261125143827.267109480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 48d0f30694c73..cbeaec5a0a1eb 100644
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



