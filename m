Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679203C870E;
	Wed, 20 May 2026 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298600; cv=none; b=keAwMp6sETZaqxlGmI5AyBQXdbYQjlIE40ynzZ6WgGxdYF7e0BbyLctEuw4mNZEssO6BMbixtAniUVtLt5LAQIPlL9gzf/Yuki7vJfVq8eEDCYc7GqWa3DDxWN466+CGrdtQcs6/eDttrON1xHPBbt5tK7QpdArmNwTE/bwaLBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298600; c=relaxed/simple;
	bh=Kj4ppoJCVBIUMj7Q86a+RhmQ+5q7FZWggXNC1CvGaz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcRCTVHGufcQxV744p3cYBAC/g7z7l7HBU4ye/1ejHju6CoISETb/auK/5LR875ipS6OlAq86QSfq0thnFUch+SKxmZrUTpUAurm0uSJ7QDwX3US3mYitw/Rkn+A05E2zqXM/oIfNU7hVepELOunmHdXNXJS0KyzCC3YPfSU1tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1D9aolqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1D9aolqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B051F000E9;
	Wed, 20 May 2026 17:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298599;
	bh=ET+YKICmtQGuygXNrrvar2Cr4B0Ez3sUGJm8IdqRtsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1D9aolqualLylb/flAtdt4UkF/oOE08Z8oWxXSjfUP0Qg1nZNJQWFNJNcHw3AS2RT
	 y3QPXmCBSQe7IMx2X31cSwqEh1mwOBFBiWycDq+iabZ9dGN1HAkW47SanVIFjFIwV7
	 +odFrXo41ozyOPopw0HRX0FegqThSta1YtNLZW1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <cosmin-gabriel.tanislav.xa@renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 471/957] mtd: parsers: ofpart: call of_node_get() for dedicated subpartitions
Date: Wed, 20 May 2026 18:15:54 +0200
Message-ID: <20260520162144.739276389@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a5ba78c6723ee..321002a1d0cae 100644
--- a/drivers/mtd/parsers/ofpart_core.c
+++ b/drivers/mtd/parsers/ofpart_core.c
@@ -71,7 +71,7 @@ static int parse_fixed_partitions(struct mtd_info *master,
 			dedicated = false;
 		}
 	} else { /* Partition */
-		ofpart_node = mtd_node;
+		ofpart_node = of_node_get(mtd_node);
 	}
 
 	of_id = of_match_node(parse_ofpart_match_table, ofpart_node);
-- 
2.53.0



