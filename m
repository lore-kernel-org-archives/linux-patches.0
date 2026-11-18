Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032745;
	b=lfZL5o4HqRUC0C6n/4VFmCmnWnxo13ggth/MhKslsVRucknregLnwPFm0AX139LkX3aV
	 o+Ct5Gc47lT6+HikxGyJYs014/OCezL/mXwnGKFa/RXV5ug5dbDakwShBKz6qK9/dPISp
	 j+zpKc+kV1gbs4XDdMtVCD2IAcfYnOV/UgTb6npppL4nBqkksjilqNn1e94hE2RiEuUy6
	 +ietgi3Ztj/JWwu5nQYE7X6HPduwWzC23HNTQ2icTXEFAvP7D9pviWAitc2OoaE/pYAfB
	 XPBGp0P7H2FWTfj68VK9biJ1s9Xq5kO1UmWE3+lyqF6wUP4DGHxpzdd90xSFuKYNgrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDK/Nh+Qm0QyvR7eSfkBmq9QRNeahvIkCgz3bg/SlRc=;
	b=D+qHdxqaNOMqbKc4Os/6WAsxO5mMXaepL7jyWTy/tuH4rpKTF1xE0qi6X2yYHS3iDI+t
	 BelOqazQJjcdEEPjWz3njQgnKKIl1qE4CIW5lOYtq3M6f0Q77wxQ1U3nK6smaQ1ZJbcZ7
	 vcnBBL91AMdvprpA8VWqLFxsHBJwtLPdjn/zEUSko/cc9WNXQSTCy75ok4ZJdRNPz8xe1
	 34pOlRhF4BjTMRZMAl69FauCih7wWO1gosU8uw4oFdmfKoIXCu7xhJ8Ie3n56S/rzRuUi
	 jTqCD2sLPJm9bPulNMPvituZG6fHCZpIcm7QBPRw4VtdyJiDcrFOO/0uMjvdvs9jMvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T1/6Qg86";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A46606A31C;
	Wed, 18 Nov 2026 20:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T1/6Qg86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343511F000C4;
	Wed, 18 Nov 2026 20:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032745;
	bh=DDK/Nh+Qm0QyvR7eSfkBmq9QRNeahvIkCgz3bg/SlRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1/6Qg86ENJk8hUTktAO3FLnWNnHkv/OTGlab2Yencey1rwEht6SE2YiwLZPOOGec
	 Gl3pLeUjA+SXjKjWk+GVVdwFkjxWQuZCD2ARIJqLdhl7O9gLoDlNK0mC1eRXefK99/
	 Pgn1a7JSf5qdfSIxE/WQ1oFckrUNdTdgjUjVQ8mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1522/1756] signal: skip blocked signals in dequeue_synchronous_signal()
Date: Wed, 18 Nov 2026 16:00:49 +0100
Message-ID: <20261118150109.435939744@linuxfoundation.org>
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
index a3ee3c6960cb1..b89ff1e615adc 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -716,12 +716,13 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
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



