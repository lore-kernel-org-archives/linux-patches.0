Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220791BDA95;
	Thu, 30 Jan 2025 14:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246821; cv=none; b=JFA1n/FEDoJOyup1fmh4Z0R7+UMuoTHEKkoa9G0w1Grzlmuua1CS/bsWuhE8ZJV5A2kf41ov9Nu1Cs2X7k8PSiIo+23gLMEkKPq574Mj3OfmsxCegSmMhbJ2vvnN3fazTnUHc/OOufyl43duK5gvyo1wou47zFPYOQbRv2+LJ9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246821; c=relaxed/simple;
	bh=BwV4JYOho5/IxREn2Uwq4f+grOKFdP9jDB++RvAIxLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCWuogAQvc1ngfwSneBmMJkwwcsyNo82m8HRXpVGGk1CtKRlHkhKGlNbI6vj7ca/WNdynw9Vz8tUOWcaaeUUNGZv4+Gat9tBe79re5e/2oxu0UnBs9DNZkqwQCmzMcF2oGlZcbnGNVWyA6+eq6xb4p/nh4RWc5yv5Evn7cGtEtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B8GIAOIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B8GIAOIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BC6C4CED2;
	Thu, 30 Jan 2025 14:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246820;
	bh=BwV4JYOho5/IxREn2Uwq4f+grOKFdP9jDB++RvAIxLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B8GIAOILEeoe0dlqKzrWOCTdb2fXMVjVBXwMtedGIaVl4ONGSsYdwpfkZb8qr/eVP
	 wqDY4K+jGTxDkmGlRLw5bS6ROF+b8agCXxCOjShV+z17ofB3IXg9LfQO2W8O8f0USN
	 CL1d17gkirEcnSTXlBX22p3mg0vFBNq2bqC/eL8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 49/91] RISC-V: Avoid dereferening NULL regs in die()
Date: Thu, 30 Jan 2025 15:01:08 +0100
Message-ID: <20250130140135.632995641@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Palmer Dabbelt <palmer@rivosinc.com>

[ Upstream commit f2913d006fcdb61719635e093d1b5dd0dafecac7 ]

I don't think we can actually die() without a regs pointer, but the
compiler was warning about a NULL check after a dereference.  It seems
prudent to just avoid the possibly-NULL dereference, given that when
die()ing the system is already toast so who knows how we got there.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20220920200037.6727-1-palmer@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Stable-dep-of: 6a97f4118ac0 ("riscv: Fix sleeping in invalid context in die()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/traps.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/kernel/traps.c b/arch/riscv/kernel/traps.c
index 184f7b82c5ae..533087439e80 100644
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -29,6 +29,7 @@ void die(struct pt_regs *regs, const char *str)
 {
 	static int die_counter;
 	int ret;
+	long cause;
 
 	oops_enter();
 
@@ -38,11 +39,13 @@ void die(struct pt_regs *regs, const char *str)
 
 	pr_emerg("%s [#%d]\n", str, ++die_counter);
 	print_modules();
-	show_regs(regs);
+	if (regs)
+		show_regs(regs);
 
-	ret = notify_die(DIE_OOPS, str, regs, 0, regs->cause, SIGSEGV);
+	cause = regs ? regs->cause : -1;
+	ret = notify_die(DIE_OOPS, str, regs, 0, cause, SIGSEGV);
 
-	if (regs && kexec_should_crash(current))
+	if (kexec_should_crash(current))
 		crash_kexec(regs);
 
 	bust_spinlocks(0);
-- 
2.39.5



