Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CAF1350CA;
	Tue, 23 Jan 2024 01:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971947; cv=none; b=ExzOXESZQ6Ld6CxnVqO7jRmnltKvzsowv5YqCqS+Bgd9xPDj2c1daQzzNBUkcxqy7s9O2AZepNje7ntRPkR/lvTND4PJyAGuNx1Hq4sY2DoxfO3fnYmv5ezzgCZ3hS9c9aVv5sfah6w7VDiBpFcw+X8kzu1DlXVSYba9rX6jYDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971947; c=relaxed/simple;
	bh=y79POcjDGHVYRzDM78M6MywMhJuK2CmNlQv0YF8tj6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBc1X1oYH06XAksJRv/IeycxHhcRiBBF2bT38o/poUIAlndArN37QnzdavKqpWBD9PU5JfKdKLNN19pVnd/J8xsYso8dKojzNszO9PD+ztHMuRwoUQe0oxcIXJxLpzICS4FnXBZi5TsSYm4LjM2W4EVJiyuz/IP6cJVWfUVd5G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AjSFlRQY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AjSFlRQY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6591FC433F1;
	Tue, 23 Jan 2024 01:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971947;
	bh=y79POcjDGHVYRzDM78M6MywMhJuK2CmNlQv0YF8tj6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AjSFlRQYkekbV0FYCaio0ENX4HkzCLH8FDRUcfGGA26bMIamu0meAbr8ssz0tZOsL
	 jDUn3/KyKVe5hJyJ2vzkTEog1l2PMBZHbcbLzbt7FjEo+zfn68uL8PxwXBFDSkpQ+e
	 p73LAsE6usOQpIUM7Jeo+v86qK2xx+l3ozVIf87Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 271/286] netfilter: nf_tables: do not allow mismatch field size and set key length
Date: Mon, 22 Jan 2024 15:59:37 -0800
Message-ID: <20240122235742.489111964@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e91c743a4d4..009cb23bc972 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4302,8 +4302,8 @@ static int nft_set_desc_concat_parse(const struct nlattr *attr,
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
+	u32 num_regs = 0, key_num_regs = 0;
 	struct nlattr *attr;
-	u32 num_regs = 0;
 	int rem, err, i;
 
 	nla_for_each_nested(attr, nla, rem) {
@@ -4318,6 +4318,10 @@ static int nft_set_desc_concat(struct nft_set_desc *desc,
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



