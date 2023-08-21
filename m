Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CB01171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA540C433C7;
	Mon, 21 Aug 2023 20:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648374;
	bh=zApVTFQFRsLKPHHOMTpJVVlRGCvPHOzViZsR6SGu5pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZSfl+XFGTOZUrx1O4UbYPwRacUa9cNxSijj/n57MsR7TX31zW8QDvywc/frfRt4k
	 8hd9iGzdJZEO3zRiZAB4iO00a7xmwdxYXS4lvgzOEL8YgF7c3SZaepm6T8u+FfJkWB
	 Xfz2Qqvbqe7twChFHR2a67H+N44vrTou5uUAGGiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Bricart <christian@bricart.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Subject: [PATCH 6.4 125/234] x86/static_call: Fix __static_call_fixup()
Date: Mon, 21 Aug 2023 21:41:28 +0200
Message-ID: <20230821194134.350318374@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
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

commit 54097309620ef0dc2d7083783dc521c6a5fef957 upstream.

Christian reported spurious module load crashes after some of Song's
module memory layout patches.

Turns out that if the very last instruction on the very last page of the
module is a 'JMP __x86_return_thunk' then __static_call_fixup() will
trip a fault and die.

And while the module rework made this slightly more likely to happen,
it's always been possible.

Fixes: ee88d363d156 ("x86,static_call: Use alternative RET encoding")
Reported-by: Christian Bricart <christian@bricart.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Link: https://lkml.kernel.org/r/20230816104419.GA982867@hirez.programming.kicks-ass.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/static_call.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -186,6 +186,19 @@ EXPORT_SYMBOL_GPL(arch_static_call_trans
  */
 bool __static_call_fixup(void *tramp, u8 op, void *dest)
 {
+	unsigned long addr = (unsigned long)tramp;
+	/*
+	 * Not all .return_sites are a static_call trampoline (most are not).
+	 * Check if the 3 bytes after the return are still kernel text, if not,
+	 * then this definitely is not a trampoline and we need not worry
+	 * further.
+	 *
+	 * This avoids the memcmp() below tripping over pagefaults etc..
+	 */
+	if (((addr >> PAGE_SHIFT) != ((addr + 7) >> PAGE_SHIFT)) &&
+	    !kernel_text_address(addr + 7))
+		return false;
+
 	if (memcmp(tramp+5, tramp_ud, 3)) {
 		/* Not a trampoline site, not our problem. */
 		return false;


