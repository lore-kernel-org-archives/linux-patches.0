Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBDC35AC1E;
	Sat, 12 Sep 2026 08:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201636; cv=none; b=MU0nsMNor1BTd6RvPsi364JhHT7MH0LYLGpvdeLKDxSPZFACc5Gidz6Qf2/rj58/T1VAJ2BbEgaJqE0CnDoTX5kBEk3yendwpP9JNcYn1FXODW1ybVdBgZ8Io+xILU+QxPJVm/RWXBP/QiT3ZYA6kmZRxg5R1imbcOsbYubBFsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201636; c=relaxed/simple;
	bh=UyHKI9GkOhC9h6MCr0RobFKbNmf+6fLvknVUkG0Y79I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYGoUvm1mCGU0/w0+RtG1p0Ggn8s0IQTwCQIV0BN6bMdbKTH8QJZelbceiGWc4giCY/BDpw4OLz/2ewZbasczJq5ljNTWIlAsG2Aef+PbrmUXv6xc+vhGqXaSn0LvmTlzOF04+wZ/LCv4++7nAYMlHkcqPJpGLetIbVnZdggZ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRX1suP2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRX1suP2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3E61F000FF;
	Sat, 12 Sep 2026 08:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201634;
	bh=O4jE7rcuTOben9/VJZEFilJk/YBmHic5Ln2BOdahkek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRX1suP2F9ocZhjNGFf9fkn6fJb0Ck4jHJo6ReWGjoKZLuUUYZIGrFc8IqLDGmH+a
	 JU+G59I1JzPGttjWimMJ+a+i3E2xh7aseDxqMKSx9wNO7qCWOTQFru5VXcgqsp3ypC
	 TR9QnXasFeG8b7cGJGOIasRf1w988GT109dG3NF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1035/1815] ublk: check for ublk_unmap_io() returning 0
Date: Sat, 12 Sep 2026 08:46:25 +0200
Message-ID: <20260912065713.317568767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6d6fffdfa439e..ebd84d36cd486 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1590,8 +1590,14 @@ static inline void __ublk_complete_rq(struct request *req, struct ublk_io *io,
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



