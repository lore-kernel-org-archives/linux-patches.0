Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807A8385D7B;
	Sat, 17 Oct 2026 17:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259234; cv=none; b=r73iYgd4IriSw6oiLlo89AeMnSwYj/rqIdLjRBGVNlHuiQM1rx5tuSe273QMh6h39gl4FFuqoo/zB8pIfxlU1+jZIXgI78A6D0N2gfbHmAML0d6zgXzfafV69B9BH/KejSMgtSnkscN1TFzzheo2HQcUeCHKywdnyweBIFC0TiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259234; c=relaxed/simple;
	bh=PyOdLhZGUHxzxhXY2u2pyX8KLQBPiwOLy15FQtASoZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0bLOb64KbBNwetGJHVu8Xcs952pEmz24Hny2UQwZPPHUPhtta7jhpgYkMc/dYD3o+H84ejFcNGnaodbz76dN23EGs1Hp2I4Tf3p+/LGw8Qnl7jMQEjyaFtqG+cWeQnN4yo3XmuKTJTJQGB93bJk5aXv8JC/tY1uo4Kfw0560vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+vio3HG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+vio3HG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91C61F000C4;
	Sat, 17 Oct 2026 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259233;
	bh=NHVI/vHmK6NwsGB7pvdp3A8d8cEjC3yW4XvQjGMI0tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+vio3HGPWjMP06ZG7zQKD2KXfxPJIT5bbfpjRpYkXrAvAzMc5D3PGEB11K5IlsOy
	 xQ2D07DrdlEcebx3XOm4hz8dg23pOXfRQYrPhFnhQvfJFetR+2oL78q1RzInU1Y/2a
	 00OABTE6Yxi0vhobBAiwGo4st0XXL6bAM336YC68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baoquan He <bhe@redhat.com>,
	kernel test robot <lkp@intel.com>,
	Eric DeVolder <eric_devolder@yahoo.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1107/1674] loongarch, kexec: change dependency of object files
Date: Sat, 17 Oct 2026 17:56:19 +0200
Message-ID: <20261017160459.540923628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baoquan He <bhe@redhat.com>

[ Upstream commit 655fc6cd45521aba4a21c6e607533f1a21e06c2e ]

Patch series "kexec: fix the incorrect ifdeffery and dependency of
CONFIG_KEXEC".

The select of KEXEC for CRASH_DUMP in kernel/Kconfig.kexec will be
dropped, then compiling errors will be triggered if below config items are
set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

E.g on mips, below link error are seen:
--------------------------------------------------------------------
mipsel-linux-ld: kernel/kexec_core.o: in function `kimage_free':
kernel/kexec_core.c:(.text+0x2200): undefined reference to `machine_kexec_cleanup'
mipsel-linux-ld: kernel/kexec_core.o: in function `__crash_kexec':
kernel/kexec_core.c:(.text+0x2480): undefined reference to `machine_crash_shutdown'
mipsel-linux-ld: kernel/kexec_core.c:(.text+0x2488): undefined reference to `machine_kexec'
mipsel-linux-ld: kernel/kexec_core.o: in function `kernel_kexec':
kernel/kexec_core.c:(.text+0x29b8): undefined reference to `machine_shutdown'
mipsel-linux-ld: kernel/kexec_core.c:(.text+0x29c0): undefined reference to `machine_kexec'
--------------------------------------------------------------------

Here, change the incorrect dependency of building kexec_core related
object files, and the ifdeffery on architectures from CONFIG_KEXEC to
CONFIG_KEXEC_CORE.

Testing:
========
Passed on mips and loognarch with the LKP reproducer.

This patch (of 5):

Currently, in arch/loongarch/kernel/Makefile, building machine_kexec.o
relocate_kernel.o depends on CONFIG_KEXEC.

Whereas, since we will drop the select of KEXEC for CRASH_DUMP in
kernel/Kconfig.kexec, compiling error will be triggered if below config
items are set:

===
CONFIG_CRASH_CORE=y
CONFIG_KEXEC_CORE=y
CONFIG_CRASH_DUMP=y
===

---------------------------------------------------------------
loongarch64-linux-ld: kernel/kexec_core.o: in function `.L209':
>> kexec_core.c:(.text+0x1660): undefined reference to `machine_kexec_cleanup'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L287':
>> kexec_core.c:(.text+0x1c5c): undefined reference to `machine_crash_shutdown'
>> loongarch64-linux-ld: kexec_core.c:(.text+0x1c64): undefined reference to `machine_kexec'
   loongarch64-linux-ld: kernel/kexec_core.o: in function `.L2^B5':
>> kexec_core.c:(.text+0x2090): undefined reference to `machine_shutdown'
   loongarch64-linux-ld: kexec_core.c:(.text+0x20a0): undefined reference to `machine_kexec'
---------------------------------------------------------------

Here, change the dependency of machine_kexec.o relocate_kernel.o to
CONFIG_KEXEC_CORE can fix above building error.

Link: https://lkml.kernel.org/r/20231208073036.7884-1-bhe@redhat.com
Link: https://lkml.kernel.org/r/20231208073036.7884-2-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311300946.kHE9Iu71-lkp@intel.com/
Cc: Eric DeVolder <eric_devolder@yahoo.com>
Cc: Ignat Korchagin <ignat@cloudflare.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 485ed44db569 ("LoongArch: Fix address space mismatch in kexec command line lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
index 4fcc168f07323..3c808c6803703 100644
--- a/arch/loongarch/kernel/Makefile
+++ b/arch/loongarch/kernel/Makefile
@@ -57,7 +57,7 @@ obj-$(CONFIG_MAGIC_SYSRQ)	+= sysrq.o
 
 obj-$(CONFIG_RELOCATABLE)	+= relocate.o
 
-obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o
+obj-$(CONFIG_KEXEC_CORE)	+= machine_kexec.o relocate_kernel.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 
 obj-$(CONFIG_UNWINDER_GUESS)	+= unwind_guess.o
-- 
2.53.0



