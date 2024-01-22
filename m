Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3B74E1D0;
	Tue, 23 Jan 2024 00:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970294; cv=none; b=nvJAkuTi8xDA02tG0sDKQRA4RDvIMIbVMdoQ9F4mPIqwd0MkuEvXzT4rmGMz24ziRJ8KZPyC8qgrGPb5V3N5pQ4+a7JIg7Oc+jFzdbga3x4JoP/+mJhF9PhX+xo9HLC7OEUzPmRPqbpwhuMl6t1exT3uIOg69FV+Rj/FOQaQ9x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970294; c=relaxed/simple;
	bh=HNgLwruE2VUB0TxecPIfPPXyaNef6EXiYbtG+WUuz5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DUpwfT7rXQrtE1zURWdypq9q0XiXs5b0x952es+hQQsel04BXg9drN3/+HuZ+kz+ngPDog58v67/b1RVRFWdRqkmqmMeUckW+KsYS4ig23kfq9N1rlyFoKbVCvi3L8eMmjEvYpI9EJO8CkIgf36R9Zvo/LqT2iEJqnmMAMHPpKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1dPirQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1dPirQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7275CC433F1;
	Tue, 23 Jan 2024 00:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970293;
	bh=HNgLwruE2VUB0TxecPIfPPXyaNef6EXiYbtG+WUuz5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M1dPirQbkoE4b2WVSYfN44EA0kAx3iqFi0YQVrEnu3YA7ulqoa7CNgfllGrxBs541
	 FIUZW+kHb8SRlKljsySXirrmKSTdMcms4ROgHcgo3jbvz/v4eRpxQxToEfgS6SsNVW
	 KxulbjEbZhxPYg5wjPtFSCDFFaYT4TMl897kGdeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 626/641] netfilter: nf_tables: skip dead set elements in netlink dump
Date: Mon, 22 Jan 2024 15:58:50 -0800
Message-ID: <20240122235837.849021487@linuxfoundation.org>
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
index 7775bf5224ac..47ffb9e4c353 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5716,7 +5716,7 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem_priv);
 	struct nft_set_dump_args *args;
 
-	if (nft_set_elem_expired(ext))
+	if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext))
 		return 0;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);
-- 
2.43.0



