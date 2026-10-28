Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209586;
	b=3n/U2dYoFRovBxnG+aZ7HZ47iTOymULJvho81VNgoQGSI8uNqQlynz8jGUpspmik/uO+
	 F8mtBp27zPHkraNrckLHaLbAlV96IwziIvkb4DumGn2lkHLXwoiHXzgoytwppQcejAtlH
	 D9/Xzrbu25uGbxl8082/lvl4vwtgUQOlJOPLeoAHYQ0wbwrC+QqX7ebB7kqPEY9gNQHdE
	 2Rpe2EX2F3YZKimfTjODqQuIYeKNU7YHJ0ST0AxCAuhcM34GjkwRU6sUxlAF9H5hsS3bW
	 M9JSJqHZoK1MwpehHDFQgs6ln0xiVF7wBhf8sMggZ4zA13pmVnRCPANFW5cc23qei6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ELEXb1AQczi3BlxvZHTmfAMABbzrbdz9d8diuRQ3Il4=;
	b=TdW2GY563KpnWBCHnLXhYeY4XPPgH34VzSpZVpy0Cnyy/tiWON0g1hMK80tWEXCSgyIF
	 mP8MJ5w7ngqfn86+HjxMXPW1EYbPfOwcDd4jSTDbgMfRBeCUyLOWM1VUh0iOs1DAVGqcv
	 mJ27MfVXU43By0IudDeKaXiJfteC26utaAiwPHNe4Y2/fDaZypxrkLArXqwBwLNEGR9ML
	 ssWIy5m7Dyf09wGNu9mewlW7AmNCKclKHDkTNZoPKFuCzwhgENYXuH9E1eLAKfbwOO056
	 gJgiHlg3SokHfCD4OtUHzyUcQ5/a+OC37tUest6pWCxxB6TZY8z+gG1iF+UAaL5pkGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5WwaXXq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA92606A31A;
	Wed, 28 Oct 2026 17:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e5WwaXXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF7E1F01825;
	Wed, 28 Oct 2026 17:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209585;
	bh=ELEXb1AQczi3BlxvZHTmfAMABbzrbdz9d8diuRQ3Il4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e5WwaXXqhNCVh2vVdY+iSY53RvSXlzLzjiNBihecsT+29BouGxeq7WcU8Kxb14aea
	 pMj6OusyN+3j5bnlG54LIJ9nhYf739U99EyR3NoHYeHOkW78euKM4FmDZ6SN8X1DvJ
	 BaIAyXEW55ah3dk/fStVMo8ZJuo2EL5xX8To43co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 516/516] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:01:08 +0100
Message-ID: <20261028170015.699648478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
@@ -2830,6 +2830,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


