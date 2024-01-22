Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFC35243;
	Tue, 23 Jan 2024 02:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975788; cv=none; b=cpmadvfD48eu0aAXMLnt09cfrpvhRZlnmtMT15dm1apVO/QOkdfNZFLbpgurC/QqvfB/1Y+Lox76ety/QIWOVsOhUX+cwdbjqqzzRfDhfEGXYQqVbYvfB4lv+HfxIwtJHq4rc2mYwNz/HKc3rD/EjnB69SoR5Mz1013mSQuHvew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975788; c=relaxed/simple;
	bh=d1JUfHeg7SMZnqSwnRevkV04MEHt77dp1E8OFx3ZmMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VsaiSqg4L5qfB8auq9YZM1oFH3+Gd5mt2MkMG2U0Fw3Ri5fdkF+JdgRC0T2cujXccbIUAi34/iRefpEAy1JCraEMt1Jl+dnOwHQV7eJAAJ9Md/9k3xuFPx4yc4NCILgZNmkhobU+zH9LXnw9J5Gri8r+qlUh5KIDUpSj7h5EkXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RppXQOCo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RppXQOCo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E415C43390;
	Tue, 23 Jan 2024 02:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975788;
	bh=d1JUfHeg7SMZnqSwnRevkV04MEHt77dp1E8OFx3ZmMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RppXQOCoj/l0F91bonDvyk8cSN6PpPm5Vih7nicg9dRvYgqUlWM/tG9WDRYBhxyUE
	 1d3yg+vSGiE+7EHOluZfeBXdYBOACQ7R5ejKVoQqgRBtUrimvmKLh6vq8VkO3hakPn
	 XZdjkWEpicP5DJmI2k+JiW1HpC6QspRn60Z/HH9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditi Ghag <aditi.ghag@isovalent.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 545/583] bpf: Avoid iter->offset making backward progress in bpf_iter_udp
Date: Mon, 22 Jan 2024 15:59:56 -0800
Message-ID: <20240122235828.808784045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a4857c85a020..9cb22a6ae1dc 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -3116,16 +3116,18 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
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
 
@@ -3145,19 +3147,19 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
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
@@ -3171,9 +3173,6 @@ static struct sock *bpf_iter_udp_batch(struct seq_file *seq)
 
 		if (iter->end_sk)
 			break;
-
-		/* Reset the current bucket's offset before moving to the next bucket. */
-		iter->offset = 0;
 	}
 
 	/* All done: no batch made. */
-- 
2.43.0



