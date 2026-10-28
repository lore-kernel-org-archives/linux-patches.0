Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211986;
	b=HSYEq18RSSh14Fx5JrQr/MoUATrKirIarehuE8IuAFghOfBVWxxn1Q07WTWBx0REXHUA
	 XpiWhu65iJ3b41+ZHRLrMwLUjhop+k0DU4M0luihhm72rTJjP5mdlg50T3nn6xUOJB4un
	 tFdwzealPxluYVsqCND6dHJBDB1r//Octl9v9oMqcFO59lmxlYYwpPi4EHRNyL+ELbS58
	 rNtNZqpCu5+RQJSHUlu+9niFdqJz5eQE0cSgVEnjpCBTJXGMoT+TxLuPLsk0HeoCTmRZM
	 P0WD1D5IeiPywSmjmgHfD/+aiWDF6+w0E2QxsV+Ynba3TaF8lB4Nzhk2MPs9wpQZalA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211986;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0gJ63TWbbRb2gkJ4OLNgPhJRdl5/esQcqi60/g55Hps=;
	b=tqfyBg5/IrR7U/5oIq0lhWNnPMbGY7OmuG+ADNXlQ5zTm2WvC4LHogMK0uQQdWp1i7oV
	 +xgjBcv7perMIlSRinQzQBC2rg5nqLKClI9CnbBD148d+LUC92UeTCCDzYl0JOejIkvy5
	 mhFFvNRp05wA3cvVVTv9kZSOiNpOYLTjTYXEvFRVE0aSrcbOFJYLI20IYx/MNo/9k8aCQ
	 U8mh5FTCg7Su+3gwU3CRne1Avq4uGtaGhXafZNZCCN6UFAjZxcADc/+rPbUAephnMIJHj
	 5mcChEwj/hOXjga5PaWlG45Gv1d5PTAY436evTfswMpLas4JFsG0SCtncliK/HKKDsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLCpSfTA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE506606A31C;
	Wed, 28 Oct 2026 18:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eLCpSfTA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F041F01825;
	Wed, 28 Oct 2026 18:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211985;
	bh=0gJ63TWbbRb2gkJ4OLNgPhJRdl5/esQcqi60/g55Hps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLCpSfTAbaWLLybE4FmBV+6fHbZGxoXAH7BE2nuu1JqFOdYXn9IYHNHItjEEHlDXq
	 ZgOi+pGuR2JNpvrk1ueKsLySCYTGWCtC1wRXxo5J0dOU3gTQyZi/Q6UH9F2rqCOeF4
	 FJjC3Z85iyxszVih8mm3/ev47Tn0qYq5qTeQWFbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.15 571/571] signal: dont retarget shared signals in a dying thread group
Date: Wed, 28 Oct 2026 18:01:58 +0100
Message-ID: <20261028170021.590532093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
@@ -2974,6 +2974,10 @@ static void retarget_shared_pending(stru
 	sigset_t retarget;
 	struct task_struct *t;
 
+	/* Nobody dequeues them in a dying group, see get_signal(). */
+	if (tsk->signal->flags & SIGNAL_GROUP_EXIT)
+		return;
+
 	sigandsets(&retarget, &tsk->signal->shared_pending.signal, which);
 	if (sigisemptyset(&retarget))
 		return;


