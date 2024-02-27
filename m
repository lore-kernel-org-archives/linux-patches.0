Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022D4146E8A;
	Tue, 27 Feb 2024 14:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044170; cv=none; b=jBgDGOAYaXDC87uF1C63TbLctQs4FMiGAdSRyu2T5uVjqyMAvEWwPkPuvNv7fpu/UgfK/dWQbVLRsSu0OPJXLmFYzpMyJ1XUJ6W7e1j+6YElFYFl5e5jxr5fAvF/jlpYkI7ogpOVzEsYR6ATewLvsTLscezyDJqq1Jw/KNRGfFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044170; c=relaxed/simple;
	bh=7fgr7qrCdtDhMdpwvl11pc5cdhIW4RKzcywWv4z7yYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0bAaLWrFr2HYenaMvSW4aE/dyTF/uSXXJ4gDfw7sdrngaf8uq0o7CQO1rKiQHv09xiQBAi1PAifyFd9JVOcDgyfSRwbQn/zeLL8Jm4KWxunOWz2DT3K8Udc7iJtzyQYvZoZOphJwe04JE5r9Qn9luiOKPIV8qwaUS/wU4567iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZi5W3za; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZi5W3za"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85508C433C7;
	Tue, 27 Feb 2024 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044169;
	bh=7fgr7qrCdtDhMdpwvl11pc5cdhIW4RKzcywWv4z7yYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZi5W3zaM55HKAMr5HqPhPoAj2EXD5IJtoQuCloXML/F4ARFbWcBSsyBoVgTcIdkj
	 Jq5miRPtRjhIp2Dv12LxYZyZXNYDq40ybk84DxxJNidrLUSYw0gSJh9wunmGN9VajG
	 d7Qr1fcFOniXN1ibUjaSMmnO0zd2rYREzQOxRPII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 5.10 088/122] Revert "x86/alternative: Make custom return thunk unconditional"
Date: Tue, 27 Feb 2024 14:27:29 +0100
Message-ID: <20240227131601.585873985@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

This reverts commit 08f7cfd44f77b2796582bc26164fdef44dd33b6c.

Revert the backport of upstream commit:

  095b8303f383 ("x86/alternative: Make custom return thunk unconditional")

in order to backport the full version now that

  770ae1b70952 ("x86/returnthunk: Allow different return thunks")

has been backported.

Revert it here so that the build breakage is kept at minimum.

Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/nospec-branch.h |    4 ----
 arch/x86/kernel/cpu/bugs.c           |    4 ----
 2 files changed, 8 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -190,11 +190,7 @@
 	_ASM_PTR " 999b\n\t"					\
 	".popsection\n\t"
 
-#ifdef CONFIG_RETHUNK
 extern void __x86_return_thunk(void);
-#else
-static inline void __x86_return_thunk(void) {}
-#endif
 
 extern void retbleed_return_thunk(void);
 extern void srso_return_thunk(void);
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -61,10 +61,6 @@ EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
-#ifdef CONFIG_CALL_THUNKS
-void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
-#endif
-
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
 {


