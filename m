Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80692D6E58;
	Wed, 25 Feb 2026 06:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002624; cv=none; b=Nn2hyTux5QvQe8rNiYjanDL5o8Ef8xl0o3+jaf/2cUT39/4mfwo8gPyh51+X7pIshkIZPsFpoCOdX3w2bE0v0hfSZBqTxyGIWjGh7P2ZXSNRQAZkQYem6wY0xjFNteAfmN6wWCpahUicHD/XX713IRAlCwhQho1j+wnZdAWD8P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002624; c=relaxed/simple;
	bh=wt7xYhnuy2G8IE6X3Nkyd5FLO9bCXdrOv4X6pq5c+70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbkUK2lVEKbXUsnLV89Fs+NHejVAMlZjwZ7UJ+xt71MofEoQAiMUrqLb3f/3yHxmBc61Z796h9h0kL2HXGAaDjbfx4tssn1mAFWHLx1Hw92vRqVT1wfAoUtklkghcJwNdmKU/+ihPCtE45kJen4xB4dbfeqY6TzknLJf2+3oyC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGAOlDn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGAOlDn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CE9C116D0;
	Wed, 25 Feb 2026 06:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002624;
	bh=wt7xYhnuy2G8IE6X3Nkyd5FLO9bCXdrOv4X6pq5c+70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGAOlDn7+DxghhQAqb9lXDiBDH97ldbGYJCYNyL/2ANRhtY8B1Y8crfajLOzRoOEB
	 CZ8OI2kDwlxeqpwCi+hdmVNSBr3lXCOFRQyfmjxU6VttbxptKqg+lIlbxLd1P0n6gE
	 pQUiEdciridTchLZNYdNuFHB2d0a3K/Gx65Vu+7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 384/641] mtd: parsers: ofpart: fix OF node refcount leak in parse_fixed_partitions()
Date: Tue, 24 Feb 2026 17:21:50 -0800
Message-ID: <20260225012357.893805932@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index abfa687989182..09961c6f39496 100644
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



