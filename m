Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6653E5ED6;
	Tue, 17 Mar 2026 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766194; cv=none; b=YaRsUdprmXsstlhmrdz7IAfoW0/WMY93W9PU9QAEzVys0R1Rk2DPxKVvfF6kYVuo5Ja5G1ndpZC7sABsezpTqGDjfLy+XYqGF21gtx/fn3nVE5Vt8HsZjggGAQQbfnuMyuV1/QcTHKmDYjR4seT/XqPs5dT52yXGQmpeJ/HAFzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766194; c=relaxed/simple;
	bh=6zcBuNPPg/qPZGMi35GJGNhwQO7aMJ35JqScTu7CEzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jL/1zKn6RPR3Jv3t867Yn6RySh3RPbkOygB7UWYTlUPSaWTBzPR0PF1eYfF4BOtx46bg7VXXy7ybkF6QfTkirBwlLjMQB0kKPxckKS9b7PYiiSPvZpJ/z6a5gGe7kn8W8qs5zbWH5i/pCSk6WbTNk9+ez9I35HPjv7HW0zkJc0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H1mh94bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H1mh94bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0895CC4CEF7;
	Tue, 17 Mar 2026 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766194;
	bh=6zcBuNPPg/qPZGMi35GJGNhwQO7aMJ35JqScTu7CEzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1mh94bRSmlChQOxm09qv1Z5irne+WAkYD5ncrves3MvIwnlrGNz02VYFvWx23AMG
	 F5ztKHJz+zLiYu5q57HyJ0VG6Fo0che+psiRaS0fvz+8PawGaBvPD2Q5o0HgOWaTgn
	 54AYfASRoWOn2e/srWuj8NGYLbNu45zAAumV83No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Qiao Zhao <qzhao@redhat.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 190/378] powerpc, perf: Check that current->mm is alive before getting user callchain
Date: Tue, 17 Mar 2026 17:32:27 +0100
Message-ID: <20260317163013.997557153@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit e9bbfb4bfa86c6b5515b868d6982ac60505d7e39 ]

It may happen that mm is already released, which leads to kernel panic.
This adds the NULL check for current->mm, similarly to
commit 20afc60f892d ("x86, perf: Check that current->mm is alive before getting user callchain").

I was getting this panic when running a profiling BPF program
(profile.py from bcc-tools):

    [26215.051935] Kernel attempted to read user page (588) - exploit attempt? (uid: 0)
    [26215.051950] BUG: Kernel NULL pointer dereference on read at 0x00000588
    [26215.051952] Faulting instruction address: 0xc00000000020fac0
    [26215.051957] Oops: Kernel access of bad area, sig: 11 [#1]
    [...]
    [26215.052049] Call Trace:
    [26215.052050] [c000000061da6d30] [c00000000020fc10] perf_callchain_user_64+0x2d0/0x490 (unreliable)
    [26215.052054] [c000000061da6dc0] [c00000000020f92c] perf_callchain_user+0x1c/0x30
    [26215.052057] [c000000061da6de0] [c0000000005ab2a0] get_perf_callchain+0x100/0x360
    [26215.052063] [c000000061da6e70] [c000000000573bc8] bpf_get_stackid+0x88/0xf0
    [26215.052067] [c000000061da6ea0] [c008000000042258] bpf_prog_16d4ab9ab662f669_do_perf_event+0xf8/0x274
    [...]

In addition, move storing the top-level stack entry to generic
perf_callchain_user to make sure the top-evel entry is always captured,
even if current->mm is NULL.

Fixes: 20002ded4d93 ("perf_counter: powerpc: Add callchain support")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Tested-by: Qiao Zhao <qzhao@redhat.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Reviewed-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
[Maddy: fixed message to avoid checkpatch format style error]
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260309144045.169427-1-vmalik@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/perf/callchain.c    | 5 +++++
 arch/powerpc/perf/callchain_32.c | 1 -
 arch/powerpc/perf/callchain_64.c | 1 -
 3 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/perf/callchain.c b/arch/powerpc/perf/callchain.c
index 26aa26482c9ac..992cc5c982144 100644
--- a/arch/powerpc/perf/callchain.c
+++ b/arch/powerpc/perf/callchain.c
@@ -103,6 +103,11 @@ perf_callchain_kernel(struct perf_callchain_entry_ctx *entry, struct pt_regs *re
 void
 perf_callchain_user(struct perf_callchain_entry_ctx *entry, struct pt_regs *regs)
 {
+	perf_callchain_store(entry, perf_arch_instruction_pointer(regs));
+
+	if (!current->mm)
+		return;
+
 	if (!is_32bit_task())
 		perf_callchain_user_64(entry, regs);
 	else
diff --git a/arch/powerpc/perf/callchain_32.c b/arch/powerpc/perf/callchain_32.c
index ddcc2d8aa64a5..0de21c5d272c2 100644
--- a/arch/powerpc/perf/callchain_32.c
+++ b/arch/powerpc/perf/callchain_32.c
@@ -142,7 +142,6 @@ void perf_callchain_user_32(struct perf_callchain_entry_ctx *entry,
 	next_ip = perf_arch_instruction_pointer(regs);
 	lr = regs->link;
 	sp = regs->gpr[1];
-	perf_callchain_store(entry, next_ip);
 
 	while (entry->nr < entry->max_stack) {
 		fp = (unsigned int __user *) (unsigned long) sp;
diff --git a/arch/powerpc/perf/callchain_64.c b/arch/powerpc/perf/callchain_64.c
index 115d1c105e8a8..30fb61c5f0cb0 100644
--- a/arch/powerpc/perf/callchain_64.c
+++ b/arch/powerpc/perf/callchain_64.c
@@ -77,7 +77,6 @@ void perf_callchain_user_64(struct perf_callchain_entry_ctx *entry,
 	next_ip = perf_arch_instruction_pointer(regs);
 	lr = regs->link;
 	sp = regs->gpr[1];
-	perf_callchain_store(entry, next_ip);
 
 	while (entry->nr < entry->max_stack) {
 		fp = (unsigned long __user *) sp;
-- 
2.51.0



