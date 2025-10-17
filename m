Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFEB330B01;
	Fri, 17 Oct 2025 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715296; cv=none; b=HEjuZmoL2J9Azw7V2EM0g/kmmtum1Euq8O/rcaALbeyV1UcoS4PgZEExVvzUQ/xMUhsuVc4JhP+pbYvKvmRc7XL9Fq9BdeVKQM0oe4ldmeC258mV1i7J74fZU1nXd53nczgfoWoAaCCvLZsS3SZA6o+U1ZGwJJeIcQzFGTNLfn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715296; c=relaxed/simple;
	bh=qs8zg/W9vzyXD/9NlogoMDBMO3q1GLYL8AqyJP27Oao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JufEK2lNm4u0zsB9un4fU5SICj37R0gwcRURPZgZoktrs1Yc4XwPXAzrnSgHc27Or8wP2/bPJX1gX0er+ckQlNmOywVGZtBt6HhxRth/bD58dihFjjCLcYuGxdzwliq2nPc89h0aWcqpEiWg2kfK9NGZ+/SG+17mru2Z/zUtPt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsxBWz6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsxBWz6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A6EC4CEE7;
	Fri, 17 Oct 2025 15:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715295;
	bh=qs8zg/W9vzyXD/9NlogoMDBMO3q1GLYL8AqyJP27Oao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsxBWz6GcgMPC4N9eB2zlbuCSO6b2yDY4fxKkxvXd1g5ONLtN3L7YRSLwaRkLxr00
	 vet4S30tIZ/jnYvI3FoWaEVl+zdOYV4Qtknm+1HIf/2cjvN4/KSLwuADNX4OHNFZe7
	 IRwlqQRH76rDAHjPZYyUBrtbRO1HQNRvaLThkaAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Alexey Gladkov <legion@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 133/371] kbuild: Add .rel.* strip pattern for vmlinux
Date: Fri, 17 Oct 2025 16:51:48 +0200
Message-ID: <20251017145206.741614158@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 8ec3af916fe3954381cf3555ea03dc5adf4d0e8e ]

Prior to binutils commit c12d9fa2afe ("Support objcopy
--remove-section=.relaFOO") [1] in 2.32, stripping relocation sections
required the trailing period (i.e., '.rel.*') to work properly.

After commit 3e86e4d74c04 ("kbuild: keep .modinfo section in
vmlinux.unstripped"), there is an error with binutils 2.31.1 or earlier
because these sections are not properly removed:

  s390-linux-objcopy: st6tO8Ev: symbol `.modinfo' required but not present
  s390-linux-objcopy:st6tO8Ev: no symbols

Add the old pattern to resolve this issue (along with a comment to allow
cleaning this when binutils 2.32 or newer is the minimum supported
version). While the aforementioned kbuild change exposes this, the
pattern was originally changed by commit 71d815bf5dfd ("kbuild: Strip
runtime const RELA sections correctly"), where it would still be
incorrect with binutils older than 2.32.

Fixes: 71d815bf5dfd ("kbuild: Strip runtime const RELA sections correctly")
Link: https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=c12d9fa2afe7abcbe407a00e15719e1a1350c2a7 [1]
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/CA+G9fYvVktRhFtZXdNgVOL8j+ArsJDpvMLgCitaQvQmCx=hwOQ@mail.gmail.com/
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Alexey Gladkov <legion@kernel.org>
Acked-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/20251008-kbuild-fix-modinfo-regressions-v1-2-9fc776c5887c@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.vmlinux | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/Makefile.vmlinux b/scripts/Makefile.vmlinux
index 7c6f0e882eabb..ffc7b49e54f70 100644
--- a/scripts/Makefile.vmlinux
+++ b/scripts/Makefile.vmlinux
@@ -88,6 +88,9 @@ endif
 
 remove-section-y                                   := .modinfo
 remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel*' '!.rel*.dyn'
+# for compatibility with binutils < 2.32
+# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=c12d9fa2afe7abcbe407a00e15719e1a1350c2a7
+remove-section-$(CONFIG_ARCH_VMLINUX_NEEDS_RELOCS) += '.rel.*'
 
 # To avoid warnings: "empty loadable segment detected at ..." from GNU objcopy,
 # it is necessary to remove the PT_LOAD flag from the segment.
-- 
2.51.0



