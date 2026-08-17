Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E8F175A6B;
	Mon, 17 Aug 2026 15:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978845; cv=none; b=qPBYD8WuQFN7CxfGXsNSrh0h9ci2XjgZx2zwIJaG3IUz8br+bPbVZxk4IZTxQlfPv/obJPNlQT9REBDDwkEmTmSAS5LwyHq4XcO+52kN95afbq5qz39FDsWOJe92jU7zl2l3WZAKK9NNVg1M3cHjCemMaLETdoIND/zdPbNTFDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978845; c=relaxed/simple;
	bh=q4X6jC9kObcbcRSbqq8Cm8ZN/fD+HWgByyymdK1rV1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPcVvP7lEYxZwQhPPPeXsxILiVGuQ9/+pJdswruTeO3nLTrOOKdOxIc7DuTOaYXHoy2DWEigcnpHU2nrrySKsxFwf5gOd1ImEWhcgXG1LYezLXOemjJ7Pq/ZpVpHVPBvx0GtGLqFLrcHux86ZFqY+UjHpBCLiblLSqlhrhTOkMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GeIVtqjU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GeIVtqjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0291F000E9;
	Mon, 17 Aug 2026 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978844;
	bh=rj1RXBxHoeQYg4Ki81D9UCEZShsJSWYAZa4c+9Or3uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GeIVtqjU4XYYCVdrJsIqgV8js9Grz1CUzq5lligfDdF9X046jnG841Z9cu3FCMfPx
	 MuJV3pMoFvhF3dU/ucPQHaFxJXeJnwAthMbb2uXYUrjxpXDsBvYwf2VtWahjsSuFQ5
	 82iVvSY+1JB1oIXgMXJny3wRR0drXIOaAoX9vSNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/609] gpu: host1x: Fix use-after-free in host1x_bo_clear_cached_mappings
Date: Mon, 17 Aug 2026 15:25:16 +0200
Message-ID: <20260817132543.883488785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 819f0c4fdfa899..8c819af1bce697 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -1025,10 +1025,10 @@ void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
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



