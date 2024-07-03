Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5DE21741FC;
	Wed,  3 Jul 2024 10:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003604; cv=none; b=rH3yCu/5o80zn1VPnFTj8nwJy/FOrDeq14nrH+/LvdwT9qlx9acjeWXtZSXl0YfSsYwtYZAh1UppTw91w927y06IJNjTnTP71IoG3tXP1KhUoeg31bNvQbHJyTV6UrtnMV30IPrJmwLPKZeR57DQzKqb1Kx8otn1XB+35Hg8Kxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003604; c=relaxed/simple;
	bh=+5nrnRPEeMwDgx+CyuYYqiT7T9XRr9l1pB3t5e4EVu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8A2lGDIQCPGfLMp8AjIWhAmYlXLa6hDonKm1rijgHGUt2/PzouFgBh2qbtZ9XMZrZ02bC2Znoyak/oTlp1bYjTNO8L5H3pxD6cbJlUB0m0wBTv+Y5qRUffQ7d5NXLJyTcJsii/vYNVK6lPqsGNGEe6yDAp7IxqFhkuxV0tc2Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C0bKZiUt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C0bKZiUt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA90C2BD10;
	Wed,  3 Jul 2024 10:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003604;
	bh=+5nrnRPEeMwDgx+CyuYYqiT7T9XRr9l1pB3t5e4EVu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C0bKZiUtErLC1kg5SJhwU5Pm3X3efv3zDfhIlhsRQgWkEO0Kp2voD0R3o0tK/vPz5
	 h8amYlylowZ3Gtlls+K5IiVv9g+cU7jHMceRmPH2Zh95OdB0c6RkDr8gpWqF0EukH+
	 6B355BnZgXHYGjob34sPk+WhqwlywW6ygraAJbiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 104/139] netfilter: nf_tables: validate family when identifying table via handle
Date: Wed,  3 Jul 2024 12:40:01 +0200
Message-ID: <20240703102834.369840428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
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

[ Upstream commit f6e1532a2697b81da00bfb184e99d15e01e9d98c ]

Validate table family when looking up for it via NFTA_TABLE_HANDLE.

Fixes: 3ecbfd65f50e ("netfilter: nf_tables: allocate handle and delete objects via handle")
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 198e4a89df481..2c31470dd61f5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -536,7 +536,7 @@ static struct nft_table *nft_table_lookup(const struct net *net,
 
 static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 						   const struct nlattr *nla,
-						   u8 genmask)
+						   int family, u8 genmask)
 {
 	struct nftables_pernet *nft_net;
 	struct nft_table *table;
@@ -544,6 +544,7 @@ static struct nft_table *nft_table_lookup_byhandle(const struct net *net,
 	nft_net = net_generic(net, nf_tables_net_id);
 	list_for_each_entry(table, &nft_net->tables, list) {
 		if (be64_to_cpu(nla_get_be64(nla)) == table->handle &&
+		    table->family == family &&
 		    nft_active_genmask(table, genmask))
 			return table;
 	}
@@ -1189,7 +1190,7 @@ static int nf_tables_deltable(struct net *net, struct sock *nlsk,
 
 	if (nla[NFTA_TABLE_HANDLE]) {
 		attr = nla[NFTA_TABLE_HANDLE];
-		table = nft_table_lookup_byhandle(net, attr, genmask);
+		table = nft_table_lookup_byhandle(net, attr, family, genmask);
 	} else {
 		attr = nla[NFTA_TABLE_NAME];
 		table = nft_table_lookup(net, attr, family, genmask);
-- 
2.43.0



