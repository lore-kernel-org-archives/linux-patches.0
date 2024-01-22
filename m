Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3AD5F564;
	Tue, 23 Jan 2024 00:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970163; cv=none; b=komMJDmfxhFANyb407H6qPXvPYfXvq+rUZTplBEub9acZsoc3UrOD2SlzciBSjfcTt2EvZSQjM0m7EtNcgU77ND8Il4e6DoY/vLOzN+u5tTOKBebsB1G2rCk7iB7C21P1qKO3EV4svTBwaWl3O/NqHjo6qXAW0WbGj3xYeI5nPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970163; c=relaxed/simple;
	bh=kXSLW8IcQkJhYLMAiWM85Se4X5ONDFPp2FzVfYPiIBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UIzpXW2/Mp5QVAEEKW4VuBezqf7B6KkbS8OFuZ8Msw6EjioVwBNR7jpYxAbFM+Mkz/YspyYVIxG5pOll8kMYobhqiCQPZHTu8JBYru3EhhEiCMbjnQJqEsBGvXKnC344DK6Zh70HUHUiwwLd56Zni7EIklMcFCjBsz3BO3yobOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5VTh5Kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5VTh5Kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9050FC433C7;
	Tue, 23 Jan 2024 00:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970162;
	bh=kXSLW8IcQkJhYLMAiWM85Se4X5ONDFPp2FzVfYPiIBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5VTh5KnF5idSRb/UTjxZdE4sTP7qddk5+1kILIoVVlmZ5TJyzuQFMrudDwOcgYDG
	 WWN7cJUTHHPsT1s7CUmBqdrum9gBXHSUvBKDI7eTPFnoPTrRJIx4ObLDcNaYjDQ88L
	 pPS2ZOAlBej4vrUumqf10yWmx3ho9L9M1Jo1wA6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditi Ghag <aditi.ghag@isovalent.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 603/641] bpf: Avoid iter->offset making backward progress in bpf_iter_udp
Date: Mon, 22 Jan 2024 15:58:27 -0800
Message-ID: <20240122235837.098501466@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin KaFai Lau <martin.lau@kernel.org>

[ Upstream commit 2242fd537fab52d5f4d2fbb1845f047c01fad0cf ]

There is a bug in the bpf_iter_udp_batch() function that stops
the userspace from making forward progress.

The case that triggers the bug is the userspace passed in
a very small read buffer. When the bpf prog does bpf_seq_printf,
the userspace read buffer is not enough to capture the whole bucket.

When the read buffer is not large enough, the kernel will remember
the offset of the bucket in iter->offset such that the next userspace
read() can continue from where it left off.

The kernel will skip the number (== "iter->offset") of sockets in
the next read(). However, the code directly decrements the
"--iter->offset". This is incorrect because the next read() may
not consume the whole bucket either and then the next-next read()
will start from offset 0. The net effect is the userspace will
keep reading from the beginning of a bucket and the process will
never finish. "iter->offset" must always go forward until the
whole bucket is consumed.

This patch fixes it by using a local variable "resume_offset"
and "resume_bucket". "iter->offset" is always reset to 0 before
it may be used. "iter->offset" will be advanced to the
"resume_offset" when it continues from the "resume_bucket" (i.e.
"state->bucket == resume_bucket"). This brings it closer to
the bpf_iter_tcp's offset handling which does not suffer
the same bug.

Cc: Aditi Ghag <aditi.ghag@isovalent.com>
Fixes: c96dac8d369f ("bpf: udp: Implement batching for sockets iterator")
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Aditi Ghag <aditi.ghag@isovalent.com>
Link: https://lore.kernel.org/r/20240112190530.3751661-3-martin.lau@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 79050d83e736..148ffb007969 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3137,16 +3137,18 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
 	struct bpf_udp_iter_state *iter = seq->private;
 	struct udp_iter_state *state = &iter->state;
 	struct net *net = seq_file_net(seq);
+	int resume_bucket, resume_offset;
 	struct udp_table *udptable;
 	unsigned int batch_sks = 0;
 	bool resized = false;
 	struct sock *sk;
 
+	resume_bucket = state->bucket;
+	resume_offset = iter->offset;
+
 	/* The current batch is done, so advance the bucket. */
-	if (iter->st_bucket_done) {
+	if (iter->st_bucket_done)
 		state->bucket++;
-		iter->offset = 0;
-	}
 
 	udptable = udp_get_table_seq(seq, net);
 
@@ -3166,19 +3168,19 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
 	for (; state->bucket <= udptable->mask; state->bucket++) {
 		struct udp_hslot *hslot2 = &udptable->hash2[state->bucket];
 
-		if (hlist_empty(&hslot2->head)) {
-			iter->offset = 0;
+		if (hlist_empty(&hslot2->head))
 			continue;
-		}
 
+		iter->offset = 0;
 		spin_lock_bh(&hslot2->lock);
 		udp_portaddr_for_each_entry(sk, &hslot2->head) {
 			if (seq_sk_match(seq, sk)) {
 				/* Resume from the last iterated socket at the
 				 * offset in the bucket before iterator was stopped.
 				 */
-				if (iter->offset) {
-					--iter->offset;
+				if (state->bucket == resume_bucket &&
+				    iter->offset < resume_offset) {
+					++iter->offset;
 					continue;
 				}
 				if (iter->end_sk < iter->max_sk) {
@@ -3192,9 +3194,6 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
 
 		if (iter->end_sk)
 			break;
-
-		/* Reset the current bucket's offset before moving to the next bucket. */
-		iter->offset = 0;
 	}
 
 	/* All done: no batch made. */
-- 
2.43.0



