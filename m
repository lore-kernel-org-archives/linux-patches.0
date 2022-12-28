Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99871C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:12:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E53C433EF;
	Wed, 28 Dec 2022 16:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243927;
	bh=4fwTmJSony6tMREeZYaqH9q0yVlRdm4LJSLAbp406no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbZabZzxomQNKUjLQbYaXnGO87d8edcnNUcN/lb7hyg5xcyB2Ve3q5Vd8g/H9J11J
	 +kxiCGURKv6quwtskfU27D0P6rkTH3mlXsCgXxDikRUWil6WNzw35U/TKELgC4b8si
	 IKia+lSrB8mg+xaHruX84ZpbqOf2N7X9w8qwvQZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0617/1073] padata: Fix list iterator in padata_do_serial()
Date: Wed, 28 Dec 2022 15:36:45 +0100
Message-Id: <20221228144344.801669372@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 97f51e0c1776..de90af5fcbe6 100644
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



