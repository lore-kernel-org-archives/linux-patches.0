Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEE92517AC;
	Mon, 22 Sep 2025 19:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570339; cv=none; b=oszWLFbzz7VrJP6uiaE+P2PSBTtNEfsN4WjoYSkwD4kfo7ujeM8m5lvQKGf0kWoQTjIEJQxVDEaUBazOJw3siOgOSAkVg92l0Wvi8Z2fE6luRUJ5kR2fTg8P3XDG6xe5zKMLbsk8G7SgUavj6RSt+S2uGBzhfulTddnDmi3nssM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570339; c=relaxed/simple;
	bh=EsU0fYavsBxf9grkx85QV+Cfl2v5CfOp/DFEfFAGJQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptSOWOrrivwhFSJ4FNFXI83xSDwJb44TIAr+Lk1GGogVvg8nR8pNgvaqEFA5eXSnVGhGN24reZwyDCkSGUNNXF5pFal2p0rXxvDpn60xMj/Si4701XJqAtSyLX0uhdvFHtTZVRPrlY+7MZMnciNxb66hxBVQTNcnt18wnGWnh54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRWY8Cq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRWY8Cq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499ECC4CEF0;
	Mon, 22 Sep 2025 19:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570339;
	bh=EsU0fYavsBxf9grkx85QV+Cfl2v5CfOp/DFEfFAGJQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRWY8Cq4KmgRR/MHLamJhCnoRhHdy7a7D85Lv7Ak1bcHwu8zi5hg2P7sPyTqR9AZJ
	 csHnlGr5YSVIoaROjTNQ4xq0S3h6hQuxrcBWsWpTssZRXcOo6LQGJyWcJIjZhQmPm+
	 IO1VbhPKRyqymTYKiFRZzwX2eaH6WbiLxS5HOubk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Fengnan Chang <changfengnan@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 098/149] io_uring/io-wq: fix `max_workers` breakage and `nr_workers` underflow
Date: Mon, 22 Sep 2025 21:29:58 +0200
Message-ID: <20250922192415.354953654@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

commit cd4ea81be3eb94047ad023c631afd9bd6c295400 upstream.

Commit 88e6c42e40de ("io_uring/io-wq: add check free worker before
create new worker") reused the variable `do_create` for something
else, abusing it for the free worker check.

This caused the value to effectively always be `true` at the time
`nr_workers < max_workers` was checked, but it should really be
`false`.  This means the `max_workers` setting was ignored, and worse:
if the limit had already been reached, incrementing `nr_workers` was
skipped even though another worker would be created.

When later lots of workers exit, the `nr_workers` field could easily
underflow, making the problem worse because more and more workers
would be created without incrementing `nr_workers`.

The simple solution is to use a different variable for the free worker
check instead of using one variable for two different things.

Cc: stable@vger.kernel.org
Fixes: 88e6c42e40de ("io_uring/io-wq: add check free worker before create new worker")
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Fengnan Chang <changfengnan@bytedance.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 17dfaa0395c4..1d03b2fc4b25 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -352,16 +352,16 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_wq *wq;
 
 	struct io_wq_acct *acct;
-	bool do_create = false;
+	bool activated_free_worker, do_create = false;
 
 	worker = container_of(cb, struct io_worker, create_work);
 	wq = worker->wq;
 	acct = worker->acct;
 
 	rcu_read_lock();
-	do_create = !io_acct_activate_free_worker(acct);
+	activated_free_worker = io_acct_activate_free_worker(acct);
 	rcu_read_unlock();
-	if (!do_create)
+	if (activated_free_worker)
 		goto no_need_create;
 
 	raw_spin_lock(&acct->workers_lock);
-- 
2.51.0



