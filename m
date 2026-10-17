Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C242248B3;
	Sat, 17 Oct 2026 16:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254321; cv=none; b=GlcnyUQtzYmDveuMuws292bn9ziRNtNoj/pVYzzw5Hz9N1dmHasAwVJ/Xr0YR9lfqQRnz7HhdMJNJcdtK5WaG0Jo62sd8KTMNwRvge5K+onsbwJUDiOuwvub0w7CZP5wMiDdU45O7LxmyF9sJ0MX0nAW+KwJwEiMJFAbjDpwNo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254321; c=relaxed/simple;
	bh=Gdjpl5S8JihIb71dbT0IMStiAQvcKNQOrQsjfDLW0JY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LWGfH2SVSkFq+HKU9uliTzmgZB2tI9MVlKndS3vbunHie50uKYmBWY5RejqVzVPEWWc7QW5oFLq+i4bmGCoo4Zw/tFS/wGtg9KkxncNU59lbzEZRv8vraUPs7U8cURIpsUYlIz1/WSxdJLSglZCjdDgEXa7tm3h7TNsaBRE7OMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMba4GXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMba4GXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF201F000C4;
	Sat, 17 Oct 2026 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254320;
	bh=mXGHsk5zPyJ0dzoqjseHvTE5hWzNKUsBgXhUUA3ekc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hMba4GXJljbVJV9thWBYcm1q3jd5LO7w2PBfd0A3UpK1e3V+HrknSCeGVg+Eak8MP
	 Oct6t08wObwcKeAOIXoeCi1zEiaeInRhkK1cv8KLnArkuI/aP1+oMQm5BKtwlO1gfv
	 0n0Eyh6A6QdnL1AO96wOEElM1Rw1uYI5TP/t8clI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/869] drm/vc4: Shut down BO cache timer before teardown
Date: Sat, 17 Oct 2026 17:53:42 +0200
Message-ID: <20261017160046.882273991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 6273dd3ffb54ec581855b82ae77331b66028249c ]

The BO cache timer callback schedules time_work, and time_work can rearm
the timer through vc4_bo_cache_free_old().

vc4_bo_cache_destroy() deletes the timer and then cancels the work, which
does not break that cycle: the work being cancelled can rearm the timer,
and the timer then queues work again after teardown.

Use timer_shutdown_sync() instead, so the timer cannot be rearmed and the
cycle ends with cancel_work_sync().

Fixes: c826a6e10644 ("drm/vc4: Add a BO cache.")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260720084426.1632508-1-lilinmao@kylinos.cn
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_bo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vc4/vc4_bo.c b/drivers/gpu/drm/vc4/vc4_bo.c
index 212c86acca482..57935b5c640a1 100644
--- a/drivers/gpu/drm/vc4/vc4_bo.c
+++ b/drivers/gpu/drm/vc4/vc4_bo.c
@@ -1050,7 +1050,7 @@ static void vc4_bo_cache_destroy(struct drm_device *dev, void *unused)
 	struct vc4_dev *vc4 = to_vc4_dev(dev);
 	int i;
 
-	del_timer(&vc4->bo_cache.time_timer);
+	timer_shutdown_sync(&vc4->bo_cache.time_timer);
 	cancel_work_sync(&vc4->bo_cache.time_work);
 
 	vc4_bo_cache_purge(dev);
-- 
2.53.0



