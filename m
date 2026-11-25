Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624577;
	b=44w9mkS9W9EBBW4+r0eiDwpuECebZEEo09C3Ud1ZyUy4+51G8hbH0Kk1H9bDhgq7A8p+
	 HRWs5dKyHcQdINaIeTcnSY7NihPBuo3UDKGBCqNYIPA1c50SLO/7KxoRYzDELjtq2zwFD
	 wud6Gcj5M3Y+blQRhdcigYG1aN/I+VZa9TMZpbS4K1eWyn+bgn9bnffxEaBKyDlQ/eJi+
	 o3qlAIrGqfuo6bn3wrjgxvNHmnPXGLrLgoFS+CVV8ArO9wr2llpwLG+4ejhMvjAoZo3Lb
	 j/grn/XuBwUMf69yTZL9R3ycDXCz6z5B1iH/yTYGgcQqsh7Qp9kCNVMXP+e+3RefzhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624577;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kw98bXUsZDl1n3g2ohVxFcxyozrYuqIcf7x9F2qYsJ8=;
	b=g5d5LCtlKkV0oU15caozUdj6NrJpMN8OQTCC3Zz8C7nX8dlTct8JiG4vJVzr9cFt6CRA
	 Tr6NOvDtg3y7AZD5/8uIFPlULxT+dnFA/VCn2en95DgWyd1183J+zBSBljMAf12gn6W++
	 uoQxyZ6IIcyfw9CTNofDjFe/tDgB1l6XpdK99lORQiCFoILNGgpGp1/9lt77fCpFRfUvf
	 1iGBKM+TUQpmNruJ97GpFF6x2zkUStTQkYN9TK0ltQcuyPDVXhtDBbEJlb+IDE5PDxDt5
	 TKfULxWVZO8e4IGqlNnNKVw2nUZ3dp9rddyRcUG5lOjb5xDIy9LBhnzFs6TnYE5LHqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRfdcv3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489AC606A33A;
	Wed, 25 Nov 2026 16:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRfdcv3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8324A1F000CA;
	Wed, 25 Nov 2026 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624577;
	bh=Kw98bXUsZDl1n3g2ohVxFcxyozrYuqIcf7x9F2qYsJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRfdcv3R4KBxCr6iJiYx009dioRHWIGtE13wTZq33GNg/oGmjqd1FRY2CBlF9X4zi
	 oB5MwneT3n7V0wOoPgQT1mEzpW2vdZGPrION4t93C6WvW04j8qGrCJOf3of0BXnpR/
	 9pJ6XVuVWHKqK+CayPr6cAtQlNd9/Pdq9tQA3UcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/816] MIPS: Avoid dead code/data elimination when using recordmcount
Date: Wed, 25 Nov 2026 15:29:47 +0100
Message-ID: <20261125143854.742285914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b107ce720279a..2df298fcc027d 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -80,7 +80,7 @@ config MIPS
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



