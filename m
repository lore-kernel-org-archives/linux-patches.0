Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E727481FCC;
	Tue, 25 Aug 2026 13:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664926; cv=none; b=mSWEeeRotR7dKw8DMbJip03S64zHANs+AGrf/bH1eGdFUDWPBnXbEqZi7R+oEHXJWon7/86DXzQjNtwvyn0qllphkSBLP36uMtZdR3yStgg/XWTi3OaBUZFM3YABQ+0rOLjgT/PgZa1KvqXWNqiBO20swjD8X8HZvJlZWdvhIlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664926; c=relaxed/simple;
	bh=TpUJqImBJWye+IE0d9eeBXGKf1o2nOxEFOz0FniZIkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojHqDQRZV8eTVSiHWV+uRaxnPvxlPyuJxEidHLeyKhM4D9m63bAZvoCM6FUKkj+ezNPC3wINfooNy3OldBvXgT6B0BH5H7+dcBH8eDBvPdozfAwKUr/IW8Oh+c4eniz3znB7X++eneS1A4oiHFKGGS27A+Xs5mwXroiZHczB9uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jllgb2P5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jllgb2P5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540C01F000E9;
	Tue, 25 Aug 2026 13:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664924;
	bh=PgCdtnqs1uU7T2wohmSLr6/fRJHIFqtclMc4C9TJtUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jllgb2P5MkQ0VoF6tpJf9wzhc3yi0P1tNCx7BZ5bHw9CO9SXLDU4cycOoDZVRquNt
	 4DjeyzGio0IX1zilEvPM2MHUMCvIf51LrXfndrJx0wZfKxDaQgYePyK4JlVJryG3ha
	 xXnKzKzMmpObLeAZKm/E2jGL3hYGQwHawJem0SEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Lin <lin2530632123@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 013/101] io_uring/futex: dont mark futex wake requests as inflight
Date: Tue, 25 Aug 2026 15:24:51 +0200
Message-ID: <20260825132542.520932037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -465,7 +465,7 @@ const struct io_issue_def io_issue_defs[
 	},
 	[IORING_OP_FUTEX_WAIT] = {
 #if defined(CONFIG_FUTEX)
-		.prep			= io_futex_prep,
+		.prep			= io_futex_wait_prep,
 		.issue			= io_futex_wait,
 #else
 		.prep			= io_eopnotsupp_prep,


