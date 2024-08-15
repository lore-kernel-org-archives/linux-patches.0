Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B66418D64F;
	Thu, 15 Aug 2024 14:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730816; cv=none; b=HhNxggYRYeNF4fdLvfq/HmEq7sDwoxfkoU7N4e8fSThNVevIeeIaGbZJyE7tX9ZUJhWd9xoO4aKl3KseOK0M8RBY9YHYLgSfLs9weFLshoDXUctEE8aJbXZOsQti9QVa/1eoGWIPp0WDqlzESI82MJEgNOGEkgDbcsoPM7Y723I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730816; c=relaxed/simple;
	bh=LPfnAFxnnKCHIxfhdtAr69EoRulpqK1uccA2VlwC4nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxkkQY1oNX1DnUzIAcPa+1hkfoXWUmdJq4t3bgpzm6vXbz0MZZIwfkPvtMkw4Q13cCLtlrILD2lxoH55d0uG6qQtjGq2du+v/No9kBs5zwHRRVX5ngVZ8A/0tE5XQmPzB9d1NSKfzgYW9K+WgdXEay1KTJHSDel4dEAAsEht3qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5AT+8mp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5AT+8mp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA3FAC32786;
	Thu, 15 Aug 2024 14:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730816;
	bh=LPfnAFxnnKCHIxfhdtAr69EoRulpqK1uccA2VlwC4nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5AT+8mp/90O4MGua5NPHDlF5f19BGyY3wpO3cWJR3m4b8Ld0XNvDOoFhvMNjPfLr
	 AoQ7/SfFJt07o3i9S3nw7wCgcIF9Liqg4HLAa+oopSvUgU0q7GjdGB0xr9SnDoEIc2
	 6bN+ABDfnHXDl8n3Ky08UGDOkjeYQ5S+nbxc6wrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 09/38] LoongArch: Define __ARCH_WANT_NEW_STAT in unistd.h
Date: Thu, 15 Aug 2024 15:25:43 +0200
Message-ID: <20240815131833.311788675@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

commit 7697a0fe0154468f5df35c23ebd7aa48994c2cdc upstream.

Chromium sandbox apparently wants to deny statx [1] so it could properly
inspect arguments after the sandboxed process later falls back to fstat.
Because there's currently not a "fd-only" version of statx, so that the
sandbox has no way to ensure the path argument is empty without being
able to peek into the sandboxed process's memory. For architectures able
to do newfstatat though, glibc falls back to newfstatat after getting
-ENOSYS for statx, then the respective SIGSYS handler [2] takes care of
inspecting the path argument, transforming allowed newfstatat's into
fstat instead which is allowed and has the same type of return value.

But, as LoongArch is the first architecture to not have fstat nor
newfstatat, the LoongArch glibc does not attempt falling back at all
when it gets -ENOSYS for statx -- and you see the problem there!

Actually, back when the LoongArch port was under review, people were
aware of the same problem with sandboxing clone3 [3], so clone was
eventually kept. Unfortunately it seemed at that time no one had noticed
statx, so besides restoring fstat/newfstatat to LoongArch uapi (and
postponing the problem further), it seems inevitable that we would need
to tackle seccomp deep argument inspection.

However, this is obviously a decision that shouldn't be taken lightly,
so we just restore fstat/newfstatat by defining __ARCH_WANT_NEW_STAT
in unistd.h. This is the simplest solution for now, and so we hope the
community will tackle the long-standing problem of seccomp deep argument
inspection in the future [4][5].

Also add "newstat" to syscall_abis_64 in Makefile.syscalls due to
upstream asm-generic changes.

More infomation please reading this thread [6].

[1] https://chromium-review.googlesource.com/c/chromium/src/+/2823150
[2] https://chromium.googlesource.com/chromium/src/sandbox/+/c085b51940bd/linux/seccomp-bpf-helpers/sigsys_handlers.cc#355
[3] https://lore.kernel.org/linux-arch/20220511211231.GG7074@brightrain.aerifal.cx/
[4] https://lwn.net/Articles/799557/
[5] https://lpc.events/event/4/contributions/560/attachments/397/640/deep-arg-inspection.pdf
[6] https://lore.kernel.org/loongarch/20240226-granit-seilschaft-eccc2433014d@brauner/T/#t

Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/uapi/asm/unistd.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/loongarch/include/uapi/asm/unistd.h
+++ b/arch/loongarch/include/uapi/asm/unistd.h
@@ -1,4 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_SYS_CLONE
 #define __ARCH_WANT_SYS_CLONE3
 


