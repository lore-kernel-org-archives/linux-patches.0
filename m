Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7782A154C05;
	Tue, 23 Jan 2024 00:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969401; cv=none; b=YA+rTVpAUvWflIp9qqb9EuWNRAbyn8qmFSQOC7UIupj+S0V/JWPOhtnkZRRSko1JZh4GzEWjRaRbG+WsBWb72JPxafVOZ0XAF5YFu+13Jm4sew3LtLdC2oo1BpwwOo9V7Ymv8XAqHUp9XSbB96tgz9K3I3UVvpwxoxEg6Q1rOjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969401; c=relaxed/simple;
	bh=Qzy729f9Xb+K4S2r+oCudkbkloQljandwiiHRPtE+Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e632f1P0w3IihvOPGESaPAKauZ6pMQsvPv8PXvvi0eIz0fM3wlGLsGiDKUaSL9d7NV39dYHfzGRpeAsJXi/y54Qo4+oT+rKO97JctBCWCFB1t/ZTK8NBoVHMbCeYxYwlvoOwh03yH28u0GwQkKTb9eZvvaRjo48CMtGh7HsC3BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBtlUT4D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBtlUT4D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9C7C43390;
	Tue, 23 Jan 2024 00:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969401;
	bh=Qzy729f9Xb+K4S2r+oCudkbkloQljandwiiHRPtE+Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBtlUT4DbGldnxj3z6AhnIZS7wmvFyLKrDBHqYHFU0/jXHtJlcn+p4zvDg2lgRice
	 ZyFCr/AwSj0ZTgtA+PThVIBE7aEdmAZyxvqdUAWI54HSDCJv+pgE2+mQh2Mxy7oN9+
	 65Te6KfrvMKr90iefM6UTzOa3UzTZM/tLy+2O1bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 222/641] netfilter: nf_tables: validate chain type update if available
Date: Mon, 22 Jan 2024 15:52:06 -0800
Message-ID: <20240122235824.887122851@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit aaba7ddc8507f4ad5bbd07988573967632bc2385 ]

Parse netlink attribute containing the chain type in this update, to
bail out if this is different from the existing type.

Otherwise, it is possible to define a chain with the same name, hook and
priority but different type, which is silently ignored.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bbb8d8533f77..d5f76e26ae03 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2261,7 +2261,16 @@ static int nft_chain_parse_hook(struct net *net,
 				return -EOPNOTSUPP;
 		}
 
-		type = basechain->type;
+		if (nla[NFTA_CHAIN_TYPE]) {
+			type = __nf_tables_chain_type_lookup(nla[NFTA_CHAIN_TYPE],
+							     family);
+			if (!type) {
+				NL_SET_BAD_ATTR(extack, nla[NFTA_CHAIN_TYPE]);
+				return -ENOENT;
+			}
+		} else {
+			type = basechain->type;
+		}
 	}
 
 	if (!try_module_get(type->owner)) {
-- 
2.43.0



