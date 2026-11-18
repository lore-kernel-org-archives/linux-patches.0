Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050408;
	b=WxvsgJxffyrjiUyPCAR6lcIdBzzevzaqd9ydadG2trk0BUa7d4iziPFidYkLiTC+q9Ji
	 8m5q9gpwQDcb1BYNUJllmeZtZCJQHbMVJOEaC7zFfZKvxuyXvUyQ5k8tCbdh1n5ovIQVp
	 SDJLlSQu4ojFlpotzzGadEFvpgPahAZDvP22zdiLmHOsLjkiSy65t/h2HvmKJOPBcjkAF
	 Rn78CqR/Am5EfioBcUvgSIALB6ts+V96K2+g92/2aoKL5wAWQSSMkxQmOU8/HkYKUi9N1
	 RgqSIf21JieVxrn2WXQf8A3a4nMRKQp9efNn+7ew8Y3O9E87I9w2bq760Q+zMvnb/Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q6dyTiUbOQiLcTx1DDgbITEAfRPfXRlzBDFDQOZy5Js=;
	b=koMWssV+xo1GXIiv4g7AAL8moXbSH5cJ9VibX1VYwp2t7BzI6/Ye5XXbJ9v4NewOPfUu
	 1zliT7d/foP5WwZokTwQ8leFxxE4t+D3ODMGvHI+O46ljucJtdp2cztsGUynXIlB4EDYQ
	 SLiUzniz6ViP9Z+yK7WzQn0clkPafv4btRBVBu79idydvZ8JHzf6WtE0zK8qzZbhBN2Z0
	 YICQDUggrVJe3yMgL3fJsOKg+L40jLv+CsEzdYMD0+ee4c2I9RxSv4r/MDlFj/m5pqcSx
	 c+pyuNdYBBFfq4d7U3TfjsdS79SSyYwXxUr3qyyi2haN8Lfh/z9sXpHOySTKJxRKpRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9PZmpWC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66C8606A31C;
	Thu, 19 Nov 2026 01:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U9PZmpWC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138B91F000C4;
	Thu, 19 Nov 2026 01:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050408;
	bh=q6dyTiUbOQiLcTx1DDgbITEAfRPfXRlzBDFDQOZy5Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9PZmpWCTxye9QL7PIabrOnVygbfzU8RRZAqQhQbjxjYmQbajIbHT46WHep6lydIF
	 KDjk4D4r36srXk/rubTPffcNHrFKT2yq2xGJeovojpZ1LRp225ZigzhcZX2ZwDDHie
	 XGSKMsI6tc/4/SjMAq0lhjTktMukW0mFI5ov0ZBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2696/2857] signal: skip blocked signals in dequeue_synchronous_signal()
Date: Wed, 18 Nov 2026 16:02:10 +0100
Message-ID: <20261118150338.639363576@linuxfoundation.org>
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
index 73745319f1c70..1860b23b3b14f 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -725,12 +725,13 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
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



