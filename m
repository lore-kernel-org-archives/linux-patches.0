Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F2C359A8C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302423; cv=none; b=JqYcLv74uKaWAGSfpILaH/sCWDx1gRzVTHuWWyW0qPKxFV/bpytLSo7Hcx3mYfbaiNUTJ0/162ed0EnntSWlHnGzNIIlz1BJxNp+hBb9zc0p1UgaMayBth1lgU4x7YdDWkFyyDiJqv0B/VfD6rCYhdnphmBxIOG37Y4fK5bOCzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302423; c=relaxed/simple;
	bh=ShaRIg+kityQ5D282p/NSbqyVJtbDtPadlpy3fxwLLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0pR784HRK8mr4MfbecBn0nC0Di1jnTtomjaPIpiwQ4bvoaDeFIH7EtvXc9SyHjxTW34gDMwh+PZt/kSQdx8S7UvA9HIdAP+b7F3W/XdoMjSmig99mhOu8A05GTR1VHdmY5TYtn+29rQZDpOq5Ozv/uh7ykFnrpL9IUupXFr0fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YC2FHXWu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YC2FHXWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA768C116D0;
	Sat, 28 Feb 2026 18:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302423;
	bh=ShaRIg+kityQ5D282p/NSbqyVJtbDtPadlpy3fxwLLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YC2FHXWurxUImJy4i9UmrQma7KKY/nxgqfsBhh2pa6StP/nK73kJ0YapAEWpTe4fx
	 U1i5zZGM/2+5UJv7mssJqG3OF0HKyUaA4fdeOLCImBVJRxo1vgsltiG84Dljnhs+XV
	 KTW8ww4XOFGooQQP4lOnp+YzfhLRIPzYLmxE8lH9QIbhvZnklY/6FwtkJvOfsWtGm5
	 XZh2pfsJ6MY8+GUbj/aYAqRym2ZWk8WrtEdELwiygRv5mZIdJze5YwYf5mXjEsw/Ca
	 O+CkWmsMExQLSshTgcfRMPyxTL0ZogddfQo2rfRT4dMFU4uLxPTROcS5xSFn0yBdoA
	 dtIXzqU2sb2/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/232] mtd: parsers: ofpart: fix OF node refcount leak in parse_fixed_partitions()
Date: Sat, 28 Feb 2026 13:10:12 -0500
Message-ID: <20260228181127.1592657-159-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 7cce81df7d26d44123bd7620715c8349d96793d7 ]

of_get_child_by_name() returns a node pointer with refcount incremented,
which must be released with of_node_put() when done. However, in
parse_fixed_partitions(), when dedicated is true (i.e., a "partitions"
subnode was found), the ofpart_node obtained from of_get_child_by_name()
is never released on any code path.

Add of_node_put(ofpart_node) calls on all exit paths when dedicated is
true to fix the reference count leak.

This bug was detected by our static analysis tool.

Fixes: 562b4e91d3b2 ("mtd: parsers: ofpart: fix parsing subpartitions")
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/ofpart_core.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/parsers/ofpart_core.c b/drivers/mtd/parsers/ofpart_core.c
index e7b8e9d0a9103..3cf75b56d5a2e 100644
--- a/drivers/mtd/parsers/ofpart_core.c
+++ b/drivers/mtd/parsers/ofpart_core.c
@@ -77,6 +77,7 @@ static int parse_fixed_partitions(struct mtd_info *master,
 	of_id = of_match_node(parse_ofpart_match_table, ofpart_node);
 	if (dedicated && !of_id) {
 		/* The 'partitions' subnode might be used by another parser */
+		of_node_put(ofpart_node);
 		return 0;
 	}
 
@@ -91,12 +92,18 @@ static int parse_fixed_partitions(struct mtd_info *master,
 		nr_parts++;
 	}
 
-	if (nr_parts == 0)
+	if (nr_parts == 0) {
+		if (dedicated)
+			of_node_put(ofpart_node);
 		return 0;
+	}
 
 	parts = kcalloc(nr_parts, sizeof(*parts), GFP_KERNEL);
-	if (!parts)
+	if (!parts) {
+		if (dedicated)
+			of_node_put(ofpart_node);
 		return -ENOMEM;
+	}
 
 	i = 0;
 	for_each_child_of_node(ofpart_node,  pp) {
@@ -175,6 +182,9 @@ static int parse_fixed_partitions(struct mtd_info *master,
 	if (quirks && quirks->post_parse)
 		quirks->post_parse(master, parts, nr_parts);
 
+	if (dedicated)
+		of_node_put(ofpart_node);
+
 	*pparts = parts;
 	return nr_parts;
 
@@ -183,6 +193,8 @@ static int parse_fixed_partitions(struct mtd_info *master,
 	       master->name, pp, mtd_node);
 	ret = -EINVAL;
 ofpart_none:
+	if (dedicated)
+		of_node_put(ofpart_node);
 	of_node_put(pp);
 	kfree(parts);
 	return ret;
-- 
2.51.0

