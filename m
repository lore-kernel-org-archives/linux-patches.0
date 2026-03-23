Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C85823DD;
	Mon, 23 Mar 2026 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275325; cv=none; b=bZ/dZv5vEPj9HgljIknFP7I6i0KXvGl9udnymQfnG+f/xE15+cjbTgPsVJK/+nyCY8HraCr+pLK96v35fezRMSmtKixgVhAxUOn/bJb5TAXvt69U0ouToS4yk+/SXDOIXqf6/3ludzxhTEbtBO9loWTcRrKixEaEB5rjyn4sEHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275325; c=relaxed/simple;
	bh=HjTbMQQevAJ1OQ/SMkveBGVIYxls1Rim6gf9KZ2yNPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMUWzeEYlYi2xHzZiiOPfcRMOPmuBbRO4tQ0JpYskai6YuV/CvLDIldTlh5vRyTxqsHbl856CpTezEsTZ43dML3AGVLMJzKYWPdbAJKxR3lBVaEeC8EjrgCIoqte3WKBRWizQAzj3XFSZnEM9xX2vuixcNPb5k4iuJCCpdICTC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukLOl7eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukLOl7eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D63EC4CEF7;
	Mon, 23 Mar 2026 14:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275325;
	bh=HjTbMQQevAJ1OQ/SMkveBGVIYxls1Rim6gf9KZ2yNPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukLOl7eo3SRn+HLZNFDtQ7zTHa1Xv3kmcOCiz2UUXGtIsfecyLz8lasW6mB+PvjB3
	 krlmaq7o6hK7cPrADXNIbuFyJNh0yM3T2bsv4RJHL4j1WjXwTqGLiQxxtB07zHqxur
	 IXBhNUV338QdKZ5rFHg/cr/H8ybMVi8vbfHe4oBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/460] powerpc/uaccess: Fix inline assembly for clang build on PPC32
Date: Mon, 23 Mar 2026 14:40:12 +0100
Message-ID: <20260323134527.061949009@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



