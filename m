Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE09DDB1;
	Thu, 13 Jun 2024 11:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278651; cv=none; b=Qb8jHesFPomm6nsediLXv4gaFP+ft7W1FiKJaVOtjPxDEfuULDbq3AMOqoz7e24p2hpqxfiWDZ+qHfiDcforHqJdgiCAMsUpIOdbYAlt/zwsyOiKELGkf+87W2XjacUHkdJ5RGNh2Rm/BlvLt1yIp/ryJlArAfGJYaLTe8lb3r4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278651; c=relaxed/simple;
	bh=7WACd20wx8wlZ1WQFyZlvKvLztj/0BfbLLyFonmI8As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sXkCcMnlQtdex/IKg1ubpWDnfYwnXIHhG7uz8EdPIEXYwXReyVv7xWGbaq0wQcSVguOC198MoEpTuzgZPKSXBTAGfXjtq0JJqG3DwsYt0WO4l/I9RCkv0Ki3xb0ctzkMwpJMZrBFJLmmdD3HylOV9/3rxyQJI7C5dr9J76uHHgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xqTXvVPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xqTXvVPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A814EC2BBFC;
	Thu, 13 Jun 2024 11:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278651;
	bh=7WACd20wx8wlZ1WQFyZlvKvLztj/0BfbLLyFonmI8As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xqTXvVPEtm017QKFc7Mu+1eIxG8nU49O8lTxpyIGIUIFlujEUrkZwE+5Y67IVIPi2
	 LRahwalACXG3Zk4IHxmjlonBC/Xl3oFyBBdNNyf8cIOGDNwNaEAvROMxU61hMXfgOz
	 wA6A9xIiokXYLu7XYqficFzE/sRbwXVQd8hRTsfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH 4.19 024/213] md: fix resync softlockup when bitmap size is less than array size
Date: Thu, 13 Jun 2024 13:31:12 +0200
Message-ID: <20240613113228.927326775@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit f0e729af2eb6bee9eb58c4df1087f14ebaefe26b ]

Is is reported that for dm-raid10, lvextend + lvchange --syncaction will
trigger following softlockup:

kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s! [mdX_resync:6976]
CPU: 7 PID: 3588 Comm: mdX_resync Kdump: loaded Not tainted 6.9.0-rc4-next-20240419 #1
RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
Call Trace:
 <TASK>
 md_bitmap_start_sync+0x6b/0xf0
 raid10_sync_request+0x25c/0x1b40 [raid10]
 md_do_sync+0x64b/0x1020
 md_thread+0xa7/0x170
 kthread+0xcf/0x100
 ret_from_fork+0x30/0x50
 ret_from_fork_asm+0x1a/0x30

And the detailed process is as follows:

md_do_sync
 j = mddev->resync_min
 while (j < max_sectors)
  sectors = raid10_sync_request(mddev, j, &skipped)
   if (!md_bitmap_start_sync(..., &sync_blocks))
    // md_bitmap_start_sync set sync_blocks to 0
    return sync_blocks + sectors_skippe;
  // sectors = 0;
  j += sectors;
  // j never change

Root cause is that commit 301867b1c168 ("md/raid10: check
slab-out-of-bounds in md_bitmap_get_counter") return early from
md_bitmap_get_counter(), without setting returned blocks.

Fix this problem by always set returned blocks from
md_bitmap_get_counter"(), as it used to be.

Noted that this patch just fix the softlockup problem in kernel, the
case that bitmap size doesn't match array size still need to be fixed.

Fixes: 301867b1c168 ("md/raid10: check slab-out-of-bounds in md_bitmap_get_counter")
Reported-and-tested-by: Nigel Croxon <ncroxon@redhat.com>
Closes: https://lore.kernel.org/all/71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20240422065824.2516-1-yukuai1@huaweicloud.com
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md-bitmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7ca81e917aef4..6cbf4a069652c 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1358,7 +1358,7 @@ __acquires(bitmap->lock)
 	sector_t chunk = offset >> bitmap->chunkshift;
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
 	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
-	sector_t csize;
+	sector_t csize = ((sector_t)1) << bitmap->chunkshift;
 	int err;
 
 	if (page >= bitmap->pages) {
@@ -1367,6 +1367,7 @@ __acquires(bitmap->lock)
 		 * End-of-device while looking for a whole page or
 		 * user set a huge number to sysfs bitmap_set_bits.
 		 */
+		*blocks = csize - (offset & (csize - 1));
 		return NULL;
 	}
 	err = md_bitmap_checkpage(bitmap, page, create, 0);
@@ -1375,8 +1376,7 @@ __acquires(bitmap->lock)
 	    bitmap->bp[page].map == NULL)
 		csize = ((sector_t)1) << (bitmap->chunkshift +
 					  PAGE_COUNTER_SHIFT);
-	else
-		csize = ((sector_t)1) << bitmap->chunkshift;
+
 	*blocks = csize - (offset & (csize - 1));
 
 	if (err < 0)
-- 
2.43.0



