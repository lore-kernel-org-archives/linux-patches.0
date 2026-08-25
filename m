Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC343470421;
	Tue, 25 Aug 2026 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665135; cv=none; b=jbMCZyc+x++49/QtIpvz6X8ewvqDCbAUNl5p/Ap7DrG/l1RQam5pkRGRjDXxDq9VNo2lXwPr/6prbjfbyMihsjE+BpBoQjqW2sNpCskUlkGZj5US6mlxqFg3LaGGvkFQnQYGBji3AIal6FZaYcPvE9W7Ji17Am2jYqHbsz8VgsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665135; c=relaxed/simple;
	bh=LaScYqOqHKXZ7yW+VTehEMFyX8H6bEEihJLC2Qbjcy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSZ4g9GaLm8X5RR0vsYascJb0I+yibwQlfXpIdDXzCYBmiVvkVH3SvKErPgoogoVv0yRw+VFnH/EoD1vm7sfAjgp/Tqegu4k4CGzpP05KyFWj6j8kMr36Dh8vksM+s0fTTVVX9XtmwYx/QzudWCpbkLlOMD+fqtRxNn1H5EZ1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUCeDq/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUCeDq/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8B71F000E9;
	Tue, 25 Aug 2026 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665133;
	bh=aODAbr8eiItrvqPpzqKeJCkRMnTXUvefwvoUo2wYTP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GUCeDq/GUQVRLphvPSUgjeqVbEgpA5WfdGbkNypMKvBnZ2BKgV3e2eyiqfgGz3R/i
	 tx6DsB8rhXV3DeTkSD6K/XydZxsWDCI7U/+/wFgoraliEJozhICRV0N7grwE0Oes3g
	 AeIGQQLV3qggScoXyppLM5C1PDO3MvFo2W9CiCT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vishnu Razdan <vrazdan@openai.com>,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 19/94] io_uring/io-wq: fix worker accounting when canceling creation callbacks
Date: Tue, 25 Aug 2026 15:25:15 +0200
Message-ID: <20260825132542.647231774@linuxfoundation.org>
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

From: Vishnu Razdan <vrazdan@openai.com>

commit 297b5ccea4acacaa47c150f043bce695202afbf1 upstream.

create_worker_cb() reserves an io-wq worker slot only after its
task-work callback runs. If the callback is canceled before then,
io_worker_cancel_cb() still decrements acct->nr_workers. When an
existing worker retires with its creation callback pending, that
worker has already decremented the same account's worker count.

The resulting undercount permits worker creation beyond the account's
configured limit. On an AST2600 OpenBMC system, an unchanged sensor
daemon reached 4,291 threads with the original kernel. With an
equivalent downstream fix, 25 passive samples under its normal
workload showed 6-9 threads.

Decrement nr_workers only when the canceled callback is not
create_worker_cb(). Continuation callbacks still release their reserved
slot, and both callback types retain the existing running-count,
reference-count, and create-state cleanup.

Fixes: 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Vishnu Razdan <vrazdan@openai.com>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260811-vrazdan-io-wq-b4-submit-v1-1-719ced16c921@openai.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -210,9 +210,12 @@ static void io_worker_cancel_cb(struct i
 	struct io_wq *wq = worker->wq;
 
 	atomic_dec(&acct->nr_running);
-	raw_spin_lock(&acct->workers_lock);
-	acct->nr_workers--;
-	raw_spin_unlock(&acct->workers_lock);
+	/* create_worker_cb() has not reserved a worker slot yet. */
+	if (worker->create_work.func != create_worker_cb) {
+		raw_spin_lock(&acct->workers_lock);
+		acct->nr_workers--;
+		raw_spin_unlock(&acct->workers_lock);
+	}
 	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
 	io_worker_release(worker);


