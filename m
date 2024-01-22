Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28611634F8;
	Tue, 23 Jan 2024 01:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975031; cv=none; b=ppIOhaFYYqh6rRduxRXyQuNEG5PD/D3aOq3YI0UcgY37wymfNQkR/AKI7MCqYfKXSb73+dh4qSMRfX78TnPj+p7GhankY/NDI5zkkgsTX8cjLRscDOyrnuaUOEOTjJgakkD+8CVvKpLdu/WLBDkaRP+mD/KRppTkYhmE58XUAIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975031; c=relaxed/simple;
	bh=6vwed6qBaQLZo5hIn9MPzQU7owEY++EMsV1PATlaDMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbNrK4YHBBJ/nmJZPkaFjWP04Ribj/JNUmeylxCKsXupjEC6hXjF3AehiL4Ct6Cy6xZY2oChfFJ2Me1JMfT+E8afbpH2P5Fs2jSl5wHfX0Pg0/czdCR9tVBw+NadZOOrjiKGSFcK44B5i4rjWalca4lEVhyiHGExR9zbOTrmzRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsMSnwvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsMSnwvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A20BC43390;
	Tue, 23 Jan 2024 01:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975030;
	bh=6vwed6qBaQLZo5hIn9MPzQU7owEY++EMsV1PATlaDMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsMSnwvxG3tUC92wug7j/zL1lvUvuJeAQyLINu+KXBnhCYxi7qvGgIri34ypiotFR
	 5mWpxXuyQ2SOi1lFHBzw8tCR25NOcOm2Hscf+02SPolFmPNaID06GSpAoPsqMKiQXW
	 womrt2C4RLAeAMgjrT0l1JUi1j/UtYY9Pc0yZl7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/583] netfilter: nf_tables: validate chain type update if available
Date: Mon, 22 Jan 2024 15:54:15 -0800
Message-ID: <20240122235818.238627247@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 24cad36565d7..5822912045ef 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2263,7 +2263,16 @@ static int nft_chain_parse_hook(struct net *net,
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



