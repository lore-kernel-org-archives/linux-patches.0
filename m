Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209860;
	b=uuMlC6X1C3k+WouYfYgXbCzapFFh6Ku2IkD6zQXXr4r0t5jmE7e9ylQBJcta7gLYBXkJ
	 wP+2Jf+H7jT/YpFHHrOtcheMexCI7vWF962FQG4kWbyv6F4yd4YUBi2hI+soGLgwzjNAY
	 CKtjgoW4uK891KSs0MhwKKjvUXQbGKu+gwCHF61/aHJbM6zyeXYLxloyZuvrgIWL6TRY7
	 fg0nltXvoEwH01YZDjUQSeGh/4QbCvB0AtXwTmnB9oPi8+sdVrb/hmDE/3OrVMRmOOPL0
	 5o8xe+sQcg+8ZbNMkx9v8qjSSHGN+egJzd13JNB0Jie7tA6WWX8UHnGfkxN/vjv5Dlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HZYF2x87JV27cQWcNZVUwTWk+72ITmF+64eDZU8nLDY=;
	b=kCavWx/s2HynzpRFNnszi5X/13dagfzRBSneEN7VktDwoeWUP4/Sejkwenv0ToEfsTC1
	 YWAsZZ1Yf6xyA+iYU9yVFov6+KD/2rxnskiMLrTweVPOT9Plhq3337a86s95JOFJLxIP+
	 Mvr794tSEU+zRYFP7kWnGpZynTqKAOOlMwEO6T3uQrvCB2iRlsb/IWqUIngxH0jqu0q5A
	 qxmuzZYIC/rNjM9QzSEAb+hMA1djfxDf+GzZAqIsEKoqvhe5EHygfftykmgkC/O7jgoUg
	 JHhN9yT4O85W1m23wWWNRSshR4XABB1EpWuhhe7/TSWdAZTj0TN25OJxx+OZ/NPWSBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0N1S+0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A4C606A31D;
	Wed, 28 Oct 2026 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c0N1S+0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163061F01825;
	Wed, 28 Oct 2026 17:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209859;
	bh=HZYF2x87JV27cQWcNZVUwTWk+72ITmF+64eDZU8nLDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c0N1S+0P2wTRrWDCOlT6xcE72w9uGMjUTKwfdxS3EHIGkz1DLxUAtOqDoDfZVsyiJ
	 0bdg8Uho3XdrG8pMcV7TbdTOOBlCGu5ULMrST4c94Ntx5wM02jyVkCD8Byf+9ePF24
	 a4hBCQIkKOpQ55FGcgUxF2RPbwf2rEDdQmwslK3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 103/109] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:01:27 +0100
Message-ID: <20261028165944.780504280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -3178,6 +3178,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


