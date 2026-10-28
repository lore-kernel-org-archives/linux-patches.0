Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210352;
	b=vT07jZrEVpILQTuY6B2Szbmb+AucWVxeVgMddP2c7DISSLKy100JFLVakywbZzGs17JH
	 G6/KS2BN280kh3yO+6782lIg/YyIUh5Ms0BtpwW22Uh0/I+JT7z4ZxS2316suiTJhUo3J
	 seJ1HCdPniP9QsheJkMa88BuewRiDm9lsOTgeCHjjX6BpIGG5+DBfo715wZtiorfpJcf5
	 VJRMma1x3HqX30KLoSOrMVIScQEv5VKr8uby62Rttxugb/+uKwV48shyLM616z2dovuKF
	 hCVFyNv65jdei5t6Xdc2mSzC7afFTVpP1DZZY7Sl791pISW4s7rKWQGY0gPSYLwNwPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fbcCSzOWE+4tI0bZAZufQrjOSQPuCnZ6j7NNdfoIhkM=;
	b=nEHquv+T1KM7CY7zGZNS1zVS3u5Vz4lDs9AAxZ8EwWnKor2PLrbnYDjtPpR5icWjSk1P
	 i4WJmRinXPqm7LEBJ6bqWkxKHMgZ2YeI6Jm0wqo2zR0GhZCP2M/RRj0EHjEY/hQF3F/2z
	 Kk7pshreLkyyZ+euRgHov7kjhqX+wPjx66ib7YvuG91jvZyh5KU1VC3OV/XM6kZCM3U+r
	 Ry69S0hC0ki/4fduRHM5tNVtm9hbW+7/OwHdrXwKK3IidyHhgq5suhmEAI+BvGCxYyocQ
	 FBzlOMIgZQrSDPdja0EnTkHxKsrexCcnRTZNd+Es4ACWi91+syt6dzEKp6qnMWn7Q7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJLfgMWQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 423E1606A330;
	Wed, 28 Oct 2026 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nJLfgMWQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BBF1F01825;
	Wed, 28 Oct 2026 17:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210352;
	bh=fbcCSzOWE+4tI0bZAZufQrjOSQPuCnZ6j7NNdfoIhkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJLfgMWQe8esoV4rRxkirqdf8R+n+CpVNwcWpgzA7xwDY5iLpCtlmkgHsTXT2qYJC
	 bnNBbFGTWLDzV2BoN2ETzdfzNEKuKc0aN3Tpo7a3cW1tglUv9lIOrux57jNGWFgToV
	 7toBVcI6KKDBB+X5wUkkio61CK9p4yjfFAwUiYLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 165/168] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:01:41 +0100
Message-ID: <20261028165946.993451002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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
@@ -2985,6 +2985,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


