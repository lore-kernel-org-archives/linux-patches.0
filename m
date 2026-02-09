Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A103259CAF;
	Mon,  9 Feb 2026 14:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647688; cv=none; b=PzMZWhtg2uHXF5bLzwUXtUuk4aSBz1l6ROPikVBzte36RUkWm9yn4a3qV80wDnXAblJxqegN4Bfb1cRD3JFY5e+sgBgvJUalPvZl6z7G0m8zP9qAD2ku92NMKTawRO9B0nPIDp8EKA7Hi98tV3zusknMy/t/XDSYuh3YjLoVLWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647688; c=relaxed/simple;
	bh=L3mUKvNgdcmO+I4heI/LFcaqSdoa47UvhbILjjBWi6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1JIdgbmomp/TncR2PXxl0LwQr0aLpmG7uDdvxcL6nkK349i1erO9sni/rwY9ejbdCNZW/NxNL7UsrVMe/2SQDGBwBASvi/vfghT5fOw0DJRVE5K8GCRsTa2svnHzxKpEXSBt5CHtUfH+kUOp4qsMcGzjraYudSWnN8YvT8ouqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPh19JBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPh19JBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4CAC16AAE;
	Mon,  9 Feb 2026 14:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647688;
	bh=L3mUKvNgdcmO+I4heI/LFcaqSdoa47UvhbILjjBWi6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPh19JBxYILokCsAc2Fv8lUFWeaEk4oSJu5EQqwL5+cuKKNjEJmdlazuvdY1WKB+W
	 FKAo3KnywZQamBNHaTdef1W28HLlGcwVWI+6eT8YrS8kMyzsC9DGLYtEL7HVxZIVga
	 uP4gf00zgtOea4MWGb5KLGunOocQxWWCOje6p4+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Paul Walmsley <pjw@kernel.org>
Subject: [PATCH 6.18 175/175] riscv: Add intermediate cast to unsigned long in __get_user_asm
Date: Mon,  9 Feb 2026 15:24:08 +0100
Message-ID: <20260209142326.770811236@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 841e47d56cef9b96fd2314220e3d0f1d92c719f4 upstream.

After commit bdce162f2e57 ("riscv: Use 64-bit variable for output in
__get_user_asm"), there is a warning when building for 32-bit RISC-V:

  In file included from include/linux/uaccess.h:13,
                   from include/linux/sched/task.h:13,
                   from include/linux/sched/signal.h:9,
                   from include/linux/rcuwait.h:6,
                   from include/linux/mm.h:36,
                   from include/linux/migrate.h:5,
                   from mm/migrate.c:16:
  mm/migrate.c: In function 'do_pages_move':
  arch/riscv/include/asm/uaccess.h:115:15: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    115 |         (x) = (__typeof__(x))__tmp;                             \
        |               ^
  arch/riscv/include/asm/uaccess.h:198:17: note: in expansion of macro '__get_user_asm'
    198 |                 __get_user_asm("lb", (x), __gu_ptr, label);     \
        |                 ^~~~~~~~~~~~~~
  arch/riscv/include/asm/uaccess.h:218:9: note: in expansion of macro '__get_user_nocheck'
    218 |         __get_user_nocheck(x, ptr, __gu_failed);                        \
        |         ^~~~~~~~~~~~~~~~~~
  arch/riscv/include/asm/uaccess.h:255:9: note: in expansion of macro '__get_user_error'
    255 |         __get_user_error(__gu_val, __gu_ptr, __gu_err);         \
        |         ^~~~~~~~~~~~~~~~
  arch/riscv/include/asm/uaccess.h:285:17: note: in expansion of macro '__get_user'
    285 |                 __get_user((x), __p) :                          \
        |                 ^~~~~~~~~~
  mm/migrate.c:2358:29: note: in expansion of macro 'get_user'
   2358 |                         if (get_user(p, pages + i))
        |                             ^~~~~~~~

Add an intermediate cast to 'unsigned long', which is guaranteed to be the same
width as a pointer, before the cast to the type of the output variable to clear
up the warning.

Fixes: bdce162f2e57 ("riscv: Use 64-bit variable for output in __get_user_asm")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202601210526.OT45dlOZ-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Link: https://patch.msgid.link/20260121-riscv-fix-int-to-pointer-cast-v1-1-b83eebe57c76@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/uaccess.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/include/asm/uaccess.h
+++ b/arch/riscv/include/asm/uaccess.h
@@ -112,7 +112,7 @@ do {								\
 		_ASM_EXTABLE_UACCESS_ERR(1b, %l2, %0)		\
 		: "=&r" (__tmp)					\
 		: "m" (*(ptr)) : : label);			\
-	(x) = (__typeof__(x))__tmp;				\
+	(x) = (__typeof__(x))(unsigned long)__tmp;		\
 } while (0)
 #else /* !CONFIG_CC_HAS_ASM_GOTO_OUTPUT */
 #define __get_user_asm(insn, x, ptr, label)			\


