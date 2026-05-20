Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61B8318EC7;
	Wed, 20 May 2026 16:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295916; cv=none; b=Lyh+cTX9DipgpUdV7z3lVXJ/uTJKz8Bisv0bunNqNLgopKW3tMvzX1NSzNBz2XJ8eamPrULLTwt/D2Skmhnewz9LCYRHOXb5KfFN8lGbo6Qo7TXVoHbec3Gggg6/4QeZhRLgrqYbSlTFARgA7s0UOMOWiNTCDfIgDjM0AylIzB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295916; c=relaxed/simple;
	bh=HfmKOSySB9j9QNyLgkibqWUN29nBgj5VO9pUd/boVpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FaXXRKy29oFfX6RBwFfyIkxt+APb4fN+RBTV4vz4nj4rs6EvZPZuJLLCu7NZy0yjePALmcZ3pP08L3Y0LvBVWAJyQEVexrblQyBXx+IUZJCcuIRLOMa8/iyziwUXVhqi8BUJFuvIz/Xoe/GmIVYBGBi0mnMkSsAdySRcrK9jUO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuzIESvX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuzIESvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2470E1F000E9;
	Wed, 20 May 2026 16:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295915;
	bh=f0I6ZGpsQFcj48yJiEwMTEqzUjnBlNmeSzIpUCQ4sPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuzIESvXSjXp1+MUp2QXb96eTMKbts5ov5rpJCWpcf8VG9iY4i3Px+FtFOvDvJsJy
	 ZuxuzzENmqjX+yjy/gCyAS0wfZTtLfizVugLNORKZhOUl6L3Ap7kaAwEKWPgNjtH0s
	 Ick/2piqunXOg1++esJEzurPdRlS47SK+4zzI/mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0599/1146] mtd: parsers: ofpart: call of_node_get() for dedicated subpartitions
Date: Wed, 20 May 2026 18:14:09 +0200
Message-ID: <20260520162201.734633541@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>

[ Upstream commit e882626c1747653f1f01ea9d12e278e613b11d0f ]

In order to parse sub-partitions, add_mtd_partitions() calls
parse_mtd_partitions() for all previously found partitions.

Each partition will end up being passed to parse_fixed_partitions(), and
its of_node will be treated as the ofpart_node.

Commit 7cce81df7d26 ("mtd: parsers: ofpart: fix OF node refcount leak in
parse_fixed_partitions()") added of_node_put() calls for ofpart_node on
all exit paths.

In the case where the partition passed to parse_fixed_partitions() has a
parent, it is treated as a dedicated partitions node, and of_node_put()
is wrongly called for it, even if of_node_get() was not called
explicitly.

On repeated bind / unbinds of the MTD, the extra of_node_put() ends up
decrementing the refcount down to 0, which should never happen,
resulting in the following error:

OF: ERROR: of_node_release() detected bad of_node_put() on
/soc/spi@80007000/flash@0/partitions/partition@0

Call of_node_get() to balance the call to of_node_put() done for
dedicated partitions nodes.

Fixes: 7cce81df7d26 ("mtd: parsers: ofpart: fix OF node refcount leak in parse_fixed_partitions()")
Signed-off-by: Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/ofpart_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpart_core.c
index 181ae9616b2e3..262c4221d23f7 100644
--- a/drivers/mtd/parsers/ofpart_core.c
+++ b/drivers/mtd/parsers/ofpart_core.c
@@ -75,7 +75,7 @@ static int parse_fixed_partitions(struct mtd_info *master,
 			dedicated = false;
 		}
 	} else { /* Partition */
-		ofpart_node = mtd_node;
+		ofpart_node = of_node_get(mtd_node);
 	}
 
 	of_id = of_match_node(parse_ofpart_match_table, ofpart_node);
-- 
2.53.0



