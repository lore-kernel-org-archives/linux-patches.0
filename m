Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D840910E0;
	Tue, 26 Aug 2025 14:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218193; cv=none; b=hjxKqDBTckx2CbIYl33oBQeDBGoMrM05G/KwhjHgTKBVbUSkigMac420Xbfimlw40sHDYzHHm0ZzS2jz94SfTde5lUZHjKzQWFaCr1j8NPTGmHMpnqSV4SMkFokrH0reb+k6gpyt/c3NGgyHoGO9+BeWrhfvnJCVT6gg79Zshz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218193; c=relaxed/simple;
	bh=6zF3iAw3P5Len1VT9N8/Wl/WAVt73Y2VSzellkWMjdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SmWzEOHh0htVnU1FpxVcR4Z7zaR4ClbuA2cFo0DJPiMjvL2Tag+gvogfX05UoL2ceO2h8q4OJdCfkzbcNp1zxsfSusbDEnG7aAVl//2IrqkYPTAU/TYmVrWkn2uJbMHpicev1wmjbM32qdKQwHP3rKHjBDIRXFWbZpIDkehrgSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TqIGD0CA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TqIGD0CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127A3C4CEF1;
	Tue, 26 Aug 2025 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218193;
	bh=6zF3iAw3P5Len1VT9N8/Wl/WAVt73Y2VSzellkWMjdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TqIGD0CA54icJ78H9dvV19ZFOQzF3dDKIjrdQIYN1yD/ONMRHx0jWM5I2moHbivzs
	 wz+bb8Sy2nJNlkWxPG4Ngq8eBZNEoXyTVDOzs+/z+TITbAuTdl4gQJUxQTutBGObGx
	 v+wcETK/U7KgaYyiPX66agGLajg5tBRtbc5p7cRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 428/523] x86/fpu: Delay instruction pointer fixup until after warning
Date: Tue, 26 Aug 2025 13:10:38 +0200
Message-ID: <20250826110935.012902978@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Adapted ex_handler_default() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/extable.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -60,13 +60,12 @@ __visible bool ex_handler_fprestore(cons
 				    unsigned long error_code,
 				    unsigned long fault_addr)
 {
-	regs->ip = ex_fixup_addr(fixup);
-
 	WARN_ONCE(1, "Bad FPU state detected at %pB, reinitializing FPU registers.",
 		  (void *)instruction_pointer(regs));
 
 	__copy_kernel_to_fpregs(&init_fpstate, -1);
-	return true;
+
+	return ex_handler_default(fixup, regs, trapnr, error_code, fault_addr);
 }
 EXPORT_SYMBOL_GPL(ex_handler_fprestore);
 


