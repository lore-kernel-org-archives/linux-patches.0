Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5927149C4F;
	Tue, 25 Jun 2024 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309418; cv=none; b=aulw4J3cPHGWOg99BDdS/WHtxJ+lJi9ncbM3r/Net1yBBLfK7Jxa7CHq+w7dQb5YHv047nsLmgX+4L19jbw78yNKlY/ZYQHmp73NzBB2Aelva/h8K5e+YyEoNzUyKbq72RVKEZaa8WJigr0pkYj7IuOVOog3OsrpxedK02oEQqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309418; c=relaxed/simple;
	bh=rzJ6dUiH/B1GkM+Ec9zHWnlzBe+jJYrb/GC1yT5Hn1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cteQyQJXzNvNTKB0nyBmpl2jmp7/KvfseL4FHVXz0+hE24Cbe+XVuW5/MZj3jlUoa9qdIZayNylcQD/lgZNkmyDi5m02lCgbVZC4QdbOPkQqk29XK33f7azDCpQ+yTVgIzxXUy76cjPprM7jhXCsU7ZLcM0l5goL6vBwLyaGzjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NETBclKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NETBclKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21124C32781;
	Tue, 25 Jun 2024 09:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309417;
	bh=rzJ6dUiH/B1GkM+Ec9zHWnlzBe+jJYrb/GC1yT5Hn1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NETBclKG8dU/Obq2scJejraAVHAikEVPLJvsFvihTgAYWYTPhrino93VJ/i0ecSPh
	 XGHv+QFl2IeLPM6F5q6K29eoy0J5Fro3PBx+kOkz5FS0rbYBLMKPvRjt65aVtmUrnK
	 z4UfqHTe24ImIWfIAQgtV9bn6gxbOLF83W5EkVwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/131] padata: Disable BH when taking works lock on MT path
Date: Tue, 25 Jun 2024 11:32:36 +0200
Message-ID: <20240625085525.990952244@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 58329c4312031603bb1786b44265c26d5065fe72 ]

As the old padata code can execute in softirq context, disable
softirqs for the new padata_do_mutithreaded code too as otherwise
lockdep will get antsy.

Reported-by: syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 7bef7dae3db54..0261bced7eb6e 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -98,7 +98,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 {
 	int i;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	/* Start at 1 because the current task participates in the job. */
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
@@ -108,7 +108,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 
 	return i;
 }
@@ -126,12 +126,12 @@ static void __init padata_works_free(struct list_head *works)
 	if (list_empty(works))
 		return;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	list_for_each_entry_safe(cur, next, works, pw_list) {
 		list_del(&cur->pw_list);
 		padata_work_free(cur);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 }
 
 static void padata_parallel_worker(struct work_struct *parallel_work)
-- 
2.43.0



