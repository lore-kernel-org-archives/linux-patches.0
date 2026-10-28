Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208081;
	b=Q7LARviw479S6yIDu+XgHGQklI2CAypvWBxISpSLzpmUatuBswGH7cMOdB+86yI+kzXL
	 rpq30SXjYGfsrCvbLs6/jnxWsp1OpzNOKE7TSdS2PqmKc7mxU2rntGfGXgpoY05V/D+F5
	 EXm2RdXf+Y2cJ2Adh6PNhxjUyaziIiAUfUCCbzQQreYMUDCvGO8zCK+IeiZf+JSKVg9x7
	 vsYMzPRh1M5gc3wLv4Mp5uflEXUdwxAhCe1zSKmxSDu7e9f+1X2gHSB6RwXUdHak+kTW/
	 k23yl0JrDTjSAa63ng54N8pAUri5SYQHpwdWAKzavatMpqri4YhvgqOxo1yICpZV0tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AT/CmF3w1EWWuPTsR3Uvco0sQsgreB2nPgHY0dHXIb0=;
	b=muR4cnuGDqx16qUIP6rSNEKnwAWP5VYFDhGhCSrMU9pp4tLcsT9/z1xXwZnVsq8mIToG
	 MsXKJHnzSBdkfEiDEYs9dWjQCi1u9V3C/65Zk0S3LvQhNjar5ddmKT4zG0CGx66y+TA3X
	 2OTszc9EQfiHpj2mPs1Ll5l8sb5aZyQnQnF9VNCHqehdeCJWqJMd3pQ39Z84zxUsJ+5Gd
	 cmCHHd/CRGVxloQAxgZeOn3R6O+wNhfiIDEIsWfHmY0WZTdZm2yesC+Az25rwa9FDWeoU
	 yuRVGXxarMv2j6nIXmJXdrNEMWMR/u9Htl9aXaQyhG98sYhW27+Xt0kMS0/4ADzkMfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upGLnL61;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A818606A31A;
	Wed, 28 Oct 2026 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=upGLnL61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336781F01825;
	Wed, 28 Oct 2026 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208080;
	bh=AT/CmF3w1EWWuPTsR3Uvco0sQsgreB2nPgHY0dHXIb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=upGLnL614DuELZU25AXqR1am1E6eUtHIlLQjC4mNoeTXrOBuHfwKu7p2vAgX3p8yG
	 IaejAlVWmiGK3RE+lPjnu2+rXAI/VLIzv2zGwSWrXPwDmuHUB/cTufcVdaRux/CPS5
	 /e42J/8/qX/Nv9w7AhXcJ9t4oi6TOdOfrFiN1LAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.12 242/247] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:00:45 +0100
Message-ID: <20261028165953.153235970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

commit c0e659511d4f49087da095a95799edb5b775a705 upstream.

If the calling thread has blocked a signal then
retarget_shared_pending() slingshots a shared pending signal to a
sibling thread. Today it only skips PF_EXITING threads but not a
coredumping thread.

But if SIGNAL_GROUP_EXIT is set no thread in the thread-group can
dequeue such signals anymore as get_signal() sends SIGKILL to every
thread and prepare_signal() drops any other signal.

exit_signals() also returns early on SIGNAL_GROUP_EXIT. But neither
sigprocmask() nor the mask restore in sigtimedwait() do.

Say a thread sleeps in sigtimedwait() and a sibling thread crashes. The
sleeping thread gets woken by the zap call. It restores its mask on the
way out and retargets a signal that was queued for the coredumping
process. That means TIF_SIGPENDING is set on the coredumping task which
zap_threads() had cleared. So a blocking write sees TIF_SIGPENDING and
truncates the dump.

Stop retargeting signals when SIGNAL_GROUP_EXIT is set and avoid
needlessly truncating coredumps.

Fixes: e6fa16ab9c1e ("signal: sigprocmask() should do retarget_shared_pending()")
Cc: stable@vger.kernel.org
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20260921-work-coredump-fixes-v3-5-8e4adb1619e6@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/signal.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2999,6 +2999,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


