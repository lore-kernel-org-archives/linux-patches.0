Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AD91C68A4;
	Tue, 27 Aug 2024 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769898; cv=none; b=QeeN3uOjzGV393ahkEgz5JWVHcmabmqhnx/HRq6yOOTS+0uyNSEEC4UlwX7fUgzOfPcnQ3Xotc/+xuFapbaRt1jjFwg6xmgj1r48yQblbXkQlmwElX/WeIInHt07pZjR0qTzCvQtMSWuGDrr3hbqOz7fuKwu1UIjywDndJQlicY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769898; c=relaxed/simple;
	bh=pLww4pFvbo9xggRMogqX1ycKoLy+Te/Efjmvdd08uuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AT9Wo4FQFBHqu89tu6VR13nqPqrbDruJ93EAZL2igBtp8EPagBpDbfff+2Swq5Fnu2R4r/EltCbnxtJ2BjsDjWRP0CSEYlBzJFcb8r9h4YFZKUUmEN5/IQ1BJMn/ufkDvY6FomXUwvpUypJfRFkxZmQJXFl7wFCSkQbgTowY85o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGBuAIL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGBuAIL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0B6C6106B;
	Tue, 27 Aug 2024 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769898;
	bh=pLww4pFvbo9xggRMogqX1ycKoLy+Te/Efjmvdd08uuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGBuAIL/9sbj4rGma+UZsPbYQsmRMm3TOrRFReomx7ndhAu4WPg1cW1W1HfMRCeuU
	 eOSS4IGETqjxUHkDctmicjSscs697+GROIcbOaOGNQeG2gO+t7jtEdjgJoWc9ogNg4
	 zk8zDEPdJiqxNElrawkzBfNOh/8X+LShdMJuLIHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/341] netfilter: nf_tables: Unconditionally allocate nft_obj_filter
Date: Tue, 27 Aug 2024 16:34:59 +0200
Message-ID: <20240827143846.001343338@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 4279cc60b354d2d2b970655a70a151cbfa1d958b ]

Prep work for moving the filter into struct netlink_callback's scratch
area.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: bd662c4218f9 ("netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 36 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d29c5803c3ff0..35d5848cb3d0d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7753,11 +7753,9 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (filter && filter->table &&
-			    strcmp(filter->table, table->name))
+			if (filter->table && strcmp(filter->table, table->name))
 				goto cont;
-			if (filter &&
-			    filter->type != NFT_OBJECT_UNSPEC &&
+			if (filter->type != NFT_OBJECT_UNSPEC &&
 			    obj->ops->type->type != filter->type)
 				goto cont;
 
@@ -7792,23 +7790,21 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	const struct nlattr * const *nla = cb->data;
 	struct nft_obj_filter *filter = NULL;
 
-	if (nla[NFTA_OBJ_TABLE] || nla[NFTA_OBJ_TYPE]) {
-		filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
-		if (!filter)
-			return -ENOMEM;
+	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
+	if (!filter)
+		return -ENOMEM;
 
-		if (nla[NFTA_OBJ_TABLE]) {
-			filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
-			if (!filter->table) {
-				kfree(filter);
-				return -ENOMEM;
-			}
+	if (nla[NFTA_OBJ_TABLE]) {
+		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
+		if (!filter->table) {
+			kfree(filter);
+			return -ENOMEM;
 		}
-
-		if (nla[NFTA_OBJ_TYPE])
-			filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 	}
 
+	if (nla[NFTA_OBJ_TYPE])
+		filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
+
 	cb->data = filter;
 	return 0;
 }
@@ -7817,10 +7813,8 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
 	struct nft_obj_filter *filter = cb->data;
 
-	if (filter) {
-		kfree(filter->table);
-		kfree(filter);
-	}
+	kfree(filter->table);
+	kfree(filter);
 
 	return 0;
 }
-- 
2.43.0



