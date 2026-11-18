Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062014;
	b=SQvGPVGlct/YXqPJSx/YR4gQNbZQswXhRWKKrggjUrBd5Y8iaBXVTMY5+faQhuu/LwNe
	 7mn6qsBTwnfrUn/ZSgg9Bj5qEnxSN9Vr7yjZT1rDSiIThoTR4JVU8ZblxEAG+MHaE9xxK
	 LDXaOxIH4m8JsYtqyy7MZtAZ9IXSSdIb/BgyfVq2jNjQo43kLSrLKhKmrsO/T09HFNSpo
	 L/1TkfrDQkUslMiEX6zqS3T70Eg3iLf6wuWdZBh5EwWju57/4Dt3AH3wfWzm+Qe9F1x/t
	 yXGJfJgzcasOXnj74DIoXricTovnP2DNL8UrIrt0rvEvUaLzf21wvVNoYuDeAcAioBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sXUr0M0I8YZ/VWj0aIwGxUdpmbcWimkIJ96jL8JKdmc=;
	b=H91doPAdDXQ2gW4gHKF7dI9NhekzjazK2ZWpt9o28AAOahTJPtSUjOiWqkteeTZV0zZe
	 EtyTveXXATKXSZYN5vK+cNP/hTew160q4+IbD5Ouj01euprxUOTuWvGYME5hGE2zDVZS3
	 6B/GK8VYZMEirFK7I9Kakd1+za53rcDk5Xi/zKE7hc2J/fA5b73OZZRHJ+AiwXnIO4xgc
	 EPCrI/5s4B9TbJd/BudxpB+UWiLcA+8TgOQseOILJR/oXxQ1SBGVj8p2c6IiwxWfM5PRa
	 TE2GOa6sEx112ae25vh/61y9zIlqjJ8Bsu4o6uxfO8VUlHHL7K9JY+oYheMzev4P3YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="F4/bnvYN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C8E606A325;
	Thu, 19 Nov 2026 04:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F4/bnvYN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1F81F000C4;
	Thu, 19 Nov 2026 04:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062014;
	bh=sXUr0M0I8YZ/VWj0aIwGxUdpmbcWimkIJ96jL8JKdmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F4/bnvYNFjAx4af8AjDdcDi0wNzF1Crj7zHSWBuJcP9Tj4TzV1ZWP6jATqrspeZtK
	 T+GlYF/H9n6oj5L5HRoAIYamBe8F0p0EnSwfb99zJdf86eJTEt/ktVNPXaMR+hu+fI
	 k2SCpJ50QMBGQ8zMpyy/9x8kVCTbKeR968srYoiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1758/1848] signal: skip blocked signals in dequeue_synchronous_signal()
Date: Wed, 18 Nov 2026 16:03:16 +0100
Message-ID: <20261118150033.041501003@linuxfoundation.org>
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
index 752e71af26b33..9c77f946ff2d2 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -717,12 +717,13 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
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



