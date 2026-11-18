Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033279;
	b=mMHY7VhXCdsx+DhnsHb2tOfsu5LHir04vSEPh4E4BQI382wmN4xDbVHshqDctMxe38OF
	 bIidki4QAASq7lm22N6aSEnybCI/f8a9yuqP3oGcy3kHU7Aff9Q1ghCBwHZLfWRIE+7HF
	 yWHpLTwtjfxC/7Jq5TzJxRr6+TzI5iZVisKGC+JdaMHYhtyv4+g7HbYfqtMyx+Ub/ljsM
	 w+o2pVGsLTsIKJQfbPsy0raOBc88k+SIM+rViiouZh9kUoVzI8KB7HWKR+8/F5+IlNJ8F
	 Wc9ni1L1U8blpAuNYQUriid1Q+zX70iQtjT0fvGz/XcMCJOpv7pV0DHLeSMEkp+cMig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9NZGkUIRSOBvWKNn28bObMZ+LH2mNPKQ/KjDIm+/un8=;
	b=vxiQpCWyXDh8UESax4fkl5WWWAqw+1r/bclc+zFf/hblyAHVBYptkNHElz98leKhL4lw
	 znB4LS4239uZK4HnvONNCfmd6QKmNpTAYXCHasoLShbgmjudns6Mdk7L1oI7039cD1dKB
	 J3ON9T++LEJVX7YXRGwnGmB1DNGiWuQe2CBclJTlBhNBCA2Jado/rdbvbDG33QmFC3Si7
	 ZswHBdY8xQNkneDx0SVtjVd0Vcjygmk+HcB1mcnuSpihvZ/v96ndVax6o808HSNMTdRFh
	 YzuBYdUOTzULv7pmun/w+v/1ztQtyerwLIREXA8GEDrZEbMbRe9CoHBkZbM2U8HetHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDKlAT8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E0606A32A;
	Wed, 18 Nov 2026 20:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDKlAT8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC371F000C8;
	Wed, 18 Nov 2026 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033278;
	bh=9NZGkUIRSOBvWKNn28bObMZ+LH2mNPKQ/KjDIm+/un8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDKlAT8C4YFV5oNMNLSYw5Vg8ee7THdbImHCIeu/IGPjH6j7qZUbC4YccLfVcEWPq
	 nCZVK7upnsdEUQKwWtyTgtcz5FIb/WUBgEV+mU0s+FyZO08FqVqNlwgrD7uTzJB8ak
	 e5IB/P7ewy890CJcVYIxm+h/xy3+87MSKTgmCAv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1712/1756] splice: retry tee() instead of returning 0 when it races
Date: Wed, 18 Nov 2026 16:03:59 +0100
Message-ID: <20261118150117.772121476@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a8f4ec2b7de10..aaa4c89cb28f5 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1886,6 +1886,15 @@ static ssize_t link_pipe(struct pipe_inode_info *ipipe,
 	unsigned int i_mask, o_mask;
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
@@ -1909,13 +1918,32 @@ static ssize_t link_pipe(struct pipe_inode_info *ipipe,
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
@@ -1986,16 +2014,7 @@ ssize_t do_tee(struct file *in, struct file *out, size_t len,
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



