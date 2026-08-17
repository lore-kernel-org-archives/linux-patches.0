Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806604334B5;
	Mon, 17 Aug 2026 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786981787; cv=none; b=KXheS4jlRhHNijZjx4BCKMIFK/dQ2fLgD/u6eJER4E1gZGZSgYmHxbVolorYxSGn5Q3YQIqSCXz9vAwTsZ8nmQ0zkLcJwVVkSptCP8oKow7rPl0HPM0pyP82Fj4q5aF+DcgsFHpPI6Bq+yaSie26oQZrrm2HuTP1uhOObz8kwyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786981787; c=relaxed/simple;
	bh=Vrm8sjoaRb/+7+Yf0FIuZTmiiWsu0T4V8Vo3yNJstno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfRzf4uoj7jw2w6ty3WmHV2mysG/0YMHzs0z/uFoImYQw7t9Tl2f896Iyzd0p0iLtuJXEM5NeJX52H1p5MnhlM1RSSnH26apDydXFYV/SOSiZszwX8a9Ulx+g7grRF9u2TIqVuA29mdmyss/VErFbxTWqHYdTEFtMc5HAiPUQ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jx5O77LA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jx5O77LA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736621F00A3A;
	Mon, 17 Aug 2026 15:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786981781;
	bh=0EzmneW1Rmy38W2KlLeCgjEVeBP1Cq/03b9rImtRyg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jx5O77LAOyDBWaYrSLnSCkTKMsFpcgbeHKLgjTeAqq/7BVathZ3uHXU+i5awd21vF
	 noN/7Tkjxx1ki7CM9+SARHwfXQoCtZRgP1YxcT5vahuYi4yLjqmVMT6JeVIdmYDJRZ
	 J/c8GYS46QnZcdNe/KrrSn5bMVae7wzZ1hVfpllQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@vger.kernel.org,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 364/456] firmware: stratix10-svc: fix memory leaks and list corruption bugs
Date: Mon, 17 Aug 2026 15:32:34 +0200
Message-ID: <20260817132553.741510506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tze Yee Ng <tze.yee.ng@altera.com>

[ Upstream commit 9119ceb76e987c2ec2b549ea100e3268ce3a1c7c ]

Fix a memory leak when gen_pool_alloc() fails by freeing pmem on the error
path. Switch pmem allocation from devm_kzalloc() to kzalloc() with
explicit kfree() in the free path to match its list-managed lifetime.
Remove the erroneous list_del(&svc_data_mem) which corrupted the list head
on failed lookups.

Fixes: 7ca5ce896524 ("firmware: add Intel Stratix10 service layer driver")
Cc: stable@vger.kernel.org#5.0+
Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
(cherry picked from commit 9119ceb76e987c2ec2b549ea100e3268ce3a1c7c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 993ef210169c0..c5ddd20fe4b75 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -911,13 +911,15 @@ void *stratix10_svc_allocate_memory(struct stratix10_svc_chan *chan,
 	struct gen_pool *genpool = chan->ctrl->genpool;
 	size_t s = roundup(size, 1 << genpool->min_alloc_order);
 
-	pmem = devm_kzalloc(chan->ctrl->dev, sizeof(*pmem), GFP_KERNEL);
+	pmem = kzalloc(sizeof(*pmem), GFP_KERNEL);
 	if (!pmem)
 		return ERR_PTR(-ENOMEM);
 
 	va = gen_pool_alloc(genpool, s);
-	if (!va)
+	if (!va) {
+		kfree(pmem);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	memset((void *)va, 0, s);
 	pa = gen_pool_virt_to_phys(genpool, va);
@@ -950,10 +952,9 @@ void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 				       (unsigned long)kaddr, pmem->size);
 			pmem->vaddr = NULL;
 			list_del(&pmem->node);
+			kfree(pmem);
 			return;
 		}
-
-	list_del(&svc_data_mem);
 }
 EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
 
-- 
2.53.0



