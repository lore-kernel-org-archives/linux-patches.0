Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC26352FF0;
	Tue, 26 Aug 2025 13:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216729; cv=none; b=SmAXs12Ab+miemsDaTxYj7nC3urRkP4VKkeKEfVmEqqio8/g/w+IfpDy8wE/BUTlLqSr5uELLemssfKMWfDinP5pVcNxfUXowTW6L48zSLcsQIytCKstH01tGm7AalDeAGRX0qGnkOt8Z6OXusHfox7MJ81mYws5pQvo5C5K42U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216729; c=relaxed/simple;
	bh=AvxVh6FosuCGoLiv2giagHt9Ck29X3uEyBCygyDkbLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bCVNZuVZTVQyFNK0B/RUVvDXlQ7AZHkN/qz+XTd5EI0qMI9KK0tQiWo0TtKFOBYdhU3MJJGmZp25r8YhDUzdjl3v5+YW8VGUgmU5MGQwEOgCfA40G6FwrCXuhPGdvGe83b4C/6hDKH9RNMn9etBwZMYcU+2l2m1AfxTFkfa8I+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZMeBRmkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZMeBRmkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02CCC4CEF1;
	Tue, 26 Aug 2025 13:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216729;
	bh=AvxVh6FosuCGoLiv2giagHt9Ck29X3uEyBCygyDkbLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZMeBRmkHUXHeJOnOzA3ORwhnR7PjQo2QNEdJ10lvLSTgPl1onBjD0r9XoNPYiZkBX
	 Vzu293nc33qaMr41qFVqN9Zwtwrl8yn7KS9OsKexxgcuTYKW7ANB7/jJmYz71ZybX9
	 yJzIrV4vye6d7WUohqj2rsRpktuiCR6qpgABBvNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/644] x86/fpu: Delay instruction pointer fixup until after warning
Date: Tue, 26 Aug 2025 13:10:12 +0200
Message-ID: <20250826110959.418421094@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

[ Upstream commit 1cec9ac2d071cfd2da562241aab0ef701355762a ]

Right now, if XRSTOR fails a console message like this is be printed:

	Bad FPU state detected at restore_fpregs_from_fpstate+0x9a/0x170, reinitializing FPU registers.

However, the text location (...+0x9a in this case) is the instruction
*AFTER* the XRSTOR. The highlighted instruction in the "Code:" dump
also points one instruction late.

The reason is that the "fixup" moves RIP up to pass the bad XRSTOR and
keep on running after returning from the #GP handler. But it does this
fixup before warning.

The resulting warning output is nonsensical because it looks like the
non-FPU-related instruction is #GP'ing.

Do not fix up RIP until after printing the warning. Do this by using
the more generic and standard ex_handler_default().

Fixes: d5c8028b4788 ("x86/fpu: Reinitialize FPU registers if restoring FPU state fails")
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Acked-by: Alison Schofield <alison.schofield@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250624210148.97126F9E%40davehans-spike.ostc.intel.com
[ Replace fpu_reset_from_exception_fixup() with __restore_fpregs_from_fpstate() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/extable.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -60,13 +60,12 @@ static bool ex_handler_fault(const struc
 static bool ex_handler_fprestore(const struct exception_table_entry *fixup,
 				 struct pt_regs *regs)
 {
-	regs->ip = ex_fixup_addr(fixup);
-
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
 	__restore_fpregs_from_fpstate(&init_fpstate, xfeatures_mask_fpstate());
-	return true;
+
+	return ex_handler_default(fixup, regs);
 }
 
 static bool ex_handler_uaccess(const struct exception_table_entry *fixup,


