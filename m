Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6282212FF73;
	Tue, 23 Jan 2024 01:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971817; cv=none; b=hArwbPm0OsaqCTgqTd+5Y+tlQP4b0K/wPL8xOBCllZbXc280GyMJNksgWCW+dmEaHWhEo+iSs3dtfNahg9DMIhl3es231JdTqnsXDaJuf3ay5WbeLxNX7ROcvTCx6YoBsa2nro2HFojFG0og/A4bvzEAGsEzadeD0BtChWtSBXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971817; c=relaxed/simple;
	bh=y4xs/9rpqvUI/wrooiq5VNIh3TOglH7agERzct7oxDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKcsuJZ4mzekf2azA5C6ObdPyFoBUEOmAVHLlF61KGirvGvTr7eAUelQFg8p7s8Fd35dNndMx4BYOJMQlKtrR0B+zmmVD5+8YSt3LlZixQWIAV2mdKxAF3jnURn4ixvGvXlxME7Q7AvPCn2MEo6N2jz8tX7ZNKFeFR41Vl+h96o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQ09HbRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQ09HbRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BA0C433C7;
	Tue, 23 Jan 2024 01:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971817;
	bh=y4xs/9rpqvUI/wrooiq5VNIh3TOglH7agERzct7oxDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aQ09HbRxhMPzgzUoRARYmLTuo5py41TJu/j4AUhL3ZbXYlnWukCQE9LyrLmfrqk0P
	 IZlbTc/I89kPWCmVVsOH778xjeIKl8JBwVLuH2gBFIRtkSe7qXUVWxN0Lful2Wy4zh
	 RKtgke84Lo0LFzUGRPBjYv+U7mSyMIR4t0gk/WhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/286] mips: dmi: Fix early remap on MIPS32
Date: Mon, 22 Jan 2024 15:59:04 -0800
Message-ID: <20240122235741.232249758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



