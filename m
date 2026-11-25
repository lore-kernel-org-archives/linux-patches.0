Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619369;
	b=1oHgGmsWQw8L/4iRe3L61LAjM8mkYSGshuH+/1rPh3nhkhH+StneRNi8lzFVMzZGldxB
	 Tyz6px6WGI3HjEnJj+1EpBJPMUqrseUhivUQdR1hyoS8IElkVyhJoshYYdxkp/HILod4F
	 iOgM7LvmpQd+dp9zAXOUaMsPdrYhbjyWAELEKsmU6O9q6XauuNaqkoBWntws9/S7pU7mI
	 sQpIfxhwtP5ORCcHV6daUN/A9JeZJ3IafboOh39br97wgHinHUBVl5tVCnW5nWHBduuhp
	 EQTPRZHfI9U8ik2JOC0T3lY9+IQHEJmhnmzw6ThGzYi1SK3PR2zKz/zErZXNvxkx1Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HpMA2TTypCl+j2hfIkylWidIzPSxJU6cckrIziEae2g=;
	b=ARk1awJhCf8/oRjYPJHcIDs/gWi4e9pZCS1mJ9xsJsQTugPWiqNnye7TIsdJikwJOjUa
	 UqtvVX2kt6WShdIUKcTXDyqnS3+qqT+8iIdVMxZciJBJg4MqvfpjL4fPq2HYRMEtxDx7R
	 NvqAS6PawK6HggxZj0059E/+AmKzsr8AlnI72Ui0Tvxt+gkCPoG7o8tFXq82XxstSHeCJ
	 9rN2Y21LNi5F5OuXukumQGHSCd3jTXmLCf9kRcht4PXXouz81yer8V2KRywLqS8W/tyk7
	 0gD/mBMLQyI5RLzGNG6CB9V5nJp98j7pZ+N+tsQ61tAFQh13WmXvsvN583r5kKcXxqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYNgrLn4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E664A606A323;
	Wed, 25 Nov 2026 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nYNgrLn4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6B71F000CA;
	Wed, 25 Nov 2026 15:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619368;
	bh=HpMA2TTypCl+j2hfIkylWidIzPSxJU6cckrIziEae2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYNgrLn4NHs0mYeqHE2qq3FcB16bjGjoKmfRSXDJG+Hl6ku8k8xC4Bon9ULmlSQRY
	 bLRutx6iSiXha6mCEou8RY83xlT2Drimw54+sJksKVZyY1dB8TWryWtOsx0aJmV/SP
	 0mAD3MtSfDAOmUsIV4yD9lJBVhX4GFpffwqdwyno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0574/1005] kprobes: Fix double free and NULL deref in unregister_kretprobes()
Date: Wed, 25 Nov 2026 15:31:52 +0100
Message-ID: <20261125143835.195146714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 2053bac1d6e47b33fa2e570c87518395e64f7da0 upstream.

In unregister_kretprobes(), if __unregister_kprobe_top() returns an error
(e.g., if the kretprobe was not registered or was already unregistered),
rethook_free(rps[i]->rh) or rcu_assign_pointer(rps[i]->rph->rp, NULL) is
still executed. For rethook-based kretprobes, calling rethook_free() on an
already-freed rethook causes a double-free / list corruption in RCU. For
legacy kretprobes, rps[i]->rph is NULL after previous cleanup, resulting
in a NULL pointer dereference.

Skip rethook_free() and rph cleanup if __unregister_kprobe_top() fails,
and clear rps[i]->rh after synchronize_rcu() has waited for in-flight
pre_handler_kretprobe() invocations to complete.

Link: https://lore.kernel.org/all/179375031660.247640.6349602689169856649.stgit@devnote2/

Fixes: 73f9b911faa7 ("kprobes: Use rethook for kretprobe if possible")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2370,8 +2370,10 @@ void unregister_kretprobes(struct kretpr
 	for (i = 0; i < num; i++) {
 		guard(mutex)(&kprobe_mutex);
 
-		if (__unregister_kprobe_top(&rps[i]->kp) < 0)
+		if (__unregister_kprobe_top(&rps[i]->kp) < 0) {
 			rps[i]->kp.addr = NULL;
+			continue;
+		}
 #ifdef CONFIG_KRETPROBE_ON_RETHOOK
 		rethook_free(rps[i]->rh);
 #else
@@ -2383,7 +2385,9 @@ void unregister_kretprobes(struct kretpr
 	for (i = 0; i < num; i++) {
 		if (rps[i]->kp.addr) {
 			__unregister_kprobe_bottom(&rps[i]->kp);
-#ifndef CONFIG_KRETPROBE_ON_RETHOOK
+#ifdef CONFIG_KRETPROBE_ON_RETHOOK
+			rps[i]->rh = NULL;
+#else
 			free_rp_inst(rps[i]);
 #endif
 		}


