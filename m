Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E311C111A8
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BD0C433C9;
	Thu, 24 Aug 2023 14:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692886542;
	bh=iCXqDsUDa0kmrku0NEKsRYIZsOnBcVJqDMHOapPh2J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1pWJn+TxJcPLlywrVpKC4YbhmVB3crEZkwZptlunfGuGzFiF5l2wFrFibMLNPW2lx
	 6bs9bnEwFxmwhKbNaPCj0hCMuQcpu8TPxNEYo3cfJcNn6jw+dSzR8EnvjataN07ndF
	 9ahiH7agcGL/3jjJBadR/gfPyY4HUCeDlJqCoxTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 02/15] x86/cpu: Fix up srso_safe_ret() and __x86_return_thunk()
Date: Thu, 24 Aug 2023 16:14:58 +0200
Message-ID: <20230824141447.295186481@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824141447.155846739@linuxfoundation.org>
References: <20230824141447.155846739@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Zijlstra <peterz@infradead.org>

commit af023ef335f13c8b579298fc432daeef609a9e60 upstream.

  vmlinux.o: warning: objtool: srso_untrain_ret() falls through to next function __x86_return_skl()
  vmlinux.o: warning: objtool: __x86_return_thunk() falls through to next function __x86_return_skl()

This is because these functions (can) end with CALL, which objtool
does not consider a terminating instruction. Therefore, replace the
INT3 instruction (which is a non-fatal trap) with UD2 (which is a
fatal-trap).

This indicates execution will not continue past this point.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814121148.637802730@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -202,7 +202,7 @@ SYM_INNER_LABEL(srso_safe_ret, SYM_L_GLO
 	int3
 	lfence
 	call srso_safe_ret
-	int3
+	ud2
 SYM_CODE_END(srso_safe_ret)
 SYM_FUNC_END(srso_untrain_ret)
 __EXPORT_THUNK(srso_untrain_ret)
@@ -212,7 +212,7 @@ SYM_CODE_START(__x86_return_thunk)
 	ANNOTATE_NOENDBR
 	ALTERNATIVE_2 "jmp __ret", "call srso_safe_ret", X86_FEATURE_SRSO, \
 			"call srso_safe_ret_alias", X86_FEATURE_SRSO_ALIAS
-	int3
+	ud2
 SYM_CODE_END(__x86_return_thunk)
 EXPORT_SYMBOL(__x86_return_thunk)
 


