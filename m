Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618642;
	b=tJlByK4/Xa2IRTZ758iENeqSFYQUNM2UwYvcFSLeW9Suaminf9y9zWF7HdngnB8uReEL
	 CnORrwgArDp1pTVrASC50oACtXFmnG/Tz0IgPFPHD+Ppkc6RlLY7PdFgQG73yCclHGbSI
	 EBHYV2iqE0un31h55gukI+sz8Vn7G23J97blyo5CKV7wOUdYsLDK16BNEBAFAMmyn7q5V
	 HX2/O7GRvti6BWM7R1kt4W54A597qyPE+m9H8rwnw4ga05nhrus9CZqNp/YLDO1LKgzs1
	 PKjE6NqiP8djxWJUBW8jpI631MGhc+mnDqeP0Q2eMUHb0TZIL4Jq6cOpUnktUyo4TUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KOUzryjLiFInwkCZbFLpoDQYdW6U9LqMvOVdQk8/ozw=;
	b=Dx8EU/kzT6bxHbV9HnBLIsxFDYzAIves8rsFeCZPvROicGas3ua1pzcaaT2QJLGLLMb0
	 tSPkNWvefgKTeonWn27PusXQqULqAOWKf1Y+23QZ8g7NhU2cMNLODMRln//hJQr7sraQE
	 FYehtZTyuZPRoh/AOmtSMBrTHm3IJu2bG6z3Wty516XVZ1t7sNN3YPOfs/+P8dgh7c6Wb
	 zZl3nfpxk8hAxsiL8xyJ9cfHPZxW+rVlcnJIgAhTJfeXEJV/ZJo0E/8uKgX/Yfj+PlLWx
	 DDwveO2ysREe56vH7LUJKzTnutOOKKcKWEplXbWtii8tZcCGBCfjhuWAXjxCLkLm4Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlFtkbyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9177606A321;
	Wed, 25 Nov 2026 14:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tlFtkbyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ED41F000E1;
	Wed, 25 Nov 2026 14:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618641;
	bh=KOUzryjLiFInwkCZbFLpoDQYdW6U9LqMvOVdQk8/ozw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tlFtkbyMpuqOdnVCQHog8/rINKgdYiJVn7qhY4at4ETsJfEDyMGjT21quSG2qh01P
	 X0e31ACW8gXeVoNtSNzWs7pkBWtnN7tmEcPx8VFeLwYyFl5KidVE2l65RdJTZXcYn3
	 lZrtc4SNISwzNd9sHHkilijhr/z7wTvidTsvBsqg=
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
Subject: [PATCH 7.3 0342/1005] perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR
Date: Wed, 25 Nov 2026 15:28:00 +0100
Message-ID: <20261125143829.745662677@linuxfoundation.org>
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
index bfb51f8e184fd..010d14d2357bc 100644
--- a/arch/x86/events/amd/ibs.c
+++ b/arch/x86/events/amd/ibs.c
@@ -1533,6 +1533,56 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
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
index bb2452fccd0b6..8a985486ab122 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1813,6 +1813,12 @@ extern unsigned long perf_misc_flags(struct perf_event *event, struct pt_regs *r
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
index fa82d7625ba07..9c45f9d584d67 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7919,8 +7919,8 @@ perf_output_sample_simd_regs(struct perf_output_handle *handle,
 	}
 }
 
-static void perf_sample_regs_user(struct perf_regs *regs_user,
-				  struct pt_regs *regs)
+void perf_sample_regs_user(struct perf_regs *regs_user,
+			   struct pt_regs *regs)
 {
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
@@ -7933,9 +7933,9 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
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



