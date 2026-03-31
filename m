Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548173E3174;
	Tue, 31 Mar 2026 16:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974320; cv=none; b=dn3sJ81sae67xvd5GaN0R0yy0nLPAP81wQDoeB1pJU61I27z2GKGcMXjiOcZyxHQyWQYZ2uppgpTKvFrmZX/4XRpHVmljI/5R6sbb7uEzklSfc58+uktmggx7nww/HWUGXPxRXE1o3Jll0f81vyz2Fivk4E/WLkZ6s7Cfgljw6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974320; c=relaxed/simple;
	bh=mnRu6kRUHPRJWn807bx8EnGojt5vY5S4xLF8RzkDI40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlwVGL4kSsbw7Fdi50VpsJegMOvgsr31CQUjLWFIEStBniq12XQeE0F6n2DIWryLTmLHg1b8uRVKDr8TMjS4m47fi8ryAHRruRemP2VbJkeZuYP1wacLKewgEYN82iHAu5KVq5H6NOgmgNKgNMS8TJL0bid4oxGyMgbUHjzAVP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OaQVm+I7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OaQVm+I7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADA6C19423;
	Tue, 31 Mar 2026 16:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974319;
	bh=mnRu6kRUHPRJWn807bx8EnGojt5vY5S4xLF8RzkDI40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaQVm+I7gTCXUPeqDt/tJmgWdb8PTVVsSMfSe2XvGuDwqFZf1PgtIfs13T/s5TPGs
	 pDUiSnupCJ5S3P0kRRMXX2P1BltG+0TRHjhO8dqM2ICriGxgIeRz1CMHZuRop57R68
	 k3v11ME9pA+nHbnzfup5PXx3UboOQ4s+YtkpfY0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/175] sh: platform_early: remove pdev->driver_override check
Date: Tue, 31 Mar 2026 18:19:51 +0200
Message-ID: <20260331161730.053461846@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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



