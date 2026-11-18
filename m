Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050778;
	b=QdlVvq3DsN6NthAQrz401AsdDp+6FE7Bp/ANfP5MOVqNzP4lIu+lGJlSEV+icQ7d7pFP
	 sQR5v7GFjw5f/fq2cHtDCyr+9/Qr+8re1HCha50rWylHf8QeN/CfQaOnBGv02HtxsuaGP
	 Xv/aEiV/x38PSXIwLd1CvIqPDdsSlrJn5m/uA98MBRzbwvUH6B/2uIFCHyACAbwYhZdoJ
	 bcGLtLQab8xp3/4Y8BI8X2UsgMOAhxpA9DmkpDiQGpGWtIdpNfCv5hmkxvoKRxNFOnE6k
	 Oyp9Z48WRmEI1m7111TSaTiRZswlbieGzVoCrPsWfIK+Sj+PM9vCZsmUp6jwhszMlUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R8Un7Nc3wn6y8ARi+g05kLqXTfrMV5Q/c4+OkqdvZqE=;
	b=a+Kzl/jyBy4znrPzjUal8Cx47wSAMOqs6tGSP1VBVud4BqNxfSyoL4Umz0n5Mi3/qWm5
	 KorEEqQYFzVa1jysvzQuERb+0MiRLV+u8lzts9uYiHcFEThuC9qcqSRN94XFXZVGoq6/S
	 zsTWdV+S7/R49wKuwKlGnQ6Onb9Ytn2hl70lcSNrRxDCM46PTeeiS0+Uiqz9P67gyfXEs
	 6y4OCManxF/Z/QBbEsONxoAemIBIL4NNpnF+wQtZr1dba3nEJk8v/52lBGgllYDM8tPWa
	 jSP8Ce0LucbLP9pgUaHBp8fNqkl/FMVqeGG5pSn6xLt9mg6BtDrgzy4vIqjnIDIu0OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdKmNzrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111BE606A333;
	Thu, 19 Nov 2026 01:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mdKmNzrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C891F000C4;
	Thu, 19 Nov 2026 01:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050777;
	bh=R8Un7Nc3wn6y8ARi+g05kLqXTfrMV5Q/c4+OkqdvZqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mdKmNzrE+lEEJUDhj+L+mLWTBzOpvNJdSKauMRQgQhDmMO82IqFiJ34C86tCEdFha
	 Ax3Sk5eqRdY0jhJ9HeFHYr0BG/WMYruqx2FQ6qVVejlTfaxEGRqQmi42fUb0gkuvzv
	 xgsKIrdspKoQEz/VcIAGs5Dzzdllhmq6TeeYx/O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2828/2857] splice: retry tee() instead of returning 0 when it races
Date: Wed, 18 Nov 2026 16:04:22 +0100
Message-ID: <20261118150343.412505415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cf3d86d90bacc..26824470af974 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1616,6 +1616,15 @@ static int link_pipe(struct pipe_inode_info *ipipe,
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
@@ -1639,13 +1648,32 @@ static int link_pipe(struct pipe_inode_info *ipipe,
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
@@ -1715,16 +1743,7 @@ long do_tee(struct file *in, struct file *out, size_t len, unsigned int flags)
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



