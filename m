Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F9C185924;
	Fri, 15 Nov 2024 06:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653813; cv=none; b=UKdxl4uX9ttDG1g4n2xH7EKNqBpTaLpKrAhir9bZ0Xv9Tk8cT6qiyOCNIgmi70JOpefQ5LyPYISkQqpQc6fjI56kDx0gxo1xE5Bj9UGQnTeWEFkuDkcXdQOgry7Sg74Px8QznTRcofIZBwWr07dl/Z/aJLI0gQRJt8+ZXnkBF1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653813; c=relaxed/simple;
	bh=zSMakonphGiz/6y3AvbjFvOqSAptlkDsX93zdx4NrQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrU4/XjoFvuVblmt/IfyY68cjxxzFb3ydujwqikBtKiTuZvIVEN5hFi4V5neBMpQl1UZoqmlZy9LR/bSEGleEf68KQMbWAjT4TrOk+MhsB+R19R7LeKFLJJSPTseyszbGIFTcAKMFQ64vRaQIlHEQOmNsqGWvO/qUVtjy2m358w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0GYKMgAk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0GYKMgAk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50074C4CECF;
	Fri, 15 Nov 2024 06:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653812;
	bh=zSMakonphGiz/6y3AvbjFvOqSAptlkDsX93zdx4NrQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0GYKMgAkH1cvWOfAtIHR6H9dvsDX0zFJcCT/Ir8ctP3vOUDHuEPiIOaggVxFHpyUn
	 AEGfKrbVsy9I5Xunf8UzHQajns4WoWKSXuEu7toDSUlE2YvXfGQRHZNVk1x9oXyRjz
	 e5glKZiFMUR1ayCu7I5SmG8o3BLcL+4iyw0Xif0M=
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
Subject: [PATCH 5.10 26/82] scsi: sd_zbc: Use kvzalloc() to allocate REPORT ZONES buffer
Date: Fri, 15 Nov 2024 07:38:03 +0100
Message-ID: <20241115063726.505452960@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 01088f333dbc4..9b5dca0b6cf9a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -169,8 +169,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
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



