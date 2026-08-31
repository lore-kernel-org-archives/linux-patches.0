Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9558343F08D;
	Mon, 31 Aug 2026 13:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184740; cv=none; b=AEzKRKAuW/tELbgaV9y/ZLOVZuFDWEGUwHtbv1u30TuOxdi6Mx4InY/+UfcPOgmMqPhNx0kDHdPmO7sb5X+bGI4SPfy06+uDsyIFLJcWwPIBETr15G4tU69UOaQs+96aDkQ7nDBiV6HK2FdC2arJXT1AvODjkOhEFwDDfcrak/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184740; c=relaxed/simple;
	bh=IxgN+JHJ+yrhvv+Xn6ibeXvFDU+nB1nTr5YkgMyLdn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDCfaIquqy/F8/1pfRcXPAMY7mcCHvMJs/Ub3FoA1mrnibwYfDJtCPmhtby+lENKqfNTdMLQ+fxgjeSAFCDYP8ks1RNOn+6SseAN3YHZzb/0XJOfmd633K2KnWmyvlM0vPJvKa21Z9Q1nRNmX9LvZU12WD3plrualk7BoTHm8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ct6fnD30; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ct6fnD30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8141F00A3D;
	Mon, 31 Aug 2026 13:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184739;
	bh=YVgKiyrFCmB5GQQVcaibRXYj9lSykslaZueJKcp36Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ct6fnD30bNYdwuv3wEXXwwpvtBl/FnY3/j8Tz23TIORBIuxZmcAq8RLUKj4gytWz3
	 MBVPNYlvAQkfoYoTItN06Iy8exQC4jWIzxNn2awc70Uqph8JSJXrllQ8tt9c+3Wjee
	 fQUShnY7+E/vMtNHcj9YVnYjZOD6y/N1+EnhHRFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Vishnu Razdan <vrazdan@openai.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/92] io_uring/io-wq: fix worker accounting when canceling creation callbacks
Date: Mon, 31 Aug 2026 15:34:03 +0200
Message-ID: <20260831133359.748364699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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

[ Backport: retain the existing worker->wqe->lock protecting worker
  accounting. ]

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
index 66fdd69fd6cb4..0c3de2fead81c 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -201,9 +201,12 @@ static void io_worker_cancel_cb(struct io_worker *worker)
 	struct io_wq *wq = wqe->wq;
 
 	atomic_dec(&acct->nr_running);
-	raw_spin_lock(&worker->wqe->lock);
-	acct->nr_workers--;
-	raw_spin_unlock(&worker->wqe->lock);
+	/* create_worker_cb() has not reserved a worker slot yet. */
+	if (worker->create_work.func != create_worker_cb) {
+		raw_spin_lock(&worker->wqe->lock);
+		acct->nr_workers--;
+		raw_spin_unlock(&worker->wqe->lock);
+	}
 	io_worker_ref_put(wq);
 	clear_bit_unlock(0, &worker->create_state);
 	io_worker_release(worker);
-- 
2.53.0



