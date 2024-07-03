Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477A21891CA;
	Wed,  3 Jul 2024 11:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005742; cv=none; b=HusVo7SgeIQIXzAuqRAbCPiGx3CmPkwdGlYztFVgAF2LR35TOPDuYTkjHU6HbZOoj/OssvMdyaMIXJjEHcBFt9JU0lTEbKC7eycrGC7yUjvNnz9n1+X3e2wvcrTASPRwUQpdaXsZ1J8xa9AfFkrKPke5YTRUv/cE/BxxHl+H4Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005742; c=relaxed/simple;
	bh=hWs3NByF8fFDTF6ycy5/4Wx/gZxyo0kB3U0nOOYWtKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmSlAdKHGq/qT3s7MVriGucFrQdq+UP3FVEbvXwlYba2ACGtZp17nmDE1pVovr1QGGWemdtyiDhTCb9bfdTlTiEbW+Kc0I6LPYo9oVnEMK5Z4IUjWOI4ZcgezQX6QB7B0+G6VaquG7nICFEKX54dwNCsTfS6iLrfJAIbGgaPltg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=waXHjNr/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="waXHjNr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE932C2BD10;
	Wed,  3 Jul 2024 11:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005742;
	bh=hWs3NByF8fFDTF6ycy5/4Wx/gZxyo0kB3U0nOOYWtKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=waXHjNr/9D+2AD9PDCzp+tv+/gWDyZW+xtUu+Bfia0Gy86fgUb1JIyPbaIeqKcBRs
	 0uEyqhgjc9acbOIEsACKbpQm8aMP9qPWEJTY2XN1bpY+jfLX2/RnbnP+seBPqDhuXx
	 rNKSDw1MiahQqQGfEGylas73P+dGob4Gl0s03wu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/356] padata: Disable BH when taking works lock on MT path
Date: Wed,  3 Jul 2024 12:38:06 +0200
Message-ID: <20240703102918.778003747@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 47f146f061fb1..809978bb249c2 100644
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



