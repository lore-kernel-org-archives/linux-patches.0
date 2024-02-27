Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB38C145337;
	Tue, 27 Feb 2024 14:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043450; cv=none; b=fTl7qL68isNa41OYI7WI81r8G3VUYbP/e/q80L/PBu7uZiWAY9g+0pqxtly6XElIwo38F3xjlMifgMSR5y32U77z+HJGa2siwhHVnirrD1ivs825nX/xxtYCa2hq+jyC5hIuGi3LM5TFTmXa6G1awEqrePnytp1Vj9k9I8Tkv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043450; c=relaxed/simple;
	bh=Dtuu8Qz3YVAPkIk1XgfvxaicklzIVCldwOX79diXO0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdojFA+tiXEzjCEoCmdlImrj9bi/+gGcQLWkIePQFL6qFkJU1LD44fdpfqrNkuNpAO6eslkwmb/WPAvomKcjbSevhGZYLKHy+39x9563w2HeYNk5UHLGeiOc3JWJ1jQD1p+bGgePLrWJSG4ef3mdsv2Ic28T+flaeIHagTMbGyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpsuYOFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpsuYOFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0ACC433F1;
	Tue, 27 Feb 2024 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043450;
	bh=Dtuu8Qz3YVAPkIk1XgfvxaicklzIVCldwOX79diXO0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpsuYOFmgJ/cqAlXhESxCyEXA9KxFqJp9RPLUNy8Gimi5hncoUpM8tg9iD3dAtYk5
	 UL8LFEB9/x8E8b8nW8gzmrSrHERV2s8bI+rDofbsu2tAe6nio5brb+mFxH6thrl3TH
	 5xuJUtWIaB8oaGtIVEm14zvCgsI7zJjkMWP0Iom4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 113/195] Revert "x86/alternative: Make custom return thunk unconditional"
Date: Tue, 27 Feb 2024 14:26:14 +0100
Message-ID: <20240227131614.193956473@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Borislav Petkov (AMD)" <bp@alien8.de>

This reverts commit 53ebbe1c8c02aa7b7f072dd2f96bca4faa1daa59.

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
 arch/x86/kernel/cpu/bugs.c           |    2 --
 2 files changed, 6 deletions(-)

--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -205,11 +205,7 @@
 typedef u8 retpoline_thunk_t[RETPOLINE_THUNK_SIZE];
 extern retpoline_thunk_t __x86_indirect_thunk_array[];
 
-#ifdef CONFIG_RETHUNK
 extern void __x86_return_thunk(void);
-#else
-static inline void __x86_return_thunk(void) {}
-#endif
 
 extern void retbleed_return_thunk(void);
 extern void srso_return_thunk(void);
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -62,8 +62,6 @@ EXPORT_SYMBOL_GPL(x86_pred_cmd);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
-void (*x86_return_thunk)(void) __ro_after_init = &__x86_return_thunk;
-
 /* Update SPEC_CTRL MSR and its cached copy unconditionally */
 static void update_spec_ctrl(u64 val)
 {


