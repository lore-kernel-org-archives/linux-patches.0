Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79581DF27B;
	Tue,  8 Oct 2024 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391482; cv=none; b=kF/FS2UzOIFpJDRKe8NdvXktdARKv/y+lX7C+2MBDK9xVATaE9RNpHFAIUjeEJYo4VGfAhfCr+R33JchnVG4qybXv73WPUlxpkL7xuld5UKMa/QVzCO3QMxfkmtkyBSJqQMew8rNi24GgwXxGVKmkvaYXBdyTLuZ8JhMb6A7TVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391482; c=relaxed/simple;
	bh=4JP6GSQeMEW4nwtHmA8KJHm437ITSvPSHT9GhEB0ju0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rF8HuXmqDIdJ22Stsr7QK/vRqwYI9l5ia9+6+LrGwiOBwiFTWoF3Sl/CRSeb4o+i6KaFrTZoqPVkF8klxky7GqTaepaffCfqL4KoG+zbwZj9AEpUPyFOo+LdzuFpxUGOzvRk3nXxHNvvTcEN5J3vqcSQZJdOdDHYoMMtbjZLT1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WH3CA3qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WH3CA3qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11066C4CEC7;
	Tue,  8 Oct 2024 12:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391482;
	bh=4JP6GSQeMEW4nwtHmA8KJHm437ITSvPSHT9GhEB0ju0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH3CA3qtYR7/lnhE0QhaWBOMOvvi/eLuRiKb5p1IMMZP55jc59loZyMSpX8ooEMkY
	 2dABJPaiB7WX814CnxW+UamDebQ3r8RmPfE14Ls1pG6V3vN1/Hl5h+U9oNsty2tsA7
	 LmIvfT43rN5add/1J9yqTpQowRsVTKAaeapeshFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 128/558] netfilter: nf_tables: do not remove elements if set backend implements .abort
Date: Tue,  8 Oct 2024 14:02:38 +0200
Message-ID: <20241008115707.401640688@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c9526aeb4998393171d85225ff540e28c7d4ab86 ]

pipapo set backend maintains two copies of the datastructure, removing
the elements from the copy that is going to be discarded slows down
the abort path significantly, from several minutes to few seconds after
this patch.

This patch was previously reverted by

  f86fb94011ae ("netfilter: nf_tables: revert do not remove elements if set backend implements .abort")

but it is now possible since recent work by Florian Westphal to perform
on-demand clone from insert/remove path:

  532aec7e878b ("netfilter: nft_set_pipapo: remove dirty flag")
  3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
  a238106703ab ("netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone")
  c5444786d0ea ("netfilter: nft_set_pipapo: merge deactivate helper into caller")
  6c108d9bee44 ("netfilter: nft_set_pipapo: prepare walk function for on-demand clone")
  8b8a2417558c ("netfilter: nft_set_pipapo: prepare destroy function for on-demand clone")
  80efd2997fb9 ("netfilter: nft_set_pipapo: make pipapo_clone helper return NULL")
  a590f4760922 ("netfilter: nft_set_pipapo: move prove_locking helper around")

after this series, the clone is fully released once aborted, no need to
take it back to previous state. Thus, no stale reference to elements can
occur.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 472f211472db4..e792f153f9587 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10795,7 +10795,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				break;
 			}
 			te = nft_trans_container_elem(trans);
-			nft_setelem_remove(net, te->set, te->elem_priv);
+			if (!te->set->ops->abort ||
+			    nft_setelem_is_catchall(te->set, te->elem_priv))
+				nft_setelem_remove(net, te->set, te->elem_priv);
+
 			if (!nft_setelem_is_catchall(te->set, te->elem_priv))
 				atomic_dec(&te->set->nelems);
 
-- 
2.43.0



