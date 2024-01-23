Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B2164AB3;
	Tue, 23 Jan 2024 01:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975057; cv=none; b=qW24hI7MWlvPOkMa5uuWZ+9M9xAd0s4eCI6u6S8zSrQBy2Yg/MxL+Bhr01NbtaeGs0qDwRhm60pmBkIDg4lOCbqWmWdmLJYy/nbdI08JIPOWsULMb2MiV2Y4EVy6NmFwW256lWL2anGDyQ/Wpo80SJiCL+od4rMBQeoH0xUzrRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975057; c=relaxed/simple;
	bh=Nxzg65ZT5OLhfqhDUJ1JzZRcvBM5DwVqZD+QnlmRqkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3ykaYE2dtWNYFrhaSHSgHYmryXo5hGyW7kCYb2MZO1P6wmKHwOoX0i+VDbki/yiMUs0oFRIYHP1P3sSXIChQa8KxqytFffDAVME4ki48L4Sv3hGTUFrl6lCIyB4vpyoMaXgA8VZBZzfuqnBt/X8IY/aJfVLiWN/GlRm9AMzUgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+6g2g2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+6g2g2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D06EC43394;
	Tue, 23 Jan 2024 01:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975057;
	bh=Nxzg65ZT5OLhfqhDUJ1JzZRcvBM5DwVqZD+QnlmRqkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+6g2g2h9+s4lmteKvE0b625mIPz1s3srYhLl7MAPCVtEQZvTd6K6QTvJUbL7CfKr
	 xJzUpsKm5d4d8wllE1RiZscYEO28TZtqoXApzEKImjSd/jv4hn0iKPj+K+SfkWnetc
	 xOFkPOQA+nSlhsjaTXB4XCEsZ9OYBUgT7wu49Z7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 344/374] netfilter: nf_tables: reject invalid set policy
Date: Mon, 22 Jan 2024 16:00:00 -0800
Message-ID: <20240122235756.890179876@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0617c3de9b4026b87be12b0cb5c35f42c7c66fcb ]

Report -EINVAL in case userspace provides a unsupported set backend
policy.

Fixes: c50b960ccc59 ("netfilter: nf_tables: implement proper set selection")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 54ff4d3bcd54..8a5fca1e61be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4683,8 +4683,16 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	desc.policy = NFT_SET_POL_PERFORMANCE;
-	if (nla[NFTA_SET_POLICY] != NULL)
+	if (nla[NFTA_SET_POLICY] != NULL) {
 		desc.policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
+		switch (desc.policy) {
+		case NFT_SET_POL_PERFORMANCE:
+		case NFT_SET_POL_MEMORY:
+			break;
+		default:
+			return -EOPNOTSUPP;
+		}
+	}
 
 	if (nla[NFTA_SET_DESC] != NULL) {
 		err = nf_tables_set_desc_parse(&desc, nla[NFTA_SET_DESC]);
-- 
2.43.0



