Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056752;
	b=UDLxXYnxh0GVziUAd+P5nrCSYVWO69B2o3fD7B3h/aOcU5VvvSrjhLTTd4CWlMQcOvb2
	 iEvsFefId0Tjk5wSbSMT0ZLjZ2ScP4XmuFKEoy/PViJaHZcp33avK0TxtdTyQ/rf7BVFJ
	 1NCCC3snnE0iYsZ7OPp3/XS4Qw//YV4DN6cewjMn5CAOrGWLaX404wLJGTtXX8XiytX5T
	 9z8ciDVUipPp5XpEUdlFjYGp9+abKmdoA5OH02TopdaxlhJfgGeJQBZgjZDkJeZ7DPnwr
	 bsQzhRmZw6yP3B42GFI61/kbzksG4WEJGLblGyuujKXY1aW6YwSeokXG2lZhLrDpndQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q6NjD3kjh66mfNcnO3Khw3eY0yir0Oj7oosfcY6mzvs=;
	b=tUi0t035PGfbRmPGKJO9Ix0CFUBPxA3WX9oN6U8YQ1QMkzGiTnT82gT1/WaIdpA9CYU9
	 F04DKCeCw6hSEpFnubclAq1r7NXzRUL672dXq5Xhd/Nwu/ft+ouPv5blxibH0kCclWS5j
	 8jP/Ai8hhDW2h4pFOAfIYV3OTrZOVHpWzPPD/JcoY5uAKRH48w3c1UGWhcwxXVRQakP0R
	 9QN/SRT1mmm/sIZ7lXfNoeL1PJM6htsCSG5VZoVLmRtAaN4m3m2iMe+6j2Iir58nGAuzb
	 ORa5CzNQP2FhRqrD4COqYAdcJ6aUzxw6oL9xNAGAndxMnj1mHajb9sJq84BzVBg9bAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CA6w6VU5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847EF60A2616;
	Thu, 19 Nov 2026 02:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CA6w6VU5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6431F000D0;
	Thu, 19 Nov 2026 02:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056752;
	bh=Q6NjD3kjh66mfNcnO3Khw3eY0yir0Oj7oosfcY6mzvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CA6w6VU5X37Eg4eMmr4miQ7Xdvq6yp8oN3+CoaOgUzaDcSJpvqP2+yzT3dwr1hslD
	 WhEKVUS3G5Q4V7PPsYqL2VLFj0WGMN+0AKzjNzHIVm8EeCX7eMvRLaFfTkawOYEN84
	 QXmgqnkLB66NinB2veHjC1j54X2u6jH95JTQ9Ucw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2100/2214] signal: skip blocked signals in dequeue_synchronous_signal()
Date: Wed, 18 Nov 2026 16:02:56 +0100
Message-ID: <20261118150134.673358675@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d4e477e599385..bdb041446b7d0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -719,12 +719,13 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
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



