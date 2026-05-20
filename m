Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6B933A033;
	Wed, 20 May 2026 17:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297392; cv=none; b=llueIibyWdllIevAnAGqZVNyJIq2+BMqGKjxQV3m9LaHSp6r6udI2Y6brKKUka+bulbtCWPuSLXDSauYjlN65evgwuwJBty4DCwsC+H/gAmYRuSCZXKsOzmWNYjk7PcDMB73G3CPdgJ2bGCSvoKQdbceYrpQBYIJd3+ByYUwcqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297392; c=relaxed/simple;
	bh=8ZtGPJpqBEW9zBYUHUDdRyuMvt33ZBVbyD1KvpZaMU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dP9KjaEoA8CMGCrLKZmABwim+t7Avvyz4P/Ob/rH2islPqq8znFBlWT6w+ionDUHFEXUBq6NttNr52vVo9hUoYN7RVJ99sWStTWQh0zAvnanRjbUZ4gjz8E8hm67agu0gY4yHrrwohBBlJC+CWKQjKT0gGR5Z6TZnvIWSNTS3u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=brhaa2XU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brhaa2XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46661F000E9;
	Wed, 20 May 2026 17:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297391;
	bh=vaOD/baxAaYkju7Q3/XdFXC6/iv88DqYsi3zm3VDDzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brhaa2XU5ngPgTwepdWm+32H+0+0MxzQ7HaaFMjSAm2nDGak2katEZQSGM58M/gPz
	 iIWEtfICkhnfsCuSHJqD1v+/5qzO6A2SYIuHZD4N8hqKHpvDlwD7FyVVLKZLim4pwO
	 ZjXAt6tqDRtH63fGFCmN5qDDLVIppAEXOHB7q+ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 015/957] md: remove unused static md_wq workqueue
Date: Wed, 20 May 2026 18:08:18 +0200
Message-ID: <20260520162134.891211050@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit e4979f4fac4d6bbe757be50441b45e28e6bf7360 ]

The md_wq workqueue is defined as static and initialized in md_init(),
but it is not used anywhere within md.c.

All asynchronous and deferred work in this file is handled via
md_misc_wq or dedicated md threads.

Fixes: b75197e86e6d3 ("md: Remove flush handling")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Link: https://lore.kernel.org/linux-raid/20260328193522.3624-1-abd.masalkhi@gmail.com/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0fc779493fa78..0a3152f21d488 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -84,7 +84,6 @@ static DEFINE_XARRAY(md_submodule);
 static const struct kobj_type md_ktype;
 
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-static struct workqueue_struct *md_wq;
 
 /*
  * This workqueue is used for sync_work to register new sync_thread, and for
@@ -10345,10 +10344,6 @@ static int __init md_init(void)
 		goto err_bitmap;
 
 	ret = -ENOMEM;
-	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
-	if (!md_wq)
-		goto err_wq;
-
 	md_misc_wq = alloc_workqueue("md_misc", WQ_PERCPU, 0);
 	if (!md_misc_wq)
 		goto err_misc_wq;
@@ -10373,8 +10368,6 @@ static int __init md_init(void)
 err_md:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
-	destroy_workqueue(md_wq);
-err_wq:
 	md_llbitmap_exit();
 err_bitmap:
 	md_bitmap_exit();
@@ -10683,7 +10676,6 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_wq);
 	md_bitmap_exit();
 }
 
-- 
2.53.0



