Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429561527B4;
	Sun, 26 Oct 2025 14:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490251; cv=none; b=E+j2eD8CR8VYU1uFmiSXLJPEVSTwdHWIZ3OVQC21tsx7HWmRyQArHyaWg+vlYNWAv1gYTz1w9Ds4k94Bko0sfGkGqwvBIN7I1z2Gmk8VpO1mXl/1JDseVy7lx4N4BoFCNkMD36Kge0gGf3bSe3ipXCB8Ar3l5SZepzFF+pB63+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490251; c=relaxed/simple;
	bh=w1gMYvfH3Sk/X2LiBP00UEk02bYsThghO3HlZeRMoRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TM60IISYcxmLiFtM0g5mcbjjvAoAx/qY/Y1vLWmVdTjdmfOiycIJNS/GwGxhqN+fsPtAhEFwjs6IpuswtZmr/cRm6/g5AAphfuv0Hk2IECLIH3YCsURRP9HseZo7ixjlNBkSMKwSki/sEHaboxqSz/4RYNNKXCGuMaEa7fnC4xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OAI34osQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OAI34osQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A84DC116D0;
	Sun, 26 Oct 2025 14:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490251;
	bh=w1gMYvfH3Sk/X2LiBP00UEk02bYsThghO3HlZeRMoRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OAI34osQdeCSacPan0prjqR3CDz5tajHtGpuubLIzbShqgulp8a4bQIthAOUYPk79
	 xdLwHOQmOl0t9lqAOth4ZQKo8346XUoR1r2/Yn75+pZy+pBRdi2HyQga80D/CDHV7S
	 B8g4FSXg4wxhZ5j7/ExdRfeF/SVTuYGpiv5YcoPKwsbIXwUuIRk+9H6l7ZD7ggaCXl
	 mTFbn1Rc8pvQgJVUCUcpDKepI2gLEWFmkbQ0cpTOKsTQPcRlVpsUwNaAVB0Q2tlGJ+
	 mpn5NUJ3ousSZ+xx5zNX3tcknO3ZN3ntgYi9BPYbb7V47KjkddLZ8RxIhvGG9dOLuk
	 XfOyUKF8AAhsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
	syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>,
	ericvh@kernel.org,
	lucho@ionkov.net,
	v9fs@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17-6.12] 9p/trans_fd: p9_fd_request: kick rx thread if EPOLLIN
Date: Sun, 26 Oct 2025 10:49:01 -0400
Message-ID: <20251026144958.26750-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit e8fe3f07a357c39d429e02ca34f740692d88967a ]

p9_read_work() doesn't set Rworksched and doesn't do schedule_work(m->rq)
if list_empty(&m->req_list).

However, if the pipe is full, we need to read more data and this used to
work prior to commit aaec5a95d59615 ("pipe_read: don't wake up the writer
if the pipe is still full").

p9_read_work() does p9_fd_read() -> ... -> anon_pipe_read() which (before
the commit above) triggered the unnecessary wakeup. This wakeup calls
p9_pollwake() which kicks p9_poll_workfn() -> p9_poll_mux(), p9_poll_mux()
will notice EPOLLIN and schedule_work(&m->rq).

This no longer happens after the optimization above, change p9_fd_request()
to use p9_poll_mux() instead of only checking for EPOLLOUT.

Reported-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
Tested-by: syzbot+d1b5dace43896bc386c3@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68a2de8f.050a0220.e29e5.0097.GAE@google.com/
Link: https://lore.kernel.org/all/67dedd2f.050a0220.31a16b.003f.GAE@google.com/
Co-developed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Message-ID: <20250819161013.GB11345@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – Calling `p9_poll_mux(m)` directly from `p9_fd_request()` restores
the read-side kick that was lost when `pipe_read()` stopped waking
writers, preventing 9p transports from stalling once their pipe fills.

**Key Points**
- `net/9p/trans_fd.c:688` now invokes `p9_poll_mux(m)` right after a
  request is queued, so the mux re-evaluates readiness instead of only
  relying on the write-ready bit.
- `net/9p/trans_fd.c:622-652` shows that `p9_poll_mux()` schedules both
  read and write work: with the new call it can react to `EPOLLIN`, set
  `Rpending`, and queue `m->rq`, which is exactly what the syzbot report
  needed to drain a full pipe.
- `net/9p/trans_fd.c:394-402` (in `p9_read_work()`) demonstrates why
  this matters: the read worker only reschedules when `Rpending` is set;
  without the new kick the queue stayed full after commit
  aaec5a95d59615, blocking all further writes.
- The change is contained to the 9p fd transport, touches no external
  APIs, and is a regression fix confirmed by syzbot, making it a safe
  and targeted backport candidate.

Given the regression impact (total hang under load) and the minimal,
well-scoped fix, this should be backported to the affected stable
kernels. Consider running the syzkaller reproducer or a 9p workload test
after backporting to confirm the stall is gone.

 net/9p/trans_fd.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 8992d8bebbddf..a516745f732f7 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -666,7 +666,6 @@ static void p9_poll_mux(struct p9_conn *m)
 
 static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 {
-	__poll_t n;
 	int err;
 	struct p9_trans_fd *ts = client->trans;
 	struct p9_conn *m = &ts->conn;
@@ -686,13 +685,7 @@ static int p9_fd_request(struct p9_client *client, struct p9_req_t *req)
 	list_add_tail(&req->req_list, &m->unsent_req_list);
 	spin_unlock(&m->req_lock);
 
-	if (test_and_clear_bit(Wpending, &m->wsched))
-		n = EPOLLOUT;
-	else
-		n = p9_fd_poll(m->client, NULL, NULL);
-
-	if (n & EPOLLOUT && !test_and_set_bit(Wworksched, &m->wsched))
-		schedule_work(&m->wq);
+	p9_poll_mux(m);
 
 	return 0;
 }
-- 
2.51.0

