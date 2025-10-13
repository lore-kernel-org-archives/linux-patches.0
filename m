Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D15517F4F6;
	Mon, 13 Oct 2025 15:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369036; cv=none; b=faTGgqa/1xfEf36HxOTXChanMOdALUmF8pDBnagrSfiAw0/i8/DmB3sOHYfq0Ph/1gNSuq/Y16vd5Ocs/KHNOxLANqO1E31nTpRTZTqycbTbq8IaIN8DD8E56gtEWqqsMqXLX5fhJGaWSp+XWEMdgBxqXsmTmloBHqZGIppUUC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369036; c=relaxed/simple;
	bh=DOJ8qt2Y+YJ9ityRo8iluviqW1OKx7FgQiMbvt+PPXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmNNa4RMLZrN6ac/kkCXftm19kXi2PmEenjRSx+viSJAJD47DqqFAsts5STcTKBYnv+M4KjvkFxdQVhvk1s14OJiv1pLRzUFUkGqdnl9KfaX8bmd5H9LF+G1wJCmDCcI1uAENdK+NRSYK2bYtL4DZL51yOkFBPgKBGUkDkJAQvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qcRMAYVC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qcRMAYVC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C4EC4CEE7;
	Mon, 13 Oct 2025 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369035;
	bh=DOJ8qt2Y+YJ9ityRo8iluviqW1OKx7FgQiMbvt+PPXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcRMAYVCopuWd+EOsgNm9K9D8zBnvGiQPaawQ5z8EXdrvf2NN+AsC7PQwocFInf7L
	 m3JYsqkkANl913BYI2A699+JMj2nkrhM4B3WSgDp6YLWdNRrmRs5GZYcgQk3xa/7vm
	 wJgflskQHNH471h7hEyego3DjsM4HH9RrbrAmR1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 106/563] selftests: vDSO: Fix -Wunitialized in powerpc VDSO_CALL() wrapper
Date: Mon, 13 Oct 2025 16:39:27 +0200
Message-ID: <20251013144415.134205741@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 9f15e0f9ef514b8e1a80707931f6d07362e8ebc4 ]

The _rval register variable is meant to be an output operand of the asm
statement but is instead used as input operand.
clang 20.1 notices this and triggers -Wuninitialized warnings:

tools/testing/selftests/timers/auxclock.c:154:10: error: variable '_rval' is uninitialized when used here [-Werror,-Wuninitialized]
  154 |                 return VDSO_CALL(self->vdso_clock_gettime64, 2, clockid, ts);
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tools/testing/selftests/timers/../vDSO/vdso_call.h:59:10: note: expanded from macro 'VDSO_CALL'
   59 |                 : "r" (_rval)                                           \
      |                        ^~~~~
tools/testing/selftests/timers/auxclock.c:154:10: note: variable '_rval' is declared here
tools/testing/selftests/timers/../vDSO/vdso_call.h:47:2: note: expanded from macro 'VDSO_CALL'
   47 |         register long _rval asm ("r3");                                 \
      |         ^

It seems the list of input and output operands have been switched around.
However as the argument registers are not always initialized they can not
be marked as pure inputs as that would trigger -Wuninitialized warnings.
Adding _rval as another input and output operand does also not work as it
would collide with the existing _r3 variable.

Instead reuse _r3 for both the argument and the return value.

Fixes: 6eda706a535c ("selftests: vDSO: fix the way vDSO functions are called for powerpc")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/all/20250812-vdso-tests-fixes-v2-1-90f499dd35f8@linutronix.de
Closes: https://lore.kernel.org/oe-kbuild-all/202506180223.BOOk5jDK-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vdso_call.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vDSO/vdso_call.h b/tools/testing/selftests/vDSO/vdso_call.h
index bb237d771051b..e7205584cbdca 100644
--- a/tools/testing/selftests/vDSO/vdso_call.h
+++ b/tools/testing/selftests/vDSO/vdso_call.h
@@ -44,7 +44,6 @@
 	register long _r6 asm ("r6");					\
 	register long _r7 asm ("r7");					\
 	register long _r8 asm ("r8");					\
-	register long _rval asm ("r3");					\
 									\
 	LOADARGS_##nr(fn, args);					\
 									\
@@ -54,13 +53,13 @@
 		"	bns+	1f\n"					\
 		"	neg	3, 3\n"					\
 		"1:"							\
-		: "+r" (_r0), "=r" (_r3), "+r" (_r4), "+r" (_r5),	\
+		: "+r" (_r0), "+r" (_r3), "+r" (_r4), "+r" (_r5),	\
 		  "+r" (_r6), "+r" (_r7), "+r" (_r8)			\
-		: "r" (_rval)						\
+		:							\
 		: "r9", "r10", "r11", "r12", "cr0", "cr1", "cr5",	\
 		  "cr6", "cr7", "xer", "lr", "ctr", "memory"		\
 	);								\
-	_rval;								\
+	_r3;								\
 })
 
 #else
-- 
2.51.0



