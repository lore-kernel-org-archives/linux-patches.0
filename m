Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C70251599B;
	Wed, 30 Sep 2026 16:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787358; cv=none; b=ce5UXpqEpYeJvnKCy10OZNhOP+qQJBLCsWwP3kyQHUTKuPVVVSLXBZJVQ0CFWat8E6YOu+nlwfZVLfIhTGG+6odOdyNScNsCnANHlPXz1RU4W1hZ8r9dmsPDZZjTUh+dDSMBUCpcm3Au21Fw3FEbo0otyjXv1G9kPWrlKlF0I6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787358; c=relaxed/simple;
	bh=Q/rK7iaGUPSKAITKm8lrTa9hioqbIQlWHTDqkvo/i3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HRzQZgEuAR9QjPbV+BFmYxe320r50KdOZHJCr7wjiVcD92VGRyc7BjnM2xTb21/8zKr1X6x/bHpEnGNFYBfR8c1bU8Ne+ICHRGhlaLerTo9hpgiMWUOrZVPlttqedD9KjVDxZyZSY8UFlw0q1CHPpRPAYe4lkUytKN0Q4qd3uos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4/jUMwK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4/jUMwK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6439A1F000FF;
	Wed, 30 Sep 2026 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787356;
	bh=9wjiQ+4IB5kMVDOJGAhn9Kd6Ij9x52guhAjgKG27kBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4/jUMwKTtqmRIYDURp98XcaCT3ek7qUDEAmGwB+y3fbxXEMxczNA2L/VoWkgYGeb
	 LGHPWBAuKySGer2dmx2RWh2CjEzR1njn2nu2NACfWcl+KwnxAhB/GVQzdn67pNpXfT
	 YcTE9OjhUPsdBkhlyFqBu7fOi1AzBnsjgzNZpU0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 200/457] net: xps: reject an out of range traffic class
Date: Wed, 30 Sep 2026 17:25:05 +0200
Message-ID: <20260930152350.372164720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert Szetei <norbert@doyensec.com>

[ Upstream commit 4da3b7b8b50f3e2fde54a4c18a82a8e3f6223910 ]

Only the entries below dev->num_tc are valid in dev->tc_to_txq[], and
dev->prio_tc_map[] may only name classes below it. netdev_set_num_tc()
lowers dev->num_tc without touching either array.

netdev_txq_to_tc() walks all TC_MAX_QUEUE slots and
netdev_get_prio_tc_map() returns the entry as it stands, so a leftover
entry is handed out as a traffic class >= dev->num_tc. Taking that
class from netdev_txq_to_tc(), __netif_set_xps_queue() rejects only a
negative one and indexes an XPS map sized for dev->num_tc classes:

	tci = j * num_tc + tc;
	RCU_INIT_POINTER(new_dev_maps->attr_map[tci], map);

attr_map[] holds nr_ids * num_tc entries and j runs over the ids named
in the mask, so a class that is not below num_tc pushes tci past the end
of the map for the last ids and the store overruns it.

Any caller that lowers num_tc leaves such entries behind, and
mqprio_destroy() tears down with netdev_set_num_tc(dev, 0) rather than
netdev_reset_tc(). After mqprio with 8 classes then 1, tc_to_txq[1..7]
still describe txq 1..7. The splat is from an XPS write to txq 2 on a
veth with 8 rx queues: attr_map[] has 8 * 1 entries, tci = j + 2, and
j == 6 stores one past the end of the 88-byte map:

  BUG: KASAN: slab-out-of-bounds in __netif_set_xps_queue (net/core/dev.c:2954)
  Write of size 8 at addr ffff88813016bc58 by task xps_oob/634
   __netif_set_xps_queue (net/core/dev.c:2954)
   xps_rxqs_store (net/core/net-sysfs.c:1880)
   netdev_queue_attr_store (net/core/net-sysfs.c:1390)
  Allocated by task 634:
   __kmalloc_noprof (mm/slub.c:5439)
   __netif_set_xps_queue (net/core/dev.c:2937)
  The buggy address is located 0 bytes to the right of
   allocated 88-byte region [ffff88813016bc00, ffff88813016bc58)

Reject a class the map has no room for.

Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Link: https://patch.msgid.link/162DD16F-54C6-444A-9E09-0B8CB3D591F2@doyensec.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 65cdaf0c81f71..a48958a3f76c1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2897,7 +2897,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 		dev = netdev_get_tx_queue(dev, index)->sb_dev ? : dev;
 
 		tc = netdev_txq_to_tc(dev, index);
-		if (tc < 0)
+		if (tc < 0 || tc >= num_tc)
 			return -EINVAL;
 	}
 
-- 
2.53.0



