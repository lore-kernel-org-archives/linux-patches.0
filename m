Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC02B14078B;
	Tue, 23 Jan 2024 01:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972035; cv=none; b=tllt40iV5eRogsFspMfWptchGQ44cGQsO9Jzzmt/8G4hxPbXnD2nlhckjbJKMbXZVlA/nK2q2OHYsbu7kLgpvFYZ9Qsh0Ewky/MxEbrW20sun7+6svhN8dfgv1mycot1UcZUNGDsE5lppsDQuNtyrPmf0P4qK7p9ebx/pnClG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972035; c=relaxed/simple;
	bh=cLzEALmtj2LJDL1IVpPPsxy8py4eL00HbY25lMyZvGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9jl47zQObOJYGqJ4KXii1baWytDabdAWhNz2fCjmjNFGvcgu1j1ttp9a1HGS5hW7lhaBlstcC2u2t/0ehNJvof+pVa/QDLmWCuDTWuvVV+khwrs5vUFK+f1C5iAFSvIeOoKz8bjWkIovpN/RaSEECfwFQA3B0HyTLckRVVYycM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/Ed3MO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/Ed3MO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891A9C433F1;
	Tue, 23 Jan 2024 01:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972035;
	bh=cLzEALmtj2LJDL1IVpPPsxy8py4eL00HbY25lMyZvGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/Ed3MO8hfuwgKpRQg08hXeJjIvZ8Y0xTzpJfXRkTs0PaY78nw7QJDl3PYLYJs1yh
	 twNzxcDBgqF2QOxRpJi+aweMib/zK+qw0H+hZ1J7aeD9rDYnhCC6bspnskDbOqTyqC
	 Tz02ibKICglipn1egFxq6n8pHrJpgY5VlnFIPMk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 404/417] netfilter: nf_tables: do not allow mismatch field size and set key length
Date: Mon, 22 Jan 2024 15:59:32 -0800
Message-ID: <20240122235805.717115881@linuxfoundation.org>
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

[ Upstream commit 3ce67e3793f48c1b9635beb9bb71116ca1e51b58 ]

The set description provides the size of each field in the set whose sum
should not mismatch the set key length, bail out otherwise.

I did not manage to crash nft_set_pipapo with mismatch fields and set key
length so far, but this is UB which must be disallowed.

Fixes: f3a2181e16f1 ("netfilter: nf_tables: Support for sets with multiple ranged fields")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 98f1d42dd436..364767778102 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4523,8 +4523,8 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
+	u32 num_regs = 0, key_num_regs = 0;
 	struct nlattr *attr;
-	u32 num_regs = 0;
 	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
@@ -4539,6 +4539,10 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
 	for (i = 0; i < desc->field_count; i++)
 		num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
 
+	key_num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
+	if (key_num_regs != num_regs)
+		return -EINVAL;
+
 	if (num_regs > NFT_REG32_COUNT)
 		return -E2BIG;
 
-- 
2.43.0



