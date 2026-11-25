Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621861;
	b=fckFxrDp5EtPnhXW5FLFNXmv5+lERkCiIrk7Bi/tBXxjuoOdczmEc6f6iBxBoMjq3Xgi
	 PNFJCx6bNkMZEwLQibrRcS4u4Pphs0iMxxGRtHwjlp//bS2jFgcei2G0AU0+Q1FzEUIXp
	 CmTI/pQrqlcwNzcOoDFnLVHE5OXrl2sMc8hxW+cUibHkz7s1iL54L8KE4e8WDwntup0yt
	 UfsuGKPfU5cQWrtIvR1GvyPjQYTEw8ig6ZNI91Dn69oMuLlnFWcHAlfomHyO5w0Vnprya
	 f/HRdhGzgEgw3Hm6fbce/8iVywzVata1HOlRvIXpOwh+XOXSjMsdP8mnotpXb8nkUKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFCp+56scIQ0knbZh2o8d70z8M2jQ+v6rG1RU0CKrAM=;
	b=ZpRQVlFWxkbybD45bK2slLHgOhpCNNRUEKbPxgs1Wd89z9HReFhHS7odAFzYFcwB1Ltz
	 icc+RIxOVG2UMl5bRAaJ9ZNKkTaVOTTVgs6louJZxo9hVAOmD8UHvMKRsh5k6gexccAzJ
	 ngt//nPFyngfl/FQ96JAYYxQjGWPoItBvIXt6gT19NVL8ymhzJXqUEZ29Z2VQYNLIyvy9
	 AHVsT8eAaNcLkRr7jtCuIudgMRUg3HG3WmMFKbibwu0MavMlJkhK9UqCjHfsqeHSYjzca
	 N0DAwfsAR9bxCUlrGn/IuZRh6suIO7woSSbjrQ6zd8qolufxb9V2F/mRraFZ1rZTPtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lelePx7e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE9606A31E;
	Wed, 25 Nov 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lelePx7e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1681F000CF;
	Wed, 25 Nov 2026 15:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621860;
	bh=xFCp+56scIQ0knbZh2o8d70z8M2jQ+v6rG1RU0CKrAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lelePx7enh2HDrbGtgQM8zpInCXIRto+5gyNWdYgF9Hd7C2tu4BvKRuVUpacCqMfe
	 8Iq7596lQX63Raca846BlJ4OlWBVn6fb3W9fScFJXTQCqdYRiFsin/I1B7oR58V6qL
	 ktNVi3vSIZ774jPvH4ASlolqVRa1J6uE4og7YlZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gennady Kupava <gennady.kupava@gmail.com>,
	Jayapal Ashwin Nair <janair@amd.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 312/990] perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR
Date: Wed, 25 Nov 2026 15:27:59 +0100
Message-ID: <20261125143829.399188124@linuxfoundation.org>
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

From: Ravi Bangoria <ravi.bangoria@amd.com>

[ Upstream commit b61c12527223423ab66891b2e8131da0d66537c4 ]

IBS hardware captures a sample and raises an NMI. Since the NMI can be
delivered with a delay, a privilege change may occur between sample
capture and NMI delivery. Because IBS only provides the sample RIP, the
kernel records GPRs from the NMI pt_regs, which may reflect kernel mode
if a privilege switch occurred in the interim. This can leak kernel
addresses to unprivileged users through PERF_SAMPLE_REGS_USER and/or
PERF_SAMPLE_REGS_INTR.

Fix this by using interrupt regs while preparing PERF_SAMPLE_REGS_USER
and PERF_SAMPLE_REGS_INTR. With the change, when IBS samples a user mode
instruction but the NMI is delivered in kernel mode, PERF_SAMPLE_REGS_USER
will source its register state from task_pt_regs(current) and
PERF_SAMPLE_REGS_INTR will be omitted from the data sent to userspace.

In addition to fixing the kernel address leak, this change also ensures
GPR snapshot consistency, which resolves the DWARF unwinding issue with
IBS.

Closes: https://lore.kernel.org/r/CAPu-DQqF0aF6=GS8Z6KKWeeX_V5LiXeKU_rJQZC+uGg8zuTPNw@mail.gmail.com
Fixes: d29e744c7167 ("perf/x86: Relax privilege filter restriction on AMD IBS")
Reported-by: Gennady Kupava <gennady.kupava@gmail.com>
Reported-by: Jayapal Ashwin Nair <janair@amd.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20261026041838.941-3-ravi.bangoria@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/ibs.c  | 50 ++++++++++++++++++++++++++++++++++++++
 include/linux/perf_event.h |  6 +++++
 kernel/events/core.c       | 10 ++++----
 3 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/arch/x86/events/amd/ibs.c b/arch/x86/events/amd/ibs.c
index 23d834e7b565e..d57b34a72dddf 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1339,6 +1339,56 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 		throttle = perf_event_account_interrupt(event);
 		goto out;
 	}
+
+	/*
+	 * IBS captured RIP is out of sync with NMI pt_regs due to NMI
+	 * delivery latency. Use NMI pt_regs for PERF_SAMPLE_REGS_USER.
+	 *
+	 * Note: Valid user regs are required for PERF_SAMPLE_STACK_USER.
+	 */
+	if (event->attr.sample_type & (PERF_SAMPLE_REGS_USER |
+				       PERF_SAMPLE_STACK_USER)) {
+		perf_sample_regs_user(&data.regs_user, iregs);
+
+		/*
+		 * Don't update dyn_size if user has not requested for
+		 * PERF_SAMPLE_REGS_USER.
+		 */
+		if (event->attr.sample_type & PERF_SAMPLE_REGS_USER) {
+			/* regs dump ABI info */
+			int size = sizeof(u64);
+
+			if (data.regs_user.regs) {
+				u64 mask = event->attr.sample_regs_user;
+				size += hweight64(mask) * sizeof(u64);
+			}
+
+			data.dyn_size += size;
+		}
+
+		data.sample_flags |= PERF_SAMPLE_REGS_USER;
+	}
+
+	/*
+	 * IBS captured RIP is out of sync with NMI pt_regs due to NMI
+	 * delivery latency. Use NMI pt_regs for PERF_SAMPLE_REGS_INTR.
+	 */
+	if (event->attr.sample_type & PERF_SAMPLE_REGS_INTR) {
+		/* regs dump ABI info */
+		int size = sizeof(u64);
+
+		perf_sample_regs_intr(&data.regs_intr, iregs,
+				      event->attr.exclude_kernel);
+
+		if (data.regs_intr.regs) {
+			u64 mask = event->attr.sample_regs_intr;
+			size += hweight64(mask) * sizeof(u64);
+		}
+
+		data.dyn_size += size;
+		data.sample_flags |= PERF_SAMPLE_REGS_INTR;
+	}
+
 	/*
 	 * Prevent leaking physical addresses to unprivileged users. Skip
 	 * PERF_SAMPLE_PHYS_ADDR check since generic code prevents it for
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d698a232df114..23444b1b2503b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1829,6 +1829,12 @@ extern unsigned long perf_misc_flags(struct perf_event *event, struct pt_regs *r
 extern unsigned long perf_instruction_pointer(struct perf_event *event,
 					      struct pt_regs *regs);
 
+extern void perf_sample_regs_user(struct perf_regs *regs_user,
+				  struct pt_regs *regs);
+extern void perf_sample_regs_intr(struct perf_regs *regs_intr,
+				  struct pt_regs *regs,
+				  bool exclude_kernel);
+
 #ifndef perf_arch_misc_flags
 # define perf_arch_misc_flags(regs) \
 		(user_mode(regs) ? PERF_RECORD_MISC_USER : PERF_RECORD_MISC_KERNEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 42057df334af3..6d3fe508b7406 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7682,8 +7682,8 @@ perf_output_sample_simd_regs(struct perf_output_handle *handle,
 	}
 }
 
-static void perf_sample_regs_user(struct perf_regs *regs_user,
-				  struct pt_regs *regs)
+void perf_sample_regs_user(struct perf_regs *regs_user,
+			   struct pt_regs *regs)
 {
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
@@ -7696,9 +7696,9 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 	}
 }
 
-static void perf_sample_regs_intr(struct perf_regs *regs_intr,
-				  struct pt_regs *regs,
-				  bool exclude_kernel)
+void perf_sample_regs_intr(struct perf_regs *regs_intr,
+			   struct pt_regs *regs,
+			   bool exclude_kernel)
 {
 	/*
 	 * Hardware skid can lead to a scenario where a PMI is
-- 
2.53.0



