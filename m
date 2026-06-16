Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1CE38837F;
	Tue, 16 Jun 2026 15:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624005; cv=none; b=X6XZqP1YQarRakp9U9LRh8SjKPbYZc3koVUpWn2Byt5+d5XL5yi9i/s5zjEQFqSAJVQC6T0vwT+Jee1cIax0663rC3xttKPDKGMsi8f+raV9xbglyxG0W5Dg8tuhfdYBuQ8tJ+UrysTJ4joylBxMvDr359faeXeKmAsaXnM/05k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624005; c=relaxed/simple;
	bh=FKboyD5QFHvbu2LiVKxBDPc97uE06rkS1rG+sSMLlLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCrK2rh+GkKcyCO7zB7cibBio5QXimnBpTN4gTisygHGbIkfuBOHfinXmCv30YtvCZEBBuiPYJg6jHv+nJ2ZJw/0DBypPHEwe+OuFLyu9eK+dX2kw6dc5rquA8iUo2TgcmHeOwecgZmjiSsGPIokI+Uh52708CDi2ViNMpJRISk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qot+k8Q6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qot+k8Q6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE6E1F000E9;
	Tue, 16 Jun 2026 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624004;
	bh=rwbIcIDv/J9mPS3M3KdqRp/elXoaPHc9tjO+69JigM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qot+k8Q64cvDrKSuUCaYQsxCzxUjxsDdQ21wRWrEG2L9as7FabdsP7hwLpUxU+NmY
	 uRsv3oeQ8IR7miq12XCCzo3yOZlIk+9M7y9dXkRXUzlTgyW8JLJvaHoBD3fVdHdH/Q
	 lnlT8J2SeMVdM30mZJjiyGeQuWcQOXmwBcXAI83o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 255/378] inet: frags: fix use-after-free caused by the fqdir_pre_exit() flush
Date: Tue, 16 Jun 2026 20:28:06 +0530
Message-ID: <20260616145123.548286359@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 32594b09854970d7ba83eb2dc8c69a2edd158c8e upstream.

On netns teardown, fqdir_pre_exit() walks the fqdir rhashtable and
flushes every fragment queue that is not yet complete using
inet_frag_queue_flush(). That helper frees all the skbs queued on the
fragment queue but does not set INET_FRAG_COMPLETE, and leaves
q->fragments_tail and q->last_run_head pointing at the freed skbs.
The queue itself stays in the rhashtable.

fqdir_pre_exit() first lowers high_thresh to 0 to stop new queue lookups,
but it cannot stop a fragment that already obtained the queue through
inet_frag_find() earlier and stalled just before taking the queue lock.
Once that fragment resumes after the flush and takes the queue lock,
it passes the INET_FRAG_COMPLETE check and then dereferences the freed
fragments_tail. inet_frag_queue_insert() reads FRAG_CB() and ->len of
that pointer and, on the append path, writes ->next_frag, causing a
slab use-after-free. IPv6, nf_conntrack_reasm6 and 6lowpan reassembly
share the same flush path and are affected as well.

Reset rb_fragments, fragments_tail and last_run_head in
inet_frag_queue_flush() so a flushed queue no longer points at the
freed skbs. A fragment that resumes after the flush and takes the
queue lock then finds an empty queue and starts a new run instead of
dereferencing the freed fragments_tail. ip_frag_reinit() already
performed this reset after its own flush, so drop the now duplicate
code there.

Cc: stable@vger.kernel.org
Fixes: 006a5035b495 ("inet: frags: flush pending skbs in fqdir_pre_exit()")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://patch.msgid.link/ah6ukYq5G98LshdA@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_fragment.c |    3 +++
 net/ipv4/ip_fragment.c   |    3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -328,6 +328,9 @@ void inet_frag_queue_flush(struct inet_f
 	reason = reason ?: SKB_DROP_REASON_FRAG_REASM_TIMEOUT;
 	sum = inet_frag_rbtree_purge(&q->rb_fragments, reason);
 	sub_frag_mem_limit(q->fqdir, sum);
+	q->rb_fragments = RB_ROOT;
+	q->fragments_tail = NULL;
+	q->last_run_head = NULL;
 }
 EXPORT_SYMBOL(inet_frag_queue_flush);
 
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -250,9 +250,6 @@ static int ip_frag_reinit(struct ipq *qp
 	qp->q.flags = 0;
 	qp->q.len = 0;
 	qp->q.meat = 0;
-	qp->q.rb_fragments = RB_ROOT;
-	qp->q.fragments_tail = NULL;
-	qp->q.last_run_head = NULL;
 	qp->iif = 0;
 	qp->ecn = 0;
 


