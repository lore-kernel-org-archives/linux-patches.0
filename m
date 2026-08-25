Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B5A40243B;
	Tue, 25 Aug 2026 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665143; cv=none; b=Fi5brx4XArUgQFeNe6c0N+lsoG8WQH3GmQy3G6QnqPzs2OoxyoiU3oGpaZTo/jw4e+3rDk4arBs8ZQApqevswWCIx+7jzT3Iqa3LEqwlrK0O328ictGC9V1g916Sxj9oL7HcDyFevog/s9A8VlHmatJLAz6yW/NTYj0zRXi6c0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665143; c=relaxed/simple;
	bh=QgBBWIuibVQZ0GQg3Tm7jcJT0ybozdWir/u1dmCtwbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/4jNvKtFxU5Me2H3UVU9pSk0oMx6hB7BuXrOLz2klFve5ZGGEk4pT7Hi2xLRaZpOJq2MnTy6tZth63WEWAqv0x9cASQAPxcbfI0dQCCn18LfTI1MeIxt054j1agrc417lIsg1sDHDzNcFTEmvTVFc/z28nPP0VFLZ1w2Bmdl30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaM3O1p8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaM3O1p8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A363F1F000E9;
	Tue, 25 Aug 2026 13:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665142;
	bh=bhC0ZAG0TGiZquMdGhUXMt3zo9e5zREpZxWMesPc4y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaM3O1p8nqc4ZrmHKGHy7wHtPGSfKDH7wOP2DWHaY+jbFRyjFLiqjwgygjQYvVrEk
	 PBeXcDx01V0igwi21oFTjQI2TOd8+eSCVt7zQyap50tlZfEnmEYGj3TWzmz8t2bS3T
	 t9emgY/aG774j1syuXRFiW16IU+IzFHokqas5pKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a4ccdd7ebf452e4d4701@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 21/94] io_uring/uring_cmd: dont skip completion for a synchronous multishot cmd
Date: Tue, 25 Aug 2026 15:25:17 +0200
Message-ID: <20260825132542.726043933@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit 360941242f09437a1e07cbed9b5a96663ffeabb6 upstream.

If IORING_URING_CMD_MULTISHOT is set, io_uring_cmd() treats any
non-negative return from ->uring_cmd() as the driver having taken
ownership of the request and returns IOU_ISSUE_SKIP_COMPLETE. But
nothing guarantees that the driver did so, and any handler that just
completes the command inline and returns 0 or a positive result then
leaves the request orphaned, leaking the io_kiocb, the async data,
and the file reference.

The special case isn't needed. ublk returns -EIOCBQUEUED for the
multishot fetch command, which is passed through as-is, and the poll
driven socket timestamp command returns -EAGAIN. Kill it, a multishot
handler that wants to hang on to the request must return -EIOCBQUEUED
or -EAGAIN like any other command.

Fixes: 620a50c92700 ("io_uring: uring_cmd: add multishot support")
Cc: stable@vger.kernel.org
Reported-by: syzbot+a4ccdd7ebf452e4d4701@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6a7a0194.b50370da.49fe0.0056.GAE@google.com/
Link: https://lore.kernel.org/all/20260811115125.1831170-1-vasilisalmpanis@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/uring_cmd.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -265,10 +265,6 @@ int io_uring_cmd(struct io_kiocb *req, u
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
-		if (ret >= 0)
-			return IOU_ISSUE_SKIP_COMPLETE;
-	}
 	if (ret == -EAGAIN) {
 		ioucmd->flags |= IORING_URING_CMD_REISSUE;
 		return ret;


