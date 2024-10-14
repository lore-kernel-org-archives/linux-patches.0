Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164891DFEF;
	Mon, 14 Oct 2024 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915842; cv=none; b=i3VGTj1N0EPPUe/y4MJh1F6yb1u72y+2nfE76BmXwcDjp4nlnqBvyfydwff73rKhsw2rG9WUEOZ60UfVOT6cGQbhlHVAnKmpjZVhspx3y6p+WzhdEJe4lmcWlf2Fv41R+XKqf7CgZc4BbWBCPeRGkVZX1uCtfxUjv5tINuqGUX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915842; c=relaxed/simple;
	bh=DAoRWsP8cz9yeMI9NAIZbJ+0EMJ3LOByJrLck3dnkic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5UR8xjAFe5T3W6riXjx2k8bE9VQIWsg/m3vqUbcyZilqOAW4cuoYWz6Wr/O5GsvuvLfXp7q0tgC38t79WGo9WLEKwwMvSM+WChmkCQ82kSHGuSAD7Y+zhlWYThyyKCYdFIszqqcfGFfX5sk/mjnqCU/PnVhFWSjSCFYa11x/bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ksq6/L70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ksq6/L70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0102BC4CEC3;
	Mon, 14 Oct 2024 14:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915841;
	bh=DAoRWsP8cz9yeMI9NAIZbJ+0EMJ3LOByJrLck3dnkic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ksq6/L70vWgnVQSHMpdSMIqYlogfHitdRNadDeKcUQJ48GW/My2pWpurF7tOSVifW
	 E8Aj9cK0c0l2iZiJLvWM0QxeARU1+Qu87KslfSCcWFLQFyMfFzc/dX5lq/qB93q/Vs
	 NsYwYK5XYpyeITQ996BlgogM3jM1z27qvoRPQWcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jens Axboe <axboe@kernel.dk>,
	Minchan Kim <minchan@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 015/214] zram: dont free statically defined names
Date: Mon, 14 Oct 2024 16:17:58 +0200
Message-ID: <20241014141045.588644436@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Skvortsov <andrej.skvortzov@gmail.com>

[ Upstream commit 486fd58af7ac1098b68370b1d4d9f94a2a1c7124 ]

When CONFIG_ZRAM_MULTI_COMP isn't set ZRAM_SECONDARY_COMP can hold
default_compressor, because it's the same offset as ZRAM_PRIMARY_COMP, so
we need to make sure that we don't attempt to kfree() the statically
defined compressor name.

This is detected by KASAN.

==================================================================
  Call trace:
   kfree+0x60/0x3a0
   zram_destroy_comps+0x98/0x198 [zram]
   zram_reset_device+0x22c/0x4a8 [zram]
   reset_store+0x1bc/0x2d8 [zram]
   dev_attr_store+0x44/0x80
   sysfs_kf_write+0xfc/0x188
   kernfs_fop_write_iter+0x28c/0x428
   vfs_write+0x4dc/0x9b8
   ksys_write+0x100/0x1f8
   __arm64_sys_write+0x74/0xb8
   invoke_syscall+0xd8/0x260
   el0_svc_common.constprop.0+0xb4/0x240
   do_el0_svc+0x48/0x68
   el0_svc+0x40/0xc8
   el0t_64_sync_handler+0x120/0x130
   el0t_64_sync+0x190/0x198
==================================================================

Link: https://lkml.kernel.org/r/20240923164843.1117010-1-andrej.skvortzov@gmail.com
Fixes: 684826f8271a ("zram: free secondary algorithms names")
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reported-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Closes: https://lore.kernel.org/lkml/57130e48-dbb6-4047-a8c7-ebf5aaea93f4@linux.vnet.ibm.com/
Tested-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Cc: Chris Li <chrisl@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 1a875ac43d566..f25b1670e91ca 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1990,8 +1990,10 @@ static void zram_destroy_comps(struct zram *zram)
 		zram->num_active_comps--;
 	}
 
-	for (prio = ZRAM_SECONDARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
-		kfree(zram->comp_algs[prio]);
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
+		/* Do not free statically defined compression algorithms */
+		if (zram->comp_algs[prio] != default_compressor)
+			kfree(zram->comp_algs[prio]);
 		zram->comp_algs[prio] = NULL;
 	}
 }
-- 
2.43.0



