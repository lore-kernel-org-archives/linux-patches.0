Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C69213A41E;
	Mon,  8 Apr 2024 13:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583491; cv=none; b=CKOYY9khIkCyHpT9xnDwIO2oL+uDRz0kHqmmgIwQYKOoporvLBrslM8zSsOJFGNoaXsiaY/dbtf+RlOhX0drkh/kkE+U937BzeKga7TeQvESzyMjS0vbwhRCdzqV2NoULQea7eP6l3Pg+w1csNONTTMnXjhQnoUIOHpyLEsLnz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583491; c=relaxed/simple;
	bh=TdEM4eqwrumtRy5lbzaY0GVwZlqwln5fuT015KGQNf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrHCJ/37iHDEgpujuRMM6FRweEII1R3eECUr95JdEv+uh5e2VBI6qXlhPj5Y7p28UAMzdm9oR3G9hj3BY/uQrS4OPPae1ZiEciM4+9avsVzwi3U22TSVn7q3ebxeUA/d9HJ4NNuCRkffpzku8Eu199+6swYKLArx9E3gAAti/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HnwN3NcT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HnwN3NcT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96333C433F1;
	Mon,  8 Apr 2024 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583491;
	bh=TdEM4eqwrumtRy5lbzaY0GVwZlqwln5fuT015KGQNf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnwN3NcThEK2gUXigL/hgaZZJuDESbi74bVfJqfgi1kdzDrrW9UySClTsIM4KZCw8
	 34sI3vdMw3wTdnXrn+jl6XqTb7s4ET/H+DNsHfRWKRQo4MttyTM8e3JMLvxFlDwcJK
	 JKfnpPXL7+0e3xF/vFjkpto6FsFq3Ey6ZAWLuXLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 201/252] x86/retpoline: Add NOENDBR annotation to the SRSO dummy return thunk
Date: Mon,  8 Apr 2024 14:58:20 +0200
Message-ID: <20240408125312.892778893@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov (AMD) <bp@alien8.de>

commit b377c66ae3509ccea596512d6afb4777711c4870 upstream.

srso_alias_untrain_ret() is special code, even if it is a dummy
which is called in the !SRSO case, so annotate it like its real
counterpart, to address the following objtool splat:

  vmlinux.o: warning: objtool: .export_symbol+0x2b290: data relocation to !ENDBR: srso_alias_untrain_ret+0x0

Fixes: 4535e1a4174c ("x86/bugs: Fix the SRSO mitigation on Zen3/4")
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/20240405144637.17908-1-bp@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -223,6 +223,7 @@ SYM_CODE_END(srso_return_thunk)
 /* Dummy for the alternative in CALL_UNTRAIN_RET. */
 SYM_CODE_START(srso_alias_untrain_ret)
 	ANNOTATE_UNRET_SAFE
+	ANNOTATE_NOENDBR
 	ret
 	int3
 SYM_FUNC_END(srso_alias_untrain_ret)


