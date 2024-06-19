Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576F712FB31;
	Wed, 19 Jun 2024 13:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802415; cv=none; b=tSrZ58rGWaDLIA0/WLlymlEq02gtaHCviiCbVXdyq+yYHwrzWdsEKTBkOI2W+fTUSS/WZ3Hhe+kaap2ww+dK5ScE6wIfQ3FML7CRd0hCEwGrwWZsACNDqFdA2Bbv908JbtxZYMbVl2gU2ZpTLjKTptQjwAUFNjRWFukolQbNke4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802415; c=relaxed/simple;
	bh=hgvitopahzjiQR/PGv5xlNa1s0hPdHVBuak4YWnhPaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nY6n3FhJscpoPvZ51FOa3GmVnWwNGuCj9AB8EvkLtt0HSTUTMI6xEpREPztRTXzBouPRTeidl+mHo/A8PNPGxXHZOTpJgU2sKuEPcNY2MXsSIDKvUQwt3zkxEHOYnCSZts57MIh818XqPczOdrpF4pDAL7ChcBOX+7xlfFvmzbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+tDkA+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+tDkA+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88793C2BBFC;
	Wed, 19 Jun 2024 13:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802414;
	bh=hgvitopahzjiQR/PGv5xlNa1s0hPdHVBuak4YWnhPaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+tDkA+XvhGMwQz6h4id5oDrUdm1l1DphfAdaRQxF28RKGSLR3B4bgIBlhXxtTXhg
	 Tz+LjolwNyY52aPOXNmXQTZrOjzbB/pa2t13DczPjUhKN+UX/n/rYHWPFN1JJMtsCI
	 WYo/Gn5ALCFSkeLNn4F1VZQI+3FpEQoypa+f7Jr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Kees Cook <kees@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/267] x86/uaccess: Fix missed zeroing of ia32 u64 get_user() range checking
Date: Wed, 19 Jun 2024 14:55:09 +0200
Message-ID: <20240619125612.407945009@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Kees Cook <kees@kernel.org>

[ Upstream commit 8c860ed825cb85f6672cd7b10a8f33e3498a7c81 ]

When reworking the range checking for get_user(), the get_user_8() case
on 32-bit wasn't zeroing the high register. (The jump to bad_get_user_8
was accidentally dropped.) Restore the correct error handling
destination (and rename the jump to using the expected ".L" prefix).

While here, switch to using a named argument ("size") for the call
template ("%c4" to "%c[size]") as already used in the other call
templates in this file.

Found after moving the usercopy selftests to KUnit:

      # usercopy_test_invalid: EXPECTATION FAILED at
      lib/usercopy_kunit.c:278
      Expected val_u64 == 0, but
          val_u64 == -60129542144 (0xfffffff200000000)

Closes: https://lore.kernel.org/all/CABVgOSn=tb=Lj9SxHuT4_9MTjjKVxsq-ikdXC4kGHO4CfKVmGQ@mail.gmail.com
Fixes: b19b74bc99b1 ("x86/mm: Rework address range check in get_user() and put_user()")
Reported-by: David Gow <davidgow@google.com>
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Tested-by: David Gow <davidgow@google.com>
Link: https://lore.kernel.org/all/20240610210213.work.143-kees%40kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess.h | 4 ++--
 arch/x86/lib/getuser.S         | 6 +++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 0f9bab92a43d7..3a7755c1a4410 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -78,10 +78,10 @@ extern int __get_user_bad(void);
 	int __ret_gu;							\
 	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
 	__chk_user_ptr(ptr);						\
-	asm volatile("call __" #fn "_%c4"				\
+	asm volatile("call __" #fn "_%c[size]"				\
 		     : "=a" (__ret_gu), "=r" (__val_gu),		\
 			ASM_CALL_CONSTRAINT				\
-		     : "0" (ptr), "i" (sizeof(*(ptr))));		\
+		     : "0" (ptr), [size] "i" (sizeof(*(ptr))));		\
 	instrument_get_user(__val_gu);					\
 	(x) = (__force __typeof__(*(ptr))) __val_gu;			\
 	__builtin_expect(__ret_gu, 0);					\
diff --git a/arch/x86/lib/getuser.S b/arch/x86/lib/getuser.S
index f6aad480febd3..6913fbce6544f 100644
--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -44,7 +44,11 @@
 	or %rdx, %rax
 .else
 	cmp $TASK_SIZE_MAX-\size+1, %eax
+.if \size != 8
 	jae .Lbad_get_user
+.else
+	jae .Lbad_get_user_8
+.endif
 	sbb %edx, %edx		/* array_index_mask_nospec() */
 	and %edx, %eax
 .endif
@@ -154,7 +158,7 @@ SYM_CODE_END(__get_user_handle_exception)
 #ifdef CONFIG_X86_32
 SYM_CODE_START_LOCAL(__get_user_8_handle_exception)
 	ASM_CLAC
-bad_get_user_8:
+.Lbad_get_user_8:
 	xor %edx,%edx
 	xor %ecx,%ecx
 	mov $(-EFAULT),%_ASM_AX
-- 
2.43.0



