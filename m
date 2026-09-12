Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9A81FC110;
	Sat, 12 Sep 2026 10:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209669; cv=none; b=VIKjMmjK5hf4JFRXPCKM4Ht97qUmCYA+CoSjsfo9L6YPSTnXZj0s2PeKYq4XTqwWoiFjL+OOQE1oOl2zfivmT1sd2lme4b6dm9AjfdlAriGlwK3fMnOMtA2xsozdjhJRM6nbzjh3LZcVasadLQdKEgOb0IuBPVvZ7Cjd3riBvyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209669; c=relaxed/simple;
	bh=4goAMExOFtS9lP1bSppFgfkH5jwuqeDszi/GvzWox44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a90VZbadUCGZrLPAVGBXV5zFA5C9n+dN3F3FMHCoYD37DG9g+PdMZDGKFHLZCVJPR60QwxPj5t11UXxFyQC5t1/Ny/RAXVZ1IjuIRYsDMQPMGC7RjS2x4mUTE9RidBfD3tFpXrqclesVUU6z5wQEfDmVX31ZDhhtMftw1tPi75I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMgi38s3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMgi38s3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30021F000FF;
	Sat, 12 Sep 2026 10:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209668;
	bh=H/pIHYIT+VCgKI069L/NTVAOLx6lKaLV3n7QqyCOYik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMgi38s31ARtuB2GL9CKZGOkM81G9/cnd4m5bvOF0Gn01sUJRE1DiF7EzLU6a2sRt
	 6MOjzJeoLfhqH8tbPuUF0Jqt1VLpNrguxJgGNYhm7bfqbY4vdGJDq3IVzVy+3Q2J/1
	 pyLBnaAAgKBudxvky7qo1ImQOYxCJ1xaZOe99fQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0866/1518] ublk: check for ublk_unmap_io() returning 0
Date: Sat, 12 Sep 2026 08:50:35 +0200
Message-ID: <20260912065643.040688596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 755add69fb8a8..d71407fc1f4c8 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1196,8 +1196,14 @@ static inline void __ublk_complete_rq(struct request *req, struct ublk_io *io,
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



