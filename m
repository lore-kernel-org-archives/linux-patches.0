Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0228C1AB505;
	Mon, 14 Oct 2024 15:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919258; cv=none; b=ipk7zP3NWcdxrg+Tx67o4tKSlZfS8ghKC1y6yD4oWA6kv+JNgehbRGKc8keSuxfZpLYEFSL97e79+WrYHTp/ObxcJeOQxdFyEtejtqYnKwRlgiNw0IJ4P9JmoyNdAm7rZxZHzIaUPOif7y6BGcuEsOvTR89msjjR30dK70k5plw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919258; c=relaxed/simple;
	bh=n7OmxHrOoxVjqjlYcAcM76XhGMYvfn7CYsm9SIENnn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxcRRm+RN4i5+GMGf3y0Mi8aQzz29LRQU6cjd4gIU9UrfZZrmpy/IEiIOd2j30Y8+eKRC6VDEUSJnZSYhwj5jpVh+1YsMhZjLrfunA948t1+Cps1MqfyvbM8r022Jrulx1QQebeDwaXjDySyds/nDtdeL6qQmhN+uLJfmh9wMUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOKjjyQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOKjjyQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F894C4CEC3;
	Mon, 14 Oct 2024 15:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919257;
	bh=n7OmxHrOoxVjqjlYcAcM76XhGMYvfn7CYsm9SIENnn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOKjjyQvK2adCFbKGqboP1Q3QEJqCmMxiCxyvx5izPpOWy9me1FhYfItbOGcdW/6p
	 y01v1PoZviODfjAoeRpjmE31JmdRUynWWoc0sTey2ILR20A4+gLzVTfcehhsWw/JfM
	 bGzZ4n1p4G8eXLG4efODFaRp4o5BQE66zqImmXjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 557/798] parisc: Fix 64-bit userspace syscall path
Date: Mon, 14 Oct 2024 16:18:31 +0200
Message-ID: <20241014141239.876673761@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Helge Deller <deller@kernel.org>

commit d24449864da5838936669618356b0e30ca2999c3 upstream.

Currently the glibc isn't yet ported to 64-bit for hppa, so
there is no usable userspace available yet.
But it's possible to manually build a static 64-bit binary
and run that for testing. One such 64-bit test program is
available at http://ftp.parisc-linux.org/src/64bit.tar.gz
and it shows various issues with the existing 64-bit syscall
path in the kernel.
This patch fixes those issues.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org      # v4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/syscall.S |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/arch/parisc/kernel/syscall.S
+++ b/arch/parisc/kernel/syscall.S
@@ -232,10 +232,10 @@ linux_gateway_entry:
 
 #ifdef CONFIG_64BIT
 	ldil	L%sys_call_table, %r1
-	or,=	%r2,%r2,%r2
-	addil	L%(sys_call_table64-sys_call_table), %r1
+	or,ev	%r2,%r2,%r2
+	ldil	L%sys_call_table64, %r1
 	ldo	R%sys_call_table(%r1), %r19
-	or,=	%r2,%r2,%r2
+	or,ev	%r2,%r2,%r2
 	ldo	R%sys_call_table64(%r1), %r19
 #else
 	load32	sys_call_table, %r19
@@ -368,10 +368,10 @@ tracesys_next:
 	extrd,u	%r19,63,1,%r2			/* W hidden in bottom bit */
 
 	ldil	L%sys_call_table, %r1
-	or,=	%r2,%r2,%r2
-	addil	L%(sys_call_table64-sys_call_table), %r1
+	or,ev	%r2,%r2,%r2
+	ldil	L%sys_call_table64, %r1
 	ldo	R%sys_call_table(%r1), %r19
-	or,=	%r2,%r2,%r2
+	or,ev	%r2,%r2,%r2
 	ldo	R%sys_call_table64(%r1), %r19
 #else
 	load32	sys_call_table, %r19
@@ -1310,6 +1310,8 @@ ENTRY(sys_call_table)
 END(sys_call_table)
 
 #ifdef CONFIG_64BIT
+#undef __SYSCALL_WITH_COMPAT
+#define __SYSCALL_WITH_COMPAT(nr, native, compat)	__SYSCALL(nr, native)
 	.align 8
 ENTRY(sys_call_table64)
 #include <asm/syscall_table_64.h>    /* 64-bit syscalls */


