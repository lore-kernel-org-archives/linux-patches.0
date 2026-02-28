Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2362434252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301775; cv=none; b=aaHFjb4sdWE/yw1+mW6OehkpAK2WTsjhCr7lNZDYGQ9lbm03S4VRNDAka7SRHciWrwycaAZkMWFwxzr0406rozfFL1C4uOCaBiQzvgfoDne5K/fgjAvtXCedDhpTirZdsvy29GEUcA3td39JAMbsyShMaQAVrv/motq3vUy0FaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301775; c=relaxed/simple;
	bh=+yHBVrzvNvf3e+OYWrTr3rh7o88KktEN6hOeMWiY4vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qdma3E0mjleCneXoSpIxono8m5L9KRuOukQJiE9d6EDkNOFDaTzYg1QjWuZ7O85NM/exTpfnFwhZUbcAHd9c1gE/KYTM99ARdHke9ve5ZPr/nS+D04PxaJi3WyApjkpbFYSd8dX7MM472Dl4Ec6PTI7THwP/hn8z4LhNbOCmICE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X9Sic+dO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9Sic+dO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89118C19424;
	Sat, 28 Feb 2026 18:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301775;
	bh=+yHBVrzvNvf3e+OYWrTr3rh7o88KktEN6hOeMWiY4vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X9Sic+dO8fLFjY6MG6+oBcgEGm4WS0KFWm6KuGkvLLo1g212JHIr8Z224uOxdLv5d
	 W1nyKJNTy496kxUMhuYXF4sVuvOLH6mo5kWOsw8X8NUjovIfpxnQcvceRjrQJOh8yg
	 7qLl1bxdh4EeXribaDV4HsNCVxJUnT6DyukqYia9Nz2FyM8wN4/V1mgubCOMimzp7P
	 WRjkTZ4CtBCK2rx78b9T870afKjZMl7kZKaBEyQGSDCgZdxxCyEnnuLO8GdkFJSyCd
	 xAeLImCSH0Gy1XuOIqoMXuyBiSqAxEe0E6Rm6e++o2OnQBumhzz5BLeTtkzOwKlW/T
	 NBz7OsvBdmoIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/385] dm: fix unlocked test for dm_suspended_md
Date: Sat, 28 Feb 2026 12:56:45 -0500
Message-ID: <20260228180011.1568201-183-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 24c405fdbe215c45e57bba672cc42859038491ee ]

The function dm_blk_report_zones tests if the device is suspended with
the "dm_suspended_md" call. However, this function is called without
holding any locks, so the device may be suspended just after it.

Move the call to dm_suspended_md after dm_get_live_table, so that the
device can't be suspended after the suspended state was tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zone.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 04cc36a9d5ca4..d7b1c89fcd87b 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -66,11 +66,13 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		 * Zone revalidation during __bind() is in progress, but this
 		 * call is from a different process
 		 */
-		if (dm_suspended_md(md))
-			return -EAGAIN;
-
 		map = dm_get_live_table(md, &srcu_idx);
 		put_table = true;
+
+		if (dm_suspended_md(md)) {
+			ret = -EAGAIN;
+			goto do_put_table;
+		}
 	} else {
 		/* Zone revalidation during __bind() */
 		map = zone_revalidate_map;
@@ -80,6 +82,7 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		ret = dm_blk_do_report_zones(md, map, sector, nr_zones, cb,
 					     data);
 
+do_put_table:
 	if (put_table)
 		dm_put_live_table(md, srcu_idx);
 
-- 
2.51.0

