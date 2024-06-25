Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269911465A8;
	Tue, 25 Jun 2024 09:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308854; cv=none; b=ZtAFInlnaDdotRLbKCeb1V4OVQIz4HrvVbionnd4kgDnM+QjTqnnEPbGZb+FK8Mxx3sVdpPJ3yNo3JJR9sRfxpSXswc7nLrY2fDUwbFBEelNdbopcrN5CrtVbSKJr8wIKQ42WJopMQNwCZ6dnyOQKFCMTiRJfrRCEmKWYQxd0dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308854; c=relaxed/simple;
	bh=X+p9Om5vjqg5OJwEY/T9S5DgaIWqihmeZMVEt0Gnic4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn+aqZRrRr1RsisnReXGI6BploDYYbJKFrlPkqn34j4PSCQD9d6tSmo+36wV5Rx5uk3vqwKbtGCwOVVh+8KnQJJLQZ6NgxKTVT0tNkPUrly3iWDxjMW8EQqMjl4Clz68oO9jNS8y1GO+EXYMIMLTWDCXIDkOvwosCebLGNnLFcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMtzV20a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMtzV20a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DEABC32781;
	Tue, 25 Jun 2024 09:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308853;
	bh=X+p9Om5vjqg5OJwEY/T9S5DgaIWqihmeZMVEt0Gnic4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMtzV20aJfOjraqyjA/dgcD/Cf9z439VLBBtZg7o6RvLMoWaDhY7vma9aa9Lj/hXE
	 dEw3+ne81evaOxkSq2v21r10RVa6BMRjjJRESSg/9yl/JCEQm/4HQWLR/nKYVfz3Mt
	 E8hmXcX/jcaYmFiJjxrFyI1aH38c0A3TN0M0p92Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/192] padata: Disable BH when taking works lock on MT path
Date: Tue, 25 Jun 2024 11:31:14 +0200
Message-ID: <20240625085537.247706704@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 179fb1518070c..c974568f65f5d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -106,7 +106,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 {
 	int i;
 
-	spin_lock(&padata_works_lock);
+	spin_lock_bh(&padata_works_lock);
 	/* Start at 1 because the current task participates in the job. */
 	for (i = 1; i < nworks; ++i) {
 		struct padata_work *pw = padata_work_alloc();
@@ -116,7 +116,7 @@ static int __init padata_work_alloc_mt(int nworks, void *data,
 		padata_work_init(pw, padata_mt_helper, data, 0);
 		list_add(&pw->pw_list, head);
 	}
-	spin_unlock(&padata_works_lock);
+	spin_unlock_bh(&padata_works_lock);
 
 	return i;
 }
@@ -134,12 +134,12 @@ static void __init padata_works_free(struct list_head *works)
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



