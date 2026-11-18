Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059464;
	b=3j4J0KDQjxXiU+V97guUoMkXqBbLrfHyWc5vGohAgEo9uZtOgzIf7m1DAj2AdrRdLUx6
	 o1sOTb3yGKt7LpTTe6ox/RZSmU7gQd9SizlHrLTgjGEWw9uU5uPFQ/kse3Cqrlt0qJLek
	 8j6lRdFQHKZcsrWZsOmJrOSC4ydEZ9w14C3J4jxtKCDAc3gQqoq9J5ZeI2k05KbLdcJ7l
	 JnbXtFGaTtR9o6YPyuIOOezRWZgVxvMvRuq16gShu+Igr0YiZC9BCdH7Gpn/4FDLw7lkI
	 FyBHzi1Mjzr8UbpCNK266GUoV4wC2hXGC04WYpSEU9eDGzdNjVhfzZFOnswBteRVZ+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S/3VzWaM33ChpxomuUHqB7SsYbQSMIEd9rRrkbIx95c=;
	b=TUpRpwC3pomfliYQ8tdd0bE33GA1B+Id8Cr8aQZjcynzZ9LU9pp2Ac+Cq08cOrMj+mnF
	 WjlyZ6X3sPp5r8rAKydxMFFgNKQ1DKAGiUnqFAiOiD6UmZDAGCj0RNSuQgamFYCDDQUtO
	 xSLeJoMVTwczTQbQ3ATfQ3vbRDUPzMgTYr/FOfj4nepfSULRWuOLMGHJcOTg32uM9Cf6H
	 lt4mjBbkUNMZckpoRPdNIDXz6COGt6XfOhUFSaAaAsbxg9Fm72Wzk6cnPzp06U4OxU2w0
	 K7w6fDVftdpffbn+t/5DhtaCefGJLOatR/R6Efz+xskHScvYkEmP9xW74ppBeTT6RlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZpEItik;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69832606A31C;
	Thu, 19 Nov 2026 03:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZpEItik
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4291F000C4;
	Thu, 19 Nov 2026 03:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059464;
	bh=S/3VzWaM33ChpxomuUHqB7SsYbQSMIEd9rRrkbIx95c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZpEItiksoq3Q9XE3an5SSajmEoPxuwKEcDH2wXdQ3ySJV5D0D0G5U+VMHeSrIWFQ
	 4l5C2yQqimZD+oeDBV5dzpybJlEboibCmCMPxA26UwFM7BvglqUQdXZKwpeJynTlB4
	 N900gedRW/ZZJVOkmP3reUJIqVtG529LcCpKdfKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0852/1848] do_splice_to(): move the logics for limiting the read length in
Date: Wed, 18 Nov 2026 15:48:10 +0100
Message-ID: <20261118145952.231946170@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 313d64a35d36b4bb00edde418179ff1a5f342070 ]

Both callers have the identical logics limiting the amount of
data we try to read into pipe - no more than would fit into
that pipe.  Move that into do_splice_to() itself.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: 79b496ebe382 ("splice: avoid stale f_pos writeback on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 5b15c25f30527..070b192b56386 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -774,11 +774,16 @@ static long do_splice_to(struct file *in, loff_t *ppos,
 			 struct pipe_inode_info *pipe, size_t len,
 			 unsigned int flags)
 {
+	unsigned int p_space;
 	int ret;
 
 	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
 
+	/* Don't try to read more the pipe has space for. */
+	p_space = pipe->max_usage - pipe_occupancy(pipe->head, pipe->tail);
+	len = min_t(size_t, len, p_space << PAGE_SHIFT);
+
 	ret = rw_verify_area(READ, in, ppos, len);
 	if (unlikely(ret < 0))
 		return ret;
@@ -859,15 +864,10 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 	WARN_ON_ONCE(!pipe_empty(pipe->head, pipe->tail));
 
 	while (len) {
-		unsigned int p_space;
 		size_t read_len;
 		loff_t pos = sd->pos, prev_pos = pos;
 
-		/* Don't try to read more the pipe has space for. */
-		p_space = pipe->max_usage -
-			pipe_occupancy(pipe->head, pipe->tail);
-		read_len = min_t(size_t, len, p_space << PAGE_SHIFT);
-		ret = do_splice_to(in, &pos, pipe, read_len, flags);
+		ret = do_splice_to(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
 			goto out_release;
 
@@ -1086,15 +1086,8 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 
 		pipe_lock(opipe);
 		ret = wait_for_space(opipe, flags);
-		if (!ret) {
-			unsigned int p_space;
-
-			/* Don't try to read more the pipe has space for. */
-			p_space = opipe->max_usage - pipe_occupancy(opipe->head, opipe->tail);
-			len = min_t(size_t, len, p_space << PAGE_SHIFT);
-
+		if (!ret)
 			ret = do_splice_to(in, &offset, opipe, len, flags);
-		}
 		pipe_unlock(opipe);
 		if (ret > 0)
 			wakeup_pipe_readers(opipe);
-- 
2.53.0



