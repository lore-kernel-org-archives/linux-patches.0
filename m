Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413F1171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF9EC433EF;
	Mon, 22 May 2023 19:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784690;
	bh=tU2A4wj5lvfjaL193dHua5J4mUq9RDcdrukuxdAY/Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZfeWJfJiP5hvKh44zGYJNcFspdDc2r1qWjhs63uaHy7vaxrjHn6W8mGNK6MfAX4qj
	 gw6cOz7v5hB+ILTRPUQxrLAOo9DH1QZP7RhXL86kWh4+iKGJFc2T6HGqYsFRMjNr/E
	 yce3h9F0cRRdHQYO0PYInnoxjKbczeDIlBbZH9z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 169/364] lkdtm/stackleak: Fix noinstr violation
Date: Mon, 22 May 2023 20:07:54 +0100
Message-Id: <20230522190416.955085293@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit f571da059f86fd9d432aea32c9c7e5aaa53245d8 ]

Fixes the following warning:

  vmlinux.o: warning: objtool: check_stackleak_irqoff+0x2b6: call to _printk() leaves .noinstr.text section

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/ee5209f53aa0a62aea58be18f2b78b17606779a6.1681320026.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/stackleak.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/misc/lkdtm/stackleak.c b/drivers/misc/lkdtm/stackleak.c
index 025b133297a6b..f1d0221609138 100644
--- a/drivers/misc/lkdtm/stackleak.c
+++ b/drivers/misc/lkdtm/stackleak.c
@@ -43,12 +43,14 @@ static void noinstr check_stackleak_irqoff(void)
 	 * STACK_END_MAGIC, and in either casee something is seriously wrong.
 	 */
 	if (current_sp < task_stack_low || current_sp >= task_stack_high) {
+		instrumentation_begin();
 		pr_err("FAIL: current_stack_pointer (0x%lx) outside of task stack bounds [0x%lx..0x%lx]\n",
 		       current_sp, task_stack_low, task_stack_high - 1);
 		test_failed = true;
 		goto out;
 	}
 	if (lowest_sp < task_stack_low || lowest_sp >= task_stack_high) {
+		instrumentation_begin();
 		pr_err("FAIL: current->lowest_stack (0x%lx) outside of task stack bounds [0x%lx..0x%lx]\n",
 		       lowest_sp, task_stack_low, task_stack_high - 1);
 		test_failed = true;
@@ -86,11 +88,14 @@ static void noinstr check_stackleak_irqoff(void)
 		if (*(unsigned long *)poison_low == STACKLEAK_POISON)
 			continue;
 
+		instrumentation_begin();
 		pr_err("FAIL: non-poison value %lu bytes below poison boundary: 0x%lx\n",
 		       poison_high - poison_low, *(unsigned long *)poison_low);
 		test_failed = true;
+		goto out;
 	}
 
+	instrumentation_begin();
 	pr_info("stackleak stack usage:\n"
 		"  high offset: %lu bytes\n"
 		"  current:     %lu bytes\n"
@@ -113,6 +118,7 @@ static void noinstr check_stackleak_irqoff(void)
 	} else {
 		pr_info("OK: the rest of the thread stack is properly erased\n");
 	}
+	instrumentation_end();
 }
 
 static void lkdtm_STACKLEAK_ERASING(void)
-- 
2.39.2



