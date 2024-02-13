Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2EE5FF16;
	Tue, 13 Feb 2024 17:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845584; cv=none; b=D+wEwww/56kUSijk7yQzkO6gkt7qCKMmFnAvv4wTtSFfy9/+uhGurgnrzSEGlj0n4BmCVE/PJ7dFSrzRgaMo+20U+VcrLiRpVADQ2yyDKYp3aBTbglSYACLpAYnpGB/8Ek16zZJZQg1BoPPysQ8BOPjED33EuJiVCJFYkNjlPq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845584; c=relaxed/simple;
	bh=Yh9NIUOXVfUIK3UL4bqOcTeseSkIBlb+oF4kys+5LlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tThDCZKJaNy05DDHIQNFEHWGe5mRYdUC5sP4H5QIUQMEjoZQV8LPvsKyQ7wOwwPIQ9mM10VxQPjuWVUugoHQmvPNYyCsH26N1m27ZPubnS7sylGpPrd6i5WfowlYvIXXqhWbDCuJv9JgCWis9HRrCex4kcKwBMBW6jie2biPmDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSMEWRG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSMEWRG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942D8C433C7;
	Tue, 13 Feb 2024 17:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845584;
	bh=Yh9NIUOXVfUIK3UL4bqOcTeseSkIBlb+oF4kys+5LlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSMEWRG0pRIKXVynJliwGcE19nBeB4pBnCohoFTROds1Q8G45E9piO4YibdtT3xtY
	 ouOcdtiwPr2VdSkoeCtmh5cfLCzt81FOp8NVsJ+0gOhODaFQOyc+XPth8Jr7RtEZKx
	 mRnLGJuoisAvlgiALWKeIqZyuRqdhyckWR9P7Pbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 106/121] x86/lib: Revert to _ASM_EXTABLE_UA() for {get,put}_user() fixups
Date: Tue, 13 Feb 2024 18:21:55 +0100
Message-ID: <20240213171856.087052361@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
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

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

commit 8eed4e00a370b37b4e5985ed983dccedd555ea9d upstream.

During memory error injection test on kernels >= v6.4, the kernel panics
like below. However, this issue couldn't be reproduced on kernels <= v6.3.

  mce: [Hardware Error]: CPU 296: Machine Check Exception: f Bank 1: bd80000000100134
  mce: [Hardware Error]: RIP 10:<ffffffff821b9776> {__get_user_nocheck_4+0x6/0x20}
  mce: [Hardware Error]: TSC 411a93533ed ADDR 346a8730040 MISC 86
  mce: [Hardware Error]: PROCESSOR 0:a06d0 TIME 1706000767 SOCKET 1 APIC 211 microcode 80001490
  mce: [Hardware Error]: Run the above through 'mcelog --ascii'
  mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
  Kernel panic - not syncing: Fatal local machine check

The MCA code can recover from an in-kernel #MC if the fixup type is
EX_TYPE_UACCESS, explicitly indicating that the kernel is attempting to
access userspace memory. However, if the fixup type is EX_TYPE_DEFAULT
the only thing that is raised for an in-kernel #MC is a panic.

ex_handler_uaccess() would warn if users gave a non-canonical addresses
(with bit 63 clear) to {get, put}_user(), which was unexpected.

Therefore, commit

  b19b74bc99b1 ("x86/mm: Rework address range check in get_user() and put_user()")

replaced _ASM_EXTABLE_UA() with _ASM_EXTABLE() for {get, put}_user()
fixups. However, the new fixup type EX_TYPE_DEFAULT results in a panic.

Commit

  6014bc27561f ("x86-64: make access_ok() independent of LAM")

added the check gp_fault_address_ok() right before the WARN_ONCE() in
ex_handler_uaccess() to not warn about non-canonical user addresses due
to LAM.

With that in place, revert back to _ASM_EXTABLE_UA() for {get,put}_user()
exception fixups in order to be able to handle in-kernel MCEs correctly
again.

  [ bp: Massage commit message. ]

Fixes: b19b74bc99b1 ("x86/mm: Rework address range check in get_user() and put_user()")
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: <stable@kernel.org>
Link: https://lore.kernel.org/r/20240129063842.61584-1-qiuxu.zhuo@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/lib/getuser.S |   24 ++++++++++++------------
 arch/x86/lib/putuser.S |   20 ++++++++++----------
 2 files changed, 22 insertions(+), 22 deletions(-)

--- a/arch/x86/lib/getuser.S
+++ b/arch/x86/lib/getuser.S
@@ -163,23 +163,23 @@ SYM_CODE_END(__get_user_8_handle_excepti
 #endif
 
 /* get_user */
-	_ASM_EXTABLE(1b, __get_user_handle_exception)
-	_ASM_EXTABLE(2b, __get_user_handle_exception)
-	_ASM_EXTABLE(3b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(1b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(2b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(3b, __get_user_handle_exception)
 #ifdef CONFIG_X86_64
-	_ASM_EXTABLE(4b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(4b, __get_user_handle_exception)
 #else
-	_ASM_EXTABLE(4b, __get_user_8_handle_exception)
-	_ASM_EXTABLE(5b, __get_user_8_handle_exception)
+	_ASM_EXTABLE_UA(4b, __get_user_8_handle_exception)
+	_ASM_EXTABLE_UA(5b, __get_user_8_handle_exception)
 #endif
 
 /* __get_user */
-	_ASM_EXTABLE(6b, __get_user_handle_exception)
-	_ASM_EXTABLE(7b, __get_user_handle_exception)
-	_ASM_EXTABLE(8b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(6b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(7b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(8b, __get_user_handle_exception)
 #ifdef CONFIG_X86_64
-	_ASM_EXTABLE(9b, __get_user_handle_exception)
+	_ASM_EXTABLE_UA(9b, __get_user_handle_exception)
 #else
-	_ASM_EXTABLE(9b, __get_user_8_handle_exception)
-	_ASM_EXTABLE(10b, __get_user_8_handle_exception)
+	_ASM_EXTABLE_UA(9b, __get_user_8_handle_exception)
+	_ASM_EXTABLE_UA(10b, __get_user_8_handle_exception)
 #endif
--- a/arch/x86/lib/putuser.S
+++ b/arch/x86/lib/putuser.S
@@ -134,15 +134,15 @@ SYM_CODE_START_LOCAL(__put_user_handle_e
 	RET
 SYM_CODE_END(__put_user_handle_exception)
 
-	_ASM_EXTABLE(1b, __put_user_handle_exception)
-	_ASM_EXTABLE(2b, __put_user_handle_exception)
-	_ASM_EXTABLE(3b, __put_user_handle_exception)
-	_ASM_EXTABLE(4b, __put_user_handle_exception)
-	_ASM_EXTABLE(5b, __put_user_handle_exception)
-	_ASM_EXTABLE(6b, __put_user_handle_exception)
-	_ASM_EXTABLE(7b, __put_user_handle_exception)
-	_ASM_EXTABLE(9b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(1b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(2b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(3b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(4b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(5b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(6b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(7b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(9b, __put_user_handle_exception)
 #ifdef CONFIG_X86_32
-	_ASM_EXTABLE(8b, __put_user_handle_exception)
-	_ASM_EXTABLE(10b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(8b, __put_user_handle_exception)
+	_ASM_EXTABLE_UA(10b, __put_user_handle_exception)
 #endif


