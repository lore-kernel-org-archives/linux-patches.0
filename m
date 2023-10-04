Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E1210E4
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwJBxosm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6043C433C7;
	Wed,  4 Oct 2023 18:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444366;
	bh=IzeR6xEnfV20MMbkkEWSY1HoAAtWV37XzW3qHOc5LG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwJBxosmE0uwpYqY5TwWWLbvxiGWEV8TFO0aps61cjiN89jd0i8R5KLLet4cbiuks
	 kbnwAr5LoOQ6Drolwsx9GVpPB3fECPTmc7MAbG1lygVy0mQIWPCyh5+h9fBpD34GoU
	 uYXwnrrfGkca+2iO/IxRYLslvIPGM22CDpNDSTY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 225/321] powerpc/watchpoint: Disable pagefaults when getting user instruction
Date: Wed,  4 Oct 2023 19:56:10 +0200
Message-ID: <20231004175239.645172718@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit 3241f260eb830d27d09cc604690ec24533fdb433 ]

This is called in an atomic context, so is not allowed to sleep if a
user page needs to be faulted in and has nowhere it can be deferred to.
The pagefault_disabled() function is documented as preventing user
access methods from sleeping.

In practice the page will be mapped in nearly always because we are
reading the instruction that just triggered the watchpoint trap.

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230829063457.54157-3-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/hw_breakpoint_constraints.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/hw_breakpoint_constraints.c b/arch/powerpc/kernel/hw_breakpoint_constraints.c
index a74623025f3ab..9e51801c49152 100644
--- a/arch/powerpc/kernel/hw_breakpoint_constraints.c
+++ b/arch/powerpc/kernel/hw_breakpoint_constraints.c
@@ -131,8 +131,13 @@ void wp_get_instr_detail(struct pt_regs *regs, ppc_inst_t *instr,
 			 int *type, int *size, unsigned long *ea)
 {
 	struct instruction_op op;
+	int err;
 
-	if (__get_user_instr(*instr, (void __user *)regs->nip))
+	pagefault_disable();
+	err = __get_user_instr(*instr, (void __user *)regs->nip);
+	pagefault_enable();
+
+	if (err)
 		return;
 
 	analyse_instr(&op, regs, *instr);
-- 
2.40.1



