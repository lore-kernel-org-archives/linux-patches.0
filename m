Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062269;
	b=EDBjy1y9xfrWxPUVklHmoxXSrmYOErxO3wFihHcHEv3XXBaBlCX8noN7n3wbIAv01ffG
	 R9rnDBHhfxcWl6jymQaHcWsPgqF0PAL3EVrpH6mKIWHtRFtwwod8GFK8FRfe2KBVc0RDB
	 3reCrRZtVrGyJW+e6mQKSJ4RomKULNLPrnbUCHK5ZP0FiVRNlyszzJPSbiGO5fFhIWEUj
	 YyDtDZzm9QKb6fWXjE/U+PVC5FbQkwksqPseLNt9PEZdWZChxnpRCEd2tz6qUX7d//0rb
	 Prk6M2uI0EFQkmQ+To+3qU+oN+0UTXmZgbG7OVgQXO77ikgAJvL+yeVVAG4XxLf1fbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yASH4PQwOCBa8+b85Vm3kAZM8o65IE5olwrRcLWzIzM=;
	b=V7Vc8IdnoHclzKZp7fG3gGqr8BO+vIehNrJ0rT6ENpP196W3kFX6+VwkVMXc5DCSi4F1
	 xGu9toL/+aumJYF0qsYJlyr83Sm36LANNY6Qvdtmg2D3nOGzq+W8Y3nv6lFTFACmNadhL
	 7txIkll3Own986WiyBRUxGHpqJG9nMHl4ipCxXJ4SV6U137S/xQjGkRQqZe0pqhWuyz7+
	 fr0JrGyUy5j2aoz/lTvZm+XeD04gARBl5XEzZFulimpSxx/cdAfl2lNat+0PNAMQg467R
	 jPHf20g4DYiYBi0A1B32Kqr4yn8+5rN9pb3Gx0yHII5F+W8+UzZVK3pxsK8Fdj+ib5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zy2+ORX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D1F606A320;
	Thu, 19 Nov 2026 04:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zy2+ORX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9971F000C4;
	Thu, 19 Nov 2026 04:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062268;
	bh=yASH4PQwOCBa8+b85Vm3kAZM8o65IE5olwrRcLWzIzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zy2+ORX4TJm0/wkRzRhg++Ye2El6JffBWKfMhz5fR7eggvLy85Ce/u1NnGrwwzJxj
	 q5uZYSP86HhB4MseT/SQE9xvilb4IARhaK3o59s7iDCYfxYHqyea7BV2kcOUzsMfuw
	 YO8zZBVD8QhyTvRRPuQtttznHoTZi6b+EpN+fKIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1821/1848] splice: retry tee() instead of returning 0 when it races
Date: Wed, 18 Nov 2026 16:04:19 +0100
Message-ID: <20261118150035.904534289@linuxfoundation.org>
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

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit b2aa970a0a03c117306f48d75a4c3125a8cc9957 ]

tee() can return 0 while the input pipe still has writers, when
another task reads the input pipe or fills the output pipe at the same
time. tee(2) documents 0 as "no data was copied" because the input pipe
has no writers, and loops built on it (the man page example breaks out
on 0) stop early. In a test with one thread writing 1 byte at a time
to the input pipe, one reading it and one draining the output pipe,
about one tee() call in 150 returned 0.

do_tee() runs ipipe_prep() and opipe_prep() to wait for data and room,
each under its own pipe lock, and only then takes both locks in
link_pipe(). If the input pipe was emptied or the output pipe filled in
between, link_pipe() finds nothing to do and returns 0.
splice_pipe_to_pipe(), which was modelled on tee(), handles the same
race by dropping both locks and going back to the prep steps ("A zero
return value means EOF, so retry instead"), and returns -EAGAIN for
SPLICE_F_NONBLOCK.

Do the same in link_pipe(): move the prep steps into it and retry when
nothing was linked although the input pipe still has writers.

Tested under QEMU (x86_64) with the program in the notes: 154 of 22698
tee() calls returned 0 before the change, none of 34429 after it.

Fixes: aadd06e5c56b ("[PATCH] splice: fix problems with sys_tee()")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261018025541.799135-1-nickolai@csail.mit.edu
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/splice.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index 30502e226cad7..7f826452e494a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1592,6 +1592,15 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 	unsigned int i_mask, o_mask;
 	int ret = 0;
 
+retry:
+	ret = ipipe_prep(ipipe, flags);
+	if (ret)
+		return ret;
+
+	ret = opipe_prep(opipe, flags);
+	if (ret)
+		return ret;
+
 	/*
 	 * Potential ABBA deadlock, work around it by ordering lock
 	 * grabbing by pipe info address. Otherwise two different processes
@@ -1615,13 +1624,32 @@ static int link_pipe(struct pipe_inode_info *ipipe,
 		i_head = ipipe->head;
 		o_tail = opipe->tail;
 
+		if (pipe_empty(i_head, i_tail) && !ipipe->writers)
+			break;
+
 		/*
 		 * If we have iterated all input buffers or run out of
 		 * output room, break.
 		 */
 		if (pipe_empty(i_head, i_tail) ||
-		    pipe_full(o_head, o_tail, opipe->max_usage))
-			break;
+		    pipe_full(o_head, o_tail, opipe->max_usage)) {
+			if (ret)
+				break;
+
+			if (flags & SPLICE_F_NONBLOCK) {
+				ret = -EAGAIN;
+				break;
+			}
+
+			/*
+			 * We raced with another reader/writer and haven't
+			 * linked any buffers. A zero return value means EOF,
+			 * so retry instead.
+			 */
+			pipe_unlock(ipipe);
+			pipe_unlock(opipe);
+			goto retry;
+		}
 
 		ibuf = &ipipe->bufs[i_tail & i_mask];
 		obuf = &opipe->bufs[o_head & o_mask];
@@ -1691,16 +1719,7 @@ long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
 		if ((in->f_flags | out->f_flags) & O_NONBLOCK)
 			flags |= SPLICE_F_NONBLOCK;
 
-		/*
-		 * Keep going, unless we encounter an error. The ipipe/opipe
-		 * ordering doesn't really matter.
-		 */
-		ret = ipipe_prep(ipipe, flags);
-		if (!ret) {
-			ret = opipe_prep(opipe, flags);
-			if (!ret)
-				ret = link_pipe(ipipe, opipe, len, flags);
-		}
+		ret = link_pipe(ipipe, opipe, len, flags);
 	}
 
 	if (ret > 0) {
-- 
2.53.0



