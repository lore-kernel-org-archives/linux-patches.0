Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05A1328DB
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0XTbiMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB31C433C8;
	Mon,  9 Oct 2023 13:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858956;
	bh=sIgrf7WlLwyaljrUuTMJv7Y5vKj7NOEHUmeWK5/OBys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0XTbiMbxEpxNbzjng52J40MxN9hW7YKTlzmIWw3wEdI1K5gOwwmM5Wk7DalKg+nY
	 DZp7NNfo0yT+M4liyRi0vbhXXrIfrSZmUyRryT0RIBLByy3a+wYpRE8H7Jvr0c9lqU
	 B2gWvgb2hPmLdmUA22F4KdZgXh8tcE3YfUWr7B5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/226] powerpc/watchpoints: Disable preemption in thread_change_pc()
Date: Mon,  9 Oct 2023 15:01:26 +0200
Message-ID: <20231009130130.041988192@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f4e8f21046f54..6e5bed50c3578 100644
--- a/arch/powerpc/kernel/hw_breakpoint.c
+++ b/arch/powerpc/kernel/hw_breakpoint.c
@@ -479,11 +479,13 @@ void thread_change_pc(struct task_struct *tsk, struct pt_regs *regs)
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
 	regs->msr &= ~MSR_SE;
@@ -492,6 +494,9 @@ void thread_change_pc(struct task_struct *tsk, struct pt_regs *regs)
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



