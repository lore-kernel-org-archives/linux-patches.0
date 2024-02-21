Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA913EA71;
	Wed, 21 Feb 2024 13:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521151; cv=none; b=ZYP3bOZtlsCTpIF8f10uVv19aqDMQz8rS+vaKiFYzKqZ+8nepdT+z7QfyuFO19vJDl3Mn7NRnOcBCn/1WiF0zxZRh7YlaMvgqicDYOxPAXz7toR67e9ohDK32i9jMXycUwMeZ/BDeAwYRrk0YUWNKDLLy9+poI8SMvnNk5Tv6bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521151; c=relaxed/simple;
	bh=rH8ollqpuPtxXPV3EAAbDp7T3EulW9tTgNV4GrSMHus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEg9RHvCrBtZg0S7LR1GhUu/5Kd5+/IOT1UNUlLhuyHKWTTBoAM1N4qFfGcpUPNbR7APZ4/gw2lqTNP5fng8qpcvE5ebCQv4Z5nzRRKjdmaIwGgHKkeCSFDASCAHL0MqvJCTs40LLKmm7UbcDoEE+gBFK1MLly8n/UGXEWzd3Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSA0yO3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSA0yO3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE75C433C7;
	Wed, 21 Feb 2024 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521151;
	bh=rH8ollqpuPtxXPV3EAAbDp7T3EulW9tTgNV4GrSMHus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSA0yO3xFAYtViRv4EiUtAllSMPHortuwgr3NaD9mZJPCh+8TY+ltrFlTd/uT0ydx
	 +5eRBrA8350riL99reAA/nkdbAhca3Hj5HEGZHJsYLe/Tb5pgeMS1PoEqMbfJqCPGV
	 IVxduBByfdPw2rcqSU/sWiDLgDlvW1q977SYHonY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/202] netfilter: nf_tables: restrict anonymous set and map names to 16 bytes
Date: Wed, 21 Feb 2024 14:05:35 +0100
Message-ID: <20240221125932.896992620@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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
index e0c224dea316..4465b832305f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -26,6 +26,7 @@
 #include <net/sock.h>
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
+#define NFT_SET_MAX_ANONLEN 16
 
 unsigned int nf_tables_net_id __read_mostly;
 
@@ -3184,6 +3185,9 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
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



