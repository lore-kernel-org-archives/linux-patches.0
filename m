Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878A83B27E9;
	Thu, 30 Jul 2026 15:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427025; cv=none; b=hAVFbVW0osHw6OkjZYnMnhDInSLVKFrDYzWYwatMq0t7CAxDEM/vEaoKN0OKw2Brhng7aEFeYjSoXRUE3UQHZvbdDXDmGL6KaWa4HgFSt804RHVPR43n0BYL6PTvHAhaTBSz1DOsbJ6NjzB3CeF8435b9OPby8MvsjHAFAUiem0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427025; c=relaxed/simple;
	bh=ttYz6U+Vb0s0whGPW79CQbKw0sq2HQqSOCLWOW4Zmnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AY+Z0P1H60tKOpXGEcZYmOBapGSJ9k/NHaxQzGOR25v+xsvrnJvgXnH29eLyYSci1WsfzWSd8uuTqYHEk/cm8GwdVBgidtfr8FQ+SYzaGgw/nKAvL3Bbuux9USJ/rHhguQHmhStiYrtajTqpKRtc+BsMTG0rAMYzKHczN6FppfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWKmBzPs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWKmBzPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B831F000E9;
	Thu, 30 Jul 2026 15:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427024;
	bh=FHYUNCKPerwzxK106eC1Zb/A8W9uWcsIWs7WJB+78Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWKmBzPstp/bt/5LRtZKskiSCFQus4G6u4wYr/LTlgBN7RfVc2d4uSUD3wLinnVCR
	 20eM5OLTt/3Hjj8j0pSq23LarnchSHL2KuYYcuI3By5sIS4/yAI0/XwR74E0fL3WFE
	 kv/ylZjT5vY4pHs8p6Zz0wNdf2+9gBy6MNaSScIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/484] gpu: host1x: Fix use-after-free in host1x_bo_clear_cached_mappings
Date: Thu, 30 Jul 2026 16:08:42 +0200
Message-ID: <20260730141423.972949251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6b8b7395a4189e..8a4e0738014d6c 100644
--- a/drivers/gpu/host1x/bus.c
+++ b/drivers/gpu/host1x/bus.c
@@ -1006,10 +1006,10 @@ void host1x_bo_clear_cached_mappings(struct host1x_bo *bo)
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



