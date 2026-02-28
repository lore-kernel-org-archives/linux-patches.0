Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AE6301F0D;
	Sat, 28 Feb 2026 17:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301429; cv=none; b=DAEmaW7OONE3GTK7msUleDbBAJAe7pnutnvex49xtt3oe6DvMeUgbk8H0w5crao2q0a1oyUuGNLlHw52YAnghAS8EDT1viKCZGWBqBpoE/BrpobuOTln7jamCqSgQ5R5vZD+xVOhIA9BGZnaCUuDEZV+XqTRYrIOuHqD8LFs8JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301429; c=relaxed/simple;
	bh=Aqc0C09FHgHvnnRPqXKzOg3T8s79hVLPi8LPOoDVkRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1pz/DEiHgF+uBHUtQcEvvMDZqJ0pnPq3juhdUFiOPnU5RQjYNEBOuYWYMHHSlsovKI9v9Ttgy9JR/5JTBhNF+k4tbaG43SLHEAQtIuo98cX87t71pzYP6d8kw0Y/3i1/OA6L+EnDFINyy+1hKaYmnEZQEfaMfrfUxUN1xEMyv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rEwsGaBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rEwsGaBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58579C19423;
	Sat, 28 Feb 2026 17:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301428;
	bh=Aqc0C09FHgHvnnRPqXKzOg3T8s79hVLPi8LPOoDVkRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rEwsGaBdYcBli4yF811cfHPu1h2JQNdEMjHcu7wxIHtKHgBvZwZsr3+g5pJOfRCRx
	 uYwtHDXWYoG1i34TXUwGXCm2BicdY70dwWXhIGzousu7HM5s7UxjQu6qyNaFj7tscf
	 8U/dlF1zQzGOIcdf3FC0qoYdy2el79xcGSCHJnN6ZqZqnA9wU2yfDwrRwB6c08slXK
	 wStiZR5D2efmG6GhDir+PniAT5vKXmSI8GhSFP95SounR6mFf/qJYA5Blbt8TE+wUi
	 nzPKs5OuWulWODLSkHWMP5W3MJMNebLg/3rTgqzh6MGT//uhTN6z1fj7+FwCgXxDzK
	 BC1J9inFUELSA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jack Wang <jinpu.wang@ionos.com>,
	stable@vger.kernel.org,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 619/752] md/bitmap: fix GPF in write_page caused by resize race
Date: Sat, 28 Feb 2026 12:45:30 -0500
Message-ID: <20260228174750.1542406-619-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 46ef85f854dfa9d5226b3c1c46493d79556c9589 ]

A General Protection Fault occurs in write_page() during array resize:
RIP: 0010:write_page+0x22b/0x3c0 [md_mod]

This is a use-after-free race between bitmap_daemon_work() and
__bitmap_resize(). The daemon iterates over `bitmap->storage.filemap`
without locking, while the resize path frees that storage via
md_bitmap_file_unmap(). `quiesce()` does not stop the md thread,
allowing concurrent access to freed pages.

Fix by holding `mddev->bitmap_info.mutex` during the bitmap update.

Link: https://lore.kernel.org/linux-raid/20260120102456.25169-1-jinpu.wang@ionos.com
Closes: https://lore.kernel.org/linux-raid/CAMGffE=Mbfp=7xD_hYxXk1PAaCZNSEAVeQGKGy7YF9f2S4=NEA@mail.gmail.com/T/#u
Cc: stable@vger.kernel.org
Fixes: d60b479d177a ("md/bitmap: add bitmap_resize function to allow bitmap resizing.")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 84b7e2af6dbaa..7bb56d0491a2f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2453,6 +2453,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 		memcpy(page_address(store.sb_page),
 		       page_address(bitmap->storage.sb_page),
 		       sizeof(bitmap_super_t));
+	mutex_lock(&bitmap->mddev->bitmap_info.mutex);
 	spin_lock_irq(&bitmap->counts.lock);
 	md_bitmap_file_unmap(&bitmap->storage);
 	bitmap->storage = store;
@@ -2560,7 +2561,7 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);
 	}
 	spin_unlock_irq(&bitmap->counts.lock);
-
+	mutex_unlock(&bitmap->mddev->bitmap_info.mutex);
 	if (!init) {
 		__bitmap_unplug(bitmap);
 		bitmap->mddev->pers->quiesce(bitmap->mddev, 0);
-- 
2.51.0

