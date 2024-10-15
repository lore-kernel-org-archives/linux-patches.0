Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0597A227B8C;
	Tue, 15 Oct 2024 13:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998099; cv=none; b=oJxUydxFYTmKZx4JmY0dUNbYETScwcoBJEbuko/lU9kYgwp8+EAD0bKqV/XAuY7VijS7ThvXv52MVj1Gb+AwhdMgkgytySLxUlgvtDOK/BUvF+e2metJg01WUBMFVeO8V46/1irZnY8R0rSLcz5hahZmFJH1FINPylhgahX3RF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998099; c=relaxed/simple;
	bh=YaTqVhnIFEQW4gA605KUJlajc3mSE02dTrl8GVk0QJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHpnKAyVVVaWd5tCrTKV3DMapMtzTeBycz27jTBTDI6rD2WuELry65hjCH3wf9o9zPlmpQxiybucXdWAWb677UKqnSJ+7kl8PeVflHCLdqraW2HZ45dk+tU8ZAVhrJE/blyGH3tT26ixtlk8sKmrPOYIG5idu3RNZ039jUl4Cz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEnawJlr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEnawJlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2558BC4CEC6;
	Tue, 15 Oct 2024 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998098;
	bh=YaTqVhnIFEQW4gA605KUJlajc3mSE02dTrl8GVk0QJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEnawJlrSuwYRZHANgpmybSmqaS/ns6h6QUPCy5GQAHiBjh5XknHckE5AOT7oXzWp
	 OIS5+8Sohh71Q07Y2eOJzpKMn/v2uX3lftAzc8I/Bs/UwG/9vkvkjk3W3jURZA38a0
	 foI2XFlBj8px6ljdmjZwQkrs3FIkNu4DSLaqMdk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 379/518] parisc: Fix 64-bit userspace syscall path
Date: Tue, 15 Oct 2024 14:44:43 +0200
Message-ID: <20241015123931.598637077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -217,10 +217,10 @@ linux_gateway_entry:
 
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
@@ -355,10 +355,10 @@ tracesys_next:
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
@@ -931,6 +931,8 @@ ENTRY(sys_call_table)
 END(sys_call_table)
 
 #ifdef CONFIG_64BIT
+#undef __SYSCALL_WITH_COMPAT
+#define __SYSCALL_WITH_COMPAT(nr, native, compat)	__SYSCALL(nr, native)
 	.align 8
 ENTRY(sys_call_table64)
 #include <asm/syscall_table_64.h>    /* 64-bit native syscalls */


