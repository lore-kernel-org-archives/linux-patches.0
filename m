Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CDB13FEC
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wt1UfbMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2654C433C8;
	Mon, 23 Oct 2023 11:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059192;
	bh=LBXUVVwXmg8BRdc+F6whbzQPTaU6+5R5txK42q2NO0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wt1UfbMXBg+8JpSGhzTDVHtCzriVzx0sAFXeTo3DygLJi6jpiPVS8oMh6Iay/yRXi
	 9XjFgFNYr3jCSxVNB+Ejbha7bcuPUyo4mLg9gyHrskWqKuJmzirrM3PM6YBP99QAcE
	 RJJq2YF2U/CtUDKYQFabs0avh3ThJc3kR+m0A5tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.5 087/241] netfilter: nf_tables: revert do not remove elements if set backend implements .abort
Date: Mon, 23 Oct 2023 12:54:33 +0200
Message-ID: <20231023104836.011436025@linuxfoundation.org>
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

commit f86fb94011aeb3b26337fc22204ca726aeb8bc24 upstream.

nf_tables_abort_release() path calls nft_set_elem_destroy() for
NFT_MSG_NEWSETELEM which releases the element, however, a reference to
the element still remains in the working copy.

Fixes: ebd032fa8818 ("netfilter: nf_tables: do not remove elements if set backend implements .abort")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10336,10 +10336,7 @@ static int __nf_tables_abort(struct net
 				break;
 			}
 			te = (struct nft_trans_elem *)trans->data;
-			if (!te->set->ops->abort ||
-			    nft_setelem_is_catchall(te->set, &te->elem))
-				nft_setelem_remove(net, te->set, &te->elem);
-
+			nft_setelem_remove(net, te->set, &te->elem);
 			if (!nft_setelem_is_catchall(te->set, &te->elem))
 				atomic_dec(&te->set->nelems);
 


