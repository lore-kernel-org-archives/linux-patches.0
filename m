Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E3220FAB3;
	Tue, 12 Nov 2024 10:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407137; cv=none; b=RVelcEdfbZMUmpkkzu46RLvT547iA8wQQc9AzX/6LNSMi/dktkVLxGbGjqY0+2Al6mFY6BILebmh2ABxOwt8t9MkpkxJiTVWv7hGINwH0uw14c6z6+yrydRgPxcbfPyBwz/eSvKyu1CzeBe8DF34Odc0RXoEtte3/5TrEUhNerY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407137; c=relaxed/simple;
	bh=FPKZNxCE/VzjYOOOcQdUeNtuszjfGLYsbHWDw3FwX5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mBHEyQrd/sQyUIvYzMhISQ4nV5KwcfIaazxacs4y+c+winryqpu/LWfZlk/co2H3MJTqret5Ey2pu9hsWueOj8GaFX0zemJVi/LcQ2HRuPiXDUlFAUfOsUEq8mkNmBT9WBVfEIqdqOy39vamCOPbIob0KocORwSAsa41a1fK0qY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y+yGqjGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y+yGqjGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43657C4CECD;
	Tue, 12 Nov 2024 10:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407137;
	bh=FPKZNxCE/VzjYOOOcQdUeNtuszjfGLYsbHWDw3FwX5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y+yGqjGl4tVHBJ52F2GTWusja7FUStTIg/TC2M19qWPjpYYVSMbcefpQ4JoIhCbhO
	 8NaSqSAAodDPPtNbxO57U3r1GPZTb+i9LGl6TKZH9zttrn9/F7dSJY3yaP0HIh9pkp
	 WMmY/rrTLZybwfwSI3voPFSqcZCxA9oSHcwk1J1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenru <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 30/76] scsi: sd_zbc: Use kvzalloc() to allocate REPORT ZONES buffer
Date: Tue, 12 Nov 2024 11:20:55 +0100
Message-ID: <20241112101840.935185154@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit 7ce3e6107103214d354a16729a472f588be60572 ]

We have two reports of failed memory allocation in btrfs' code which is
calling into report zones.

Both of these reports have the following signature coming from
__vmalloc_area_node():

 kworker/u17:5: vmalloc error: size 0, failed to allocate pages, mode:0x10dc2(GFP_KERNEL|__GFP_HIGHMEM|__GFP_NORETRY|__GFP_ZERO), nodemask=(null),cpuset=/,mems_allowed=0

Further debugging showed these where allocations of one sector (512
bytes) and at least one of the reporter's systems where low on memory,
so going through the overhead of allocating a vm area failed.

Switching the allocation from __vmalloc() to kvzalloc() avoids the
overhead of vmalloc() on small allocations and succeeds.

Note: the buffer is already freed using kvfree() so there's no need to
adjust the free path.

Cc: Qu Wenru <wqu@suse.com>
Cc: Naohiro Aota <naohiro.aota@wdc.com>
Link: https://github.com/kdave/btrfs-progs/issues/779
Link: https://github.com/kdave/btrfs-progs/issues/915
Fixes: 23a50861adda ("scsi: sd_zbc: Cleanup sd_zbc_alloc_report_buffer()")
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/r/20241030110253.11718-1-jth@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd_zbc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index ed06798983f87..00791a42b8d87 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -168,8 +168,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	bufsize = min_t(size_t, bufsize, queue_max_segments(q) << PAGE_SHIFT);
 
 	while (bufsize >= SECTOR_SIZE) {
-		buf = __vmalloc(bufsize,
-				GFP_KERNEL | __GFP_ZERO | __GFP_NORETRY);
+		buf = kvzalloc(bufsize, GFP_KERNEL | __GFP_NORETRY);
 		if (buf) {
 			*buflen = bufsize;
 			return buf;
-- 
2.43.0



