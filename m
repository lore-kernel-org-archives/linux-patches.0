Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2734831E832;
	Mon, 13 Apr 2026 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099171; cv=none; b=tRsfn8zdrx67kDCk/1KPvk1qY9q3kMCKeJ0eGurzUn0F5x6tpSEpr11BLG5UgkHlLRJMQ6VNHjbA6mAf5lWy3NDGTVlJWzDUp5uCgDS3OjUp/qHun0A02Cn4udkWhGeKJFb7wlbbp6AeP2O/RP14KoqyuPmEf+ZNHTN6jhRfS8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099171; c=relaxed/simple;
	bh=vp5m54qqoB/9XFXVCiLUgzZtM6d0A8urvq+LEYNRFFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jm2bsRIo/Zk/UZJbYnY/1WM7gDRvP/zcb1HoqR56BjWM+HP1lKdD2p4vSqZwGxZgNl1wMJ4Kwsrk+7m6+5bsAY2fz4enznNBk7QGsVIUUVARyM+tntp2LmEUPizrlGWeDhETZng7z5s3O/ssB7kMZcXApA3vewG5RWmJLYMfqGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XUMnpZpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XUMnpZpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF051C2BCB0;
	Mon, 13 Apr 2026 16:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099171;
	bh=vp5m54qqoB/9XFXVCiLUgzZtM6d0A8urvq+LEYNRFFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XUMnpZpq9nawSZOi16M/hUkQmtvoC6oNfttfmvvWTiHPZjq4BxmaKT2TaUf/RYLgh
	 PLqwG3QVY21iEhQvrHqYMbh0+ohObMOJSPD/ICsqJSy7rz4id/U5nEgsowgRQpFhEC
	 Lrv4ampPTZ6bkbe8hKJxKaviQZ+VgXGP4UiWp6Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/491] sh: platform_early: remove pdev->driver_override check
Date: Mon, 13 Apr 2026 17:58:02 +0200
Message-ID: <20260413155827.930608561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit c5f60e3f07b6609562d21efda878e83ce8860728 ]

In commit 507fd01d5333 ("drivers: move the early platform device support to
arch/sh") platform_match() was copied over to the sh platform_early
code, accidentally including the driver_override check.

This check does not make sense for platform_early, as sysfs is not even
available in first place at this point in the boot process, hence remove
the check.

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Fixes: 507fd01d5333 ("drivers: move the early platform device support to arch/sh")
Link: https://lore.kernel.org/all/DH4M3DJ4P58T.1BGVAVXN71Z09@kernel.org/
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/drivers/platform_early.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/sh/drivers/platform_early.c b/arch/sh/drivers/platform_early.c
index 143747c45206f..48ddbc547bd9a 100644
--- a/arch/sh/drivers/platform_early.c
+++ b/arch/sh/drivers/platform_early.c
@@ -26,10 +26,6 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 	struct platform_device *pdev = to_platform_device(dev);
 	struct platform_driver *pdrv = to_platform_driver(drv);
 
-	/* When driver_override is set, only bind to the matching driver */
-	if (pdev->driver_override)
-		return !strcmp(pdev->driver_override, drv->name);
-
 	/* Then try to match against the id table */
 	if (pdrv->id_table)
 		return platform_match_id(pdrv->id_table, pdev) != NULL;
-- 
2.51.0



