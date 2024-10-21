Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEAC1EABC2;
	Mon, 21 Oct 2024 10:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507082; cv=none; b=a8VuOROscfDqaWzq6WeV2p7jFkpMUKZJ4WRPO6h+mOLEFMlZqCAlhyn8e5EkWdQwCs/S6JPYgIdbKVPY3hBTuD9bdXeaJwdQGK82FMdEh/V1v4AVtS7m+Dx9hvFcz4/T8GHsuWj0pbSs1vgjRfMJzxZQ1ZzqnnjDAJhQDBWSiqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507082; c=relaxed/simple;
	bh=z53ixMWgP8bMju39fXrBd6PA9+5K5coV2eTSNL3Reic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOOWLUfw7zLucL9/0XSzJCXsX96IhLzgjPRAepFHTwSprQcL1XW5EcA3inU5EL5P4loQEMO+H30Au/DizUSS5aEDFoG/mkQVOYu2P2cy5m6sd3q5VULLo/bdw0TuxXHIXs26S14JhDqw3fKdxGeetUjfGUuuA0cwTqN6Brg7F/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdpuWVa3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdpuWVa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8191DC4CEC3;
	Mon, 21 Oct 2024 10:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507081;
	bh=z53ixMWgP8bMju39fXrBd6PA9+5K5coV2eTSNL3Reic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RdpuWVa3nXzU6NwvzF6WP2NLMUTm8juEKCLAj8C5mn8Ypb78pSNj9G7Mj9imUZuyw
	 xIDdffNgnbjkIQVlZUr8NF+NgqlwlgAFID1WBsYB7VDVAnM4XxFd5XLlXRycqoU6L6
	 WD1aqdqBsgo48mWXH57aFIteKXATEWpTRCFukVUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Wikner <kwikner@ethz.ch>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 6.6 056/124] x86/entry: Have entry_ibpb() invalidate return predictions
Date: Mon, 21 Oct 2024 12:24:20 +0200
Message-ID: <20241021102258.901468716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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

From: Johannes Wikner <kwikner@ethz.ch>

commit 50e4b3b94090babe8d4bb85c95f0d3e6b07ea86e upstream.

entry_ibpb() should invalidate all indirect predictions, including return
target predictions. Not all IBPB implementations do this, in which case the
fallback is RSB filling.

Prevent SRSO-style hijacks of return predictions following IBPB, as the return
target predictor can be corrupted before the IBPB completes.

  [ bp: Massage. ]

Signed-off-by: Johannes Wikner <kwikner@ethz.ch>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/entry/entry.S |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/entry/entry.S
+++ b/arch/x86/entry/entry.S
@@ -9,6 +9,8 @@
 #include <asm/unwind_hints.h>
 #include <asm/segment.h>
 #include <asm/cache.h>
+#include <asm/cpufeatures.h>
+#include <asm/nospec-branch.h>
 
 .pushsection .noinstr.text, "ax"
 
@@ -17,6 +19,9 @@ SYM_FUNC_START(entry_ibpb)
 	movl	$PRED_CMD_IBPB, %eax
 	xorl	%edx, %edx
 	wrmsr
+
+	/* Make sure IBPB clears return stack preductions too. */
+	FILL_RETURN_BUFFER %rax, RSB_CLEAR_LOOPS, X86_BUG_IBPB_NO_RET
 	RET
 SYM_FUNC_END(entry_ibpb)
 /* For KVM */


