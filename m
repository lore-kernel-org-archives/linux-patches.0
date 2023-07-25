Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D861D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:48:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613A0C433C7;
	Tue, 25 Jul 2023 10:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282101;
	bh=sqJB2OOTz2MJahsANIM9yn0mCcr/cCmdEUWTyysMqVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mxHdmqKiX979bWwxzm9ngWi9QofuPX+jPtI/qwrqS/s3YQk4DR/1NUfS0bg3sFLo3
	 PAtJF99ujjUiOOM3ZZ09/euZDLkIBEjn4ju4S0EUjouFD3x0UUtHfDLCyyI+gT9JSK
	 9vFB20JjCAGFIyNa7/b/6hVbPT4T7QxPKJW5ZT1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.4 001/227] io_uring: treat -EAGAIN for REQ_F_NOWAIT as final for io-wq
Date: Tue, 25 Jul 2023 12:42:48 +0200
Message-ID: <20230725104514.870622178@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jens Axboe <axboe@kernel.dk>

commit a9be202269580ca611c6cebac90eaf1795497800 upstream.

io-wq assumes that an issue is blocking, but it may not be if the
request type has asked for a non-blocking attempt. If we get
-EAGAIN for that case, then we need to treat it as a final result
and not retry or arm poll for it.

Cc: stable@vger.kernel.org # 5.10+
Link: https://github.com/axboe/liburing/issues/897
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2032,6 +2032,14 @@ fail:
 		ret = io_issue_sqe(req, issue_flags);
 		if (ret != -EAGAIN)
 			break;
+
+		/*
+		 * If REQ_F_NOWAIT is set, then don't wait or retry with
+		 * poll. -EAGAIN is final for that case.
+		 */
+		if (req->flags & REQ_F_NOWAIT)
+			break;
+
 		/*
 		 * We can get EAGAIN for iopolled IO even though we're
 		 * forcing a sync submission from here, since we can't


