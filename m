Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF84376A06;
	Tue, 21 Jul 2026 17:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653484; cv=none; b=TxZg7V5C4iCJdnUuqd/ft8mFUwgBfZgXsNmP5ZTjVr6eeqgSihqYhoH3Npv7xYAuXOZCEYcOZDerPxe7Cw8Mgn9eagV2FWTaw2g1kxsxyr/9nrlv8lU+knynOtOSsKceV4tN8//sVS6dqpm33ymfO9b8QzrUyj8O4mh1iBLa1KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653484; c=relaxed/simple;
	bh=dcNNBeAzRqnUnTYhWwUjOwlUFRiwOxDORffofYZX+SA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lxCrQ7zM6uWX1NsTi+mJgQ+sqjdGYDMGoDjlPQ7UsJBWsL3womofsB2ItfF7l0oDSdSB4HyunBgi2DJO/aywb11uwKquqwNbkiezEdsWL6TZE6ikMg3FsTwAbAfi9jTLOjRh7MHDowU0kZi9oRpAnTA9EGpwUy6BDo8V1t9KlfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7SIZIOO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7SIZIOO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62711F000E9;
	Tue, 21 Jul 2026 17:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653483;
	bh=7OoM3KkfusXAfietACa/GRQi3/cQWrFagPsTP1B1ueg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7SIZIOOamDfxOg1tfMJNRHCEs96qyj2xfMrAyuYmCZf+hgewKFRIRSP9lHWGKx7e
	 mXQ+ZvF38IlnkxR0rvWf0G5P/nf5bhkIAAGsASKRumnfWTaN+50MguV5oeVaAuSb8T
	 quwMht3po+DRiWpcWDa0oNSUlyAgokai0RQFPxoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1345/2077] drm/panthor: Fix panthor_pwr_unplug()
Date: Tue, 21 Jul 2026 17:16:58 +0200
Message-ID: <20260721152624.541913663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Boris Brezillon <boris.brezillon@collabora.com>

[ Upstream commit e62179fd3e23ecfaedf7101e19ec0d3e4f51de76 ]

We can't call panthor_pwr_irq_suspend() if the device is suspended,
or this leads to a hang when the IOMEM region is accessed while the
clks are disabled. Do what other sub-components do and conditionally
call panthor_pwr_irq_suspend() if we know the PWR regbank block is
accessible.

Fixes: c27787f2b77f ("drm/panthor: Introduce panthor_pwr API and power control framework")
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260625-panthor-misc-fixes-v1-7-b67ed973fea6@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_pwr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_pwr.c b/drivers/gpu/drm/panthor/panthor_pwr.c
index 52fc46239e6b69..dda5159a5271bb 100644
--- a/drivers/gpu/drm/panthor/panthor_pwr.c
+++ b/drivers/gpu/drm/panthor/panthor_pwr.c
@@ -435,7 +435,8 @@ void panthor_pwr_unplug(struct panthor_device *ptdev)
 		return;
 
 	/* Make sure the IRQ handler is not running after that point. */
-	panthor_pwr_irq_suspend(&ptdev->pwr->irq);
+	if (!IS_ENABLED(CONFIG_PM) || pm_runtime_active(ptdev->base.dev))
+		panthor_pwr_irq_suspend(&ptdev->pwr->irq);
 
 	/* Wake-up all waiters. */
 	spin_lock_irqsave(&ptdev->pwr->reqs_lock, flags);
-- 
2.53.0



