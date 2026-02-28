Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C03933A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301862; cv=none; b=cU+Ldr1GiX4BSJxqbB3p4gnlYxUnclKbazhbbYk1616MA5arqhb8SIsrEUoV1uO1rvKRY5O/G0c3TBTUXKRKuf3MFg2+c8dBskQcrUXoI7yuClCcgrHc/nCTSitUNn5MMm80LhOd9JzA/J2XUAYe9ipiPLnTFX+K3oZyFzKm6rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301862; c=relaxed/simple;
	bh=zppvFTRnaC4uVaBy6IRNKd+5hVamZB4G3hpfAbEl04k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wg9l6zFzhnz8asjipYKzML/Bd5fx2bJ5inS0ouPOtHbV4pr1kOcKyjyP8PByWGmKe4onYba7XbxroYKfDZk6Nb6+beTEBEVi4XyOwsW4dTO5GISYssMmhAu6Dyv6cnfDfOyZ50vgUJ9C/UKFHrwoFZdoUg4QlVUIJKOncxCVbWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWTdgDgN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWTdgDgN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DACEC2BC87;
	Sat, 28 Feb 2026 18:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301862;
	bh=zppvFTRnaC4uVaBy6IRNKd+5hVamZB4G3hpfAbEl04k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWTdgDgNroPGhvVHzJ3niD9SMNZ5tkObGeu/MOpISysdaHRF+ZmngkpUN4fRskY2f
	 L85n1q68EH3F1ebwKlK5H/k5yzfc9MMEtXyXXG/egR7QVEp3I/DTiV06DT/MziQObi
	 lf5TBH3fCRBOgqb96pep9igjbALYjaZ+Wn8Jr231GLWi0MgQDk+ZFXn1NS2z4n4nWU
	 fk6ru1IwtgOVekK6M5rqmx7BpHxDCZPSBj5f6RxcoW1qRdWlC0FfwRf7v4OkxwND2O
	 WoAvQsHPion6D2Klrs/Jnte0u8xPDVo66kLHutHE8wjZsrAKvsTFk3Rxs7mWEEaFKg
	 /3KR4DHAC2u+A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/385] mtd: parsers: ofpart: fix OF node refcount leak in parse_fixed_partitions()
Date: Sat, 28 Feb 2026 12:58:26 -0500
Message-ID: <20260228180011.1568201-284-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

