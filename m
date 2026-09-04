Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841263515D2;
	Fri,  4 Sep 2026 05:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498633; cv=none; b=pXYzzdy0QskzXbfdwpMnJ+s/vcpdIK9cQE0BRW9X4v+sWnvZS2oIRIC+TLpJhaoJLTawvFXv9iw1iso1UpSU7WmoXe3rmZaDxcQlRv7y2VtNvs3UdenYXfVbD8/zbyTGlnfyi08P7BvaKmyQgcix/BxnsMbcPLZuaEzrGlC4wm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498633; c=relaxed/simple;
	bh=tbDEo9c/TnIb/WeKQEpdQUYAlgNVjHYibriyY7Ah2o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/i9F15lLdlkeds5/QY0jrQuR/whCxpAOu3vQzcknaghBBRFuNmyDSHrWrwc03Nvdy521n9VqSUSfbdtDkiDS2P9tCh/PMxqFTCGnVJ3kO5+9MAJHa0BRoc/nsiO39HCH4YYus195xRUJ8QuFCk23CmSPaNNA6HR9LmdF4Lf6SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwYlEo0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwYlEo0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA85E1F00A3D;
	Fri,  4 Sep 2026 05:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498632;
	bh=GglkQNeXqqwPcwep9IipyCO2LFhzdLM2iEnd/+bFELE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwYlEo0AwcxdaPBeEzhc76mrxKuNxxBmlVm+3xx2q8gl++iJfR3LPQRT9dAxSNphr
	 pCob3qLmAo6ejFLitucHNZkelufOvR3k7a/mInw0sqk/2thdjwfrn2AXebmBU3+9HI
	 AnnwsXUiOJeZwN1GDEBnerKjKqnDutDMU9ICuwdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Haoqin Huang <haoqinhuang7@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 133/713] zram: set default primary compressor in zram_destroy_comps()
Date: Fri,  4 Sep 2026 06:51:41 +0200
Message-ID: <20260904045806.813319965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

commit dde75313eed0b014c437f48dd75c0308b592cbf9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2841,6 +2841,7 @@ static void zram_destroy_comps(struct zr
 		zram->comp_algs[prio] = NULL;
 
 	zram_comp_params_reset(zram);
+	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static void zram_reset_device(struct zram *zram)
@@ -2858,8 +2859,6 @@ static void zram_reset_device(struct zra
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	reset_bdev(zram);
-
-	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 }
 
 static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,


