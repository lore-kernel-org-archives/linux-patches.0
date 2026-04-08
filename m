Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE89A3D7D60;
	Wed,  8 Apr 2026 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671632; cv=none; b=m1wNmQJLi1l7nVDfgos/2usV0GbF6by6JqpqmBk71LVXDvFjP8l0Hvix5ZygE6PWplqLM1MvakeZyJyiI43gLHj+QF83ANeCsKFFKVby1PufrIo28fgZoYB2yaooO3o2AVQcCrDgyjVBfrg48D+EFtk9Q/BH+X6yGybzzyQZRMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671632; c=relaxed/simple;
	bh=acmREW3ho1mZC8xqkwrdEKgh44hFgNzks/bQMUpF1uw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m/KsWKxyah1WrxBnhdL9+6mAQX4f8smpPnLtcEfJqS5yK5u1q8wMJrxTr/9oVe0hTCr37Zo0UvzmWCaC8WS8sS3bpY9C8DWdiZ/T96d30R1hIEMb8gItLnvyiNbkXoomX2+wDUaMtNHZB9CFEO1xd1uxgmDITmEwnOsKUfYM4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9c02/l6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9c02/l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD6FC19421;
	Wed,  8 Apr 2026 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671632;
	bh=acmREW3ho1mZC8xqkwrdEKgh44hFgNzks/bQMUpF1uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9c02/l60OfDBACYulYa19XzlpNsdYn2Hc31YQdKWajqM27H0WkHeuREtmut8d4qG
	 zRNFRRDc536g1+C+PQmSc+2YsQJ2gkVz3to8+BugSBMJep7H4cJm3etzQpmL3jzZIP
	 6vzGDemZJZ8sdPt4PYXK4QXYul5Qi6dbyBaT3iLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/312] sh: platform_early: remove pdev->driver_override check
Date: Wed,  8 Apr 2026 19:58:38 +0200
Message-ID: <20260408175933.775239177@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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



