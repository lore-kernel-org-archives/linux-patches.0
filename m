Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621659;
	b=GcJ8vJ6bjzQwBrub4tbY1ifvKDH3wR8canuX3WvGelo4iLMCUsk8pjzmWDxb6X3bBohX
	 Dxg0jXgHPnTx2M+wQ0MMJqWGYRQTlybuDfZZBNJFCM6NdEN4G5MjbgtwivVxC3tHp2ciY
	 uO+z2BlpSsh6Xzouzs+DZMxY295nQHj/WCQQW4oznNXsxhnc7QHPt121JDhsdcf3I0/i6
	 lnur2MDwQqq+Z6hMx0pqU/+UPW9bPdtcKsUFBMTdwIBt1mFK70nHdHeMRGvnCoLNV/fbz
	 KBb0nCS26iXENuoPaSeulUNpdfZ4D3GyTICO+F01eUxJ3XHgHjMhMjz/2YP4EutGMuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tzyiGzaFM83J3swItMAF75Q1J3nRmhI+LvXxRL8yYbo=;
	b=1vjfxXg4n0r7oCM34R0pJ/2gXuOLO2LcbBj7AyEzIT5hGs0v6JwbZxmhTavl7blnb9OP
	 DsrD8DWCGhVlHiquuH/ZZMI/BKfAo34X84JZbD+vydrXNN8qv1EQoRwrY8F0WC0XFHeah
	 xtNkmpYJ4sVg0fCzuy4Otmv+yi89JlYJYApbujcODKki9UbERmJ/+ZXjK4E+L/V3HJSFS
	 JQiNHEwpcVe13ObOAxERXgf/bAHX4XIzjBBaz+5oPasCNPU6kBvNu5Htz0JyE27s41/Tf
	 81ZdgH+9NI70BY1BS06fc/UZnqk6LKewtGKUUYr+ydiwGXivtIbaj8WGPfEZSzb2iTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HooYdn+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF77606A32E;
	Wed, 25 Nov 2026 15:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HooYdn+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36CE1F000C0;
	Wed, 25 Nov 2026 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621658;
	bh=tzyiGzaFM83J3swItMAF75Q1J3nRmhI+LvXxRL8yYbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HooYdn+gPWDM7Y0p9HetuA+Dqd04dmd90yWX02HGp0XaXociXbSeTS3k8QsGBzcq+
	 KGNrHa8/qlfal+bPEfEMWGIqS2jpwQFm/n5J+99dtKgiYBSNrIV3uQE4paPRoJrDZh
	 Zpch/Qme/MGMt1L4WwqF3w3J7u/HXMIbZlmSoEHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/990] MIPS: Avoid dead code/data elimination when using recordmcount
Date: Wed, 25 Nov 2026 15:27:41 +0100
Message-ID: <20261125143828.976714093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 255d9dbd936f7db8b963e82429f6e57cd9d48999 ]

CONFIG_LD_DEAD_CODE_DATA_ELIMINATION builds with -ffunction-sections,
placing every function in its own section. recordmcount refuses to use
weak symbols as section bases, as a strong definition could override
them, so a weak function alone in its section, such as the generic
pcibios_fixup_bus() stub, breaks the build:

  Cannot find symbol for section 88: .text.pcibios_fixup_bus.
  drivers/pci/probe.o: failed

MIPS always records mcount locations with recordmcount, so this hits
any config with the function tracer and dead code elimination enabled,
e.g. malta_defconfig built with LLVM=1.

Only offer dead code elimination when recordmcount is not used, as
powerpc does since commit f8b2336f15f3 ("powerpc: Avoid dead code/data
elimination when using recordmcount"). In practice this makes it
unavailable together with the function tracer on MIPS.

Fixes: c0436b503591 ("MIPS: Enable dead code elimination")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index fadaeafae98e8..cefaa55ff8bd8 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -81,7 +81,7 @@ config MIPS
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
-	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
+	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !FTRACE_MCOUNT_USE_RECORDMCOUNT
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
 	select HAVE_PAGE_SIZE_4KB if !CPU_LOONGSON2EF && !CPU_LOONGSON64
-- 
2.53.0



