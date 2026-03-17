Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC35357A4A;
	Tue, 17 Mar 2026 17:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767115; cv=none; b=B6UPOJDtLLgYnbptOc4AUVxQgreEOKXz/0cwxe/41pYMP4V/HDDkxyTCD/e/7CaAmH62r/SGXZ18EEYxQ1H4KoyXvZ3yZggCwYj48bScmOo7Jgi6iUp4btdQdMJ1bVLdb5bVKsWIOsGrC+dEiDGF89kFjXvCMYZCBK+4voqOOK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767115; c=relaxed/simple;
	bh=VfpNCxGP85Hqk0B/64eiVbFICFC1wEr6TMO8v9Hz/kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/pax8upWFDPqkYSrPXwH6IKcnGhj278Aga877a51Sjzd2iFABUsI8ouxZsTAh3ATq2fyibvp02yN4PeSM8ZChqSxNZYKEdV4gpnDhsoDSU157g+mf3ufx/BDprqkwpatU6EIP8IuiFRkOaJ/ZQZMDCds7Ihf/sZTV88untF6pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VP+iHi6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VP+iHi6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024E1C2BCAF;
	Tue, 17 Mar 2026 17:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767115;
	bh=VfpNCxGP85Hqk0B/64eiVbFICFC1wEr6TMO8v9Hz/kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VP+iHi6gXpE06oln2f8elDpTYAd4464/QM1tnPVHCMhx1vYf49qNtdmcCQI2uHQCr
	 9U+4ala1oaZDgCWgIl4WTWFAj05PvhBy0AMLT8hj4IQkrCGg++hQVqyLxkuZa1gKxf
	 55lLh44n5J7cmHU9trJIcxj0LqYcckztWMEsYtQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/333] powerpc/uaccess: Fix inline assembly for clang build on PPC32
Date: Tue, 17 Mar 2026 17:30:47 +0100
Message-ID: <20260317163000.035849078@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

[ Upstream commit 0ee95a1d458630272d0415d0ffa9424fcb606c90 ]

Test robot reports the following error with clang-16.0.6:

   In file included from kernel/rseq.c:75:
   include/linux/rseq_entry.h:141:3: error: invalid operand for instruction
                   unsafe_get_user(offset, &ucs->post_commit_offset, efault);
                   ^
   include/linux/uaccess.h:608:2: note: expanded from macro 'unsafe_get_user'
           arch_unsafe_get_user(x, ptr, local_label);      \
           ^
   arch/powerpc/include/asm/uaccess.h:518:2: note: expanded from macro 'arch_unsafe_get_user'
           __get_user_size_goto(__gu_val, __gu_addr, sizeof(*(p)), e); \
           ^
   arch/powerpc/include/asm/uaccess.h:284:2: note: expanded from macro '__get_user_size_goto'
           __get_user_size_allowed(x, ptr, size, __gus_retval);    \
           ^
   arch/powerpc/include/asm/uaccess.h:275:10: note: expanded from macro '__get_user_size_allowed'
           case 8: __get_user_asm2(x, (u64 __user *)ptr, retval);  break;  \
                   ^
   arch/powerpc/include/asm/uaccess.h:258:4: note: expanded from macro '__get_user_asm2'
                   "       li %1+1,0\n"                    \
                    ^
   <inline asm>:7:5: note: instantiated into assembly here
           li 31+1,0
              ^
   1 error generated.

On PPC32, for 64 bits vars a pair of registers is used. Usually the
lower register in the pair is the high part and the higher register is
the low part. GCC uses r3/r4 ... r11/r12 ... r14/r15 ... r30/r31

In older kernel code inline assembly was using %1 and %1+1 to represent
64 bits values. However here it looks like clang uses r31 as high part,
allthough r32 doesn't exist hence the error.

Allthoug %1+1 should work, most places now use %L1 instead of %1+1, so
let's do the same here.

With that change, the build doesn't fail anymore and a disassembly shows
clang uses r17/r18 and r31/r14 pair when GCC would have used r16/r17 and
r30/r31:

	Disassembly of section .fixup:

	00000000 <.fixup>:
	   0:	38 a0 ff f2 	li      r5,-14
	   4:	3a 20 00 00 	li      r17,0
	   8:	3a 40 00 00 	li      r18,0
	   c:	48 00 00 00 	b       c <.fixup+0xc>
				c: R_PPC_REL24	.text+0xbc
	  10:	38 a0 ff f2 	li      r5,-14
	  14:	3b e0 00 00 	li      r31,0
	  18:	39 c0 00 00 	li      r14,0
	  1c:	48 00 00 00 	b       1c <.fixup+0x1c>
				1c: R_PPC_REL24	.text+0x144

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202602021825.otcItxGi-lkp@intel.com/
Fixes: c20beffeec3c ("powerpc/uaccess: Use flexible addressing with __put_user()/__get_user()")
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Acked-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/8ca3a657a650e497a96bfe7acde2f637dadab344.1770103646.git.chleroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 3987a5c33558b..929f7050c73a6 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -253,7 +253,7 @@ __gus_failed:								\
 		".section .fixup,\"ax\"\n"		\
 		"4:	li %0,%3\n"			\
 		"	li %1,0\n"			\
-		"	li %1+1,0\n"			\
+		"	li %L1,0\n"			\
 		"	b 3b\n"				\
 		".previous\n"				\
 		EX_TABLE(1b, 4b)			\
-- 
2.51.0



