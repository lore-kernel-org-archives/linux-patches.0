Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829226;
	b=ZnSfvPsnnaIgCXRIFHKEOL/oAFedeP+H7tNh9RaZLUjclrSNr1sLSIpIVbX6iAQyc+WN
	 KZUwr6b1rEaOQcrY3y3K54GQSwG3N5ZaOafF33AKLwkuCTT7w2eQwqx+MFMdwvcj5OMt0
	 2QLtg7doPjmqnHI5x+1fsjokguHWGsowgRSEm8ULwfaPP76JojPOASqYO63IkARElGgro
	 8ibfRN0lA/vlZSjybVf1+Ei7Q3lQ4lAHy85YbY5XimiKXqSibVEZ0F/FztVtjI41+0PjL
	 WO/PFjQAND+8ODasI3QrdESBL4V3Viat74vk+1anPXcGMuEI9hn5xBMkMTwISmMRVmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829226;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0yvrRfh4J/URWQIeUGoB7TEaoSwQID4ndXFal5WVZ/Q=;
	b=DSkF4paVf7R/fGUJW0lDsROD1+VVbeYvLPqK/xHAbqq/nbnxZhUJghwe5LKhz8AyzrkK
	 TGyeEnvpLIe2pO/hj3rpNUEnhCAgQMUltqYJq24SHhYQQfJlKrXtigJyr5C+eJXJELfdx
	 ItMaMOLeXOkfRMWBevgAXttTSOqYsuAAtPUfZX0/C6guMxZ9gcMSbsgLhnjvCXbW2VnWN
	 tmUMRsQiZbPyAoGotwBXDyB1kiviuoz7FTiEWcna5/MJcCEPRFYeaejtvyr6QIYPXJnUq
	 rAHIokqMXxGr0JUEeR/I7DIyX7ALAL9JdYRxIOelU2WXaJkS8S2sv4hyp981ZGOTcsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yfx4IZyl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8496070A88;
	Wed,  4 Nov 2026 21:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yfx4IZyl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DB81F0093A;
	Wed,  4 Nov 2026 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829226;
	bh=0yvrRfh4J/URWQIeUGoB7TEaoSwQID4ndXFal5WVZ/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yfx4IZylNP6YSdFeUn5FFi2qXgEuBNhIWInhB/lHTBZIjyyhGEMoyrmOrAJaOk5y/
	 HcRqZ2CNE1ubPrM4jsamZhAohpqXVHtgRbx6TLx5s7WWOc/M+BtLI1RXXQCKMk1ctd
	 Q2KdKf8ti2+lQ0OCXTwX/KyGVLvbTiIgOyzjIK7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 528/547] io_uring/bpf-ops: clear bpf_ctx while submitting SQEs
Date: Wed,  4 Nov 2026 16:11:52 -0500
Message-ID: <20261104211053.394848403@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

Commit 8543a39f03db8816a2d80d0c92c132a19f2afb48 upstream.

bpf_io_uring_submit_sqes() calls io_submit_sqes() from inside the loop
program, with current->bpf_ctx set, and requests issued inline run with
it set too. The socket code uses has_current_bpf_ctx() to recognize
calls from bpf_setsockopt() and friends, where the caller holds the
socket lock and has already been vetted, and skips both.

So a SOCKET_URING_OP_SETSOCKOPT from the SQ passes sockopt_capable()
without the capability, and runs without lock_sock(). A task with no
capability can set SO_MARK, IP_TRANSPARENT or TCP_REPAIR, and two
threads changing IP_OPTIONS on one socket, one through the ring, double
free in no time. SOCK_DESTROY via IORING_OP_SENDMSG ends up in
tcp_abort() without the lock the same way.

Clear the run context around io_submit_sqes(). The SQEs come from
userspace and must be issued like those of any other ring. They still
run inside the program's RCU tasks trace read section, so a request
that sleeps there holds up that grace period, but other request types
do that already.

Fixes: 890819248a86 ("io_uring/bpf-ops: add kfunc helpers")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/bpf-ops.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -17,8 +17,22 @@ __bpf_kfunc_start_defs();
 __bpf_kfunc int bpf_io_uring_submit_sqes(struct iou_ctx *loop_ctx, u32 nr)
 {
 	struct io_ring_ctx *ctx = io_loop_demangle_ctx(loop_ctx);
+	struct bpf_run_ctx *old_run_ctx;
+	int ret;
 
-	return io_submit_sqes(ctx, nr);
+	/*
+	 * The requests come from the SQ, which user space can write, so they
+	 * are issued for the task and not for the BPF program. Hide the run
+	 * context of the program from them. The users of has_current_bpf_ctx(),
+	 * such as sockopt_lock_sock() and sockopt_capable(), take a context for
+	 * a call from a BPF helper, whose caller holds the socket lock already
+	 * and needs no capability.
+	 */
+	old_run_ctx = bpf_set_run_ctx(NULL);
+	ret = io_submit_sqes(ctx, nr);
+	bpf_reset_run_ctx(old_run_ctx);
+
+	return ret;
 }
 
 __bpf_kfunc


