Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042338;
	b=pVuw6e4YxgiRaQQFREuYQQZw7ai3gKwXnBoy4e0HFDE0MIFQdLjryC4REcPjhnkjYvdF
	 nRB1PsQa978z4YAGxNyT+x8ZcIBUjJQp7mz0/mxPpNsbAJnyuif1e4ad0wFHFQf27CWOg
	 6NfFEN2CNzDbOMcOdOLf0dgXXWUXqkeFs64XO5sJz+HexGd2wOqyGMAM4bq7oRPqSV2CM
	 vgxztrTmwJlMKZrsJSqoKk8B4H9reB/KfkNqy3IFTLdgW4eF/80wSfEs1KHnqQWy8A9OD
	 HL4Jqbw9+Ku26yg8PDihALohfrbm6o7ypVWRlWHckKzw6EIdg9K30jCyPGLA+sm2zuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNXUfpV2HCe+rygOKTRCm5s5FIFZmz0z+oPxE8I5uqo=;
	b=q/iPiyfXXn/WXPrWFbzEpE7MNoPjFZmtgfSmZMHSZQ8NvSN4zrw76sDwRHj7q2INbm+v
	 lCfrc5+KYQOQEo1dcDFKe6366IbeDeGqYYoXyuMfeObA23Zre4D+kVkEbDPWHB0FRZfPV
	 6/YtRBfEoSKwt0MLOM5G7eJJszvZ0K3vH+Eg5EDkLBtyBs6Hxm2crU3OnSm616LTpiyWD
	 GzgFB3iTqXDE7axoyYsFwaqyRDgAgDiseHCUr7JHCSjPf7kpXNXoB/LjtLI/eybldFGtt
	 36sfLI4GdIpokoU4LFkN2+Px3FbYZSoCswuUTXrcuo1igbMOXMIZNFKJ4zp7RksBVpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/iK4bxW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B3606A31C;
	Wed, 18 Nov 2026 22:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/iK4bxW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59E21F000C4;
	Wed, 18 Nov 2026 22:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042338;
	bh=DNXUfpV2HCe+rygOKTRCm5s5FIFZmz0z+oPxE8I5uqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/iK4bxWutTiR6RTugYfnlFMoVfHQM8ANR3tLewyBujHI9q0wSTfHiDCMrw14XQFu
	 cukdidEbkmKeTZ60dF9ZbCuNOfIWDCyVefeOck3o6Q+ckFFCiSbnFe6KsSxTfM/rFa
	 q2lCwaDFUDo7ja7+9IRQjxbu47mbWzFn4zhlPo+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3135/3318] signal: skip blocked signals in dequeue_synchronous_signal()
Date: Wed, 18 Nov 2026 16:02:37 +0100
Message-ID: <20261118150453.939884410@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 4bd3a0e8e53decd614853fbb487a268f139f679e ]

dequeue_synchronous_signal() checks whether an unblocked
synchronous signal is pending, but its queue scan can select a
different blocked entry with a positive si_code. This can deliver
a signal while it is still blocked.

Check the blocked mask for each queued entry. Forced faults
are unblocked when necessary by force_sig_info_to_task(), and the
existing pending bookkeeping is unchanged.

Fixes: 7146db3317c6 ("signal: Better detection of synchronous signals")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261020181101.1605736-1-thnkslprpt@gmail.com
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 396ec7d89f8ae..1053cb2701d9b 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -727,12 +727,13 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
 		return 0;
 
 	/*
-	 * Return the first synchronous signal in the queue.
+	 * Return the first unblocked synchronous signal in the queue.
 	 */
 	list_for_each_entry(q, &pending->list, list) {
 		/* Synchronous signals have a positive si_code */
 		if ((q->info.si_code > SI_USER) &&
-		    (sigmask(q->info.si_signo) & SYNCHRONOUS_MASK)) {
+		    (sigmask(q->info.si_signo) & SYNCHRONOUS_MASK) &&
+		    !sigismember(&tsk->blocked, q->info.si_signo)) {
 			sync = q;
 			goto next;
 		}
-- 
2.53.0



