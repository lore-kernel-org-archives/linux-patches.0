Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E1DFBEF;
	Tue, 25 Jun 2024 09:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308138; cv=none; b=ZLAhPJVqYmxzBLwA19I+hotvbM1Ud1z8BR7uIUy/vZu62yHjcCYcqlKiZhxj6+Qse+vLGJZtHlKCBmlK5tcbkG8x/vDyZ8smwWGWhSUIOpqoxMx2+MOzU6jINsjMUbc42kZS6HXZo3GXaveVBD8moBvErtqMTiiTyuZRS4cNxIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308138; c=relaxed/simple;
	bh=Sk3l7ZaWMnmk2m4y0XQpHakpQtOEh67XIJw49w2nrmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwk3XuJNM4oi32qMcdlXc++pBLAkrso8ssQzsyHg5ifB+EHtAZo4iPz1mFk/4DPRRdBVFCP3dZmAQ2GOUOoHRYtR4oEurjsPQnFsSboq8U1ngjda8EYfg2qXPX6dDaIbzxRkyDqE69iIjIMSOZKdqho00Ga/H1gNpZ2jZDFVhEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6nKwh1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6nKwh1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCC2C32781;
	Tue, 25 Jun 2024 09:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308138;
	bh=Sk3l7ZaWMnmk2m4y0XQpHakpQtOEh67XIJw49w2nrmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6nKwh1pl4yegU20eOXJ1QTNVsOFDlMaQ+b/SekJ0Xagtxyh/IXZOyMfHvEeHnxPT
	 Zw12NRfKz2Ms3SEXiWLIf6CaI7cT0CnH2nmWQqhQiP1xSSzR6hC80dI+xEPKXWhTZm
	 3oueBFtFr0Y6D5pSjBXRfuvJbuqJ5/1gfpOnOOcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0cb5bb0f4bf9e79db3b3@syzkaller.appspotmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 002/250] padata: Disable BH when taking works lock on MT path
Date: Tue, 25 Jun 2024 11:29:20 +0200
Message-ID: <20240625085548.131723110@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index e3f639ff16707..53f4bc9127127 100644
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



