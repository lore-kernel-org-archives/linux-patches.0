Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6C934E1B9;
	Mon, 18 Aug 2025 14:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525817; cv=none; b=Zap6O87ITlCw7ihMOMF6MZUfyUimmOuzF0je0fPt/VLaZfQ8MSWeM6enXdnfq1V2b2qnUi3vKB7qqFIRkEt/wqmzo0I3biDN/BiZy3otXheM8tQiRT/giT0jNHVeWIsS4HJXKTFb1vKmMavO4nB+CDtNSdkb1pHMSXMWaUSBdnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525817; c=relaxed/simple;
	bh=e56MxLzooYjlLaC8sISHTB8dPdz5Ai5lSMaP4Q/lVjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FPUXs5zCQyqxMQVDt3l2CrBPzYC8koYeZhFe45AEtve6FoH33nZgYLE8Y6iRNOl+A2ff/+1LpgRXBwkpmsEeuMlixz9YI3wgtWZx7jpUIGXifb7MRt/soXoTwMSqcLmDpKwtNA9GAdhjp/US8ig+SxJdB3CqQpuc6dXkcPbTy08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=askemrNS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="askemrNS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ACBC4CEEB;
	Mon, 18 Aug 2025 14:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525817;
	bh=e56MxLzooYjlLaC8sISHTB8dPdz5Ai5lSMaP4Q/lVjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=askemrNSXY22ymvyIPRGX/Fov6w/xEbY65ngNa5al4DOzhoNslUGsCkFIElk3yGKL
	 0lbBSjv+CKlkv3xXDnyrhlAXbPHVWcP62FAXbKjksUYOXWG8ubPzwdA0T7YQazZi/R
	 PAAYL9iDVG9Sz1Klgf6SJkY4Rr7CyUVgmvQwtkiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emily Deng <Emily.Deng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 343/570] drm/ttm: Should to return the evict error
Date: Mon, 18 Aug 2025 14:45:30 +0200
Message-ID: <20250818124519.075150941@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emily Deng <Emily.Deng@amd.com>

[ Upstream commit 4e16a9a00239db5d819197b9a00f70665951bf50 ]

For the evict fail case, the evict error should be returned.

v2: Consider ENOENT case.

v3: Abort directly when the eviction failed for some reason (except for -ENOENT)
 and not wait for the move to finish

Signed-off-by: Emily Deng <Emily.Deng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250603091154.3472646-1-Emily.Deng@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_resource.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_resource.c b/drivers/gpu/drm/ttm/ttm_resource.c
index 769b0ca9be47..006202fcd3c2 100644
--- a/drivers/gpu/drm/ttm/ttm_resource.c
+++ b/drivers/gpu/drm/ttm/ttm_resource.c
@@ -557,6 +557,9 @@ int ttm_resource_manager_evict_all(struct ttm_device *bdev,
 		cond_resched();
 	} while (!ret);
 
+	if (ret && ret != -ENOENT)
+		return ret;
+
 	spin_lock(&man->move_lock);
 	fence = dma_fence_get(man->move);
 	spin_unlock(&man->move_lock);
-- 
2.39.5



