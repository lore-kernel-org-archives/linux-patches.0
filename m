Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3C01F95E
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C391DC433C7;
	Tue,  1 Aug 2023 09:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882194;
	bh=jGKJpD6M0TC2vV1WXeIakEgJBBgv2dXs6auc2y7U47U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGKoHmEvNkhvWB7bZ42lQ+zEVCodI6Kn9QTGsSgZbTk1I9pYiyjSIFNTNBs1wqE0f
	 9+2TZLzBBa2b1qbcQgBS485ZmqR57hPSP9MrjDbqXAu5F1xnkG4tfQJCQCQvTiwZhc
	 4C8J6V95wTsafrCqefhQBiLp4p3pXYuUCGMGoV+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 002/228] netfilter: nf_tables: fix underflow in chain reference counter
Date: Tue,  1 Aug 2023 11:17:40 +0200
Message-ID: <20230801091922.894919441@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit b389139f12f287b8ed2e2628b72df89a081f0b59 upstream.

Set element addition error path decrements reference counter on chains
twice: once on element release and again via nft_data_release().

Then, d6b478666ffa ("netfilter: nf_tables: fix underflow in object
reference counter") incorrectly fixed this by removing the stateful
object reference count decrement.

Restore the stateful object decrement as in b91d90368837 ("netfilter:
nf_tables: fix leaking object reference count") and let
nft_data_release() decrement the chain reference counter, so this is
done only once.

Fixes: d6b478666ffa ("netfilter: nf_tables: fix underflow in object reference counter")
Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6571,7 +6571,9 @@ err_set_full:
 err_element_clash:
 	kfree(trans);
 err_elem_free:
-	nft_set_elem_destroy(set, elem.priv, true);
+	nf_tables_set_elem_destroy(ctx, set, elem.priv);
+	if (obj)
+		obj->use--;
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&elem.data.val, desc.type);


