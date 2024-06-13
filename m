Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337EE142E84;
	Thu, 13 Jun 2024 12:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281866; cv=none; b=rUDJnrJaI/OUQ+oaL6w8noAqJP3nvtpfa4xGO2rDbnwyoeu1TWFBPHUrLJpo4n0NA633zAbqJCO/OG8z2dS5wgAEECQmQcHssxBR6WzV63q87J4yf9TIU2AD6T6grPgR1eQFWXhSu2mnCaafBRCzbiDpuJNCN+bgb0vFWz3bKdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281866; c=relaxed/simple;
	bh=ZpO8xbNy5CxD4MaEEMnyelNmE5nYeBVjLWhVW3OOVDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3Ibzq9akCwjfs1rmifa1qxE9AfazrwXEBsKA+sH57R4spvaA1yBJ8/h5MoPPQOk1tDLRDEiIG/sLSkuYwTXZYDUGVhdryAwMJ0x7KeWWolURZyPkW55h/SoaghA4BAd+kxECSR4Px5df4yrlH59hvS8kkYwN0bAa9esizfZYXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+aCo28x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+aCo28x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E31FC32786;
	Thu, 13 Jun 2024 12:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281865;
	bh=ZpO8xbNy5CxD4MaEEMnyelNmE5nYeBVjLWhVW3OOVDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+aCo28xKZO+lLXyUeVX6xdg7s0DUcOWIxqoJjP4xjoNjjnsQ0ORHlJ5lqe3Z0dcm
	 3utglVcVhRgEQuONUqtWoVB4c8L4qL3mmsGEn5JxqVQje1ILOahJT5iCpVRk6JhAE2
	 sxcwJ8erMgGBEN6W3NTKBXahUG02WR9G/bl0F420=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH 5.15 051/402] md: fix resync softlockup when bitmap size is less than array size
Date: Thu, 13 Jun 2024 13:30:08 +0200
Message-ID: <20240613113304.129498548@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index 49c46f3aea573..b26e22dd9ba2e 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1355,7 +1355,7 @@ __acquires(bitmap->lock)
 	sector_t chunk = offset >> bitmap->chunkshift;
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
 	unsigned long pageoff = (chunk & PAGE_COUNTER_MASK) << COUNTER_BYTE_SHIFT;
-	sector_t csize;
+	sector_t csize = ((sector_t)1) << bitmap->chunkshift;
 	int err;
 
 	if (page >= bitmap->pages) {
@@ -1364,6 +1364,7 @@ __acquires(bitmap->lock)
 		 * End-of-device while looking for a whole page or
 		 * user set a huge number to sysfs bitmap_set_bits.
 		 */
+		*blocks = csize - (offset & (csize - 1));
 		return NULL;
 	}
 	err = md_bitmap_checkpage(bitmap, page, create, 0);
@@ -1372,8 +1373,7 @@ __acquires(bitmap->lock)
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



