Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585337;
	b=UsX7xbFQXDpVGvRHA98SDBAoWln4vb6WTTLAgfwcR/EB9DzU9Gjz6P1CHY2r1AVEWwP/
	 rdLjK2TaxIO/HcQ9n6SlMT4iinx2LgQHY2JuSaEDTGHWe64sEf5pige2cOctHINvoW8d2
	 vKWpv9oAR7MHq2iAZnbTyXZlaS0496lGtWFZIWuc/D1DVynnYVBZ0YCcqXndC31w3p3X7
	 Parz6Qs+0akKQgzrmYaADBhe9Fb2DNHTA+DM9nCgCgazkH8qdrYOIiqdWtx0IUjYsk2zq
	 jppjy7LJ5lUqFZGUDtx1Ytupff7qE8XCQWJeFfRky2+EorjO6UK7Cl8MCP0I+KE7Z5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S2BQVnNOt+/OxVEWzx/T9Pnhob1LJbZPNskuBWhVynA=;
	b=UQCOZ7zkXXhbanUrX1RA+wUL98WoIzbwnA2j+6BtxHhTR0Vczqrmbc2O4sC01HbRskmi
	 ny8a2GTfczxgStScges3uuxpZ+hJXXsBnQg1KrmLKO6JOxbbHdYQaSIrlQKquN6l8+upF
	 HKtRJ2ZDHSxyZjfjTt3PZ7+o3NxnNqtF51hI2elXE/nAF7DZIZQ3fNIwbkCJ2MUxZ/wxv
	 9tqTQ3iTbGWRqAZNo44lDJh++wxJeWmF7Ua198kDUULI8elLs5rx8dk5r+f1LNffrdXTb
	 cE7XtSr/gQkHeMm/oTiVdgyUvEOTTu6ROGQJ0EMeZnJGgflfH51R81iUtcIjCSFwQNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaeQXtTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5651060A2607;
	Fri, 13 Nov 2026 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XaeQXtTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E027A1F000C5;
	Fri, 13 Nov 2026 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585337;
	bh=S2BQVnNOt+/OxVEWzx/T9Pnhob1LJbZPNskuBWhVynA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaeQXtTHhsd9+BV7BOUkCuHb1CP+Bj69o9pRouVvImxfHBhFt0ZhlBkNjA8yWZkAv
	 8UBCW2Kt2vfAHqR3c880RHgzB2uf1BcbLSp7YUGNOn9wHcd7ljnNwHJMvJ52ZLsQuY
	 2q7If4hqfsdBFj1pnDSkR2sSKl3cIm4Pl8p5OnAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 022/507] io_uring/cancel: drop sqd->lock while SQPOLL waits
Date: Fri, 13 Nov 2026 10:45:26 -0500
Message-ID: <20261113153754.145993472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

Commit cb0306c52ffae083a86fb283de67875ae7a9500e upstream.

An exiting SQPOLL thread calls io_uring_cancel_generic() with sqd->lock
held, and keeps it across cond_resched() and the sleep until nothing is
in flight anymore. A zero-copy send notification can't be canceled and
stays pending as long as the peer doesn't read, so the lock is held for
as long as a user cares to. io_ring_exit_work() needs it to park the
thread, and so do IORING_REGISTER_IOWQ_AFF and IOWQ_MAX_WORKERS. With
64 such rings sharing the thread, every iou_exit slot sleeps on the lock
and no ring gets freed for anyone.

Drop the lock around cond_resched() and the sleep, like the main loop of
the thread does. Each walk of ctx_list is still under one hold, and
nothing is kept across the unlock. The thread drops its io-wq, frees its
tctx and clears sqd->thread under one hold after the loop, so whoever
holds the lock and finds sqd->thread set can still use them.

Fixes: 63809137ebb5 ("io_uring: flush notifiers after sendzc")
Signed-off-by: Chris Mason <mason@kernel.org>
[axboe: adapted to the schedule_timeout() based loop]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[axboe: adapted to the schedule() based wait loop]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cancel.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 75a21ecfe69c8..c7ed51377dea2 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -650,7 +650,16 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		}
 
 		if (loop) {
+			/*
+			 * A request that runs in io-wq and doesn't end makes
+			 * each round come here. Don't hold sqd->lock for that
+			 * long either.
+			 */
+			if (sqd)
+				mutex_unlock(&sqd->lock);
 			cond_resched();
+			if (sqd)
+				mutex_lock(&sqd->lock);
 			continue;
 		}
 
@@ -678,8 +687,20 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx, !cancel_all))
+		if (inflight == tctx_inflight(tctx, !cancel_all)) {
+			/*
+			 * A zero-copy notification can't be canceled, and a
+			 * peer that doesn't read keeps it pending. Don't hold
+			 * sqd->lock while waiting for it, or whoever wants the
+			 * lock sleeps as long. No ring is used across this,
+			 * the next round walks ->ctx_list anew.
+			 */
+			if (sqd)
+				mutex_unlock(&sqd->lock);
 			schedule();
+			if (sqd)
+				mutex_lock(&sqd->lock);
+		}
 end_wait:
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
-- 
2.53.0



