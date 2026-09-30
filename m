Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4B8481A99;
	Wed, 30 Sep 2026 16:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784024; cv=none; b=dldkZmVQ9XkIZVl1KMhPcILhEKXaDwbuygPO+MBvCKp39aQnSoW1P1Q8/PBGBuYpJPyUsRLt00bMD13o2XNAbpuWNcrRpvbF0CQSEvAF6rj63KlyIGHL3ohdw21ZclTKjTFAOszByCgJi000hkxwD1v3UsaWpMpbKkxqtLE8miE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784024; c=relaxed/simple;
	bh=IKmWoXwvPOMMjV+Q+fR85pXkWtzICaRw1o88HXSXPz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHBP1WTd6+rL/ZFjTwjWRTgsx5uFMqXGb0JYVquVSllLX4bEoHNz7vDuR3h1/bovG5hjPtJfUhVpXKHRGz8rUKgzMOQmzbMxXvle5j7Pc+ROOqbUeJSdw0Wtvweg4HGHgVzJlV2d0r2m3vuuWYNr0WKXZVVtm+8Ny2FJauhiZdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsxeQaFV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsxeQaFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C9C1F000FF;
	Wed, 30 Sep 2026 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784020;
	bh=un797saSmXnDCEwwNuujxnr0u7m8v2J8zu+8WsUXgcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsxeQaFVl06OPyyEoplNsP6Wiu1tgXXSQ1aGQg0CqtFuQ8X+ad16k1ubjGWw7P4AW
	 DjaOeHoZVpE2eiBaQwLWPJvR18trSO7Si9cdky/Uwm7mTjbZyiwNXTxj3uw1GyZew7
	 OVG/DWXsPS2fSy0PpnBPupCs4Qf7+yDTsKW1twZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/982] drm/gem: Consider GEM object reclaimable if shrinking fails
Date: Wed, 30 Sep 2026 17:12:17 +0200
Message-ID: <20260930152416.810892049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index ebf60c8d98ed8..e9be1d590f4ac 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1419,6 +1419,16 @@ drm_gem_lru_scan(struct drm_gem_lru *lru,
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



