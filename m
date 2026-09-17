Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5215B49D58C;
	Thu, 17 Sep 2026 18:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671559; cv=none; b=edCW5Q7N1aXCWTJjbCGI8mdnRW3qk6slNU0CoCfq5kvMJ2RMWlUYIiewLV4aj4VwxoLvRsW17BJJiESNXGAss4FGuEB2+oyOrL3PfqNHRnSdBRmEbsZ0PYhKbxd3yytg1H73YUxwKFYsRuEYx0r5vu90Ma8w2BwW+xawiY3hW5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671559; c=relaxed/simple;
	bh=DF3cP09fTdvW9VLQGZ6kq92TR1oC79oHmWkWa9yPTWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vEnaF+0r4DXsiwqAXA5w/n/20jev8cUWFdynEddIpcmHWGfAQVpy2OZP/jXIEdo7BWizerrBtzqYNQAOPSWFVgypWr3cCmt3nzlLX43PQ0KKtQbtWMn00xfo13pwYBaudlOTOl7t0K7qDh2Ojx5wEmNIKu2S2Y/RlPI51FKavmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSeb8v0w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSeb8v0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939241F000FF;
	Thu, 17 Sep 2026 18:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671558;
	bh=qOsHFDw6JbuhOFYMcP0L9qLS2aqzv3rLlTw6wqsEo6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSeb8v0wEmoQ+Dkc2mR7xGhdgDD9oODioFUe3Dflon5ETsygqIrWGLqeKCbseVIeq
	 ZAqZtyg5dE6xy79Ev03v5qt9HvhUg2boLKAt/HtqQXVcx1b1KIriG1eEPIdmWHPWQJ
	 jgeosza0ExajFznmABfkEJsSS0YiQ9Rj1FmbHzXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1017/1102] zram: set default primary compressor in zram_destroy_comps()
Date: Thu, 17 Sep 2026 16:16:00 +0100
Message-ID: <20260917151606.286195023@linuxfoundation.org>
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

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit dde75313eed0b014c437f48dd75c0308b592cbf9 ]

Patch series "zram: fix zram issues reported by sashiko".

Sashiko drove by and reported [1] a couple of zram issues:
a possible BUG_ON() in zlib code due to missing winbits range
validation and one possible NULL-ptr dereference in zcomp.
Both are low risk yet still worth fixing.

This patch (of 2):

zram_destroy_comps() resets all compressors and leaves them set to NULL,
including the primary one, which is invalid device state, as now
comp_algorithm_show()->strcmp() can be called on a NULL compressor.  Set
default primary compressor in zram_destroy_comps().

Link: https://lore.kernel.org/20260729045745.775973-2-senozhatsky@chromium.org
Fixes: 486fd58af7ac ("zram: don't free statically defined names")
Link: https://sashiko.dev/#/patchset/20260728092935.31139-1-haoqinhuang7@gmail.com [1]
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Haoqin Huang <haoqinhuang7@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2163,6 +2163,7 @@ static void zram_destroy_comps(struct zr
 	}
 
 	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2181,8 +2182,6 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static ssize_t disksize_store(struct device *dev,


