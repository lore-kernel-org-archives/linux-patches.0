Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651221D8E07;
	Tue, 20 May 2025 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749659; cv=none; b=OXBydUKTIuG9Jv17IqS7kOHdctE7Q5mRrxohbSKlg3hlY6YYwklX/kSkudat7kWEliObKiNN2IneqajzrIZLmIeLyYZNvRmx/MVuqTKDGub/HPxp4m1bnxi8YKxiKKP1MYVT3hVMUKy5euFGpMcOVltVa3S+N1yvD1nHpBNQYS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749659; c=relaxed/simple;
	bh=KVz80NOgwKLkpK3YO/n3sXaqAdhImNhqzq/8J0fak70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ctu6GKQfeOGWIOBDwZqurb2njPwlrxVMN3pxDJS4vLSrMgn3FpI83plcpdqXFmMOSFrFcKcFQoSzd9Q9m6kjAnlgFzRPPouzSLjfxKTNSYfTybHfuBY4Z0H5BgkcaidkCunsQtg+daLOlAo6m3MGHkUp3YgGJsZDkSwqHtANoyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INqQhVx1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INqQhVx1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A27C4CEEB;
	Tue, 20 May 2025 14:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749659;
	bh=KVz80NOgwKLkpK3YO/n3sXaqAdhImNhqzq/8J0fak70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INqQhVx1djHqMz/KmPK1j30wJAZjPHrqhfx8u4HCA+s75Lckixd67KODeHUdLYSF0
	 3x4vH9auqglpS08/y7eSUrxfVtHRxhUrlCg3wzTdL87Xh6rWcbJwkgvpN2KhmiiWmC
	 /jm2ekJkSFRHIgVFu3830r9C+qgaq8P8fK0eqQyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/117] binfmt_elf: Leave a gap between .bss and brk
Date: Tue, 20 May 2025 15:49:30 +0200
Message-ID: <20250520125804.203965245@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 2a5eb9995528441447d33838727f6ec1caf08139 ]

Currently the brk starts its randomization immediately after .bss,
which means there is a chance that when the random offset is 0, linear
overflows from .bss can reach into the brk area. Leave at least a single
page gap between .bss and brk (when it has not already been explicitly
relocated into the mmap range).

Reported-by: <y0un9n132@gmail.com>
Closes: https://lore.kernel.org/linux-hardening/CA+2EKTVLvc8hDZc+2Yhwmus=dzOUG5E4gV7ayCbu0MPJTZzWkw@mail.gmail.com/
Link: https://lore.kernel.org/r/20240217062545.1631668-2-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 11854fe263eb ("binfmt_elf: Move brk for static PIE even if ASLR disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/binfmt_elf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 02258b28e370e..700d93e73f6e0 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1293,6 +1293,9 @@ static int load_elf_binary(struct linux_binprm *bprm)
 		if (IS_ENABLED(CONFIG_ARCH_HAS_ELF_RANDOMIZE) &&
 		    elf_ex->e_type == ET_DYN && !interpreter) {
 			mm->brk = mm->start_brk = ELF_ET_DYN_BASE;
+		} else {
+			/* Otherwise leave a gap between .bss and brk. */
+			mm->brk = mm->start_brk = mm->brk + PAGE_SIZE;
 		}
 
 		mm->brk = mm->start_brk = arch_randomize_brk(mm);
-- 
2.39.5



