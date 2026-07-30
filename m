Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ECF7421EF8;
	Thu, 30 Jul 2026 14:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423386; cv=none; b=aFp5jbhGQwGqwJKa+Zjz4sr1sDTOh8A1qWnIbiSXt8ecUmhGjUKCVtD4mQhOrNC6zWt+DXDUQaMOJnNMUso+E77cbhMYyDxdi9aBqezG5yIYy7exlPtAEdO3kJex0KUv5nue2wzwVI4D8O+FgjKaCvF2Rd3u6WdytQXZ9p8z3jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423386; c=relaxed/simple;
	bh=bAThjGqDhRg72BwVMRnvVDYFsElnwVD6uNGVG/H0d2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRKNAehqPjXw+DCr8FdcKTrWtBhWqUUzhxGl16zWKLsHqeYvYok4Xoy0oXa0gjyh+lod05OZwFSi3uplr4FZ4QwG3Ok5kLcJvHB6hGL9Bq4x2GFySKBu/a2L1vhf+z1Ya9QwxXxwL7eGFGOBv1V6yd5eMgNSUbQ91BDx/LhnLgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BN25jraT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BN25jraT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3216A1F000E9;
	Thu, 30 Jul 2026 14:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423384;
	bh=PyCPTyTvlSnjMZ5rKbVY5o5AwjHdjof3k6Dx4q8+qII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BN25jraTl5MDb6XKIu9kbNnyVHEt5sdy0ZOxgkz68C2skPXE1u0cHvHxjdxEY5JKr
	 4Z+xzZHH72VjkI5iihlTrip0uCU1KPVOciSsPHTzwpj7crS0i0wbt4zsXDiWWBu5W3
	 D0bvtk+HGZoTqzzNaGOoi7uuEtOdJ/Mhmd1DdIMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/675] gpu: host1x: Fix use-after-free in host1x_bo_clear_cached_mappings
Date: Thu, 30 Jul 2026 16:05:55 +0200
Message-ID: <20260730141445.655854675@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
index 3801eab63282ff..3313ead8bfcc24 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -1001,10 +1001,10 @@ void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
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



