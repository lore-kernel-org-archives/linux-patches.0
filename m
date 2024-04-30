Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D9C1292C8;
	Tue, 30 Apr 2024 10:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474012; cv=none; b=Oz8MwFAc5WKbIUzKwcZOzLeH3M4NtT5j2SHyXznkuB/DiiSihctllRJbg9m4jFfX7qszrX1tGZQNiCe9cQ/svpbKqp0XiQNej9eaAswivVCFfwDQQKPeZcsqDP56g6JzuhNgBgVuootNZGYMg4e0zi2Di4Pal6ALZG7jNKhbPJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474012; c=relaxed/simple;
	bh=BpFEz+70OYUlnR+ZdWsrTOJcT83aKAzgYQE03lfJ47I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDzUnVZyUprxX2hwsXQeFc2mddBI6Y8rmQ1kHOnTO64P3HpckWuGisGJNW7sfzBRfw5IrGQdIOwdgEIP0XE+GY29iMqlo6KXCuA+DgStTnomCEH3rVfxYK9V/SLya77jnEVNw5WNll1tg4fu6GzYKGrYbH8kdsOIiDtyO8/GFFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spa/P/Y5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spa/P/Y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8110C4AF1A;
	Tue, 30 Apr 2024 10:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474012;
	bh=BpFEz+70OYUlnR+ZdWsrTOJcT83aKAzgYQE03lfJ47I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=spa/P/Y56+mngCrFSyiXK5cerEIr+K+pMm+9oojoLpvVGTF962nIpmd2ec02MK3Kj
	 /JsToQCcC4UrhxRtfY04LJnDUZ6ayBhOcPaTk0SNHlPYkuRHrAj5V8TvWLekmDs8j+
	 U5WdenuMyxZFP0Q166+GDtuun2o2V2zVqxX955KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 034/228] block: fix module reference leakage from bdev_open_by_dev error path
Date: Tue, 30 Apr 2024 12:36:52 +0200
Message-ID: <20240430103104.801197164@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 9617cd6f24b294552a817f80f5225431ef67b540 ]

At the time bdev_may_open() is called, module reference is grabbed
already, hence module reference should be released if bdev_may_open()
failed.

This problem is found by code review.

Fixes: ed5cc702d311 ("block: Add config option to not allow writing to mounted devices")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240406090930.2252838-22-yukuai1@huaweicloud.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index 2b0f97651a0a7..812872cdc0bef 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -873,7 +873,7 @@ struct bdev_handle *bdev_open_by_dev(dev_t dev, blk_mode_t mode, void *holder,
 		goto abort_claiming;
 	ret = -EBUSY;
 	if (!bdev_may_open(bdev, mode))
-		goto abort_claiming;
+		goto put_module;
 	if (bdev_is_partition(bdev))
 		ret = blkdev_get_part(bdev, mode);
 	else
-- 
2.43.0



