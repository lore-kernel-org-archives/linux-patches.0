Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9AF1116
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0c7YshEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F80C433C8;
	Mon, 23 Oct 2023 11:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059159;
	bh=jzNGlTmoxwcxyoVFuBKe0q0Klc5hk31NYMg8YOSVb6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0c7YshEALBNPas+wHceA1h1Qcib/V+C23avh0yUXYge+w4Q3vinrcw0lW+h2gxmE5
	 jbrSyIutZB9+MrMLqeixgo3vlZ77TKwUJKH8DyJ0h8M4WH3ww6Y1DeUSVH5lUbRJa7
	 5cTEYgshFCkh8nyALNv4oQ5Kmx5D/wVFoJDVKock=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.5 083/241] netfilter: nf_tables: do not refresh timeout when resetting element
Date: Mon, 23 Oct 2023 12:54:29 +0200
Message-ID: <20231023104835.910201407@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 4c90bba60c26db7dc7df450f748e86440149786e upstream.

The dump and reset command should not refresh the timeout, this command
is intended to allow users to list existing stateful objects and reset
them, element expiration should be refresh via transaction instead with
a specific command to achieve this, otherwise this is entering combo
semantics that will be hard to be undone later (eg. a user asking to
retrieve counters but _not_ requiring to refresh expiration).

Fixes: 079cd633219d ("netfilter: nf_tables: Introduce NFT_MSG_GETSETELEM_RESET")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5553,7 +5553,6 @@ static int nf_tables_fill_setelem(struct
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	unsigned char *b = skb_tail_pointer(skb);
 	struct nlattr *nest;
-	u64 timeout = 0;
 
 	nest = nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
 	if (nest == NULL)
@@ -5589,15 +5588,11 @@ static int nf_tables_fill_setelem(struct
 		         htonl(*nft_set_ext_flags(ext))))
 		goto nla_put_failure;
 
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT)) {
-		timeout = *nft_set_ext_timeout(ext);
-		if (nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
-				 nf_jiffies64_to_msecs(timeout),
-				 NFTA_SET_ELEM_PAD))
-			goto nla_put_failure;
-	} else if (set->flags & NFT_SET_TIMEOUT) {
-		timeout = READ_ONCE(set->timeout);
-	}
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT) &&
+	    nla_put_be64(skb, NFTA_SET_ELEM_TIMEOUT,
+			 nf_jiffies64_to_msecs(*nft_set_ext_timeout(ext)),
+			 NFTA_SET_ELEM_PAD))
+		goto nla_put_failure;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 		u64 expires, now = get_jiffies_64();
@@ -5612,9 +5607,6 @@ static int nf_tables_fill_setelem(struct
 				 nf_jiffies64_to_msecs(expires),
 				 NFTA_SET_ELEM_PAD))
 			goto nla_put_failure;
-
-		if (reset)
-			*nft_set_ext_expiration(ext) = now + timeout;
 	}
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_USERDATA)) {


