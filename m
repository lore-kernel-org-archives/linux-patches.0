Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D0D4CDDC3;
	Thu, 17 Sep 2026 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658417; cv=none; b=EDytoBKdhH6mPM4kdhyfY/5QtLjZ9n2M6fCqfNn6shcdz9YGhpUAQGbFTfnLDghe0N9IJrv4EOaBoK6mVx8J3mrgewecvyLmGw9zwalqspfE7wf+VPF5ahX0PIYhhBR32H/H1TZbjFNImMAo8PtjCR0WA8cOwxufRugRWJ2l0co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658417; c=relaxed/simple;
	bh=azDmFJwkqPho5p8peGpB5EeDYw7bGnCxjudYNEUInUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2lrlmYipuZTgAoLu24A9Z4WBO8Bq/EjmWl/qZC/8RY9nujJXp+XR0WNSOEYg0tF5L+QiBRZ+pjfwcQ1yCaNRzHAP4CEfFg41d3T2uFssJtdmKOYh6Hobl2/VbmvqYRmeC2GkV68Bn02hk+HnuqmYuTiDoZK697n2OeNbzSe1nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XiIWpW85; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XiIWpW85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE091F0089A;
	Thu, 17 Sep 2026 15:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658404;
	bh=qiUQE4uQTChc9tPzT/AwXPmv7+puR8wUsoKXE8C+Fw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XiIWpW85HCqZfIdd5Kwtqy4lmjUGaICn+ICgYOAB9eZdK3KXtGwRd3mxdYv1ld+TQ
	 qDsBniDkNp15XX3CHWaD78o1FAXOYHGHEBen7gsuNdymLD+V0kQTjS6TJ4CYoosoO+
	 ApWZ2NMA9TtApwRRaMmixmYzJmJijY13WH0FHbQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0002/1102] drm/gem: Consider GEM object reclaimable if shrinking fails
Date: Thu, 17 Sep 2026 15:59:05 +0100
Message-ID: <20260917151539.479437367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9e8a4da313a0e..ee94cbb7e2c7d 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1546,6 +1546,16 @@ drm_gem_lru_scan(struct drm_gem_lru *lru,
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



