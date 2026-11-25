Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622812;
	b=vKYUPsl5S7U6WKk+RPEG+9Cy6qMQjkjuoIHowx8ewkbVOfRqGwnqYHeONZJtAmdhbFbb
	 d+O0gwrfV0VTMwtX+xMdYoGK/5SYLpNhSrjLXTkK/DFGy+MJrK64vzOhzGk0bIxZKns//
	 Jwgd/V4U19YK9G+zy2GqIordHcoBgC2n28ehFeKuDoXfWBRJJPN1w8gpfgFeQM2vlZus0
	 +cElFffgXQSpGmzUCfpMB2OD2s4p/PRQVnIjpZ/rEMyQ5xKB21OyQ7XTnVJC77i3sbhr/
	 RMgASzU4Z8+DAZ7M6VmGyttnDWDkBAA3H+E2niobHsw+5xb5N2xDAWP/zpvOWpoWKuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622812;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UaEhO7t0wzi/YsF5M5T0z061sDWW5d/psE7igaawb6U=;
	b=4KsLPrpn7fTdNi67EXrXNmCNXxp9tTkDfGxbDJ3c/EwwjnG29EAG9eCHSzgGbITD/G/3
	 4qRaIuRgH3byhTbzLx1cYqs+eJgqQoZXDdObcNwEDX+mVXKNmQbzWo43VSYHlLNxU2V22
	 qzRLkLseKpxNskRoY7Om4si0wgVSEx4YZ8BDlApJxJXjlsJ9JP18ZM65f0zTY6xRY8Lx9
	 C1Q3W8YBeX2tKBf3lSF7wGwU+zQXrrYqn4e1qWOTuORvmYhzT7pjFzyNrrMFSB1awz9/7
	 KlaYM4SEqSBqcW2aZxpjfRvtfMYN3IEtiXN/DCMtdT3Z+h2dewuISxEor/oFpjdkRkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUBIyiFY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC68606A321;
	Wed, 25 Nov 2026 16:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vUBIyiFY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49C41F000C6;
	Wed, 25 Nov 2026 16:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622812;
	bh=UaEhO7t0wzi/YsF5M5T0z061sDWW5d/psE7igaawb6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vUBIyiFYZcdapKqq4EzXnc3AGbOxputEn+JZ46+C1bwB3b+L2IlTCqtAEyLjbAyXw
	 jGlcudnrXfcIbmEvSPYtBHULZJjRaIBARvJqLP9coc8U/nMYp9fPFVsfviHQgj8+Po
	 Yq/u86IWyspWeRykUVKX30YIPLvW48BaYqv3KJzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 658/990] kprobes: Fix double free and NULL deref in unregister_kretprobes()
Date: Wed, 25 Nov 2026 15:33:45 +0100
Message-ID: <20261125143837.502924121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
@@ -2290,8 +2290,10 @@ void unregister_kretprobes(struct kretpr
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
@@ -2303,7 +2305,9 @@ void unregister_kretprobes(struct kretpr
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


