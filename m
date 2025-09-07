Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94F81DF246;
	Sun,  7 Sep 2025 20:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277413; cv=none; b=sfxWRslfQasBMxEaIB6CUbhEVX/MWwr7nTGF64FFRJfq51ZTnpCmCg14kf58neBLUgzi9frXsSyeLU/HCXaMChPPnR9rUI7pvX5tKDQvjuAtZxJRWglwL4t86bM96JEsIpyhmzTO/cKHEG0oUjVznBIbf4eMVf0i01LNUZwXe3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277413; c=relaxed/simple;
	bh=0FOvq8JqEYaehbWWJONUnyeFvJ+hBbuiS8FY3OGEips=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6WDp96PFiQslYBIkk70ksB7N0ux1YzzyF/PyMy3i2tcuFVBW9NNPbm3iwSp5Z2lj0r05m2Km2tUrJQ4vmio95uNMZuFtxIrGlvvqlpp5kgRXLFbJ+W3f7yg4qIbQ3qF1/1lM7Jp31kMQ4t18BUeUDzUYVkYK4oUXTLsFGpPXGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZzOHll1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZzOHll1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6A4C4CEF0;
	Sun,  7 Sep 2025 20:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277413;
	bh=0FOvq8JqEYaehbWWJONUnyeFvJ+hBbuiS8FY3OGEips=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZzOHll1rNzPt9eZccWxa71fEr3Prx+jf2vdcvUG5MYYJK6vv3jt8gReFz9Vh0EWv
	 iCS/N9JdCwe/rjqrrv2x4QvvkW5raqqUiSVJVV14retwaLgUFQx5wMC1G+Xi2kEbQt
	 uAFqVAUsmh5ARDk7ZJ0Pgbnn6G0xzc5INo9Nr2+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 6.12 130/175] md/raid1,raid10: strip REQ_NOWAIT from member bios
Date: Sun,  7 Sep 2025 21:58:45 +0200
Message-ID: <20250907195617.927482308@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zheng Qixing <zhengqixing@huawei.com>

commit 5fa31c49928139fa948f078b094d80f12ed83f5f upstream.

RAID layers don't implement proper non-blocking semantics for
REQ_NOWAIT, making the flag potentially misleading when propagated
to member disks.

This patch clear REQ_NOWAIT from cloned bios in raid1/raid10. Retain
original bio's REQ_NOWAIT flag for upper layer error handling.

Maybe we can implement non-blocking I/O handling mechanisms within
RAID in future work.

Fixes: 9f346f7d4ea7 ("md/raid1,raid10: don't handle IO error for REQ_RAHEAD and REQ_NOWAIT")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250702102341.1969154-1-zhengqixing@huaweicloud.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1392,7 +1392,7 @@ static void raid1_read_request(struct md
 	}
 	read_bio = bio_alloc_clone(mirror->rdev->bdev, bio, gfp,
 				   &mddev->bio_set);
-
+	read_bio->bi_opf &= ~REQ_NOWAIT;
 	r1_bio->bios[rdisk] = read_bio;
 
 	read_bio->bi_iter.bi_sector = r1_bio->sector +
@@ -1613,6 +1613,7 @@ static void raid1_write_request(struct m
 				wait_for_serialization(rdev, r1_bio);
 		}
 
+		mbio->bi_opf &= ~REQ_NOWAIT;
 		r1_bio->bios[i] = mbio;
 
 		mbio->bi_iter.bi_sector	= (r1_bio->sector + rdev->data_offset);
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1218,6 +1218,7 @@ static void raid10_read_request(struct m
 		r10_bio->master_bio = bio;
 	}
 	read_bio = bio_alloc_clone(rdev->bdev, bio, gfp, &mddev->bio_set);
+	read_bio->bi_opf &= ~REQ_NOWAIT;
 
 	r10_bio->devs[slot].bio = read_bio;
 	r10_bio->devs[slot].rdev = rdev;
@@ -1248,6 +1249,7 @@ static void raid10_write_one_disk(struct
 			     conf->mirrors[devnum].rdev;
 
 	mbio = bio_alloc_clone(rdev->bdev, bio, GFP_NOIO, &mddev->bio_set);
+	mbio->bi_opf &= ~REQ_NOWAIT;
 	if (replacement)
 		r10_bio->devs[n_copy].repl_bio = mbio;
 	else


