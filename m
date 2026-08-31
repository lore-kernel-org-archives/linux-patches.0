Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91827476CF0;
	Mon, 31 Aug 2026 13:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184489; cv=none; b=Tt/wzsShAYN7apt/pwwJ3C9rN82Ai/jmN4I87m6/JRPrhlvvW5130T1KjycQXZWurLRS7s+OJYG8QFn3byyhmqFTPvRORZ04RWx+2R/H6TtIf3muE7TFYPCPgHhch4KITjaTDQSFOEYc49I5O0uvnH8aYR6DRL1sZD46F4sq8Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184489; c=relaxed/simple;
	bh=ujxhtxtsmgSsQuT+7j7vyiFzH64DEaUGEg2bzRHSAm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOgtPCKo+zX9GTTsnGwd/1q4zq+p6DGg3acv73AkXqHlKOtcnowdkU1mk8DPXZYO7kloWloS9YVjWcDTt6AG24K6b2bj5y/r2B5a/PnUw/KUAa/+KlBtfj25nq70iKSXjDS/rAvVmetVPyDp6gLHm/0jnxsEBnjp4H5iSEwu7xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aw73e8dJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aw73e8dJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A721F000E9;
	Mon, 31 Aug 2026 13:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184488;
	bh=2UnGo9E1BUpzRJERWJVZ1ufy2FF4kFDzI4avaaBHjf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aw73e8dJItj3Anu3lRuCiztySBbmWo1IJaAtQR7DgrcX0l2t7DsQf6sfkh3orAfYw
	 TPDaQxrNROMsoZsxc5YXpd7M4qFunLapA8B5nVwNqrzxNza/TdvsKyGpDTxiSoWUH+
	 wA1keLebBmVw8FDjHkoAJc07e9ToCZz0x1Baw1xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Vishnu Razdan <vrazdan@openai.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/91] io_uring/io-wq: fix worker accounting when canceling creation callbacks
Date: Mon, 31 Aug 2026 15:33:52 +0200
Message-ID: <20260831133359.689508959@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ Backport: retain the existing wq->lock protecting worker accounting. ]

Fixes: 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/20260811-vrazdan-io-wq-b4-submit-v1-1-719ced16c921@openai.com
Signed-off-by: Vishnu Razdan <vrazdan@openai.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 37725c5031b4c..a20be1a43aafc 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -193,9 +193,12 @@ static void io_worker_cancel_cb(struct io_worker *worker)
 	struct io_wq *wq = worker->wq;
 
 	atomic_dec(&acct->nr_running);
-	raw_spin_lock(&wq->lock);
-	acct->nr_workers--;
-	raw_spin_unlock(&wq->lock);
+	/* create_worker_cb() has not reserved a worker slot yet. */
+	if (worker->create_work.func != create_worker_cb) {
+		raw_spin_lock(&wq->lock);
+		acct->nr_workers--;
+		raw_spin_unlock(&wq->lock);
+	}
 	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
 	io_worker_release(worker);
-- 
2.53.0



