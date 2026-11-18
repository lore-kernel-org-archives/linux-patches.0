Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022358;
	b=e+G200n+cQug6hglKXep8i6vmZ2gCNJmkn6nKmd63rfr47oRsun3+YIJloYm6h90ebTt
	 dI/ZpmTyNsm0VvERO0ca2DRP4tdNpfCPUs5WG67gs/YqdqxqpHDCBJzwAcqlpvLUak1RV
	 lmfykhOJKiIIm35tcstbUKglGs+PXML2CwhhZ/ZAp/BFPyxryQJDiFN2HSvU7jK8Lga9Y
	 ebpBSWSPARGnr3HMe7Ari/IzT7hjaw8hpW+P/W+NUwnqUMM1teK6nfFePCuu5Ljg1cuSy
	 dYlySRKoG5bwBdPoeL7on5rOBQZMy/MjK9PlwqBO34abNgdKZ8xCBJt9FLyUltrEI4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMhUu/cqPM4xmUleePCcxJyDhoX0VTBOasAiuwY9Ne4=;
	b=QqOFEJMPw6QUHMz46RjtZbpbfOpLXUXhxh7A6xvK8j8Tdo8ApDVYswaTR9THvdd5Cy7P
	 94VJwjc2KUG12PZ54DRvWZ9xp6SSth10GJwQZxV5FyuuJxTNAg0A9gu+G+Dwzj9q7t4If
	 7Usm1ekFiDCJnP0Ne3BkskbKPTdD32LtDdC3yO859BQNjK08G/TYm8TqPhEXgxld9btYS
	 IK/YBVb+EKS0EWVi9oTpTgwctPIspzlufWAKuyVJncf8EMyfC5n0KEc7uWzeHwW2hMQAP
	 p8CZUqdv6ohqIZrhlVOahoO2LPATj7nIRA2IVQcsuhbP3waV4tjCqG4pXI0T+RvrAmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vuIbOjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29A8606A31C;
	Wed, 18 Nov 2026 17:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vuIbOjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66571F000C4;
	Wed, 18 Nov 2026 17:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022358;
	bh=KMhUu/cqPM4xmUleePCcxJyDhoX0VTBOasAiuwY9Ne4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vuIbOjEpxGH96cflMtwMHevau7X9KFQ6O/krAApM27HSkwKjRSgcn9W5qgflzllk
	 Ls65YPsufyCQjvy1mqW6oa8IbJSmffaOifJV23plMKvAqhxHB+Eg7Kqa/5fImClwxm
	 x9bGQ2PxFhLSX/+4Qiow7i4m8Q7Y5ruWk2daLG5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2634/2651] splice: retry tee() instead of returning 0 when it races
Date: Wed, 18 Nov 2026 16:04:34 +0100
Message-ID: <20261118150418.976769634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 96378d3e65580..a815f8c70e656 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1856,6 +1856,15 @@ static ssize_t link_pipe(struct pipe_inode_info *ipipe,
 	unsigned int i_tail, o_tail;
 	ssize_t ret = 0;
 
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
@@ -1877,13 +1886,32 @@ static ssize_t link_pipe(struct pipe_inode_info *ipipe,
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
 
 		ibuf = pipe_buf(ipipe, i_tail);
 		obuf = pipe_buf(opipe, o_head);
@@ -1954,16 +1982,7 @@ ssize_t do_tee(struct file *in, struct file *out, size_t len,
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



