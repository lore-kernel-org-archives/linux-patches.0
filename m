Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEA91FC110;
	Sat, 12 Sep 2026 10:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209660; cv=none; b=VusiqqqAz+4YadgTvXRTpixV1tMn1KBx4IRHhU/ae6AFp8Gu0ncCvhmKSMePzYScPSesieUrnjJkVFaRQiGcBn3wYt28Oj37TQsejFqQLhjGESvRkBJLAn8Ufk6R2eQCgYDezPaEvxNR8oRLlcSPK0i8VcdoZEkuBLsa0TxiTTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209660; c=relaxed/simple;
	bh=eedf3Zk8Y0+lp+YJAYvbTuBj9Ph72IVXCxTLTwmnMZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgCLVvfi3nuZ5eKMBWi8zIGBi/Aggh6GJt1XVs5VDGrDjAqT4zpWfzobNdiWI0ngptj6cRqBcqp1RQGnspqzKBmOWoOTBgouRLdKOqc+pmUmX962P23JA1e+TBaHGkGLnhFdPMSndr4jLsysNXDcFrt2P9PWzSlsdno5PSV+YaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7GWfize; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7GWfize"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2AC1F000FF;
	Sat, 12 Sep 2026 10:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209658;
	bh=KY1EGV5XXyFs5wuoPLQgwaaIfT2v2d4ldIwIQi9is1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7GWfizerHep0XcvD410s1Gzxx/WqUKLZMsGggM6vXqyD2ruZFMjrkuKXh76eFSU/
	 U1IH48M+i+c0LoUy6jhyME4m8uEULgDSIIOksrIoBzMthm13hem7JoP+EhUT7TrlzQ
	 Zz0nz112XK4Rp+2a4ce1Wmg3RfnShp4FbUICTi50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <tom.leiming@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0865/1518] ublk: check import_ubuf() return value
Date: Sat, 12 Sep 2026 08:50:34 +0200
Message-ID: <20260912065643.017816636@linuxfoundation.org>
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

[ Upstream commit 3831568792af75b6523fa93bb91560e29189cf55 ]

import_ubuf() can fail if the address range (provided by the userspace
ublk server) is outside the allowed user address space. Return that 0
bytes were copied if import_ubuf() fails rather than passing an
uninitialized struct iov_iter to ublk_copy_user_pages().

Fixes: 981f95a571e3 ("ublk: cleanup ublk_copy_user_pages")
Reported-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Link: https://patch.msgid.link/20260729171041.45061-2-csander@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index e7a77f27555ed..755add69fb8a8 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1050,7 +1050,10 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		struct iov_iter iter;
 		const int dir = ITER_DEST;
 
-		import_ubuf(dir, u64_to_user_ptr(io->buf.addr), rq_bytes, &iter);
+		if (import_ubuf(dir, u64_to_user_ptr(io->buf.addr), rq_bytes,
+				&iter) < 0)
+			return 0;
+
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
@@ -1071,7 +1074,10 @@ static int ublk_unmap_io(bool need_map,
 
 		WARN_ON_ONCE(io->res > rq_bytes);
 
-		import_ubuf(dir, u64_to_user_ptr(io->buf.addr), io->res, &iter);
+		if (import_ubuf(dir, u64_to_user_ptr(io->buf.addr), io->res,
+				&iter) < 0)
+			return 0;
+
 		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
-- 
2.53.0



