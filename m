Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABBC39B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302605; cv=none; b=u8MrHuE+iBXNzAGBqUIo/Dz9L3z79vohwm2qB4CksZZV7jRq1e5bHl1HHRSR9R/dLbxSe17qEXbRjb28duj0cX3UUhqCtKru+gii2baNWRTDM/MqkYsu3i3aOuSpvtvvIKUS7ooC2gRNeVxyJtTYVaYPdNVkotwzpsv3lTvbMQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302605; c=relaxed/simple;
	bh=vzRnbI3KKT9HxXUFwluHqYOc8w1GmeOFJtCDgCiPKJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdlm4mvhug1DwXHpXkvo3d7/QpnLb7MxPpF4zdO4azW3ta3hP0A3tcSCNf8/cGERp3/2xfnNjXlATfP7NOK00hjhTWNmjiueqi535V3yX07/KARe1mWnhoNm5RRLCHX7AdAZdRTkrHMlDFbWGQu1hzkcizgcR/J94fgt2jGuII4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFT49LBy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFT49LBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A5FC19423;
	Sat, 28 Feb 2026 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302605;
	bh=vzRnbI3KKT9HxXUFwluHqYOc8w1GmeOFJtCDgCiPKJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFT49LByYS5zmaCQcnlFUO5lKnaA/Cql5ywZMlbG4SFPGIvGlR1n5ieBdilj49bdq
	 3vMA+54wLP/Th9zcklPFWA8hkzwUvl2E37TC3QxBsWkyGwT1CO0TC0E/vciQU9ckel
	 EvpccLoGo+2MxE+eyulfIBDwxxbdmAdCoemlRadagZdvBImOLIJGSqOCFCJ2gOaPNe
	 hmjVrBTFyvG0KkTfXYv8aqekeIVNRxhIvmRR+AqmDpdu42AGfQlfG2C/UzC7Wkgpu8
	 rVaqAAs4SO7zTi8U2YRXVwkjdAWzhXeXSuPZLQSCMlCtELM0S66jvWudQkV/0UQM/s
	 uiszaJnrabIHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Weigang He <geoffreyhe2@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 120/164] mtd: parsers: ofpart: fix OF node refcount leak in parse_fixed_partitions()
Date: Sat, 28 Feb 2026 13:14:19 -0500
Message-ID: <20260228181505.1600663-120-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 192190c42fc84..20af45a7270d5 100644
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
@@ -156,6 +163,9 @@ static int parse_fixed_partitions(struct mtd_info *master,
 	if (quirks && quirks->post_parse)
 		quirks->post_parse(master, parts, nr_parts);
 
+	if (dedicated)
+		of_node_put(ofpart_node);
+
 	*pparts = parts;
 	return nr_parts;
 
@@ -164,6 +174,8 @@ static int parse_fixed_partitions(struct mtd_info *master,
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

