Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABB83568EA;
	Tue, 26 Aug 2025 14:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218387; cv=none; b=n8JD2LOS3YOLqc3fO/osaEsYu+ji7Zvp/PxvpaIJE7I6crcq2XQ6DBSwRFELkpcYWahY9aYACXnu9+0D6xxToUNxDwom9FMcCEzpqqAfG9RmJ+fxUPqQy62ntzeefsoFSVZ0FaG8qEoPwj58rM0sYVB+a/qGGHdDQzm6QJ0bvYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218387; c=relaxed/simple;
	bh=eFdP8uQwayKi3f43Bg6xyNOGDUSDmCN15hH9YAb6QQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RB8gTfLrbJ/T7JZy3uj4xvgap7wFNCTIfADAKeOsB8BpZNpzyw8aUSTQ/qJ5G2VCg/eT9jAG5JvxVHsl3eLsUR+TennMDdjEjgLBMltPkETAGTjhJbHNGrwFZinHOXPZ9sn7mBv4tE/n5Y2vWZC26o3ZF1c89wwR4u8oB0WxbKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fjXGKX3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fjXGKX3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB075C4CEF1;
	Tue, 26 Aug 2025 14:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218387;
	bh=eFdP8uQwayKi3f43Bg6xyNOGDUSDmCN15hH9YAb6QQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjXGKX3KLuveHge4yX5BUxcOTvvtgUs1hV4/wUKw81NiytJmKcVro2uHaO2dpzPPz
	 4vG5Vxfndnde/co6FrDeUPiFzaMavs0Z4HCI0P0RkjEuPJxnbSDphSsVEhJ4ZpQbUR
	 j6/Mkc1e1uzWBhheEdDcYWFNUlbiu/pTMeAsCJbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Beulich <jbeulich@suse.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 501/523] compiler: remove __ADDRESSABLE_ASM{_STR,}() again
Date: Tue, 26 Aug 2025 13:11:51 +0200
Message-ID: <20250826110936.798345728@linuxfoundation.org>
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

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 8ea815399c3fcce1889bd951fec25b5b9a3979c1 ]

__ADDRESSABLE_ASM_STR() is where the necessary stringification happens.
As long as "sym" doesn't contain any odd characters, no quoting is
required for its use with .quad / .long. In fact the quotation gets in
the way with gas 2.25; it's only from 2.26 onwards that quoted symbols
are half-way properly supported.

However, assembly being different from C anyway, drop
__ADDRESSABLE_ASM_STR() and its helper macro altogether. A simple
.global directive will suffice to get the symbol "declared", i.e. into
the symbol table. While there also stop open-coding STATIC_CALL_TRAMP()
and STATIC_CALL_KEY().

Fixes: 0ef8047b737d ("x86/static-call: provide a way to do very early static-call updates")
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <609d2c74-de13-4fae-ab1a-1ec44afb948d@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/xen/hypercall.h |    6 ++++--
 include/linux/compiler.h             |    8 --------
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -37,6 +37,7 @@
 #include <linux/spinlock.h>
 #include <linux/errno.h>
 #include <linux/string.h>
+#include <linux/stringify.h>
 #include <linux/types.h>
 #include <linux/pgtable.h>
 #include <linux/instrumentation.h>
@@ -94,12 +95,13 @@ DECLARE_STATIC_CALL(xen_hypercall, xen_h
 #ifdef MODULE
 #define __ADDRESSABLE_xen_hypercall
 #else
-#define __ADDRESSABLE_xen_hypercall __ADDRESSABLE_ASM_STR(__SCK__xen_hypercall)
+#define __ADDRESSABLE_xen_hypercall \
+	__stringify(.global STATIC_CALL_KEY(xen_hypercall);)
 #endif
 
 #define __HYPERCALL					\
 	__ADDRESSABLE_xen_hypercall			\
-	"call __SCT__xen_hypercall"
+	__stringify(call STATIC_CALL_TRAMP(xen_hypercall))
 
 #define __HYPERCALL_ENTRY(x)	"a" (x)
 
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -242,14 +242,6 @@ static inline void *offset_to_ptr(const
 	static void * __section(".discard.addressable") __used \
 		__UNIQUE_ID(__PASTE(__addressable_,sym)) = (void *)&sym;
 
-#define __ADDRESSABLE_ASM(sym)						\
-	.pushsection .discard.addressable,"aw";				\
-	.align ARCH_SEL(8,4);						\
-	ARCH_SEL(.quad, .long) __stringify(sym);			\
-	.popsection;
-
-#define __ADDRESSABLE_ASM_STR(sym) __stringify(__ADDRESSABLE_ASM(sym))
-
 /* &a[0] degrades to a pointer: a different type from an array */
 #define __must_be_array(a)	BUILD_BUG_ON_ZERO(__same_type((a), &(a)[0]))
 


