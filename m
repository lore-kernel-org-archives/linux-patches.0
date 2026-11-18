Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027770;
	b=O5jC2qPuWprqSaYlVOlUJGva83keqlWRqsm9bvi//wtwHUwea52kAgh1cj5Acx8V50Cq
	 ybKsXbbymcVfpWbdtRlHTX/rAiDFeADj8u9xZF46U9E/I5pdEahI3+Gy+py3TAjto5EXB
	 J6oM0FSCBxXKE3hUAdBcJAJp+U1zxE0DvQflUnibDwl5wLkaiwtSucwWa0cRyvqaBgvXJ
	 MBBTqQPrxhlMkbw8bOmUZRwYY3SUuI8gLgbsgc13MOWEfTFZVwmF8LIren1reB6C9xxne
	 OsxYMEH8VtMsSxyHeh4G2qvWDi/2pnm/TPk8qZAy2TW2DoTlWFOspdGLzVCbbjyPN9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=az5eA0gR15bdMi1NpnRbL/hV8jiXxlN54z29olSISsE=;
	b=ndaZZQkWjzg2oQy7MlQ6dODLIuDgoOaRo9g+sBwpUGCJctBM6UUqAhTlYgCLlTAFEv+G
	 FBiQ3Gg5OqTuWGJEvxIiTBuGMAnXzxn+yACQhTcf7dQu2fF5dNgPbdwwOb2kUa4LR2xxy
	 O/hjuihvxJnSuTuj6+2L1M/aOuiaj4zNUNqE4Mpp0DlTaEU5mWG6pEXkn3oAnU2PFirEY
	 98O2uO3EU8A8Q4V4150NyzP0RGumvEbkl/gwHnsSOtGzmFbqBGiWva0w9//6OYCI5ifEL
	 dp67B+I0NEEsOXxCuSIBoUmKDd7pKtUvJNwfbnF2ejnbmemXxhLq/KHb7Lytk2AOH4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptHhSSme;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6585A606A335;
	Wed, 18 Nov 2026 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ptHhSSme
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1D11F000C4;
	Wed, 18 Nov 2026 18:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027770;
	bh=az5eA0gR15bdMi1NpnRbL/hV8jiXxlN54z29olSISsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptHhSSmec7rdcY8kESb7eKKm6jYYJC8vZB/0gZCSmtOy2b/Eirub/6mEn2dUeqiEr
	 tLFPE5B8+MppF0WdSHQWO1br41kQ8PH7wUtz7i/r+VsQGWQOmgQJtSDuE6isjFU8cM
	 mHmESMEJy1Vm+OFGEsMIijTuncTGGYyocs9iAlCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1905/2151] signal: skip blocked signals in dequeue_synchronous_signal()
Date: Wed, 18 Nov 2026 16:00:40 +0100
Message-ID: <20261118150231.186962595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 636cbaa26d52a..8fb8e03f39557 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -702,12 +702,13 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
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



