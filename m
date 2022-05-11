Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9352F33;
	Wed, 11 May 2022 18:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE446C340EE;
	Wed, 11 May 2022 18:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1652295017;
	bh=W9rLIkC4kkgzqycQuHkA/UVojPhdH7N+sZBFCymIYMw=;
	h=From:To:Cc:Subject:Date:From;
	b=L7zWc1OuyqYs4BtULyThnE4ZHBy3tF1C8dR4qLEgmXCt1qSQAjXpqbFarMmV8YjJH
	 E0GLJaxtgCrWSO9P7xcFf4g3BzRFQUyZIMlNEjzsbXhYkADb1+b1bD1iotYgpALtoy
	 wmQrSZT7C0zoVdH2sCAVyVgx8ZhfVYCztyU3QIHy5I0Yts7azUbKT25jBORdbXBJ9b
	 mHOiy1C4jIHYEkI72o145Ewn6IBTbocEow8Y4KfJrhZqCNV/6j0JKc+oMuvIZMjvyH
	 pdihbuNI2sgBgFLCxspf3HHY+SvA/Fhxp9xz1/EmLrQ2vAHDDGZR5m00hzWR6aSQod
	 cx0H76qW6J0Lw==
From: Nathan Chancellor <nathan@kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linuxppc-dev@lists.ozlabs.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 0/2] Link the PowerPC vDSO with ld.lld
Date: Wed, 11 May 2022 11:49:59 -0700
Message-Id: <20220511185001.3269404-1-nathan@kernel.org>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series is an alternative to the one proposed by Nick before the
PowerPC vDSO unification in commit fd1feade75fb ("powerpc/vdso: Merge
vdso64 and vdso32 into a single directory"):

https://lore.kernel.org/20200901222523.1941988-1-ndesaulniers@google.com/

Normally, we try to make compiling and linking two separate stages so
that they can be done by $(CC) and $(LD) respectively, which is more in
line with what the user expects, versus using the compiler as a linker
driver and relying on the implicit default linker value. However, as
shown in the above thread, getting this right for the PowerPC vDSO is a
little tricky due to the linker emulation values.

The unification might make this easier but that needs further
investigation. To avoid regressing ld.bfd while enabling support for
linking the vDSO with ld.lld, we can tell the compiler to use ld.lld via
either '--ld-path=' (clang 12.0.0) or '-fuse-ld=lld'.

The first patch avoids a warning from ld.lld when linking both vDSO
objects and the second patch adds the flags.

This should help avoid the issue noticed during Alexey's LTO bring up:

https://lore.kernel.org/CAKwvOdmUMhqhQhDCpWjMNiQQPvwOJB9MbUkF3RR0BL+H+DagmA@mail.gmail.com/

Changelog:

v1 -> v2: https://lore.kernel.org/20220509204635.2539549-1-nathan@kernel.org/

* Flush out the second commit message much more with information from
  this cover letter and the other threads (Alexey's LTO enablement and
  Nick's initial stab at converting to $(CC) + $(LD)) [Nick].

* Add Nick and Alexey's tags.

Nathan Chancellor (2):
  powerpc/vdso: Remove unused ENTRY in linker scripts
  powerpc/vdso: Link with ld.lld when requested

 arch/powerpc/kernel/vdso/Makefile     | 1 +
 arch/powerpc/kernel/vdso/vdso32.lds.S | 1 -
 arch/powerpc/kernel/vdso/vdso64.lds.S | 1 -
 3 files changed, 1 insertion(+), 2 deletions(-)


base-commit: b6b1c3ce06ca438eb24e0f45bf0e63ecad0369f5
-- 
2.36.1

