Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153AD11703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C161C433C7;
	Mon, 21 Aug 2023 19:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647883;
	bh=o0EE7y63G0ZO/5dLZPpbvVdAQEgCUAkSDwslwWdrZs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXgu5B9GsxFRscxJmY3P/ga6eGTmr+hN0Hp6Xq5L7LnRyQHHmt4t6W9lGyv3617lG
	 hJy/ElvdQIz85Hih01XApmjHAg2DyKfWHXskbw6wxhEvkO08cQtvuFQ7BibYq0gaZG
	 Q9inzt2sy+TW5WpZNNJddbmUpH6jMbzt7dwwTML0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.1 173/194] x86/cpu: Fix __x86_return_thunk symbol type
Date: Mon, 21 Aug 2023 21:42:32 +0200
Message-ID: <20230821194130.305278841@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
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

commit 77f67119004296a9b2503b377d610e08b08afc2a upstream.

Commit

  fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")

reimplemented __x86_return_thunk with a mix of SYM_FUNC_START and
SYM_CODE_END, this is not a sane combination.

Since nothing should ever actually 'CALL' this, make it consistently
CODE.

Fixes: fb3bd914b3ec ("x86/srso: Add a Speculative RAS Overflow mitigation")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20230814121148.571027074@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/retpoline.S |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/lib/retpoline.S
+++ b/arch/x86/lib/retpoline.S
@@ -207,7 +207,9 @@ SYM_CODE_END(srso_safe_ret)
 SYM_FUNC_END(srso_untrain_ret)
 __EXPORT_THUNK(srso_untrain_ret)
 
-SYM_FUNC_START(__x86_return_thunk)
+SYM_CODE_START(__x86_return_thunk)
+	UNWIND_HINT_FUNC
+	ANNOTATE_NOENDBR
 	ALTERNATIVE_2 "jmp __ret", "call srso_safe_ret", X86_FEATURE_SRSO, \
 			"call srso_safe_ret_alias", X86_FEATURE_SRSO_ALIAS
 	int3


