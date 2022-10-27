Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9154D8486
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 16:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1445FC433D6;
	Thu, 27 Oct 2022 16:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666889975;
	bh=F6Pd/si6fN0gWfSPA/tJq+cHEqqdmcT6Xlm67Uv0ESs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4kATu/4Jlc7S9auWkLx4biCKb0Qqn3r+bIc4p4hUsQKo0K6/kuB5pU+ZE809c2zw
	 6L8U1aCwn6B/n1UEWAmU6wO54QQYaO/+lDIbDpVV3Apev8+7WQEjOaeY3aMSACkoSL
	 MOOamsCkplEEm4xEDmi0WUmy4FEvTq8wo1yno5dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 70/94] netfilter: nf_tables: relax NFTA_SET_ELEM_KEY_END set flags requirements
Date: Thu, 27 Oct 2022 18:55:12 +0200
Message-Id: <20221027165100.018359737@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 96df8360dbb435cc69f7c3c8db44bf8b1c24cd7b ]

Otherwise EINVAL is bogusly reported to userspace when deleting a set
element. NFTA_SET_ELEM_KEY_END does not need to be set in case of:

- insertion: if not present, start key is used as end key.
- deletion: only start key needs to be specified, end key is ignored.

Hence, relax the sanity check.

Fixes: 88cccd908d51 ("netfilter: nf_tables: NFTA_SET_ELEM_KEY_END requires concat and interval flags")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 63c70141b3e5..5897afd12466 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5865,8 +5865,9 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
 			  (NFT_SET_CONCAT | NFT_SET_INTERVAL)) {
 		if (flags & NFT_SET_ELEM_INTERVAL_END)
 			return false;
-		if (!nla[NFTA_SET_ELEM_KEY_END] &&
-		    !(flags & NFT_SET_ELEM_CATCHALL))
+
+		if (nla[NFTA_SET_ELEM_KEY_END] &&
+		    flags & NFT_SET_ELEM_CATCHALL)
 			return false;
 	} else {
 		if (nla[NFTA_SET_ELEM_KEY_END])
-- 
2.35.1



