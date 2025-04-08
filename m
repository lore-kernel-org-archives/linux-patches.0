Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443C9265CAF;
	Tue,  8 Apr 2025 11:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110522; cv=none; b=qmEFq1Zl8FqU7kC0lPJzD+AiKawXBGamQbrF+kxgQkNCCrNskzzjies3Vu5HNf0kIi9mq3W+aYIB8ElZgn3RpHMoh8c8j2j5rj9ySW6VVoP0GL+5sxALRqWB7jMKi7JmJEoYbv7ME9W/8puaXVt7hjOiqMBAXWKQIISTmu6TYSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110522; c=relaxed/simple;
	bh=0NjHSK7N5TzxOP1QP0Y/RDjo0qok1E36PPxanSSoNWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUrVIqwdnrsBx65GMipEjNkdpLfWJeEwtird6uyHXCO8ay4N9SZYbuY6O/JokyjzXLgeKvzHrrar6nWdh2Bw2JGwmUucrw70/hjBMn03oIz54R0SzUqcPqo1b8L3VleOoOfHyRo5D9vqOwtXvKvPA6yB7OAww5B2gm6npLQjgQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2C+t9WS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2C+t9WS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C846DC4CEE5;
	Tue,  8 Apr 2025 11:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110522;
	bh=0NjHSK7N5TzxOP1QP0Y/RDjo0qok1E36PPxanSSoNWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2C+t9WSApykmD8AFDFb4lmv9APIDFo6evxg2+IMiRGauEojvwLWjawO3w7vYoMTg
	 ROb8UVStHl4wpXY8MUeV35SK3cWMwQf/dzNzr/AO81HqrYXQgn9CDa0ra3r3a6+f0I
	 c3mk6vjvVRIKiv/xAOryXz6rmhs4UMElVRCTPdIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 096/731] io_uring/io-wq: eliminate redundant io_work_get_acct() calls
Date: Tue,  8 Apr 2025 12:39:53 +0200
Message-ID: <20250408104916.502984607@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 3c75635f8ed482300931327847c50068a865a648 ]

Instead of calling io_work_get_acct() again, pass acct to
io_wq_insert_work() and io_wq_remove_pending().

This atomic access in io_work_get_acct() was done under the
`acct->lock`, and optimizing it away reduces lock contention a bit.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/r/20250128133927.3989681-2-max.kellermann@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 486ba4d84d62 ("io_uring/io-wq: do not use bogus hash value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 91019b4d03088..f7d09698e43ce 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -916,9 +916,8 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 	} while (work);
 }
 
-static void io_wq_insert_work(struct io_wq *wq, struct io_wq_work *work)
+static void io_wq_insert_work(struct io_wq *wq, struct io_wq_acct *acct, struct io_wq_work *work)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
@@ -964,7 +963,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	}
 
 	raw_spin_lock(&acct->lock);
-	io_wq_insert_work(wq, work);
+	io_wq_insert_work(wq, acct, work);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
@@ -1034,10 +1033,10 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 }
 
 static inline void io_wq_remove_pending(struct io_wq *wq,
+					struct io_wq_acct *acct,
 					 struct io_wq_work *work,
 					 struct io_wq_work_node *prev)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -1064,7 +1063,7 @@ static bool io_acct_cancel_pending_work(struct io_wq *wq,
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-		io_wq_remove_pending(wq, work, prev);
+		io_wq_remove_pending(wq, acct, work, prev);
 		raw_spin_unlock(&acct->lock);
 		io_run_cancel(work, wq);
 		match->nr_pending++;
-- 
2.39.5



