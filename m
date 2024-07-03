Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3825061FDF;
	Wed,  3 Jul 2024 11:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004626; cv=none; b=X1lgOvlDiWdzCZFCUzQpHFpboYJhv+knkXMXecnuvB7G8JbgaaK1dEiiF1cji51SJea9g4Z1I8b/rruwiWHrbxpIghczzUOkZekb+ZfuyBifLuZDOgCWCaqbmvcwUk7ZgHwn1zBdXj6S+UTUNuCh7H2lsayALI1uk2DUCd6u3Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004626; c=relaxed/simple;
	bh=dvAoAgdHNcfsR6OJ/nwCkbjowitMxhcwF3fj6FLnubI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUcC1zxqeIA0LpuVlvEfmozHZcZVfg2gQKuwtyjdFUlMbRXc/WA2Z8Od/xQQizkNkPTVysH5M9kEbcS8w0UKwAlw7mff0PDKEikPbn6WjH1Ifh1Xx7QO+gSsb1S4X4xvfeS9+AVK4H3N9vdhvAsgpWYbj6+CK2aPG90o6CD95Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEmv3xTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEmv3xTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD8DC2BD10;
	Wed,  3 Jul 2024 11:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004626;
	bh=dvAoAgdHNcfsR6OJ/nwCkbjowitMxhcwF3fj6FLnubI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEmv3xTEN3Qnb9wlBHObYMnxX5HH1Dgwo6AjIhBhMTv4iP+ue4jKWRZYjAh3jy5Q4
	 wa+nPvJUS+hpCJT7ZDIqR5UFd9cXerspy4e9ghM88CRvbxLHBuBDGVAqKLwl4r8jyF
	 BEOs5AetlV/fMgg0SpcphauzlHilG/3w9lvmSi40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/290] padata: Disable BH when taking works lock on MT path
Date: Wed,  3 Jul 2024 12:38:06 +0200
Message-ID: <20240703102908.162062039@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fdcd78302cd72..471ccbc44541d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -111,7 +111,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 {
 	int i;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	/* Start at 1 because the current task participates in the job. */
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
@@ -121,7 +121,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 
 	return i;
 }
@@ -139,12 +139,12 @@ static void __init padata_works_free(struct list_head *works)
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



