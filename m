Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF2269942;
	Wed, 21 Feb 2024 14:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525028; cv=none; b=F8qiSNje3gytSeaX4Lvv/nyUpOlB1wjV975mONhkftfkX8otn8k4unI5T5k4irhvFfL8jIy9Mc/WyPtvbxN5q6UOeN/EJf2JHQZ0olwdafrCFg2Rr7wUu/9DMt3nlfermm879ufSE9aQB/QzYi5nFfXq6xv+v9HJh5JDNzUqQj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525028; c=relaxed/simple;
	bh=RovVNGdt3j+glhWlc2bhQzDLqW0OQDMts8/IkPTElDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=emi8dGWk+I1INfouBWIT+OtYz1iC68+Ra9FCYra575TYKHcn5KqA7ra+wDvnYc8rcMqRwXCGg57OcqxcjWQsWlKz/xzx+c2qjnG7bxXBfzZns3m9tVLD2EIVlB8rkaI7f79gPvovLDdjR9WyGybAyy5bT/Tz0ofm7295BYIes9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPAY7zNp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPAY7zNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1328C433C7;
	Wed, 21 Feb 2024 14:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525028;
	bh=RovVNGdt3j+glhWlc2bhQzDLqW0OQDMts8/IkPTElDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPAY7zNpUEwjB+EkFcwfcpeF/QXGqnmGKWBiNIMaeZ2LN5UdWR7VcC907XJdN9k7p
	 NenQ7XASJhclvXFIcoZkPO5JXe3xpZkHqBeqCoa30iHEoPJt3uZO9PXSc/YJGCBi7Z
	 /14B6N4heOAmdmIbDD878Hb4jbJEmcqPIz1CZ5SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 038/267] netfilter: nf_tables: restrict anonymous set and map names to 16 bytes
Date: Wed, 21 Feb 2024 14:06:19 +0100
Message-ID: <20240221125941.221121311@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b462579b2b86a8f5230543cadd3a4836be27baf7 ]

nftables has two types of sets/maps, one where userspace defines the
name, and anonymous sets/maps, where userspace defines a template name.

For the latter, kernel requires presence of exactly one "%d".
nftables uses "__set%d" and "__map%d" for this.  The kernel will
expand the format specifier and replaces it with the smallest unused
number.

As-is, userspace could define a template name that allows to move
the set name past the 256 bytes upperlimit (post-expansion).

I don't see how this could be a problem, but I would prefer if userspace
cannot do this, so add a limit of 16 bytes for the '%d' template name.

16 bytes is the old total upper limit for set names that existed when
nf_tables was merged initially.

Fixes: 387454901bd6 ("netfilter: nf_tables: Allow set names of up to 255 chars")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 534126f3687b..49e4ffa33a4e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -24,6 +24,7 @@
 #include <net/sock.h>
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
+#define NFT_SET_MAX_ANONLEN 16
 
 unsigned int nf_tables_net_id __read_mostly;
 EXPORT_SYMBOL_GPL(nf_tables_net_id);
@@ -3395,6 +3396,9 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		if (p[1] != 'd' || strchr(p + 2, '%'))
 			return -EINVAL;
 
+		if (strnlen(name, NFT_SET_MAX_ANONLEN) >= NFT_SET_MAX_ANONLEN)
+			return -EINVAL;
+
 		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
 		if (inuse == NULL)
 			return -ENOMEM;
-- 
2.43.0



