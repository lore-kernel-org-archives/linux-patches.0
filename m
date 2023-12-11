Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C80E548;
	Mon, 11 Dec 2023 18:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnT7ktNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B6C433CA;
	Mon, 11 Dec 2023 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321006;
	bh=C2DZoFI4IFogLdyYDiZObNY5phOb8zSTU7CAJR3TJ/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnT7ktNWopSXf8OUweKq7EU664/mhPA1FtpsP1H/ck2KbDO4xhoVCgT20U06p+/of
	 UF+nN0TNW8PL36WJstU+XfOoo36ki092QazT/YKsIRP3Q69T+RjXcQNbNj+ODMz4Oo
	 zg/8ay76JAgTDuInYzvPpr+O83D28sJjhiJcwqHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	JP Kobryn <inwardvessel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 076/141] kprobes: consistent rcu api usage for kretprobe holder
Date: Mon, 11 Dec 2023 19:22:15 +0100
Message-ID: <20231211182029.869706890@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: JP Kobryn <inwardvessel@gmail.com>

commit d839a656d0f3caca9f96e9bf912fd394ac6a11bc upstream.

It seems that the pointer-to-kretprobe "rp" within the kretprobe_holder is
RCU-managed, based on the (non-rethook) implementation of get_kretprobe().
The thought behind this patch is to make use of the RCU API where possible
when accessing this pointer so that the needed barriers are always in place
and to self-document the code.

The __rcu annotation to "rp" allows for sparse RCU checking. Plain writes
done to the "rp" pointer are changed to make use of the RCU macro for
assignment. For the single read, the implementation of get_kretprobe()
is simplified by making use of an RCU macro which accomplishes the same,
but note that the log warning text will be more generic.

I did find that there is a difference in assembly generated between the
usage of the RCU macros vs without. For example, on arm64, when using
rcu_assign_pointer(), the corresponding store instruction is a
store-release (STLR) which has an implicit barrier. When normal assignment
is done, a regular store (STR) is found. In the macro case, this seems to
be a result of rcu_assign_pointer() using smp_store_release() when the
value to write is not NULL.

Link: https://lore.kernel.org/all/20231122132058.3359-1-inwardvessel@gmail.com/

Fixes: d741bf41d7c7 ("kprobes: Remove kretprobe hash")
Cc: stable@vger.kernel.org
Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kprobes.h |    7 ++-----
 kernel/kprobes.c        |    4 ++--
 2 files changed, 4 insertions(+), 7 deletions(-)

--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -139,7 +139,7 @@ static inline int kprobe_ftrace(struct k
  *
  */
 struct kretprobe_holder {
-	struct kretprobe	*rp;
+	struct kretprobe __rcu *rp;
 	refcount_t		ref;
 };
 
@@ -224,10 +224,7 @@ unsigned long kretprobe_trampoline_handl
 
 static nokprobe_inline struct kretprobe *get_kretprobe(struct kretprobe_instance *ri)
 {
-	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
-		"Kretprobe is accessed from instance under preemptive context");
-
-	return READ_ONCE(ri->rph->rp);
+	return rcu_dereference_check(ri->rph->rp, rcu_read_lock_any_held());
 }
 
 #else /* CONFIG_KRETPROBES */
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2044,7 +2044,7 @@ int register_kretprobe(struct kretprobe
 	if (!rp->rph)
 		return -ENOMEM;
 
-	rp->rph->rp = rp;
+	rcu_assign_pointer(rp->rph->rp, rp);
 	for (i = 0; i < rp->maxactive; i++) {
 		inst = kzalloc(sizeof(struct kretprobe_instance) +
 			       rp->data_size, GFP_KERNEL);
@@ -2101,7 +2101,7 @@ void unregister_kretprobes(struct kretpr
 	for (i = 0; i < num; i++) {
 		if (__unregister_kprobe_top(&rps[i]->kp) < 0)
 			rps[i]->kp.addr = NULL;
-		rps[i]->rph->rp = NULL;
+		rcu_assign_pointer(rps[i]->rph->rp, NULL);
 	}
 	mutex_unlock(&kprobe_mutex);
 


