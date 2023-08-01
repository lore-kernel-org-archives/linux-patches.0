Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB141F959
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:29:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7CAC433C8;
	Tue,  1 Aug 2023 09:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882166;
	bh=z5MfgUmg5NYljhDHK/+c3C8fb60dUwcSoZgDvTrqHMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5pxhcvuIzBYDlVHmakB8pM8dFRPtFdQ09LTrzCAVTb00hjZO76j1XuCq28mkSGNW
	 vSeg7PffzGz4lWvSqfYi3cHY79g5kwpLkNeZjSPaKt3j6iJziOj2wdvBidYjBwHsjl
	 izUMiW4tnwDD6t7ub5UUVHSLHUsE6BatL0t/0cQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 001/228] netfilter: nf_tables: fix underflow in object reference counter
Date: Tue,  1 Aug 2023 11:17:39 +0200
Message-ID: <20230801091922.862467071@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit d6b478666ffa6d2c25386d78bf1c4640d4da305e upstream.

Since ("netfilter: nf_tables: drop map element references from
preparation phase"), integration with commit protocol is better,
therefore drop the workaround that b91d90368837 ("netfilter: nf_tables:
fix leaking object reference count") provides.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6504,19 +6504,19 @@ static int nft_add_set_elem(struct nft_c
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
+	if (obj) {
+		*nft_set_ext_obj(ext) = obj;
+		obj->use++;
+	}
 	if (ulen > 0) {
 		if (nft_set_ext_check(&tmpl, NFT_SET_EXT_USERDATA, ulen) < 0) {
 			err = -EINVAL;
-			goto err_elem_userdata;
+			goto err_elem_free;
 		}
 		udata = nft_set_ext_userdata(ext);
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
-	if (obj) {
-		*nft_set_ext_obj(ext) = obj;
-		obj->use++;
-	}
 	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs);
 	if (err < 0)
 		goto err_elem_free;
@@ -6571,9 +6571,6 @@ err_set_full:
 err_element_clash:
 	kfree(trans);
 err_elem_free:
-	if (obj)
-		obj->use--;
-err_elem_userdata:
 	nft_set_elem_destroy(set, elem.priv, true);
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)


