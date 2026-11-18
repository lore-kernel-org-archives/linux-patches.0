Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021586;
	b=tYed+ePK59hkQIPbYjyIEbJUgCEnG27fZbIqFX9ahy4e8T0WkXHf06Rf8IM3t2lcCayJ
	 KuIhTcCjGqHW+qwcOxQP6NL0aOuiAk7dFG8v057NqgJuClBUW5PmigEYQqxdA2Lh5foiE
	 EBFoczPOVAnkKFLrOPb3MukgaRNkwGwgNuCfHwONzsj17RltdTLArwItNTMYO/OQut71z
	 GPUu9i/Dnr3SSQon4y3qRsY3GU85052zIRw9b8V4d/WXJa8t/fzhKJKX9Vnwib4pCLUwQ
	 A9eza9NUu3TSVfiyY3oTsmZqe5HInOb8wE26WVbkhyRESp8Z3MjP4vOPGRFfR6Oxrig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M3OB8ZWbXgFCJVbbMauZKmrHF6KBsWju4Wi0aJE+YVM=;
	b=sCCH9TixzdvbDsMAfpnMf7zKG0Yd01TZtGJa+9WzddT/XTi7We/0KaJZrop5Uvnm5giL
	 5iQCccFX0UldPd6DPfOrw30uZNBTlP1enIlSVi18fy+Mx/pafkqwO+dgZP9AiWff7+L3O
	 4/3wycddXU0joyZWqIiqlK2od1AXkI0Lz9kdn2PbsuQxYvWNCQZznjSPdfaay40ga3goj
	 ysuYJI2l7rKgy3FokuTMjGS+r3ubcZa1CMSCL8KoPi+ruveA6C8KI2jOKAMtsbmCeRIf1
	 VpcRUlDCm/acrsPX3MwSRXjqz2IegrxSwgq8HbojMlCHVYcRh7MJbGES+Ha2A68+DaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psvl9Yug;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9423460A2612;
	Wed, 18 Nov 2026 17:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=psvl9Yug
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2871F000CC;
	Wed, 18 Nov 2026 17:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021586;
	bh=M3OB8ZWbXgFCJVbbMauZKmrHF6KBsWju4Wi0aJE+YVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=psvl9Yug8CxVgMPfCBdtA4vTjsJ35+opu5Lwx8N+wN84P0sWFOHiR5DnvzEP0DyRG
	 s7FBEwjEWTzNoRGaH95jDQgkwyrCQBcLDvKg6k2ux33tXzuOSrH5MKSMTXJGfGiAjq
	 ILc0F0sNR6IAvI2TL3LFwoy0KD6QRlnjIqRWgYwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2358/2651] signal: skip blocked signals in dequeue_synchronous_signal()
Date: Wed, 18 Nov 2026 15:59:58 +0100
Message-ID: <20261118150410.455275669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index 6e3950939acbb..f13be2963332c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -684,12 +684,13 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
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



