Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9C31DED7D;
	Tue,  8 Oct 2024 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393762; cv=none; b=McCD1pwBnhmASmt/hTpU6e7VEkEDPaFIdbmp5WjbDIGqALQL8kIVpA3IlP40Eb6RFMDFcwArEFDyDjNQV7heiDhTfG6P9IpmW2mKNKdbrrJS38GrvZCzl7ZIqYaXH/naCgcS3Xc4vygoE+nMJbJNta55T/KN/d9QoMdBsf21cxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393762; c=relaxed/simple;
	bh=fDjNhxfciWOoa7PYZfyvyK2/yPoJdm7S9tTJKknlr1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRt7KAgwull33h27Vpw8OfBNIpxw9y/3p9MrdnjPbxAGmjkgFbs18r2I7YPgiAN6XWuDXYxBnw8mIwdBWd4VZZj2dWG3i8ZZ/WIR0fcf8JoKtJwBY0fmrDYGsxdBWH+b3Ie4Mw5hAo/guGSc2XufinweiJIdpcQjOO+4Ap1UArM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLCudC9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLCudC9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EB92C4CEC7;
	Tue,  8 Oct 2024 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393762;
	bh=fDjNhxfciWOoa7PYZfyvyK2/yPoJdm7S9tTJKknlr1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLCudC9NjZBNHlQaWLtcn313ZfgKlHm/KNTmGsHuqQEMys7aP7crgsae+G4alf8+8
	 6O4U8E8GxT4ILasF81XOBOeVPnoY+TFzXlbBDFdYj3r0ivaGxPDpc1T+mhklc8DdAF
	 wegAPtAmsGPOS3vILPcBcSzFtM4QIIMZqcRn+GCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.6 248/386] parisc: Fix 64-bit userspace syscall path
Date: Tue,  8 Oct 2024 14:08:13 +0200
Message-ID: <20241008115639.151510719@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
@@ -243,10 +243,10 @@ linux_gateway_entry:
 
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
@@ -379,10 +379,10 @@ tracesys_next:
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
@@ -1327,6 +1327,8 @@ ENTRY(sys_call_table)
 END(sys_call_table)
 
 #ifdef CONFIG_64BIT
+#undef __SYSCALL_WITH_COMPAT
+#define __SYSCALL_WITH_COMPAT(nr, native, compat)	__SYSCALL(nr, native)
 	.align 8
 ENTRY(sys_call_table64)
 #include <asm/syscall_table_64.h>    /* 64-bit syscalls */


