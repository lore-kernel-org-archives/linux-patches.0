Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D865770838;
	Mon, 23 Jun 2025 21:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713051; cv=none; b=PVyiFHwDV1UIN6sVbaYWSoZiIN/7LcdQFC4YgmeKye6LkiyBYGS6hee3IT9hX7bd0Sju4e21GLot/NvUlxAtiEH2UXET0qFolDrB0vk8Qti/duHCYuL/QAJdscecu/2HwP8kJsj5tgh5aW4eZwi/hXvgpJ5U2Ihh9wXNMwBWHMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713051; c=relaxed/simple;
	bh=B0u8xqDLcooZ2UHoifr5j3zGCSO0RY4ou3k7odDAPMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbrnygwifHadlQAZl+/HVF+Sp8tfmc+/wtI/okLSHMGdmZRw0dykkWoZ5IQeTQeytkfzHgS9BVNlHdNcvYiY8I5521yx8pRdU6XwS6cbmB78swuRK6z4MKrLBhUq++cZvJN1GXNknWBnuPeU05HYU8Qfr40WJ6+/TLimoCS2sIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcO6RD6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcO6RD6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B95C4CEF0;
	Mon, 23 Jun 2025 21:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713051;
	bh=B0u8xqDLcooZ2UHoifr5j3zGCSO0RY4ou3k7odDAPMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcO6RD6BLu7SJTGjGJ2BkpEupdCyHwWbiPkZ1/vcwbTMho5vu4TGw6JLs8QWWXSwn
	 VVxHlYarvxOSATn0uzTwNYpU3WKCWPG+PkYl63/FYuxOVTOwj5A/rlqbzWxCstcU3F
	 31Awtl45Bm5emgpbssLS93o9F7YSU3hO/wQ62rao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/508] netfilter: nft_tunnel: fix geneve_opt dump
Date: Mon, 23 Jun 2025 15:02:20 +0200
Message-ID: <20250623130647.597382043@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 22a9613de4c29d7d0770bfb8a5a9d73eb8df7dad ]

When dumping a nft_tunnel with more than one geneve_opt configured the
netlink attribute hierarchy should be as follow:

 NFTA_TUNNEL_KEY_OPTS
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 |  |
 |  |--NFTA_TUNNEL_KEY_GENEVE_CLASS
 |  |--NFTA_TUNNEL_KEY_GENEVE_TYPE
 |  |--NFTA_TUNNEL_KEY_GENEVE_DATA
 |
 |--NFTA_TUNNEL_KEY_OPTS_GENEVE
 ...

Otherwise, userspace tools won't be able to fetch the geneve options
configured correctly.

Fixes: 925d844696d9 ("netfilter: nft_tunnel: add support for geneve opts")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_tunnel.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index d026982a00fc4..be741db50ffae 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -617,10 +617,10 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 		struct geneve_opt *opt;
 		int offset = 0;
 
-		inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
-		if (!inner)
-			goto failure;
 		while (opts->len > offset) {
+			inner = nla_nest_start_noflag(skb, NFTA_TUNNEL_KEY_OPTS_GENEVE);
+			if (!inner)
+				goto failure;
 			opt = (struct geneve_opt *)(opts->u.data + offset);
 			if (nla_put_be16(skb, NFTA_TUNNEL_KEY_GENEVE_CLASS,
 					 opt->opt_class) ||
@@ -630,8 +630,8 @@ static int nft_tunnel_opts_dump(struct sk_buff *skb,
 				    opt->length * 4, opt->opt_data))
 				goto inner_failure;
 			offset += sizeof(*opt) + opt->length * 4;
+			nla_nest_end(skb, inner);
 		}
-		nla_nest_end(skb, inner);
 	}
 	nla_nest_end(skb, nest);
 	return 0;
-- 
2.39.5



