Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A6018595E;
	Tue, 10 Sep 2024 10:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963095; cv=none; b=TuRfam+W/JylRGxf107wuLTe4BBUBXFp+HRhO0H4fN9qRk/J9I1rBV5Z2la43S/mHMLoFU5qRo4LKPaI9o/ygb3rg8s2YhZ0bAZLAV4zLtdnSEjKf1z2Sg2FY//wOti5OmDXPraOtj9BaqRd2lJme2elM4H9V0jrWYXdfm4/QAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963095; c=relaxed/simple;
	bh=CpHE0Z62MiQeMMMioKi78z7hgwqvZqlFbpx4D6btdtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sp2Bp83gUr1x0nucfsgeSIVY5qp6EJdnldectJmcuq4iRk8hLYqEXCf9qOpcA1jDjyAvyyOiy6M3dCzZu0/RsmtErjOAGue5/0Yrj5IBiFCJOEHczh3f2i2QYfVda15hi9C2hMm+Mhkai8C3MmYjP64NB+COugLw3AATYd7zxYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QLbbbVA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QLbbbVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECBFC4CEC3;
	Tue, 10 Sep 2024 10:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963095;
	bh=CpHE0Z62MiQeMMMioKi78z7hgwqvZqlFbpx4D6btdtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QLbbbVAhFhM9UnsyiQsiflyPWKlEtjWncxzekSLQ21pQtK8yhXKk1HYTrFpxwGYO
	 9IFv0/TvjgBpcaJZ/C6Pv+H4AzrZlyZFjlwlLdpzJltamNlHvikutXpmt2SWjp+P/o
	 CVpXdDD7nWPKYr/yihlnN+fKJHPNM4t0xZNPcBxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Dao <dqminh@cloudflare.com>,
	Jens Axboe <axboe@kernel.dk>,
	Felix Moessbauer <felix.moessbauer@siemens.com>
Subject: [PATCH 6.1 133/192] io_uring/io-wq: stop setting PF_NO_SETAFFINITY on io-wq workers
Date: Tue, 10 Sep 2024 11:32:37 +0200
Message-ID: <20240910092603.494892123@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 01e68ce08a30db3d842ce7a55f7f6e0474a55f9a upstream.

Every now and then reports come in that are puzzled on why changing
affinity on the io-wq workers fails with EINVAL. This happens because they
set PF_NO_SETAFFINITY as part of their creation, as io-wq organizes
workers into groups based on what CPU they are running on.

However, this is purely an optimization and not a functional requirement.
We can allow setting affinity, and just lazily update our worker to wqe
mappings. If a given io-wq thread times out, it normally exits if there's
no more work to do. The exception is if it's the last worker available.
For the timeout case, check the affinity of the worker against group mask
and exit even if it's the last worker. New workers should be created with
the right mask and in the right location.

Reported-by:Daniel Dao <dqminh@cloudflare.com>
Link: https://lore.kernel.org/io-uring/CA+wXwBQwgxB3_UphSny-yAP5b26meeOu1W4TwYVcD_+5gOhvPw@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Felix Moessbauer <felix.moessbauer@siemens.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -628,7 +628,7 @@ static int io_wqe_worker(void *data)
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	bool last_timeout = false;
+	bool exit_mask = false, last_timeout = false;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -644,8 +644,11 @@ static int io_wqe_worker(void *data)
 			io_worker_handle_work(worker);
 
 		raw_spin_lock(&wqe->lock);
-		/* timed out, exit unless we're the last worker */
-		if (last_timeout && acct->nr_workers > 1) {
+		/*
+		 * Last sleep timed out. Exit if we're not the last worker,
+		 * or if someone modified our affinity.
+		 */
+		if (last_timeout && (exit_mask || acct->nr_workers > 1)) {
 			acct->nr_workers--;
 			raw_spin_unlock(&wqe->lock);
 			__set_current_state(TASK_RUNNING);
@@ -664,7 +667,11 @@ static int io_wqe_worker(void *data)
 				continue;
 			break;
 		}
-		last_timeout = !ret;
+		if (!ret) {
+			last_timeout = true;
+			exit_mask = !cpumask_test_cpu(raw_smp_processor_id(),
+							wqe->cpu_mask);
+		}
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
@@ -716,7 +723,6 @@ static void io_init_new_worker(struct io
 	tsk->worker_private = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
-	tsk->flags |= PF_NO_SETAFFINITY;
 
 	raw_spin_lock(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);


