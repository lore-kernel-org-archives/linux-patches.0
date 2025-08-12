Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7215A2F83CB;
	Tue, 12 Aug 2025 17:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021339; cv=none; b=FS6inkJVfzK1qRvKifREuhsG4D5Fxn0LyJwz6m0VHj6pbuYo4bDd17dkdsrnVgBCy3LCi0vy9fkRSeNMCzCdh3W+0QaidnDrwQwh0I9IDyzZR4NjOXWo5suZKkb7Tg7KR0hm4Ihzg7YUaGUOO3MhG5hMinTJqInVQ22MCxH7rSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021339; c=relaxed/simple;
	bh=OjRFGQ6WABinM/uiTfPTWvBA1IOZYBoXVukGYDrPjyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6PzI2Oeb7vosWQU2spF/FeKiBPvu7sYUtWoZBVLOTGVOuUgayq8KpvyR4eUA6amKbGdrU/Z7tJRgGGn+Xh0WwKL2Bn8iz+k5ozbmRiyiw+lTmGlOmxs2yfZskeW579sKgydpnEG0neZ0MkqZJyRp4Wj/QXwpOdrIoVrPFLTf70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkPvSwi9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkPvSwi9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57DDC4CEF1;
	Tue, 12 Aug 2025 17:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021339;
	bh=OjRFGQ6WABinM/uiTfPTWvBA1IOZYBoXVukGYDrPjyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkPvSwi9QkpWWna5rLbtWCV9Y2A9OFt3fnROpUEN7B3CnlGS3FkHmFB6Gclv09xE1
	 lPIr2VdY5AcqPSfAvnSD4LsIguFodrB17m8SF8QJ2KZDQH6ALTEgbdUnKhv/XoKAqT
	 ShZ8FL6kFoTDqCdWiYzkAREWjQhH6FYnYjalgI+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 250/253] x86/fpu: Delay instruction pointer fixup until after warning
Date: Tue, 12 Aug 2025 19:30:38 +0200
Message-ID: <20250812172959.505614566@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Hansen <dave.hansen@linux.intel.com>

commit 1cec9ac2d071cfd2da562241aab0ef701355762a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/extable.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -121,13 +121,12 @@ static bool ex_handler_sgx(const struct
 static bool ex_handler_fprestore(const struct exception_table_entry *fixup,
 				 struct pt_regs *regs)
 {
-	regs->ip = ex_fixup_addr(fixup);
-
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
 	fpu_reset_from_exception_fixup();
-	return true;
+
+	return ex_handler_default(fixup, regs);
 }
 
 static bool ex_handler_uaccess(const struct exception_table_entry *fixup,


