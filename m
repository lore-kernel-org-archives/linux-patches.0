Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB74627EB;
	Tue, 23 Jan 2024 01:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974956; cv=none; b=aPwd4GEoJKKuiy1WchVyFa0I7/qHaH+70FHhqr9fQDbD/nxedA3pHKqoFkFN3s5aPZ5v5Isd/SIyUaFQKBSAXr/uaZEJKk4kxiLiqNavdbrTWldHgDwL1wvpm6nCN7PMEHKH89EernZXAXMaNsIMTy+TYnUEJHm+n9SvaTK3PLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974956; c=relaxed/simple;
	bh=5dC63xg5skpxfFm1oUtqzTpZj7bbWponPypZl8YJ/XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VO2ohU+iufcKU3SPc29nA+1xsjhBgvvJpim6zs4Yi7e+s+F6mqI/jJbivvGVBZTWuVFl9UzStDpfQn47IG7GNoWRiW2cUU6LXePynNlajHNCURUyT6HvFGXHpLvQ0acZMg/4yuygpkEiyJ0mkbv4BryR+bOp9bZ07QdKs8vCWcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6atLUkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6atLUkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA41C433B2;
	Tue, 23 Jan 2024 01:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974955;
	bh=5dC63xg5skpxfFm1oUtqzTpZj7bbWponPypZl8YJ/XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6atLUkl9rz6hRKfluELlg02pXQy2wxMaqrl1bbhMeLJbPCK2AC+CkNQNGR2YKlRF
	 R7mcoIypQh1R59JedBzTJBgnVAD2L9j4gv0ktpKwSRVufRbbZzYbqLbf//vzX5kVm5
	 BzOF1soBqlx7bqwqUnrHfmfKSyGymLnwnFikKjtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 295/374] mips: dmi: Fix early remap on MIPS32
Date: Mon, 22 Jan 2024 15:59:11 -0800
Message-ID: <20240122235755.044482226@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 0d0a3748a2cb38f9da1f08d357688ebd982eb788 ]

dmi_early_remap() has been defined as ioremap_cache() which on MIPS32 gets
to be converted to the VM-based mapping. DMI early remapping is performed
at the setup_arch() stage with no VM available. So calling the
dmi_early_remap() for MIPS32 causes the system to crash at the early boot
time. Fix that by converting dmi_early_remap() to the uncached remapping
which is always available on both 32 and 64-bits MIPS systems.

Note this change shall not cause any regressions on the current DMI
support implementation because on the early boot-up stage neither MIPS32
nor MIPS64 has the cacheable ioremapping support anyway.

Fixes: be8fa1cb444c ("MIPS: Add support for Desktop Management Interface (DMI)")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/dmi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/dmi.h b/arch/mips/include/asm/dmi.h
index 27415a288adf..dc397f630c66 100644
--- a/arch/mips/include/asm/dmi.h
+++ b/arch/mips/include/asm/dmi.h
@@ -5,7 +5,7 @@
 #include <linux/io.h>
 #include <linux/memblock.h>
 
-#define dmi_early_remap(x, l)		ioremap_cache(x, l)
+#define dmi_early_remap(x, l)		ioremap(x, l)
 #define dmi_early_unmap(x, l)		iounmap(x)
 #define dmi_remap(x, l)			ioremap_cache(x, l)
 #define dmi_unmap(x)			iounmap(x)
-- 
2.43.0



