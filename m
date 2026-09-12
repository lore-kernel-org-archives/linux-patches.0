Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5183CA6F;
	Sat, 12 Sep 2026 14:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223538; cv=none; b=LkeacwDs+Pqw0nSBWHFTnuVGmO/+b8J1eC4Bz+THQ49FrdoZp9NFph8HQIel3252VXjCJyZ4r+hSyKKSkW+EJJT9jMqx/QXxr+mmV0tN1rVt8mK63+aYbBvquqY56xa16CUIYuUODtss7GB9e+/IBvu1HaEoDK0eEATsLSrBGNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223538; c=relaxed/simple;
	bh=it3hWNPFIlvQGQtrptCVFEj0ZqHROOQee+Fb87o1dRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APNngiIb/DgDc9BV+o598BaJfHdsEuooKaqc5+oIOKRrrwrEyh0AN6tRhbXmPn/w7sxpJ03i0fN7pdIPvJBmNDRHWvIwg+oxW2xMpQsf1YBf3ac1MGjA8i4hlSLdffF3JMXO2Sxop2RoUuxjMM21OiRDxatvPbKkTRIkPRYz1ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFyvDhx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFyvDhx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7CE1F000FF;
	Sat, 12 Sep 2026 14:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223537;
	bh=aNxL4F7WS3ScEH3rSQmHBfvIu5RtUEqNx1NrnNiQGJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFyvDhx2Es1s5iI1VLFkY58vIV/Jo83xfdFKoDV154YgDcvVhvyWgGza01XRMeCiO
	 ds5DP3X9eq3FXft7M71N0xveIjLF1T4bBHhmFg5yDbZIWI5TUghB//nWA+vqEyQ2BS
	 08vy2jEqUyGyOj7Jdje2tBHMS0olzAXGKS6RbDcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhouminqiang <zhouminqiang2@huawei.com>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0808/1424] mtd: part: reject MTDPART_OFS_RETAIN in mtd_add_partition()
Date: Sat, 12 Sep 2026 08:54:00 +0200
Message-ID: <20260912065625.387269287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: zhouminqiang <zhouminqiang2@huawei.com>

[ Upstream commit b759d5bb6265419344ee9729fd0dc07ad85719d8 ]

mtd_add_partition() does not reject the special offset value
MTDPART_OFS_RETAIN (-3), which leads to a WARN_ON in
add_mtd_device() when called through the BLKPG ioctl on NAND
devices. The RETAIN value depends on cur_offset being the end of
the previous partition, but in the dynamic partition path
cur_offset equals the offset argument itself, causing undefined
behavior.

Commit 5daa7b21496a ("mtd: prepare partition add and del functions
for ioctl requests") introduced mtd_add_partition() and correctly
rejected MTDPART_OFS_APPEND (-1) and MTDPART_OFS_NXTBLK (-2),
since those special offsets rely on cur_offset tracking the
previous partition's end. However, commit 1a31368bf92e ("mtd: add a flags
for partitions which should just leave smth. after them")
later added MTDPART_OFS_RETAIN (-3) for the static
partition table path without updating mtd_add_partition() to
also reject this value.

With offset=-3 passed via BLKPG, the RETAIN size calculation in
allocate_partition() underflows (parent_size - 0xFFFFFFFFFFFFFFFD
= parent_size + 3). If the underflow result does not appear to
leave enough space, allocate_partition() jumps to out_register via
goto, skipping erasesize initialization. This results in
erasesize=0, which triggers:

WARN_ON((!mtd->erasesize || !master->_erase) &&
		!(mtd->flags & MTD_NO_ERASE))

in add_mtd_device(). If the underflow result appears to leave
enough space, a bogus partition size is calculated, but the
"out of reach" sanity check catches the invalid offset and
creates a disabled empty partition (offset=0, size=0) instead
of returning an error.

Fix this by adding MTDPART_OFS_RETAIN to the rejection list in
mtd_add_partition(), consistent with the existing handling of
APPEND and NXTBLK.

Fixes: 1a31368bf92e ("mtd: add a flags for partitions which should just leave smth. after them")

Signed-off-by: zhouminqiang <zhouminqiang2@huawei.com>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdpart.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 23483db8f30c9..5c809a12aff5d 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -254,7 +254,8 @@ int mtd_add_partition(struct mtd_info *parent, const char *name,
 
 	/* the direct offset is expected */
 	if (offset == MTDPART_OFS_APPEND ||
-	    offset == MTDPART_OFS_NXTBLK)
+	    offset == MTDPART_OFS_NXTBLK ||
+	    offset == MTDPART_OFS_RETAIN)
 		return -EINVAL;
 
 	if (length == MTDPART_SIZ_FULL)
-- 
2.53.0



