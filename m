Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E66E441638;
	Thu, 30 Jul 2026 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421228; cv=none; b=XmL0wsEKmi3zOLcMN9JtDC4DrJ3hW/laHr/j9JDTr+zRj5OoBsTJ3sYKIBzMYuKXZMO5eUUHWDG6ICZFLoQUYGV9oX9bumlM0mW2FnCif/lRRkO7Os9tgHnBzQCDaEMd4OfPYF39HyVd6N86T00sj3hVzrQ/5pYjFx2+WFJ+mFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421228; c=relaxed/simple;
	bh=1gZxpWpcX2uIHKdZeVKDod9zGkWYx1eORWtk3defqMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tygreCax0A/wGlkuXT0ORlMMLkNdW9q+hLhFVCmsZY/Ip2S1CMvzLXWjcJ92pRHSFQqWCupl+FJLLhgRXYWrHeLO89AW8p15JKBBuy/j5IcLu1Zor2OYcpozVuMdIfAe2Z9WZonZoz0RSKepHgaTnQQ8KSDmkXSZhtp3NzSWaZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qA+1e7MS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qA+1e7MS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E2A1F000E9;
	Thu, 30 Jul 2026 14:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421227;
	bh=wnJzqxk2aTgvvi+cQUXqELuZ3VknBnTLWkTDabAeKL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qA+1e7MSkz3LBENKjBgzPrvNEUy3GzxPuxyxWS9BeSXKxWS3CMQe87wOlPPlN12ix
	 OimWWjceRV9TjEyjxwQjckBTMn8Lj4/OG736TtXzbmF3VhrjdOCcZr/fuxU2pJeXhX
	 2/uOA8VFpeSnjkOsuQOF3b+a037bgOywhpjuXGDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 009/744] gpu: host1x: Fix use-after-free in host1x_bo_clear_cached_mappings
Date: Thu, 30 Jul 2026 16:04:42 +0200
Message-ID: <20260730141444.479573434@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 266cddf7bd0f6c79b6c0633aef742a22bf70265b ]

__host1x_bo_unpin() drops the last reference to the mapping and frees
it, so we can't dereference mapping afterwards. The cache itself
outlives the mapping, so use the cache local variable instead.

Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/linux-tegra/ah6ErK6f4kVudVIA@stanley.mountain/T/#u
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260603-host1x-bocache-leak-fix-v1-1-494101dbfd30@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/bus.c b/drivers/gpu/host1x/bus.c
index c273a4476f2370..a8cddb3425b428 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -1012,10 +1012,10 @@ void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
 		if (WARN_ON(!cache))
 			continue;
 
-		mutex_lock(&mapping->cache->lock);
+		mutex_lock(&cache->lock);
 		WARN_ON(kref_read(&mapping->ref) != 1);
 		__host1x_bo_unpin(&mapping->ref);
-		mutex_unlock(&mapping->cache->lock);
+		mutex_unlock(&cache->lock);
 	}
 }
 EXPORT_SYMBOL(host1x_bo_clear_cached_mappings);
-- 
2.53.0



