Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603DF560AAF;
	Wed,  9 Sep 2026 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964907; cv=none; b=UkHZ9jSkrr7hMyoWEMDSfsuTCJWN31TnomN20GFaWCNhZwZQ6rbkqSQNkekK6W2nFw3QidwLgdLxledZKyVT7+FYPaL5j+k4AdTMZW13PDhVbE3ZUmgxNrGvf+yXvT869WBiyFQzxqZLvpxKziFe6h56rDHc12f+zPj7xPT1aNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964907; c=relaxed/simple;
	bh=LgCBNPIqYfsOqBAMr7puYMDx3gswHUlPPFVJ3/XZHFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MG4fiirOYSQsLAnaV8h33S96pGg6Z+FTRTjY+fxBiJkm10Ncq6vEvBuyalridzqqrxW6O44/P3qrwldE+kkDs3DdiNrgdlx0otXyXFD2X41xS2QLMvXDfhk/+eVkw/bjxRTPbY4yMPfGvXTKKCv34g5QcQ1ovNcjRJ8d5bWil18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1X7U+MP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1X7U+MP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6831F00A3A;
	Wed,  9 Sep 2026 14:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964906;
	bh=gk1EMgE3qzMifVNrze11L35FauPbOhITuV18Cy5eCds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b1X7U+MPOKZqe4hFOqR13D1W/qj5zKeyK2LQEK9IDnP/XLP4yfg5KVDGgn1B4rbqy
	 CWATOr+UTKIKokbFgPCBmRDPQgy1a8164Gfr/cp9tokMLEv2C/oEKJaS4YLl/97V45
	 6sWe+yTrdAcgIlofZxzQM+mWEUfPtgq71krzNX5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 559/583] zram: set default primary compressor in zram_destroy_comps()
Date: Wed,  9 Sep 2026 15:44:04 +0200
Message-ID: <20260909134257.051321094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -2464,6 +2464,7 @@ static void zram_destroy_comps(struct zr
 	}
 
 	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2482,8 +2483,6 @@ static void zram_reset_device(struct zra
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static ssize_t disksize_store(struct device *dev,


