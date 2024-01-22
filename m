Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED93D14078B;
	Tue, 23 Jan 2024 01:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972037; cv=none; b=rsqUvcJI9qM/iO9oG3oV0ucrJQzkm6prepVft1Pz6Fvl5lZM2zDEmQqHQe6G8eRMuCNEnAN2hx/WO90bBI/Ktf/gi4BgbgYn771XAF8LyGVI+e92HZJ89cKMlbB+5v+A7qOzS5j9C24jyPMq4jxhFma1pbp++eLsYYIRD43RCVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972037; c=relaxed/simple;
	bh=4ErnoByCH0LSa4SZDuAE6XTY3e2hpdDs+qHpfwA5+JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmBauRlGXzl1Kt7W+73UdJImCMSudwUjt5BQd0SbrqcuhgamOBLHfPVvcadOPhBD0ydEQI4eN6Zw8JQyZ9KLPWGICKCDB6uB7f3vXuTkh/Mu+T8n81QYRhKzmH+2tbGtaq6TpEvLBuxUpChrbph5fcPJLCNDAXZykWFoTEOuC9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4ir76tM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4ir76tM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC47C433C7;
	Tue, 23 Jan 2024 01:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972036;
	bh=4ErnoByCH0LSa4SZDuAE6XTY3e2hpdDs+qHpfwA5+JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4ir76tMLN7G7Eu6TCV7axGf2B65ziVGoDclIgHy6mgo7f3q1vMwjfzKN992v2nv8
	 oU2sLi9warLtfTBpkFkA3P7t5LG6LqfzVgtUg04150DHDBDQwaDzCFVut92KKVxgFg
	 MKfTg6U5wIZKV1Y75uM8Ytp7AyJ91EdljszsFZnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 405/417] netfilter: nf_tables: skip dead set elements in netlink dump
Date: Mon, 22 Jan 2024 15:59:33 -0800
Message-ID: <20240122235805.748921333@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 6b1ca88e4bb63673dc9f9c7f23c899f22c3cb17a ]

Delete from packet path relies on the garbage collector to purge
elements with NFT_SET_ELEM_DEAD_BIT on.

Skip these dead elements from nf_tables_dump_setelem() path, I very
rarely see tests/shell/testcases/maps/typeof_maps_add_delete reports
[DUMP FAILED] showing a mismatch in the expected output with an element
that should not be there.

If the netlink dump happens before GC worker run, it might show dead
elements in the ruleset listing.

nft_rhash_get() already skips dead elements in nft_rhash_cmp(),
therefore, it already does not show the element when getting a single
element via netlink control plane.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 364767778102..a4e5d877956f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5418,7 +5418,7 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_set_dump_args *args;
 
-	if (nft_set_elem_expired(ext))
+	if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext))
 		return 0;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);
-- 
2.43.0



