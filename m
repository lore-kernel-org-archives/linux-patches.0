Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829274;
	b=A5SzxqAxQogV8u7tWD/xnhhDpvnZMBVqc/PcAWxJFFDYL5BtlSJGorrzYjYPB3l5hkYE
	 bqyxMYnpEYfZAOkMdwbTT7k1Oq8QQfwd5RTuq/+q7Y5OfDIAGP1UcV9gaIe0RSx7aU2/q
	 62MWWZU1bqmgDr8JDKorh4SnrtUr7utaKYEXTokmZari6qe1b90RPjlA70U6MSEwu3wYa
	 DQEzTQnfsHbOQ/CtSJmKUtMlvRATkpCE92YSXJdowF0+izkEAN2TTORnru9BsmETA3Leu
	 8eXCZR1W7YEDNMvUWsa9EHXt1hFezG6xe6utTyC/sRTtkZ9WEfAUarsKHeBOylsTDfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y1JvTjge3O5wb3G7jScc8T3WYG76X3S7KWQztkUYbck=;
	b=GTLmJ2ejRqvPBGPF/K/M1s2efRPpHScwG9hw+YVGaSCBoBel2kP4Uj7HeIn0AplMQRhC
	 PuOv8FIt98qEvtlUCp91iECsnk1ExHPbm5ALHkjF9PsmcgJGouQ2XJuwLCHxnaBBEcb1h
	 XILuuKrvv9Ymn0SB5U4XxgnBRIkloybg0VKUQUEr+qJASJP5O82uhr3FPTPRXJCkWfi9I
	 SKyMEqzFC3vd83Nfaip+229waSYNflEBVtS2FCTGhjmYDW1wRtmRBTLL6yaWMdb4ekC2V
	 ZOEpAfvP6n16N9tA37Bpx+lCMqzpqKb7k5wxdoVa5WVQkIuRr1ejMKwS9f481ASxb+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S5iw/yUB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79BD6070AA2;
	Wed,  4 Nov 2026 21:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5iw/yUB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2A31F000C1;
	Wed,  4 Nov 2026 21:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829273;
	bh=Y1JvTjge3O5wb3G7jScc8T3WYG76X3S7KWQztkUYbck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5iw/yUBg7/Rbd0wpd86VXzddABQMaQxIEH0ukdD2YTcFnJRZ4yVkPIYBnBp98zSZ
	 HjxDiPUaK+D5HRYquX6X7+Jh8rJwGZhgwiixwp5IielKT2UincQcOasAtgk//phAyD
	 n9u0UGm5tdnacZMFcVdoivga0luejkBiSQIFyXfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Maier <dmnk@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 521/547] io_uring/register: enforce per-task restrictions in io_uring_register_blind()
Date: Wed,  4 Nov 2026 16:11:45 -0500
Message-ID: <20261104211053.199356987@linuxfoundation.org>
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

From: Dominik Maier <dmnk@google.com>

Commit 4a93427e99a8524f3612f29ec8bc0da5f8435a51 upstream.

When io_uring_register(2) is invoked with fd == -1, it dispatches
directly to io_uring_register_blind() without checking
current->io_uring_restrict.

As a result, a task with per-task register restrictions installed via
IORING_REGISTER_RESTRICTIONS can still invoke blind registration opcodes
such as IORING_REGISTER_SEND_MSG_RING even when those opcodes are not in
the task's allowed register_op bitmap.

Check current->io_uring_restrict->register_op in
io_uring_register_blind() before dispatching blind registration opcodes.

Fixes: ed82f35b926b ("io_uring: allow registration of per-task restrictions")
Assisted-by: ARTIST LLM
Signed-off-by: Dominik Maier <dmnk@google.com>
Link: https://patch.msgid.link/20261022232121.2538616-1-dmnk@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/register.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -1058,6 +1058,13 @@ static int io_uring_register_send_msg_ri
 static int io_uring_register_blind(unsigned int opcode, void __user *arg,
 				   unsigned int nr_args)
 {
+	if (current->io_uring_restrict &&
+	    current->io_uring_restrict->reg_registered) {
+		opcode = array_index_nospec(opcode, IORING_REGISTER_LAST);
+		if (!test_bit(opcode, current->io_uring_restrict->register_op))
+			return -EACCES;
+	}
+
 	switch (opcode) {
 	case IORING_REGISTER_SEND_MSG_RING:
 		return io_uring_register_send_msg_ring(arg, nr_args);


