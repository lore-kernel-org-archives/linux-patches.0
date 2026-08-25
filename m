Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0145FFCB;
	Tue, 25 Aug 2026 13:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665126; cv=none; b=Ch2aZ4P1G6VVg14HWsi2UeOke9/9O3DzD7atFsUughaJTjhrsJwdV93/zIgmWw9Qbaqj5YtlW7TKLflYGPn6oIhAZOEHq9dfPOOjJSKmDj8nOHs9EttpUMTyMxSlPIFFn4f6x5oCKr6AuCdPwaXO2Zohmbw0AG9z06snQuWJcao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665126; c=relaxed/simple;
	bh=oZIqLfFghJH4l6Z7yzcFNed6x+eEcEEptwOuTaUMVRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+vDegDmaucDVsK4/dUjkm+RGPGGwsUJ2H0CeF11Vsh+hUzuDuH9/CJXOa69INfmwuSchi+BXqsMr8kz99mgW0S6th4Q+OFYgi99kxLralj5Maetp2nRUoS8exFdWKqC+dZLhk5TGHa/BA7tyqE0D5JoUtvScwoIgJtUfrLYoRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WON/bd5X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WON/bd5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2D91F000E9;
	Tue, 25 Aug 2026 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665124;
	bh=Xss6k7QQ3iTSfRzSPaUKOCMI7cmmw80jESUQj1zzncc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WON/bd5XZGlejTIbdp3pz6VI0t0jgBDQsVHskT/sj59m4zpwO75Jv0EWUSfn0fPuo
	 QcV7qqC0tV3gC4XZhQxOWM04kiV3J3SxGFfYRshN8kjqzxsmFWHQIvcUVeZJSxas15
	 FFM3wmwz/ZFjckj73lDphy3cbtLf4RmSRpNONobM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Lin <lin2530632123@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 16/94] io_uring/futex: dont mark futex wake requests as inflight
Date: Tue, 25 Aug 2026 15:25:12 +0200
Message-ID: <20260825132542.529543671@linuxfoundation.org>
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

commit 73e7019097473fc9f83a334ef2c6ab3343709fef upstream.

Commit 079afb081c42 ("io_uring/futex: mark wait requests as inflight")
added inflight tracking to ensure that do_exit() ->
io_uring_files_cancel() finds and cancels pending futex waits before the
mm goes away, as a private futex wait depends on the mm private futex
hash staying alive for the duration of the request. However, as
io_futex_prep() is shared between FUTEX_WAIT and FUTEX_WAKE, wake
requests got marked as inflight as well.

A futex wake executes fully inline at issue time and never depends on
the mm staying alive after completion, hence there's no need to track
it. Kill it.

Cc: stable@vger.kernel.org
Fixes: 079afb081c42 ("io_uring/futex: mark wait requests as inflight")
Reported-by: Chengfeng Lin <lin2530632123@gmail.com>
Link: https://lore.kernel.org/io-uring/CANGjgdn=R_qyUdE=j9za+vkmqcxacbP-84OHXF4nZ4ho9qRyVg@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/futex.c |   11 +++++++++++
 io_uring/futex.h |    1 +
 io_uring/opdef.c |    2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -144,6 +144,17 @@ int io_futex_prep(struct io_kiocb *req,
 	    !futex_validate_input(iof->futex_flags, iof->futex_mask))
 		return -EINVAL;
 
+	return 0;
+}
+
+int io_futex_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int ret;
+
+	ret = io_futex_prep(req, sqe);
+	if (unlikely(ret))
+		return ret;
+
 	/* Mark as inflight, so file exit cancelation will find it */
 	io_req_track_inflight(req);
 	return 0;
--- a/io_uring/futex.h
+++ b/io_uring/futex.h
@@ -3,6 +3,7 @@
 #include "cancel.h"
 
 int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_futex_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_futexv_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags);
 int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags);
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -466,7 +466,7 @@ const struct io_issue_def io_issue_defs[
 	},
 	[IORING_OP_FUTEX_WAIT] = {
 #if defined(CONFIG_FUTEX)
-		.prep			= io_futex_prep,
+		.prep			= io_futex_wait_prep,
 		.issue			= io_futex_wait,
 #else
 		.prep			= io_eopnotsupp_prep,


