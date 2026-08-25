Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30303DD502;
	Tue, 25 Aug 2026 13:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664566; cv=none; b=qtMMdshXNAKybY/bZCpUEHvNU4gyTK4lf2nCf/CwsF+5xRlkEAh+eUyvZtFO8UO+u7nFevMo1A/1EiO0On7XDFnbXFQyX/CA6wx4LcUZIV0otvsCGn5A5Vxq+9NnqoP8wteCMdw3Wczi1RGJAjKKckknah4SC0hhD4MId44YyKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664566; c=relaxed/simple;
	bh=3F5kGlXWcdgw0s9/gDhztgJrKWuA/viXKfYkT8lSeCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Em74lEysnGkjM0RssTxVjm+Z4JXNKTP/3MBkGI2bGuOz8r7QEqlmCx8ydqDepy3Axq0qNwUj4DChh8R8WWfW0VEZoPvu0maPjUR2BdG7AwSNA5xxoQ1ax0rMP/KT0hnE3cQA7/dqMHeU12aYb7VrmLh+ARPt8M6XfqPOeypdKI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGAwhTzW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGAwhTzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041C21F00A3A;
	Tue, 25 Aug 2026 13:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664565;
	bh=0/4/BazrH5iIbxt21EfpulhnhU4jW2QrODiNTMBaTAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGAwhTzWmVKT2fJB5QOV+AlefPzhgn1duFtiylgUOQMAGCTlfJaf+s+gm3+a2TnC6
	 dmyB1174MPB1qw+R79+hJ25p0ThlzsaEsHuo4JTMR17yAxJ8FAxKJHEORdcqrsBJeO
	 UCjeetNT5NIOOZaWGGjJ0HnInL8NJhX8ekU/Pkog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Lin <lin2530632123@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 14/82] io_uring/futex: dont mark futex wake requests as inflight
Date: Tue, 25 Aug 2026 15:25:01 +0200
Message-ID: <20260825132542.084695461@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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
@@ -149,6 +149,17 @@ int io_futex_prep(struct io_kiocb *req,
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
@@ -467,7 +467,7 @@ const struct io_issue_def io_issue_defs[
 	},
 	[IORING_OP_FUTEX_WAIT] = {
 #if defined(CONFIG_FUTEX)
-		.prep			= io_futex_prep,
+		.prep			= io_futex_wait_prep,
 		.issue			= io_futex_wait,
 #else
 		.prep			= io_eopnotsupp_prep,


