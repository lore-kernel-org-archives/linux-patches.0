Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6064836CDF2;
	Wed, 20 May 2026 16:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294385; cv=none; b=Y9zHEUzZhSjZkfABZLnp0QIWxG91idJaiFrbY5SJLdF1j0uQZZwsdyvaDUMncjfpmPtXzd5Y2ApwUeKk6ae8oJRXVMQI2AJMnhUFk7BDXbK4cB6XO5shHZBo1OfBZY5EwxzOX+0mn6ZUUqMLluWrDQTyPgCSrhNKWVgS1JDHNP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294385; c=relaxed/simple;
	bh=N5S3u+KhO95pVS9+EpxReHegmej9DP4y/HzjQNWZp4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXlsAmTdgK0KHTZLEn3YnCZlnbIyIkjCCQaagiXPvIqGFzYGI8nIGGqyVT20Ll/3s31Vd1znwbScDkyQ/mpRj3IfvbhLroz4B5ckvB4SWpX+A97XTiUcf9dVIWAmZdzBW5/qza1RYaSu6fNPUbRWWl8WhFyEbtsvqr9igi+aXHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJPLAQ0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJPLAQ0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349F81F000E9;
	Wed, 20 May 2026 16:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294381;
	bh=E02hpbDhzjv8ilhhyt9z8u53eQj+BkKUuhqINHO3+/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJPLAQ0+l4N8dvxcDYTC8ym9BwlnlbXH3gv+FSL+31sgEQu4h5lJO0zg20aP+PgIt
	 MsFHPCGy7JaMIvY4IBRkT12Yk57FJ2ZR2Px5x3bqsN6y89qy3+eCB1SDmg1BTP5hCn
	 edyoLxBJDf+rOovkIgW3spDjbPpIAN7QcD5AHS5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0019/1146] md: remove unused static md_wq workqueue
Date: Wed, 20 May 2026 18:04:29 +0200
Message-ID: <20260520162148.822684440@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index ecb9bd0e1b8f7..159af8d7ccf0b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -84,7 +84,6 @@ static DEFINE_XARRAY(md_submodule);
 static const struct kobj_type md_ktype;
 
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
-static struct workqueue_struct *md_wq;
 
 /*
  * This workqueue is used for sync_work to register new sync_thread, and for
@@ -10511,10 +10510,6 @@ static int __init md_init(void)
 		goto err_bitmap;
 
 	ret = -ENOMEM;
-	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
-	if (!md_wq)
-		goto err_wq;
-
 	md_misc_wq = alloc_workqueue("md_misc", WQ_PERCPU, 0);
 	if (!md_misc_wq)
 		goto err_misc_wq;
@@ -10539,8 +10534,6 @@ static int __init md_init(void)
 err_md:
 	destroy_workqueue(md_misc_wq);
 err_misc_wq:
-	destroy_workqueue(md_wq);
-err_wq:
 	md_llbitmap_exit();
 err_bitmap:
 	md_bitmap_exit();
@@ -10849,7 +10842,6 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
-	destroy_workqueue(md_wq);
 	md_bitmap_exit();
 }
 
-- 
2.53.0



