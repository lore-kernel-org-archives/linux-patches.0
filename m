Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFA93F210C;
	Mon, 17 Aug 2026 15:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979637; cv=none; b=H6TaN/M1d0JpF4vS23NtJZoONMR1903qBZi4bOWczc2HAKSTebtzWzL7HmDQsUzCxBERoieitpxBpUONyQADxecSd/XjRX+N9xUjDjkMwqBoqgNHg7sn/UPmbWIfar9fZaCb8IRChXTUtz84WC1D+IuS22WcZnfExE+iYXX9Na4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979637; c=relaxed/simple;
	bh=Uevjw92A6HhzH+lRGDgDmHuLRmB3+N0FmxepQs/K9yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ8KFL9wYgWZunTfQlkxQrsuauOHopOvGGtKUEqoEnEwFwXhMkn6V1OT2MVlu3DAguiKh1dF9fu1K5MjnBsjb7QoQcLK+Qbom6qALjJ8X1lWgwbDkXORsSDCURJfvAkBvNEe4pUuB56d6FA/BQXKviGWtuZzu0bvQDbLFtpbHw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ri+2Pry3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ri+2Pry3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345C71F000E9;
	Mon, 17 Aug 2026 15:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979636;
	bh=x/MyDUq4qbcag7IhJWwE1x71Kb77+VZQEhDDsb6MwxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ri+2Pry3b1DakmoBKdx5vFiBfvgx82BhYtW90AGHFc/8/juNRNuMijEHiO7ou6VKb
	 ihA0pnNkHeZDGqp87OLcxA95ZWu8E8f8qZBWUY8tcrUlE9E1Wl0l/IaP1ievMks5E6
	 7D4NnEKEgBCZqnhC1TEiD/4g21E9meWCziGJKgp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 295/609] io_uring/rw: fix missing ERESTARTSYS conversion in read paths
Date: Mon, 17 Aug 2026 15:29:51 +0200
Message-ID: <20260817132554.088827314@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yitang Yang <yi1tang.yang@gmail.com>

Commit ab05caca123c6d0b41850b7c05b246e4dca4a770 upstream.

Both read and write may receive internal restart error codes from
the filesystem layer and should be converted to -EINTR. However,
when multishot read support was added, the error code normalization
was lost for both io_read() and io_read_mshot().

Extract the conversion into io_fixup_restart_res() and apply it
in all three locations: io_rw_done(), io_read(), and io_read_mshot().

Fixes: a08d195b586a ("io_uring/rw: split io_read() into a helper")
Cc: stable@vger.kernel.org
Signed-off-by: Yitang Yang <yi1tang.yang@gmail.com>
Link: https://patch.msgid.link/20260722124551.130563-1-yi1tang.yang@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b75f62dccce6..cbd3ee9a9373 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -129,27 +129,37 @@ void io_readv_writev_cleanup(struct io_kiocb *req)
 	kfree(io->free_iovec);
 }
 
-static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+static inline ssize_t io_fixup_restart_res(ssize_t ret)
 {
 	switch (ret) {
-	case -EIOCBQUEUED:
-		break;
 	case -ERESTARTSYS:
 	case -ERESTARTNOINTR:
 	case -ERESTARTNOHAND:
 	case -ERESTART_RESTARTBLOCK:
 		/*
 		 * We can't just restart the syscall, since previously
-		 * submitted sqes may already be in progress. Just fail this
-		 * IO with EINTR.
+		 * submitted sqes may already be in progress. Just fail
+		 * this IO with EINTR.
 		 */
-		ret = -EINTR;
-		fallthrough;
+		return -EINTR;
 	default:
-		kiocb->ki_complete(kiocb, ret);
+		return ret;
 	}
 }
 
+static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
+{
+	/* IO was queued async, completion will happen later */
+	if (ret == -EIOCBQUEUED)
+		return;
+
+	/* transform internal restart error codes */
+	if (unlikely(ret < 0))
+		ret = io_fixup_restart_res(ret);
+
+	kiocb->ki_complete(kiocb, ret);
+}
+
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -854,7 +864,7 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret >= 0)
 		return kiocb_done(req, ret, issue_flags);
 
-	return ret;
+	return io_fixup_restart_res(ret);
 }
 
 static bool io_kiocb_start_write(struct io_kiocb *req, struct kiocb *kiocb)
-- 
2.53.0



