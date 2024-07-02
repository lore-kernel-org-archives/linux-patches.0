Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59FBB1BBBFE;
	Tue,  2 Jul 2024 17:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940517; cv=none; b=AvhRwbmQiIX0Aqr5hsuzJnIO6vvPUPPw9vWUfD1IqrBU+o35wU1nM/Hayu0+n6e6zcMAdAIFQsdSj6Y4nZgumiiFgc9o/ngLhZX2Su7ugZSMUqpINJGsYE+F7sDnG98Q/6IjD1xNG/MWgyQ3DqUyCiC9fqpvoRb9Ju5g8PQ4SYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940517; c=relaxed/simple;
	bh=2aALcdRJjq3NUYITmHDiGZ99SAv+HOLlY/VFOhoNbZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nJnYtcgPbSkkynGyS8LrjNRdx/qh0VM0lF6aJSS9mVolILrttcCO6x8nnBUia8iJqPKt0l9UqSQxHRQuS72mvLPcOKIRnfV49013PQaDz8N83dPTZzpvUtZJAG2V7RafuyfpJpL5Gp/0YVtODO7NMJkE4ShEacdDYbOv4k1Cqzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjFcPaeU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjFcPaeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FEDC116B1;
	Tue,  2 Jul 2024 17:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940517;
	bh=2aALcdRJjq3NUYITmHDiGZ99SAv+HOLlY/VFOhoNbZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjFcPaeUN9qt9QjaNrNEo3IYI2TnupUDq7DKPa+xR4Rw8LtN1QYU9FizKk3trU1hY
	 Tmg14DHgW7BJ0PtlfzteZOyOUWcWVw/PCbfovlScoOO7NFYSmqDvbgsXfNHuTpfK/u
	 NihjJu/ng/k75pcU+mrpqLxIafZBM3LA9vP4d4mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6.9 177/222] csky, hexagon: fix broken sys_sync_file_range
Date: Tue,  2 Jul 2024 19:03:35 +0200
Message-ID: <20240702170250.743104750@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 3339b99ef6fe38dac43b534cba3a8a0e29fb2eff upstream.

Both of these architectures require u64 function arguments to be
passed in even/odd pairs of registers or stack slots, which in case of
sync_file_range would result in a seven-argument system call that is
not currently possible. The system call is therefore incompatible with
all existing binaries.

While it would be possible to implement support for seven arguments
like on mips, it seems better to use a six-argument version, either
with the normal argument order but misaligned as on most architectures
or with the reordered sync_file_range2() calling conventions as on
arm and powerpc.

Cc: stable@vger.kernel.org
Acked-by: Guo Ren <guoren@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/csky/include/uapi/asm/unistd.h    |    1 +
 arch/hexagon/include/uapi/asm/unistd.h |    1 +
 2 files changed, 2 insertions(+)

--- a/arch/csky/include/uapi/asm/unistd.h
+++ b/arch/csky/include/uapi/asm/unistd.h
@@ -6,6 +6,7 @@
 #define __ARCH_WANT_SYS_CLONE3
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
+#define __ARCH_WANT_SYNC_FILE_RANGE2
 #include <asm-generic/unistd.h>
 
 #define __NR_set_thread_area	(__NR_arch_specific_syscall + 0)
--- a/arch/hexagon/include/uapi/asm/unistd.h
+++ b/arch/hexagon/include/uapi/asm/unistd.h
@@ -36,5 +36,6 @@
 #define __ARCH_WANT_SYS_VFORK
 #define __ARCH_WANT_SYS_FORK
 #define __ARCH_WANT_TIME32_SYSCALLS
+#define __ARCH_WANT_SYNC_FILE_RANGE2
 
 #include <asm-generic/unistd.h>


