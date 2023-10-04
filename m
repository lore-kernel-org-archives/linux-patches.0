Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A021D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linuxfoundation.org
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A743FC433C8;
	Wed,  4 Oct 2023 18:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442866;
	bh=OqmGTUmvoJXI8DoyVbZJ+cgKU+Kfk2sb644XFJrT5W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZox91ytYfMxes21VgrhqqaWDHD8lcEj9o27XsmYu4cSM33DZqSDIzQcxgC4DNTUf
	 fZJSVLtt4zFqvBk1aGdo57vhoOjJQaepfckc7k5G03yWgD4hNfkzqo5elEAMjVsc5j
	 RMmqnwyac3yxv+Z5BflOVaqisiTMSSD2VAhsOhfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 137/183] powerpc/watchpoints: Disable preemption in thread_change_pc()
Date: Wed,  4 Oct 2023 19:56:08 +0200
Message-ID: <20231004175209.702314952@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit cc879ab3ce39bc39f9b1d238b283f43a5f6f957d ]

thread_change_pc() uses CPU local data, so must be protected from
swapping CPUs while it is reading the breakpoint struct.

The error is more noticeable after 1e60f3564bad ("powerpc/watchpoints:
Track perf single step directly on the breakpoint"), which added an
unconditional __this_cpu_read() call in thread_change_pc(). However the
existing __this_cpu_read() that runs if a breakpoint does need to be
re-inserted has the same issue.

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230829063457.54157-2-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint.c b/arch/powerpc/kernel/hw_breakpoint.c
index 91a3be14808b1..63fec0602af22 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -478,11 +478,13 @@ void thread_change_pc(struct task_struct *tsk, struct pt_regs *regs)
 	struct arch_hw_breakpoint *info;
 	int i;
 
+	preempt_disable();
+
 	for (i = 0; i < nr_wp_slots(); i++) {
 		if (unlikely(tsk->thread.last_hit_ubp[i]))
 			goto reset;
 	}
-	return;
+	goto out;
 
 reset:
 	regs_set_return_msr(regs, regs->msr & ~MSR_SE);
@@ -491,6 +493,9 @@ void thread_change_pc(struct task_struct *tsk, struct pt_regs *regs)
 		__set_breakpoint(i, info);
 		tsk->thread.last_hit_ubp[i] = NULL;
 	}
+
+out:
+	preempt_enable();
 }
 
 static bool is_larx_stcx_instr(int type)
-- 
2.40.1



