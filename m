Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA64F3919;
	Thu, 17 Sep 2026 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660890; cv=none; b=sTd3NH3oZIPbhgxGeKIp+eiFrSo4nYnJzVWYiZ81yuWOGh2yKcoCZybN5lN6yW/aWzvNhbAcDUT2kjI0REZ4e7X1zdjuGdt9Mwqam1NT6jbrQaCYAwJd2Fcwm1k4cYl8Sy3SBxXQ73+8LsNCewtmNwvPO+EBfXH+CJov4i8TmE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660890; c=relaxed/simple;
	bh=zPXvsYsr8fsJo4gHNMPWCVVoUy7jrFuxiF9f1zdw9l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXIThPXMMjecCn/4UyBsSy3H7ECiZ+Vo7RpM5eeaxsBmrv4F6qFUVyKMDPMVCT/aETeeF23gkb2+x/mhysZRFDbFflpRepLUsQKb4t5CsQJPrkdDxxDbjLy/tqApRiY40RX2ydK29uW0hhZyLu/pIp9qPYPwEYpW23JCgqfcBHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOy9O2cT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOy9O2cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B191F000FF;
	Thu, 17 Sep 2026 16:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660888;
	bh=SJ30JQAV99hvXqZZe/RhW8sBKzO3IcFBjdiFmCAmnTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eOy9O2cTyKwIAyGsaR11chaXDeDxUCU6KpTL2/H7a7NKrUdpjcPvdrmGOQ4qwUntg
	 lHiPNhKVS9WzWzIGQhgvszAfURQq7lRr7HhDUXM8PEgajFmtiQt3jhXuRcT7ISVYxx
	 ZuCr+G6Z3tZBEnRkIneGC8ZZbpYyIQl939lcYhg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0004/1250] drm/gem: Consider GEM object reclaimable if shrinking fails
Date: Thu, 17 Sep 2026 15:56:39 +0100
Message-ID: <20260917151552.036261066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 5c4a113b08941..224ed96bd0d4a 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1601,6 +1601,16 @@ drm_gem_lru_scan(struct drm_gem_lru *lru,
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



