Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725773E7BA7;
	Mon, 17 Aug 2026 13:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974794; cv=none; b=Q61B5b8RyS1IIPSPaO3o7nx8NUzVyTNXFVBat+iT5GJI9mizQbW+Aj+KF+9YS8nPowoSdwuwSt2v4O/f+AE7KiHbrsx1HL+cjUIE8fLVa3crho9xnHlUqQKb0ioTKsHoQaBiMmuCIZs9khPD280G65kgRpP7xJBfOR8X8B2xI5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974794; c=relaxed/simple;
	bh=ldnUKd0yHdlzO1LJwGf2Cvs7dAcDqlChepnSBZMBly8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4p4d8EMz2pTEQAXnXl4Gw7GfWiC9MgsEfu+jWGnuW53RR5dasC9tTvEvjm/S9lMa8Af80CIH6U6imHyhELg2WrxIZ47G3nbaxHHsvIew7Hui3/LszWgnxuEuudi2lrUw0lXxg8cwrLwxvlw4IyTaRftgQpvZQC5RLQcoFrpH44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpspq768; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpspq768"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EED1F000E9;
	Mon, 17 Aug 2026 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974781;
	bh=XuqKabi0wCjHWbRcqZgx8JDbQJJZlKJ9hIlCfpxMHqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpspq768mE40wjEW+AZKD10Rm7Yl1O50oEyHXgoOj+FX2duIVjpw+hLnNJjeYSSOi
	 hbjtY2ZEh3XT2o+rVCMmN0i2XBcIxNLaSDdR8yagCsO0QmVvZAgY1lIgtTjqICwqYT
	 fwM4n/H1S9dLSHq26M/JnX1Wrm/76yOMQcaOlgjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 052/250] bpf: tcp: Fix use-after-free in bpf_iter_tcp_established_batch()
Date: Mon, 17 Aug 2026 15:30:13 +0200
Message-ID: <20260817132538.567625440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

From: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>

[ Upstream commit e5fd3f514e27db1f05fbd72ba615d74941e23c51 ]

reqsk_queue_hash_req() publishes a TCP_NEW_SYN_RECV request_sock onto
the ehash chain, drops the bucket lock, and only afterwards sets
rsk_refcnt to 3.

Lockless readers such as __inet_lookup_established() handle this with
refcount_inc_not_zero(), but bpf_iter_tcp_established_batch() uses plain
sock_hold() while holding the bucket lock, on the assumption that the
lock guarantees sk_refcnt > 0. That assumption does not hold for
request_sock:

  CPU 0                                CPU 1
  -----                                -----
  tcp_conn_request()
   reqsk_queue_hash_req()
    inet_ehash_insert(req)
     spin_lock(bucket)
     __sk_nulls_add_node_rcu(req)      // rsk_refcnt == 0
     spin_unlock(bucket)
                                       bpf_iter_tcp_established_batch()
                                        spin_lock(bucket)
                                        sock_hold(req)   <-- addition on 0
                                        spin_unlock(bucket)
    refcount_set(&req->rsk_refcnt, 3)  // clobbers saturated value

which surfaces as:

  refcount_t: addition on 0; use-after-free.
  WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x48/0x90, CPU#1
  Call Trace:
   bpf_iter_tcp_established_batch+0x14e/0x170
   bpf_iter_tcp_batch+0x53/0x200
   bpf_iter_tcp_seq_next+0x27/0x70
   bpf_seq_read+0x107/0x410
   vfs_read+0xb9/0x380

The iterator's stolen reference is lost when the publishing CPU's
refcount_set() overwrites the count, leaving the socket one reference
short. When the last legitimate owner drops its reference the reqsk is
freed while still reachable, leading to use-after-free.

This reproduces in seconds with tcp_syncookies=0, a handful of threads
doing connect()/close() to a local listener while others read an
iter/tcp link in a tight loop.

Use refcount_inc_not_zero() and skip the socket on failure. A skipped
socket is still part of the bucket, so keep counting it in expected.
The reallocations are sized from expected, and a request sock whose
refcount gets published while the lock is held across the last realloc
must already have room.

A skipped socket is counted in expected but never batched, so end_sk
can be short of expected on a batch that is actually complete. Decide
completeness by whether the walk left any socket behind instead. The
WARN after the locked realloc checks the same, replacing an
end_sk == expected check that could not hold on that path since
commit cdec67a489d4 ("bpf: tcp: Make sure iter->batch always
contains a full bucket snapshot").

If every matching socket in a bucket is mid-init (refcount 0), end_sk
stays 0. Advance to the next bucket rather than returning a batch entry
that was never filled this round.

Fixes: 04c7820b776f ("bpf: tcp: Bpf iter batching and lock_sock")
Assisted-by: Claude:unspecified
Signed-off-by: Jose Fernandez (Anthropic) <jose.fernandez@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://lore.kernel.org/bpf/20260730-bpf-iter-tcp-refcnt-v3-1-754b9c8a6717@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 3463e5b964a98..708b69cc2f56c 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3219,24 +3219,24 @@ static unsigned int bpf_iter_tcp_established_batch(struct seq_file *seq,
 {
 	struct bpf_tcp_iter_state *iter = seq->private;
 	struct hlist_nulls_node *node;
-	unsigned int expected = 1;
-	struct sock *sk;
-
-	sock_hold(*start_sk);
-	iter->batch[iter->end_sk++].sk = *start_sk;
+	struct sock *sk = *start_sk;
+	unsigned int expected = 0;
 
-	sk = sk_nulls_next(*start_sk);
 	*start_sk = NULL;
 	sk_nulls_for_each_from(sk, node) {
-		if (seq_sk_match(seq, sk)) {
-			if (iter->end_sk < iter->max_sk) {
-				sock_hold(sk);
-				iter->batch[iter->end_sk++].sk = sk;
-			} else if (!*start_sk) {
-				/* Remember where we left off. */
-				*start_sk = sk;
-			}
-			expected++;
+		if (!seq_sk_match(seq, sk))
+			continue;
+		expected++;
+		if (iter->end_sk < iter->max_sk) {
+			/* reqsk_queue_hash_req() inserts with sk_refcnt == 0
+			 * and refcount_set()s it after the bucket lock drops.
+			 */
+			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
+				continue;
+			iter->batch[iter->end_sk++].sk = sk;
+		} else if (!*start_sk) {
+			/* Remember where we left off. */
+			*start_sk = sk;
 		}
 	}
 
@@ -3274,12 +3274,13 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 	struct sock *sk;
 	int err;
 
+again:
 	sk = bpf_iter_tcp_resume(seq);
 	if (!sk)
 		return NULL; /* Done */
 
 	expected = bpf_iter_fill_batch(seq, &sk);
-	if (likely(iter->end_sk == expected))
+	if (likely(!sk))
 		goto done;
 
 	/* Batch size was too small. */
@@ -3298,7 +3299,7 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 		return NULL; /* Done */
 
 	expected = bpf_iter_fill_batch(seq, &sk);
-	if (likely(iter->end_sk == expected))
+	if (likely(!sk))
 		goto done;
 
 	/* Batch size was still too small. Hold onto the lock while we try
@@ -3311,10 +3312,14 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 		return ERR_PTR(err);
 	}
 
-	expected = bpf_iter_fill_batch(seq, &sk);
-	WARN_ON_ONCE(iter->end_sk != expected);
+	bpf_iter_fill_batch(seq, &sk);
+	WARN_ON_ONCE(sk);
 done:
 	bpf_iter_tcp_unlock_bucket(seq);
+	if (unlikely(!iter->end_sk)) {
+		++iter->state.bucket;
+		goto again;
+	}
 	return iter->batch[0].sk;
 }
 
-- 
2.53.0



