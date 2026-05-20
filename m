Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD9236BCDE;
	Wed, 20 May 2026 16:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296400; cv=none; b=BLRqs8RdCG6ff1aEPyyGZqQQLvA54WAEHqLirTCqgSpo00rWt9Wk9TT/YJe/TUf2iZDHy4Xa7q086Z/8fNdSVis0d2icymLWtkwNynHasRJgKbbp34THtk5pWQx52K9XqYS2se7N8K0LUDnMh8eNHd94Az/oMn1lDRR4l1rV9Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296400; c=relaxed/simple;
	bh=Yigtt9JdrUq60V3h+KK7kmG3E2Ax7JWcBptuGuSZjys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgacZDD3IZrK6hjz29JXklw+4IeRIYsmVeL+d+BO1rJhmx05TQcy9hXzy84nUa5UJ1MXBsG0mhFN++cCYOuCPm+hxk5xX4LzNdoxbwZcy7Bk3ZtrMpSLunf17KaTirds1Tcar8rUjwpaI/lNbgpogB2/2ORlXPnBy2y8oA/m6+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIHahUD1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIHahUD1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8011F00893;
	Wed, 20 May 2026 16:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296397;
	bh=6oWROzS3x235q1OWZ6+9tgMdc0Gdflu4mvgTWWY5Bdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIHahUD1I6SDzeBNOVE+hP1W6bPzA0DXHEp1txljmcqcLsgOx+9hrZ00KkUCVF4yv
	 6odPC3QHztZ9qI/BP4fUxGAL1sX0/pBOYcEaQufphUae1jF8icmB+yXBrmP1uGFjq4
	 QIaCw3fZhE4OD9xqCpGSLkJxX1uYHZMBYYvnGthM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0733/1146] f2fs: fix to preserve previous reserve_{blocks,node} value when remount
Date: Wed, 20 May 2026 18:16:23 +0200
Message-ID: <20260520162204.793163024@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 01968164d94762db2f703647c5acfa28613844f1 ]

The following steps will change previous value of reserve_{blocks,node},
this dones not match the original intention.

1.mount -t f2fs -o reserve_root=8192 imgfile test_mount/
F2FS-fs (loop56): Mounted with checkpoint version = 1b69f8c7
mount info:
/dev/block/loop56 on /data/test_mount type f2fs (xxx,reserve_root=8192,reserve_node=0,resuid=0,resgid=0,xxx)

2.mount -t f2fs -o remount,reserve_root=4096 /data/test_mount
F2FS-fs (loop56): Preserve previous reserve_root=8192
check mount info: reserve_root change to 4096
/dev/block/loop56 on /data/test_mount type f2fs (xxx,reserve_root=4096,reserve_node=0,resuid=0,resgid=0,xxx)

Prior to commit d18535132523 ("f2fs: separate the options parsing and options checking"),
the value of reserve_{blocks,node} was only set during the first mount, along with
the corresponding mount option F2FS_MOUNT_RESERVE_{ROOT,NODE} . If the mount option
F2FS_MOUNT_RESERVE_{ROOT,NODE} was found to have been set during the mount/remount,
the previously value of reserve_{blocks,node} would also be preserved, as shown in
the code below.
             if (test_opt(sbi, RESERVE_ROOT)) {
                   f2fs_info(sbi, "Preserve previous reserve_root=%u",
                          F2FS_OPTION(sbi).root_reserved_blocks);
             } else {
                   F2FS_OPTION(sbi).root_reserved_blocks = arg;
                   set_opt(sbi, RESERVE_ROOT);
             }
But commit d18535132523 ("f2fs: separate the options parsing and options checking")
only preserved the previous mount option; it did not preserve the previous value of
reserve_{blocks,node}. Since value of reserve_{blocks,node} value is assigned
or not depends on ctx->spec_mask, ctx->spec_mask should be alos handled in
f2fs_check_opt_consistency.

This patch will clear the corresponding ctx->spec_mask bits in f2fs_check_opt_consistency
to preserve the previously values of reserve_{blocks,node} if it already have a value.

Fixes: d18535132523 ("f2fs: separate the options parsing and options checking")
Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 255db40c49ed9..f44e962b1ee7d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1515,6 +1515,7 @@ static int f2fs_check_opt_consistency(struct fs_context *fc,
 			F2FS_OPTION(sbi).root_reserved_blocks);
 		ctx_clear_opt(ctx, F2FS_MOUNT_RESERVE_ROOT);
 		ctx->opt_mask &= ~BIT(F2FS_MOUNT_RESERVE_ROOT);
+		ctx->spec_mask &= ~F2FS_SPEC_reserve_root;
 	}
 	if (test_opt(sbi, RESERVE_NODE) &&
 			(ctx->opt_mask & BIT(F2FS_MOUNT_RESERVE_NODE)) &&
@@ -1523,6 +1524,7 @@ static int f2fs_check_opt_consistency(struct fs_context *fc,
 			F2FS_OPTION(sbi).root_reserved_nodes);
 		ctx_clear_opt(ctx, F2FS_MOUNT_RESERVE_NODE);
 		ctx->opt_mask &= ~BIT(F2FS_MOUNT_RESERVE_NODE);
+		ctx->spec_mask &= ~F2FS_SPEC_reserve_node;
 	}
 
 	err = f2fs_check_test_dummy_encryption(fc, sb);
-- 
2.53.0



