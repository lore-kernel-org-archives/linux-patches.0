Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FED1F868C;
	Tue, 17 Dec 2024 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455913; cv=none; b=gQuUWOmR8grAaCsi+2LjJd3iaOr8TLqrfu/oLGjAqIpznyCEapojARG43BsPFKuUteIR18XmuwzN+6KGlQkzFDTpqD1FXoBv0Erz5pW+GVnChB5an63r5Hgn3w2Ce9k95iWh5xVwycoWKWuKnvsCA8cGgT6Xm0hfphVhezWyJjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455913; c=relaxed/simple;
	bh=tl80PoyuL3clOc7BzFZ/vL5GVhI8meuCWVy4dYCdHds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vy66jIZNbWAjkFGoY26upBxJ6KG1gm/kDtWmLJrQuMm16R+Yqy4NVuEf8I4Xs82lvQzVrz4BM4p4W0wjOt7SjX6LH7LQDsbX7/c/83G/5vZatBB+C7dx+0QxJ6F7eWkwELNCjzIE00BId6Xm/W4GbG0O0Z3UbPs/BfMYGEU940E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1IhPBvkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1IhPBvkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E3FEC4CED3;
	Tue, 17 Dec 2024 17:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455912;
	bh=tl80PoyuL3clOc7BzFZ/vL5GVhI8meuCWVy4dYCdHds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1IhPBvkhWUzIRB7cX3D1jOOYRWEdpSqR9FOxtDat4HBC+QFodMuJpH6j7UBH2RnWQ
	 ZMvb94tipFG+HpYwDKQM7Gzldn9OzU7qe2Iwd8JlL6Btt6BW4hWMjUXmcEzG1Xks1O
	 KVOGQN0vDscNGjC7pfH7NPNiu0gkVcyxdruuUatg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <andrew.cooper3@citrix.com>,
	Juergen Gross <jgross@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 6.1 74/76] x86/xen: use new hypercall functions instead of hypercall page
Date: Tue, 17 Dec 2024 18:07:54 +0100
Message-ID: <20241217170529.664441919@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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


