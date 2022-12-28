Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B99A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FF6C433D2;
	Wed, 28 Dec 2022 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240863;
	bh=SpplAcP5SsV8jObAZEOlluCC6KQaKtQuIXsUf0AWnBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1PUa9FIeGY9wnpDiAVca1GCTLNcvqbmA9Lf86UKHgbyFyGG0B2TOFKRyyfsD9YMcN
	 jl75aIMthV253fomg0yM5PdsLBQ0/YEj+E7rx+c9Htsys1s9+0s8jVnjG+GDHUyFfN
	 ttxBW8VeGSy5U32qjk42Qk1v1rxqjwbemMoRMDhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 406/731] padata: Fix list iterator in padata_do_serial()
Date: Wed, 28 Dec 2022 15:38:33 +0100
Message-Id: <20221228144308.336193822@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 57ddfecc72a6c9941d159543e1c0c0a74fe9afdd ]

list_for_each_entry_reverse() assumes that the iterated list is nonempty
and that every list_head is embedded in the same type, but its use in
padata_do_serial() breaks both rules.

This doesn't cause any issues now because padata_priv and padata_list
happen to have their list fields at the same offset, but we really
shouldn't be relying on that.

Fixes: bfde23ce200e ("padata: unbind parallel jobs from specific CPUs")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 9395b77fabb1..c17f772cc315 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -390,13 +390,16 @@ void padata_do_serial(struct padata_priv *padata)
 	int hashed_cpu = padata_cpu_hash(pd, padata->seq_nr);
 	struct padata_list *reorder = per_cpu_ptr(pd->reorder_list, hashed_cpu);
 	struct padata_priv *cur;
+	struct list_head *pos;
 
 	spin_lock(&reorder->lock);
 	/* Sort in ascending order of sequence number. */
-	list_for_each_entry_reverse(cur, &reorder->list, list)
+	list_for_each_prev(pos, &reorder->list) {
+		cur = list_entry(pos, struct padata_priv, list);
 		if (cur->seq_nr < padata->seq_nr)
 			break;
-	list_add(&padata->list, &cur->list);
+	}
+	list_add(&padata->list, pos);
 	spin_unlock(&reorder->lock);
 
 	/*
-- 
2.35.1



