Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3E014900B;
	Tue, 17 Dec 2024 17:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455706; cv=none; b=V9NvEWY6PUn0aUiV33W9CSm2xxnZq7R79brBz4MIZQx22IOq4MGCjKHDT+1wHdMlm+VkNVEDYh08WpP72/3vhPKY1YdjYToWuCNFg4VxElgQBzD22D8J5h+1kdF76qZoyVOnDf6STvi/63yimtgVG6gWOS+cjlBkT6PKc7kNFhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455706; c=relaxed/simple;
	bh=9vX56ZSsB7HBXy5nG1jtqOBQ4EinHOWBznY6UcDPSkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyXlT8bzEeWMWWEWraw/q8HbJQYy2KxS1s/Y0Szji8FGLMxY3rxjP/F3AQJiSDt6F7k113/CqsGkJ/UaiMvK2e9/WxZ8d1D59JI3fHPD5GmuJheGFXSEv6IInpYoUsIy1xdJOv4omBEgQfYlI1VvSPhzYPYjlVFp8M0yI2AhRSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4e9Jdxl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4e9Jdxl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAD03C4CED3;
	Tue, 17 Dec 2024 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455706;
	bh=9vX56ZSsB7HBXy5nG1jtqOBQ4EinHOWBznY6UcDPSkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4e9JdxltDbt28kiOZ9LihHk9rnOeYFTqdUebhZmaY6NMMu7+oXBOhYMME/ABF5fc
	 WTWystUCy3cGLzL0gOlLkg/7PyEjv7mCw6i7kZDoGR/YqXAArdccM/aAh2cj45F4VA
	 U14HC2RokD8ACdc8SrGNJOiyhtLN12G9vCQFLiEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 5.15 49/51] x86/xen: use new hypercall functions instead of hypercall page
Date: Tue, 17 Dec 2024 18:07:42 +0100
Message-ID: <20241217170522.482897927@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.301972474@linuxfoundation.org>
References: <20241217170520.301972474@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit b1c2cb86f4a7861480ad54bb9a58df3cbebf8e92 upstream.

Call the Xen hypervisor via the new xen_hypercall_func static-call
instead of the hypercall page.

This is part of XSA-466 / CVE-2024-53241.

Reported-by: Andrew Cooper <andrew.cooper3@citrix.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Co-developed-by: Peter Zijlstra <peterz@infradead.org>
Co-developed-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/xen/hypercall.h |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -39,9 +39,11 @@
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/pgtable.h>
+#include <linux/instrumentation.h>
 
 #include <trace/events/xen.h>
 
+#include <asm/alternative.h>
 #include <asm/page.h>
 #include <asm/smap.h>
 #include <asm/nospec-branch.h>
@@ -91,9 +93,17 @@ extern struct { char _entry[32]; } hyper
 void xen_hypercall_func(void);
 DECLARE_STATIC_CALL(xen_hypercall, xen_hypercall_func);
 
-#define __HYPERCALL		"call hypercall_page+%c[offset]"
-#define __HYPERCALL_ENTRY(x)						\
-	[offset] "i" (__HYPERVISOR_##x * sizeof(hypercall_page[0]))
+#ifdef MODULE
+#define __ADDRESSABLE_xen_hypercall
+#else
+#define __ADDRESSABLE_xen_hypercall __ADDRESSABLE_ASM_STR(__SCK__xen_hypercall)
+#endif
+
+#define __HYPERCALL					\
+	__ADDRESSABLE_xen_hypercall			\
+	"call __SCT__xen_hypercall"
+
+#define __HYPERCALL_ENTRY(x)	"a" (x)
 
 #ifdef CONFIG_X86_32
 #define __HYPERCALL_RETREG	"eax"
@@ -151,7 +161,7 @@ DECLARE_STATIC_CALL(xen_hypercall, xen_h
 	__HYPERCALL_0ARG();						\
 	asm volatile (__HYPERCALL					\
 		      : __HYPERCALL_0PARAM				\
-		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_ENTRY(__HYPERVISOR_ ## name)	\
 		      : __HYPERCALL_CLOBBER0);				\
 	(type)__res;							\
 })
@@ -162,7 +172,7 @@ DECLARE_STATIC_CALL(xen_hypercall, xen_h
 	__HYPERCALL_1ARG(a1);						\
 	asm volatile (__HYPERCALL					\
 		      : __HYPERCALL_1PARAM				\
-		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_ENTRY(__HYPERVISOR_ ## name)	\
 		      : __HYPERCALL_CLOBBER1);				\
 	(type)__res;							\
 })
@@ -173,7 +183,7 @@ DECLARE_STATIC_CALL(xen_hypercall, xen_h
 	__HYPERCALL_2ARG(a1, a2);					\
 	asm volatile (__HYPERCALL					\
 		      : __HYPERCALL_2PARAM				\
-		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_ENTRY(__HYPERVISOR_ ## name)	\
 		      : __HYPERCALL_CLOBBER2);				\
 	(type)__res;							\
 })
@@ -184,7 +194,7 @@ DECLARE_STATIC_CALL(xen_hypercall, xen_h
 	__HYPERCALL_3ARG(a1, a2, a3);					\
 	asm volatile (__HYPERCALL					\
 		      : __HYPERCALL_3PARAM				\
-		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_ENTRY(__HYPERVISOR_ ## name)	\
 		      : __HYPERCALL_CLOBBER3);				\
 	(type)__res;							\
 })
@@ -195,7 +205,7 @@ DECLARE_STATIC_CALL(xen_hypercall, xen_h
 	__HYPERCALL_4ARG(a1, a2, a3, a4);				\
 	asm volatile (__HYPERCALL					\
 		      : __HYPERCALL_4PARAM				\
-		      : __HYPERCALL_ENTRY(name)				\
+		      : __HYPERCALL_ENTRY(__HYPERVISOR_ ## name)	\
 		      : __HYPERCALL_CLOBBER4);				\
 	(type)__res;							\
 })
@@ -209,12 +219,9 @@ xen_single_call(unsigned int call,
 	__HYPERCALL_DECLS;
 	__HYPERCALL_5ARG(a1, a2, a3, a4, a5);
 
-	if (call >= PAGE_SIZE / sizeof(hypercall_page[0]))
-		return -EINVAL;
-
-	asm volatile(CALL_NOSPEC
+	asm volatile(__HYPERCALL
 		     : __HYPERCALL_5PARAM
-		     : [thunk_target] "a" (&hypercall_page[call])
+		     : __HYPERCALL_ENTRY(call)
 		     : __HYPERCALL_CLOBBER5);
 
 	return (long)__res;


