Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0393551DE1C;
	Wed, 30 Sep 2026 18:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793865; cv=none; b=OGwru+mjblbNnQunEU4vttdvWcUMaPCyFBY/UZ6dqMF9jS0sxmJeoORraP7H+hvfBuDgicdn1Cee2Ac1Yd3o8bSgcvWk2ZvmRWBnuD/8TFtq/OqPdLyCAL6cTKMW664Wg1lq4dScaGj2cjRAfVHazvp7Y/3m4eqDA7sOM7Sa2MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793865; c=relaxed/simple;
	bh=1ASZtjvzIAzoWOquhAiE07HczgoXNft6aJDo+AxDS3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDedggOZbrLM8Q+Jl9Ag7GcD+kSOYl8ZWHZnKnrIhE0KxMaFUwRHXlj1VYf2fJ5VDgri6h2D062ROF8Y+ZyFYJamRWDOtMsRNvL+27u658CHzs/27I+fypcIpTKdL5S/iEEC2fh4jP7p9mlSKLc7ZXprcyIlp7Xatjm7Huh90II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/gG57D/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/gG57D/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB541F000FF;
	Wed, 30 Sep 2026 18:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793863;
	bh=WcBd1+qqnejuXMmJ8MtRXP751QY/1tSDn4r0kZqnuK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/gG57D/H7h8ZAX8B9uCOMfZn8uIowPv8E7pwkDvx4LQmHYGtYCP+HHTWMCV//TtB
	 gGVRNR/dTQoKMdaCI+0IAXyWZLihVZ6iOBfZTYPnplzltpbdL5Rc/aDbzIKtyutxLK
	 k/WRyqvKlJHnt3xQuJf1dkyfCWTroJ654wVNOwz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0002/1193] drm/gem: Consider GEM object reclaimable if shrinking fails
Date: Wed, 30 Sep 2026 17:11:26 +0200
Message-ID: <20260930152434.363004053@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit 71c8224a18825102ee1e5e70498f96f6c2d2a81d ]

If the object wasn't moved to a different LRU after the shrink callback
returns, it means the buffer is still reclaimable. Update the remaining
counter to reflect that.

v2:
- Collect R-b

v3:
- Collect R-b

v4:
- No changes

v5:
- No changes

v6:
- No changes

v7:
- No changes

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20260401134854.2275433-2-boris.brezillon@collabora.com
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_gem.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index a3370c77e949d..4476f44f2badb 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1519,6 +1519,16 @@ drm_gem_lru_scan(struct drm_gem_lru *lru,
 			 */
 			WARN_ON(obj->lru == &still_in_lru);
 			WARN_ON(obj->lru == lru);
+		} else if (obj->lru == &still_in_lru) {
+			/*
+			 * If the object wasn't moved and wasn't shrunk either,
+			 * it's still remaining as reclaimable. Note that
+			 * obj->lru is supposed to be checked with the LRU lock
+			 * held for an accurate result, but we don't care about
+			 * accuracy here. Worst thing that could happen is an
+			 * extra scan.
+			 */
+			*remaining += obj->size >> PAGE_SHIFT;
 		}
 
 		dma_resv_unlock(obj->resv);
-- 
2.53.0



