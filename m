Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048FCEED8;
	Sat, 12 Sep 2026 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224664; cv=none; b=WZplhQd/1o4VKf7L/TtNFyfedVumYXnk5gmcTpSEBFd1dttvihNGRXosr+8DpUg/LmpGNR+8Ymt+uTagKdyLg0NOEDIy6LJlAZiqfd8xgu22n989IY6wC5wn1MtWg/dmzv4e9Aj7KfaoXDk3GJGHiFRciMuc4hvMz5OXpUyl37I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224664; c=relaxed/simple;
	bh=uRobHrFh3/5gcSvAa5+JflBWTtdV033Qu0tH/aq2OMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhDuO82aT0PSFMWIwCJT/FGcOl+5IbgVxdFYG2DNvPvNMc2BgWpxTlLpq8Rz7z+ySmEIrXU9pkDkZ5xJpaWLJg6uAvpc3Y6IQhUex/S905PP2ZLlImIjIEkcV30JYTrWtNxH/Ee4phAT1ydKKTmPKb2Fi/FYVAjIFD/2/hBjZWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0r6LGOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0r6LGOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E441F000FF;
	Sat, 12 Sep 2026 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224662;
	bh=Iv71VeaXegS7IyN+8wPA7X4yWSVE8CHzQgaWZ/sYK5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0r6LGOBuUN9UvwtOwFI+agjqseDToR2WUcz4Qv34HR9u1Q/2Wjlr4UqRrbHWWf92
	 1/pXVL0meYYTrXZKtU3pk+mp8cVZdWwPqH60N6zlX4DcV8rdFGagouEreM1RfKGRtR
	 nyaWGSf4+jdtkg7WvcA5zlsR4tE9l9Pk5SxQySso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1037/1424] ublk: check for ublk_unmap_io() returning 0
Date: Sat, 12 Sep 2026 08:57:49 +0200
Message-ID: <20260912065630.534023383@linuxfoundation.org>
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

From: Caleb Sander Mateos <csander@purestorage.com>

[ Upstream commit 24fd3706178f1ae5501fd1ff9036e170ed0665ba ]

If the userspace ublk server passes an unmapped address as the data
buffer for a completed ublk read, ublk_unmap_io() will return 0
indicating no bytes could be copied. Currently, this will result in
calling blk_update_request() with nr_bytes=0, which doesn't seem
supported. Fail the I/O with BLK_STS_IOERR in this case instead.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://patch.msgid.link/20260729171041.45061-3-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 59b2633001ae0..356f32b6f1803 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1099,8 +1099,14 @@ static inline void __ublk_complete_rq(struct request *req)
 	 *
 	 * Re-read simply for this unlikely case.
 	 */
-	if (unlikely(unmapped_bytes < io->res))
+	if (unlikely(unmapped_bytes < io->res)) {
+		if (unlikely(!unmapped_bytes)) {
+			res = BLK_STS_IOERR;
+			goto exit;
+		}
+
 		io->res = unmapped_bytes;
+	}
 
 	/*
 	 * Run bio->bi_end_io() with softirqs disabled. If the final fput
-- 
2.53.0



