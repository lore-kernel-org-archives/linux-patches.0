Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FDFF13BC0B;
	Wed,  3 Jul 2024 11:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004471; cv=none; b=lFU7NVSvdhJxvuj5NLMo+nqMr86zlI896+KHGNejLgC9xDd7Q/vd3+tmMiVYTk3/+pobUeRGqYcjwx+kekUMNut5jDmH5t4AzFfqrUaLOKpgaBGJQR2YEz9uNargvvDW6yTsnJHtfZl/VFl0ZnHW/LLFxUimBwReva7PeRZ5Y/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004471; c=relaxed/simple;
	bh=ZQiKqOCuaXAdsFl86xdoms0vneRYWvtJSct4otIK8fs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLxivFzhXQTRdmaJqP3mYPxZFifT1nxlyZlopxtaxt0LWe+UMPRUzoElMBVhl29Kt5aHod0U31mjjyo8JrtYK3QPLE2YcUrWZI8NtoR4BDNwYLOSdC1nlaYFs+ztBx8gP1QV7RgRGsxnyljdTPtVo3BpXTXa0APqjl8Z4Hidacc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a+pS4eCw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a+pS4eCw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA851C32781;
	Wed,  3 Jul 2024 11:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004471;
	bh=ZQiKqOCuaXAdsFl86xdoms0vneRYWvtJSct4otIK8fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+pS4eCwS5NXlLKqNM63/7BLzUwz7WR2f6D7gYg/BDTnOjudLR/u1sGe7HkKsEcia
	 2BDlu4pjeLEnnRm1C6p0vyyQ02nYz/oWdVbJnUoMfHKUXYiCzKi/3mR6/W4YM9rTwZ
	 NY2iBgvVncNc/lJGR5UNI9FQWffqAGzlAWppg6Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kewen Lin <linkw@gcc.gnu.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 051/290] powerpc/uaccess: Fix build errors seen with GCC 13/14
Date: Wed,  3 Jul 2024 12:37:12 +0200
Message-ID: <20240703102906.129644927@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Michael Ellerman <mpe@ellerman.id.au>

commit 2d43cc701b96f910f50915ac4c2a0cae5deb734c upstream.

Building ppc64le_defconfig with GCC 14 fails with assembler errors:

    CC      fs/readdir.o
  /tmp/ccdQn0mD.s: Assembler messages:
  /tmp/ccdQn0mD.s:212: Error: operand out of domain (18 is not a multiple of 4)
  /tmp/ccdQn0mD.s:226: Error: operand out of domain (18 is not a multiple of 4)
  ... [6 lines]
  /tmp/ccdQn0mD.s:1699: Error: operand out of domain (18 is not a multiple of 4)

A snippet of the asm shows:

  # ../fs/readdir.c:210:         unsafe_copy_dirent_name(dirent->d_name, name, namlen, efault_end);
         ld 9,0(29)       # MEM[(u64 *)name_38(D) + _88 * 1], MEM[(u64 *)name_38(D) + _88 * 1]
  # 210 "../fs/readdir.c" 1
         1:      std 9,18(8)     # put_user       # *__pus_addr_52, MEM[(u64 *)name_38(D) + _88 * 1]

The 'std' instruction requires a 4-byte aligned displacement because
it is a DS-form instruction, and as the assembler says, 18 is not a
multiple of 4.

A similar error is seen with GCC 13 and CONFIG_UBSAN_SIGNED_WRAP=y.

The fix is to change the constraint on the memory operand to put_user(),
from "m" which is a general memory reference to "YZ".

The "Z" constraint is documented in the GCC manual PowerPC machine
constraints, and specifies a "memory operand accessed with indexed or
indirect addressing". "Y" is not documented in the manual but specifies
a "memory operand for a DS-form instruction". Using both allows the
compiler to generate a DS-form "std" or X-form "stdx" as appropriate.

The change has to be conditional on CONFIG_PPC_KERNEL_PREFIXED because
the "Y" constraint does not guarantee 4-byte alignment when prefixed
instructions are enabled.

Unfortunately clang doesn't support the "Y" constraint so that has to be
behind an ifdef.

Although the build error is only seen with GCC 13/14, that appears
to just be luck. The constraint has been incorrect since it was first
added.

Fixes: c20beffeec3c ("powerpc/uaccess: Use flexible addressing with __put_user()/__get_user()")
Cc: stable@vger.kernel.org # v5.10+
Suggested-by: Kewen Lin <linkw@gcc.gnu.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240529123029.146953-1-mpe@ellerman.id.au
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/uaccess.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -186,9 +186,20 @@ do {								\
 		:						\
 		: label)
 
+#ifdef CONFIG_CC_IS_CLANG
+#define DS_FORM_CONSTRAINT "Z<>"
+#else
+#define DS_FORM_CONSTRAINT "YZ<>"
+#endif
+
 #ifdef __powerpc64__
-#define __put_user_asm2_goto(x, ptr, label)			\
-	__put_user_asm_goto(x, ptr, label, "std")
+#define __put_user_asm2_goto(x, addr, label)			\
+	asm goto ("1: std%U1%X1 %0,%1	# put_user\n"		\
+		EX_TABLE(1b, %l2)				\
+		:						\
+		: "r" (x), DS_FORM_CONSTRAINT (*addr)		\
+		:						\
+		: label)
 #else /* __powerpc64__ */
 #define __put_user_asm2_goto(x, addr, label)			\
 	asm_volatile_goto(					\


