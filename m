Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EA3270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302196; cv=none; b=NHgh6MifNlifv1xHPnICpvNVmVO6FHiaRQHUVqUk3jVg0TSYqMCHp5lG7LeBep05ea8n8eq9fePMIpYzeAcrlpeKZ4oegwUg3AuMKxCiYjqDGf1NBn3e17ElnKSQ2mksC1QWj+/H7G5W0vTvGWvmqixpevCeCLYfUbJ3X9k660A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302196; c=relaxed/simple;
	bh=ShaRIg+kityQ5D282p/NSbqyVJtbDtPadlpy3fxwLLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ8DUN0JeN8UHEx1Tep9JURwC7jXqiK+uyawv+fNUYO16AdWNTHiIH4bMTn3fptBHsS6JQoBAd3hMBq8hdcgThXfyaTB1W86YYlIlBwE2frEJrEbzC0iOp5SKkq/8TLJ2yhBeBmlGwoE7FUQlLfWChvFUwLd0lv8y5e3y5FG3cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbIG96qC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbIG96qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB9BC19424;
	Sat, 28 Feb 2026 18:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302196;
	bh=ShaRIg+kityQ5D282p/NSbqyVJtbDtPadlpy3fxwLLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kbIG96qCQo1/AieLxCSnUM5vlJ6XKTVG5sY0qCKO0xngqtddoZwLBF5WJseZDXZCu
	 puZO5zkkg9W7t7t+uAqg6zDa+u111rEKM4NIvOzFTkwq0fD5eEGPipfuXhctx6pG45
	 T7gnvMEKxmaQDkm/LUv8h4dCwa9TnsnBlNhWK9L3ye4Ri4S7/noLDkFVKi2bna3mMx
	 kKAYsI3jLQ2D+0mwBfefmWL6uMyuyZm9flLyWiTM0iTkY8iBJHSB9DsJQMcIWD9XEU
	 TmPQ2LpbIIv8ciSRcnlfhBQAUMMB6bHpXwyv+EIARvDthLfFM42qDxKQWg9TsJF8if
	 2OTo+EfoycFwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/283] mtd: parsers: ofpart: fix OF node refcount leak in parse_fixed_partitions()
Date: Sat, 28 Feb 2026 13:05:41 -0500
Message-ID: <20260228180709.1583486-199-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

