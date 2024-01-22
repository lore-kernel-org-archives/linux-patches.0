Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84000130E42;
	Tue, 23 Jan 2024 00:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969072; cv=none; b=XIIIAps4/G9ayGSSuptVlaaAWadWWC9EZ9nDX3cnSc3325WJqU1N/GP1j/MMdzkB/OK2Bq10cZWv6fF/kEy6blI1ny//YVcw0k4yrg9/kTQnac96c7la+X5ojZ9Ki3V3k7/eQEi2Z3/7DZd0cqVZu2zWh4mqAQc5pXRKluD2TqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969072; c=relaxed/simple;
	bh=zsT9fnxeonylgpTLXSZ4KNHURGBv5NUVBMJmqQNCOZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OFAkw8NWR9gYI3538PFlZf8HtGFTcikWz2rc2nIIG1HKYfdIictIakabBgiKklB8jQydntAAKIMsmCdCx7ZSrNuZKTKiTfLGtRdjWhw7W9l1sPS5zPjAToT7XedRja/oGSwC3Z/isbR2vWf4awOtbC61VV9jT2EUMANxBBIlUGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPJR4+f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPJR4+f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A7DC433C7;
	Tue, 23 Jan 2024 00:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969072;
	bh=zsT9fnxeonylgpTLXSZ4KNHURGBv5NUVBMJmqQNCOZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPJR4+f7qih7ftknuhDctvD/H1ybUSClNMRV5+rOMdNSRm+pWx3PW+M1skmTpMPP2
	 oC5Ninuhpt/HtaLxeQSDOEbayhrij5Un+YHrYaqZURRHMNRaWjWn1Fv4wJDwzd7xyZ
	 ureE54AOmg87NafqbhlUEzMN5r2RGMpZdaz8Rj3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 187/194] netfilter: nf_tables: skip dead set elements in netlink dump
Date: Mon, 22 Jan 2024 15:58:37 -0800
Message-ID: <20240122235727.238953479@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9bd8ed0b62f1..534126f3687b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4326,7 +4326,7 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_set_dump_args *args;
 
-	if (nft_set_elem_expired(ext))
+	if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext))
 		return 0;
 
 	args = container_of(iter, struct nft_set_dump_args, iter);
-- 
2.43.0



