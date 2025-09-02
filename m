Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36F3304BDE;
	Tue,  2 Sep 2025 13:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819409; cv=none; b=JNO1VN3l7xnrfDvDNBGpt4DcYBl+WJCh5h7Eqfa6gkOQFGKnEDVw+ddRN3iHRf619EgaC44J18ZmWnbVuYuOFVd2fStGe3Z+17JkByFne1EQCWfpp/JQgvVsA1pDt4mUGyDqpWe3GURuc/N7/XI7ABCZL7rpUDcMwL7YxcI2ZXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819409; c=relaxed/simple;
	bh=3XfpMu0+dND1ZSTufAlTA7IYddTMfNFQzN725WC5Q8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oolvGTM6duWmNDx6z7ZEf7Rneumfym1WTFyoJGG2pF9p5Xai74NHrMtB361JCvaq9oVRwdnpH/laVNVNSzIw6ydTyIbBnnBs0N0VDIDbjf+vEFPjl8MGTxk/9Nbqpa8KJtKXKUQxojtHQ7UETRyRZirYTSefPY3OxVsK0Lk4J1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BOjYlXD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BOjYlXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46F10C4CEED;
	Tue,  2 Sep 2025 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819408;
	bh=3XfpMu0+dND1ZSTufAlTA7IYddTMfNFQzN725WC5Q8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BOjYlXDMFv9YfblKEgMcmKB5t/zntndzg4aboIHQ2xmvqyQHbTxnAkJWOiB492RQ
	 AVQon9wUreMgGi1wefcdzjwfAsEa1S8Zahjssqkip7KAuELwlI0e4e4vlshm1tp1LP
	 9yPEw3sXQGhM2rbGq143wOtSY6qCGXS2N9A6vw0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Diangang Li <lidiangang@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 025/142] io_uring/io-wq: add check free worker before create new worker
Date: Tue,  2 Sep 2025 15:18:47 +0200
Message-ID: <20250902131949.108458313@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Fengnan Chang <changfengnan@bytedance.com>

[ Upstream commit 9d83e1f05c98bab5de350bef89177e2be8b34db0 ]

After commit 0b2b066f8a85 ("io_uring/io-wq: only create a new worker
if it can make progress"), in our produce environment, we still
observe that part of io_worker threads keeps creating and destroying.
After analysis, it was confirmed that this was due to a more complex
scenario involving a large number of fsync operations, which can be
abstracted as frequent write + fsync operations on multiple files in
a single uring instance. Since write is a hash operation while fsync
is not, and fsync is likely to be suspended during execution, the
action of checking the hash value in
io_wqe_dec_running cannot handle such scenarios.
Similarly, if hash-based work and non-hash-based work are sent at the
same time, similar issues are likely to occur.
Returning to the starting point of the issue, when a new work
arrives, io_wq_enqueue may wake up free worker A, while
io_wq_dec_running may create worker B. Ultimately, only one of A and
B can obtain and process the task, leaving the other in an idle
state. In the end, the issue is caused by inconsistent logic in the
checks performed by io_wq_enqueue and io_wq_dec_running.
Therefore, the problem can be resolved by checking for available
workers in io_wq_dec_running.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Reviewed-by: Diangang Li <lidiangang@bytedance.com>
Link: https://lore.kernel.org/r/20250813120214.18729-1-changfengnan@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -357,6 +357,13 @@ static void create_worker_cb(struct call
 	worker = container_of(cb, struct io_worker, create_work);
 	wq = worker->wq;
 	acct = worker->acct;
+
+	rcu_read_lock();
+	do_create = !io_acct_activate_free_worker(acct);
+	rcu_read_unlock();
+	if (!do_create)
+		goto no_need_create;
+
 	raw_spin_lock(&acct->workers_lock);
 
 	if (acct->nr_workers < acct->max_workers) {
@@ -367,6 +374,7 @@ static void create_worker_cb(struct call
 	if (do_create) {
 		create_io_worker(wq, acct);
 	} else {
+no_need_create:
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
 	}


