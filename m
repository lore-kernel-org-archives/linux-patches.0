Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC80B1D07AD;
	Wed,  2 Oct 2024 14:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878546; cv=none; b=QX8cqKtIto3Jd3R3yGPr97NKcE9g/wWsA8TC3oBJdnYGOvfolO5+7bQezPlIIRLeL05zRqk7OcEC6THZ8q7gYItJH5Il/HKKm7IA7WbSEtAaVuVnw+CtJG1yZKhCQOPzKDHWuX0PVz8ppSs+mLc8sUrNrAYoOyKzghUuWVfsXKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878546; c=relaxed/simple;
	bh=dXGfi6Wrd1Jr1E3c6vogkkLcIg20s6jBGRGMAoU/GRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9OozAzNqN0OA2Db48bf1tq2R7LNR9CkBAJ4Wp2mq+F9sAr9QlkBN69rdVg9qPZDm5suy3hcf8qfarQcV0JNx7xESgw3oHwrsBqUroKrKWYKmGB0xzPyxRpm8bXF/tEE/Oz0tVnhB1gaXJOLgSn2e7XOO0aejlUtvS9Fz60HVsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdy+c7vM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdy+c7vM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7ECC4CEC2;
	Wed,  2 Oct 2024 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878545;
	bh=dXGfi6Wrd1Jr1E3c6vogkkLcIg20s6jBGRGMAoU/GRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdy+c7vMaNfje94lyECBDNJAqL09NWNh120rLwmxhdIeTPk8LqihDEIXtJh2sKRFC
	 Po9VAs45bPgfaZZtYnfRpqwexplSjbm5FX8uE3/SFWuO4aK6lzMYtgLadVyX9pYB3L
	 +wJysZ/zILNLuO7QLRSDiYdQpyD2BWgQE5HXCusI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Sander <r.sander@heinlein-support.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 451/634] io_uring/rw: treat -EOPNOTSUPP for IOCB_NOWAIT like -EAGAIN
Date: Wed,  2 Oct 2024 14:59:11 +0200
Message-ID: <20241002125828.904019972@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit c0a9d496e0fece67db777bd48550376cf2960c47 upstream.

Some file systems, ocfs2 in this case, will return -EOPNOTSUPP for
an IOCB_NOWAIT read/write attempt. While this can be argued to be
correct, the usual return value for something that requires blocking
issue is -EAGAIN.

A refactoring io_uring commit dropped calling kiocb_done() for
negative return values, which is otherwise where we already do that
transformation. To ensure we catch it in both spots, check it in
__io_read() itself as well.

Reported-by: Robert Sander <r.sander@heinlein-support.de>
Link: https://fosstodon.org/@gurubert@mastodon.gurubert.de/113112431889638440
Cc: stable@vger.kernel.org
Fixes: a08d195b586a ("io_uring/rw: split io_read() into a helper")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -856,6 +856,14 @@ static int __io_read(struct io_kiocb *re
 
 	ret = io_iter_do_read(rw, &io->iter);
 
+	/*
+	 * Some file systems like to return -EOPNOTSUPP for an IOCB_NOWAIT
+	 * issue, even though they should be returning -EAGAIN. To be safe,
+	 * retry from blocking context for either.
+	 */
+	if (ret == -EOPNOTSUPP && force_nonblock)
+		ret = -EAGAIN;
+
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		/* If we can poll, just do that. */


