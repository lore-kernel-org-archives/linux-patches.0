Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116A112C46E;
	Tue, 30 Apr 2024 10:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473806; cv=none; b=nu+gQs3FFRVksR7ODqRKiBM3ksOiH9Kk6T8fAF2ExIyHKkmgQLHicYWQbpaAxToVJciYIHnTAFr6BKvcbQ3Nd473XYQBn3vzbmWh/JGIjvANT+Z9JHMa1+U5oreZKnFWY32C03u8A3tKhcbJkauQxV5dtGUO/5pm0L3v/9k9xu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473806; c=relaxed/simple;
	bh=AvcuzfNWlSEJHnrEfhqGJwZ6gvV7nw46GXrwYte1vNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZmDE64gUS169PUxWzcC+jtzRiZkro4ROx1rjLZhEPjobOUcbRRIZl6isGTRP0ALsYsTJ9QIDP0xh8NmzXgLux2jGcciWml1UMMOIOAB8J7hrnjEGJyAaaIndhTJOxYLyxNmwaGoZehzB/WyR3ND0bVqqcwNf1td9XQ1r+Oqrg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x35KBOoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x35KBOoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D771C4AF14;
	Tue, 30 Apr 2024 10:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473805;
	bh=AvcuzfNWlSEJHnrEfhqGJwZ6gvV7nw46GXrwYte1vNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x35KBOoSwTN/8WSX5Ple+VZM4iqKnQyUpeioo2be7xp+XxFk01PwCELq5eJ2DKu9X
	 ZKyiNL0T3QhHE8MY7PppY5jneKPk0rEPnrSwa4v1lB1wOpSjMOxf3F9905rNgnys34
	 YGtZRmi6DC7iM+ZDbmZAzBfVHRs0JDnOlUkpTsEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/77] netfilter: nf_tables: __nft_expr_type_get() selects specific family type
Date: Tue, 30 Apr 2024 12:38:56 +0200
Message-ID: <20240430103041.634582331@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 9cff126f73a7025bcb0883189b2bed90010a57d4 ]

In case that there are two types, prefer the family specify extension.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: f969eb84ce48 ("netfilter: nf_tables: Fix potential data-race in __nft_expr_type_get()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dc40222a9e66b..79d0545badcab 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2081,14 +2081,17 @@ EXPORT_SYMBOL_GPL(nft_unregister_expr);
 static const struct nft_expr_type *__nft_expr_type_get(u8 family,
 						       struct nlattr *nla)
 {
-	const struct nft_expr_type *type;
+	const struct nft_expr_type *type, *candidate = NULL;
 
 	list_for_each_entry(type, &nf_tables_expressions, list) {
-		if (!nla_strcmp(nla, type->name) &&
-		    (!type->family || type->family == family))
-			return type;
+		if (!nla_strcmp(nla, type->name)) {
+			if (!type->family && !candidate)
+				candidate = type;
+			else if (type->family == family)
+				candidate = type;
+		}
 	}
-	return NULL;
+	return candidate;
 }
 
 static const struct nft_expr_type *nft_expr_type_get(struct net *net,
-- 
2.43.0



