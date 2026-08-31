Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F82F47DD5C;
	Mon, 31 Aug 2026 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184777; cv=none; b=VhWYY2/gxs59NNP9knxwD3yu5g8qVf14b6BZDzIDU1xkz3mJrQ8/FDRpydgCsu18F2WRBuoYQIlfqM80iqAB1Y3/qmDET9cHtcrxHayBhSpVhQLeVGqDKlU4RZ8CMJzp6aFCgDS0EP8hya7yy2OI8HoTfqRHnbuSdWvXpB1Yyl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184777; c=relaxed/simple;
	bh=9aZwEiIY2j4BidGb9E1Gxt5OI0abW/SUCRyr2z66Nrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wet+CY2xVXFd2Vjj/jFwpecWo0y0LDI5V876PBNQsgouA2Y1LxG3JDAGoaAGZr/2GWDmuFfM7MB1/RhgNotzCBEHk5G5c8B+/M6gUFmYWydOtOQzMhvDFQSEQyDRa3K6Aimt8AsLeT0gtjfAiyzD8np4AJRmrxVhUhwnGRrDLeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yzH2U61j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yzH2U61j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A92E1F000E9;
	Mon, 31 Aug 2026 13:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184776;
	bh=NSZP+Da8Jkkk3ynv2t+nc/r0TkGl5aNWEQhq6VuWvoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yzH2U61j1kCfJDWCmb/mebYUDOtIQhFzL/NtU7vEW8ZE12mWIcGmsHty/+xXrrja3
	 +eUGHDbt6H7gnaeIp6o39T4sKtl3uItgLAa7Qq7feRBo1mYIpo2O2xkgZPio1RVEnU
	 AnMKc512jCqvAuG5/jLtWZk7mJPJhO23e40oLToM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b8d61a58b7c7ebd2c8e0@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	syzbot+2aca91e1d3ae43aef10c@syzkaller.appspotmail.com,
	=?UTF-8?q?Miguel=20Garc=C3=ADa?= <miguelgarciaroman8@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 35/92] block: make bio_check_eod work for zero sized devices
Date: Mon, 31 Aug 2026 15:34:33 +0200
Message-ID: <20260831133401.526079712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 3eb96946f0be6bf447cbdf219aba22bc42672f92 upstream.

Since the dawn of time bio_check_eod has a check for a non-zero size of
the device.  This doesn't really make any sense as we never want to send
I/O to a device that's been set to zero size, or never moved out of that.

I am a bit surprised we haven't caught this for a long time, but the
removal of the extra validation inside of zram caused syzbot to trip
over this issue recently.  I've added a Fixes tag for that commit, but
the issue really goes back way before git history.

Fixes: 9fe95babc742 ("zram: remove valid_io_request")
Reported-by: syzbot+b8d61a58b7c7ebd2c8e0@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230524060538.1593686-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>

Backport note for 6.1.y:

The same underlying bug affects 6.1.y even though 9fe95babc742 is not in
that tree.  The syzbot reproducer attaches a socket to /dev/nbd0 without
setting its capacity, then mounts it as BEFS.  BEFS calls sb_bread() while
bdev_nr_sectors() is zero.  The maxsector guard makes bio_check_eod() accept
that read, which reaches NBD and waits for a response instead of failing
with -EIO.  syzbot reproduced the resulting __bread_gfp() hang on 6.1.y and
identified this upstream commit by fix bisection.

Reported-by: syzbot+2aca91e1d3ae43aef10c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2aca91e1d3ae43aef10c
Signed-off-by: Miguel García <miguelgarciaroman8@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 25b4733f25d3d..1fcd80a1c54fd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -515,7 +515,7 @@ static inline int bio_check_eod(struct bio *bio)
 	sector_t maxsector = bdev_nr_sectors(bio->bi_bdev);
 	unsigned int nr_sectors = bio_sectors(bio);
 
-	if (nr_sectors && maxsector &&
+	if (nr_sectors &&
 	    (nr_sectors > maxsector ||
 	     bio->bi_iter.bi_sector > maxsector - nr_sectors)) {
 		pr_info_ratelimited("%s: attempt to access beyond end of device\n"
-- 
2.53.0



